Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCE448F202
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiANVZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANVZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:25:52 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967B9C061574;
        Fri, 14 Jan 2022 13:25:52 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id k14so9946029ion.7;
        Fri, 14 Jan 2022 13:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uDnDf1DQUcIKiU/WmtPYVDPZoECXknDFAzEAIWPNPfc=;
        b=mpwljeHfYu+YF13MLEqbg4u5QEnsIwf+LiYrYhrrYAnIxk1chi1CTNZGYWVozYv3jU
         Yd5ovjTDJXVj+EoRDJ3lGTfztNxZX8E9k1NxXQ4WnTNPSQap1I8VPwBIAU01jhinJk2U
         IgJZ1OdnDJYf5IsTi7woX1klQFXEz57GP9Wp9qZYtyBjGrc5Q2FTwzZvvXv0PCz/PP/B
         095r9NvNMwzyY8J0YgdyGNAHUeNz4zk0qqJ8sJpJLoV/09ho9OVoQAbRiRDJKnwvKbMo
         Zfvv3bBfEg2Cu6HlyUVf0XAq7/6gwhzRap0Khax5rpDXR+XAY5PL5KTJCYJMU18Flvhn
         NdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uDnDf1DQUcIKiU/WmtPYVDPZoECXknDFAzEAIWPNPfc=;
        b=vM2LnKXjmIqOY2A9boGOe1wyu1cN+/3i6gT9Im4h40+6lRkwle/X33BlprlpLRlqzi
         WeR/c91ualIJWN//ox8LAUcsmINjQKjnI0wtS3yYevstp+c1m+r39s9jCnegLtU8qioy
         xzF/SSiy5Hxs8KAkVo3uhL1mP2PS83O3qGd1CoGaG+q9anhLcrwKZa49M/QbSzg3rEfh
         dczGu30nOqdozFjx7LQvijh/VXG8eyzwgMiQKjFy6/yW8DM5UyFjc5sEtXmRTaC1XlAF
         sUEBH+nyZ0iqFb/NMy1g0rMahWbcPpkhzUF4h82xe/P/SSn+iWsUGUflCeP6yLVTsSZX
         ZRMA==
X-Gm-Message-State: AOAM533RJPawryabNSjmzcelIzl5Nrl+6m9JrlAVh8SslZfsOvGtlJhQ
        vhax73ugpob9kc6gL+Jur7pRq6bFEYrZIIOOe9k=
X-Google-Smtp-Source: ABdhPJza9aKEtuNK5at3/gBvae2H+p0bDrVD5mR6YRXkAKacewQ7GCLK+nMsgkThfA54h4NhDjhtoQ==
X-Received: by 2002:a05:6638:359f:: with SMTP id v31mr4817280jal.59.1642195551501;
        Fri, 14 Jan 2022 13:25:51 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id n5sm5628388ilk.44.2022.01.14.13.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 13:25:50 -0800 (PST)
Message-ID: <61e1ea5e.1c69fb81.f740b.8957@mx.google.com>
Date:   Fri, 14 Jan 2022 13:25:50 -0800 (PST)
X-Google-Original-Date: Fri, 14 Jan 2022 21:25:49 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/25] 5.10.92-rc1 review
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

On Fri, 14 Jan 2022 09:16:08 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.92-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

