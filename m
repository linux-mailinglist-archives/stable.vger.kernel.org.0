Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745403EDAC8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 18:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhHPQVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 12:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhHPQVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 12:21:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA97C061764;
        Mon, 16 Aug 2021 09:20:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u1so4151280plr.1;
        Mon, 16 Aug 2021 09:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=g+yn9nZhNLG4DJCKJ/p6iESJD5wA0K+WPC/YfwGbIaQ=;
        b=a05oJ4/H0Nm+Cu7I/w3mILltz1wDaUvpHqlzi/Fj/uE0W2aOzRGfiH96dukuQNeb11
         TNj5vpAydvo2gr9O56x4IX86Tzuks/F7WNBDUHtlt++RmOq72qktp1g3b4vKPAsrcSu3
         wQaeTms1/1yrc8kxR3Lxb6OL050s/+9rhHQGvCe1agTsctFjRtO/cdf5u5MMIuYfPB3p
         BR40QKzTbfH54CLIqIsGAU/GY/3zn42dGV9wrkZL3Y0aBOlui7yP5hWRB9jLj6gVtg9P
         mdLTJQX2Blpy+QnqCME/ZAs6At/NFW0IzV1hjmuWkgqN5XFo5MEILvBEZvVZ0ZhNVUQB
         D27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=g+yn9nZhNLG4DJCKJ/p6iESJD5wA0K+WPC/YfwGbIaQ=;
        b=YTWMs1jskCkVU8ubSva0OqZQPPgh+Ijza2hfKFSLqUnHBZvogeKA2S414XQjVgGv15
         AV7rbTSzuwLVBi19mgTGUF+ZxGeJ2TKFMYwsNG7hkh2txSymmtrIwtl99WDSXvbtK41I
         ect2XDLv69kbHFVh10TO+HseZMOB5XNBPdvCwocY6jY4ZQzwHQOZyxPU09qyNI7qoE3u
         pN07OFOQjI0NibP+L63trVx9RK3t4En9pwKlnXst1/5TZz2Zzz4hq8NpgwdbkWUfbquk
         lhklqhZD+WcMgiG+Y620ak5nshLJT4L35insIEPnBy9jKs3JTMApY5+bJarTts8X9ZU/
         6aQA==
X-Gm-Message-State: AOAM533J240phh2vPRWXdF/uV/UcJhE6s8DpEM+YTlcLbqUQ3GVfCn4X
        Gp3bSGE7vuzJ7CI3z8kSpLc4+0CBSukfHL45glQ=
X-Google-Smtp-Source: ABdhPJzAmmlWYEOfw82hnkoqBhAnK8ltbRkrx1FXU8LEPCmTylFQGzn8ogrrZym98vXZ7DAY8IIwOQ==
X-Received: by 2002:a05:6a00:1ac7:b0:3e2:2d05:3b31 with SMTP id f7-20020a056a001ac700b003e22d053b31mr2368758pfv.2.1629130854760;
        Mon, 16 Aug 2021 09:20:54 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id g10sm12038270pfh.120.2021.08.16.09.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:20:54 -0700 (PDT)
Message-ID: <611a9066.1c69fb81.928b0.f5ae@mx.google.com>
Date:   Mon, 16 Aug 2021 09:20:54 -0700 (PDT)
X-Google-Original-Date: Mon, 16 Aug 2021 16:20:48 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/151] 5.13.12-rc1 review
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

On Mon, 16 Aug 2021 15:00:30 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 12:54:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.12-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

