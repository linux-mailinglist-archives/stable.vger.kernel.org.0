Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC34441CCC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 15:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhKAOpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAOpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 10:45:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E13C061714;
        Mon,  1 Nov 2021 07:42:27 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t21so11680755plr.6;
        Mon, 01 Nov 2021 07:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bTY8exYms3lJwzCaoq+nmco6/S9wmqs0bDwxZbOOVDg=;
        b=jFlmGgwTowKKoR0DRm3XZtyBMm/XSpDd+aOkJvWw3kCZjnWUB7GyH92vJIeIPvk/2f
         Ro0k+95jND9IIvfSgPn+ohRWSYGDvZ5cPjzja2uZvRqDnJ3CUq/R601hS+D/ZwMoRtcX
         5RSN+pAdnPfM6BuKbXlYJcatRxF3jVNwai1m0WeYNFcYbfdjCprfMydpgGf8hWiIFpZ5
         ygv8Obt2XUeRX+UFHdEQu047Hn0CRu9RXrX6vm59EoSr1P1OBc9YHDYbEN9Mpmauc1E9
         E/QkjDm1KvqV+jtAoCACns4EkU4L4UBPPAxuBjK9wMaxooPNFYTo/5NYZJ9gWAhn5DOw
         Scug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bTY8exYms3lJwzCaoq+nmco6/S9wmqs0bDwxZbOOVDg=;
        b=nhFBKVtbcb/nlzUi62mw6GRpmlC0H/Y9V0XU4H2ZHzmJwq8s9cwBNfaP19Z4PhbnVX
         18fcvGyoi/B9pmpLNtVyRzkdk7ZwMzoUiucvlizBM0QLO3Q90rcuvvi9vJHiD6MRH6zG
         74XyCrhcpD5mxQxkKJYE3+TzfPnG7635S3jE/R4Csd+ZutSUJ8VxPG563t00a3ryjZXZ
         MBHxLl+GfMM7wuGNR8TDC/YmxVCM3UWTitEt+AkxxfkR8jOCOvoIJRpwraaXFTjoBr54
         GLxqWFfw5GhO8vuSBS49TGpQ+ESyQdd40CL7Q6ZTasOxh05/4enZ/zizn3FXVjftJ8Jr
         1A6A==
X-Gm-Message-State: AOAM530sb2BeQbq3Vz+1ua9cmQz9SJIwvGLPtlUDzqctacH7gjJD7LfF
        zbaX7e7ls7k1yNbspE7AESbf7wLBrr81xUGDjP8=
X-Google-Smtp-Source: ABdhPJxeO3hvuhHUzEd/D59/9BJoOlInGjqem1Jy1QdnlMhAHfjYFFZUwpKGDbwJlJBlwSuYWhIc0g==
X-Received: by 2002:a17:90a:d317:: with SMTP id p23mr15879852pju.196.1635777746451;
        Mon, 01 Nov 2021 07:42:26 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f19sm9706731pfc.72.2021.11.01.07.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 07:42:25 -0700 (PDT)
Message-ID: <617ffcd1.1c69fb81.df46.a43f@mx.google.com>
Date:   Mon, 01 Nov 2021 07:42:25 -0700 (PDT)
X-Google-Original-Date: Mon, 01 Nov 2021 14:42:23 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/125] 5.14.16-rc1 review
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

On Mon,  1 Nov 2021 10:16:13 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.16 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.16-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

