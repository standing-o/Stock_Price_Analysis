clear; clc; close all;

% base variable
list = ls('dataset'); dir_list = list(3:23,:);

[base_data, base_header] = xlsread(strjoin({'dataset/',dir_list(1,:)},''));
allname = base_header(1,:);
name = allname(3:2:size(base_data,2)+1);

% for i = 1:length(name)  % stocks
for i = 1:1
    h = figure;
    axis tight manual
    filename = strjoin({'gif/', name{i}, '.gif'},'');

%     for j = 1:size(list,1)-2  % file
    for j =1:1
       
        [data, header] = xlsread(strjoin({'dataset/',dir_list(j,:)},''));
        
        matrix = data(:,2:2:size(data, 2));
        
        if isnan(matrix(1,1))
            matrix = matrix(2:size(data,1), :);
        end

        deri_mat = deri(matrix);  % calculating a(i+1)-a(i) / a(i)

        norm_mat = normalize(deri_mat,2);   % z score normalization

        fft_mat = fft(norm_mat(:,i));  % fourier transform
       
        len = length(fft_mat);
        pow = abs(fft_mat(1:floor(len/2)));  % power of first half of transform data
   
        n = (1:len/2);
        plot(n, pow);

        title([name{i} ' day ' num2str(j)]);
        axis([0 200 0 max(pow)]);
        xlabel('Time');
%         ylabel();
%         hold on
        drawnow;
        
        
      % save gif    
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      
      if j == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end    
          
    end
end    


%% day8이후로 nan 해결하기 : norm_mat 찍어보고 인덱싱해서 찍어보기 (0)
%% 행기준 시각화 해보기 (현재 열기준)
%% fft값이 평균보다 큰 애들만 따로 시각화 하고 count