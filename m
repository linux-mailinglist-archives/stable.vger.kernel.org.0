Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E07454D3B
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 19:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhKQSej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhKQSej (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 13:34:39 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6706C061570;
        Wed, 17 Nov 2021 10:31:40 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n85so3450844pfd.10;
        Wed, 17 Nov 2021 10:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/+smvqogmwFFh079mSXlcWbcElYUTcAGYiv6vxh7vWU=;
        b=RZHPDN7ZzOuSG1gjqmuXZCbJc3cM0Xx+00/iDp7i1v0p8ASNcqa4TP+bo5S8FLeplz
         4N45E1DqbFTfylWGUg0b+YcfbZ0sm701M3T57WjnxcluYTOq2PK5e4Vw7FJtL64Om4+W
         O5VT9IjAX8NoFecJYIsWzDhmyWokSumZ/saM7zHaQ9ekChQU7c3ww+VuLyEb2YxqVeOk
         OpInvNd/jOq4ttfkPm46yLogpqnmN2tYmEvwZgvh53r85FOYm24z2Y5lhSDzR533940D
         kgZVMf5mVeKx0iwL9AxJrRTAOE/2Q8+kAjrFL/g/FISfZvHQb2/hP3qT3lQQGghldQwX
         4mEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/+smvqogmwFFh079mSXlcWbcElYUTcAGYiv6vxh7vWU=;
        b=4oBc3IFsw2elyaGzAVI2V2UtKIl387XhdgEk+RCucAA+pP+DZ2LlY/Q3hqMItE5ht7
         16vWn5IE4aTqn04MnY9Ch+COgl/Imeg1MnHfC5w3KN8irZdimlJGExTizpS0e7/rrCeA
         G5Q7rxAl9rN3PTAxx3tnzIdlYVw/Mmc7bQY0/t7kyDaQg7TxcEvhsQuejuAFEJcLLgMy
         OvpHEnSAETEDWj5Ct8q/H7rnIwNHD8FddPnkO5yZPmu84MOg+N1W+3umyqjG/HqOYsEx
         XZd9dkDSzIoxwJ9nvjLR1ifpkOTjZLiIX0Iy+L3fJVCYc2RBq7bAQB/o/dZHgVGi0SIx
         7qSw==
X-Gm-Message-State: AOAM530e82+0XDbQl1fIe29RYYeh3QxpmV9s3gc8XIf6g9NtfNRmQ5E5
        sGpW0XhjRwb1zVdQgIoakXLnXtjx99N1yLmP8lg=
X-Google-Smtp-Source: ABdhPJw33DMLO5nhruTe39EwtFqoN0p5ChHNjNStSIgB2mfKMWYOMWgmszZ9gVZGv8u/G8ePecunCg==
X-Received: by 2002:aa7:808e:0:b0:493:f071:274f with SMTP id v14-20020aa7808e000000b00493f071274fmr8956959pff.37.1637173899691;
        Wed, 17 Nov 2021 10:31:39 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t4sm366581pfj.13.2021.11.17.10.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 10:31:39 -0800 (PST)
Message-ID: <61954a8b.1c69fb81.d860b.1c4b@mx.google.com>
Date:   Wed, 17 Nov 2021 10:31:39 -0800 (PST)
X-Google-Original-Date: Wed, 17 Nov 2021 18:31:37 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/569] 5.10.80-rc4 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Nov 2021 15:46:44 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.80-rc4 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

