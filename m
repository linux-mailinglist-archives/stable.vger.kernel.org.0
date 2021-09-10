Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DC2407102
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 20:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhIJSkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 14:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJSkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 14:40:05 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4717DC061574;
        Fri, 10 Sep 2021 11:38:54 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j2so1720729pll.1;
        Fri, 10 Sep 2021 11:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=fvpioIslolc0tYmZPPlkIYX+HxkKV9gDZuohkxnEZ4U=;
        b=fDM/GNSegGerb2hbt312Td4wq8or5SqGP8HZzCMbLOKIDxvVs+6XRzYmKCowGg4aMw
         j8D+yFvbCUNg+jQ4mILf1x9qjg0HOR7W0tXyItVcsdWuVo9T8ta06g6Kg6sccoQZXBbg
         WoXxnldAj8Hd5v33rheJe/pKergLrFUmfjoJljCIyYCzoZF3sQurUFcoyLdy3J5H6V8F
         IpRLklN2C3nSGPERf2GiTkkP77uV6nuw1xvpMLXAuwaWCKXpVmUJ4/eZtBRXUZl9WZ+u
         QdeePTyCObJ8OiOyuf9rr0rYNAvsWURRx98lmVjQYL9lUufnJ8yVC1FBgyZcnNvpKmy+
         QzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=fvpioIslolc0tYmZPPlkIYX+HxkKV9gDZuohkxnEZ4U=;
        b=4/Zu19B4SVozvhAJ7P/GkVJ0kj79x4au9IdtEBFNdW/7uYut9by/+wKJAJs7t7scqN
         cGduanchgDDDNoQXOcKTTcfbUzvmJjheqfXR5IlqPqI6iOGckIi5d8XMeYDxGm91vCGA
         /yFB+ea8cn2IdH4hk6DC8vxM9D2zwmYp9EDitgTATLXi4cLW1m+atj5IOQfoQFYvYyiz
         Z6sx1GORqHVXTEEVo0rImwh73xfxZcF4juPpH6QbYzjRpF61QJJfHJLwnrZq1UiPVCl1
         23KBfkxg8Ge5RCdBkG7gG2I7Poq2fIoEElNZIHzXxSoJ7J8TNGyzveWPZRPd5/J8lpc8
         3n9w==
X-Gm-Message-State: AOAM531KuVjNI6BzeoVc2tm31pABq7+6Liiuo2XQWz9OlaOjLjv/yl1Y
        67fHwMFD5AWUCZmQozKaHaFOiscwLG/F+UYLA0g=
X-Google-Smtp-Source: ABdhPJxTPyvzN23SZKD8CL0uzDp8+XO377H8VF/C0mNvSyP/ZGB9i8oTCvxU8gGA8IXzYfxhTBcOKA==
X-Received: by 2002:a17:902:ec06:b0:138:c3af:d085 with SMTP id l6-20020a170902ec0600b00138c3afd085mr8890091pld.56.1631299133191;
        Fri, 10 Sep 2021 11:38:53 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id x19sm5862658pfa.104.2021.09.10.11.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 11:38:52 -0700 (PDT)
Message-ID: <613ba63c.1c69fb81.cc6c0.09fb@mx.google.com>
Date:   Fri, 10 Sep 2021 11:38:52 -0700 (PDT)
X-Google-Original-Date: Fri, 10 Sep 2021 18:38:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
Subject: RE: [PATCH 5.13 00/22] 5.13.16-rc1 review
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

On Fri, 10 Sep 2021 14:29:59 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.16 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.16-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

