Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9559B38F4DA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhEXV2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 17:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhEXV2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 17:28:47 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001CFC061574;
        Mon, 24 May 2021 14:27:17 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m124so21032622pgm.13;
        Mon, 24 May 2021 14:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/AXCnWWbppkvrDbwpVLtksfVERM2AC+R+EBKyLvOYaY=;
        b=MKmC4wI49pi46Hyf+EMx6FfhhrQRWha9ra9fLMxrj5J7uc7R3L/R6NQIb0oOd3Pxue
         CffwNpR8jgrVOLuUEeToLi04XnkTABOYrZJAvjYIfRnxW+Jl8PYEkiI/z0LfCZtU7ioq
         kaKseHnUNsHICmKdVUlVX095Y0wUlQBCAUuT+VLT1wTwJY6Xc+ZmK6H+P7hvaE1ubS/n
         k8lJyTQiVsdX8ol7vKYEtB7q/bEBl1ZAJhMv06ohgeuO0FFG+CARn2t6LXMdNafR0YjV
         A92fGlM/k/tyCm6FCrFJ/ZMszV/VPU0eE1dIrc/FA02qX7YGnZiBYLK2acHlDWQ5VM6f
         cAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/AXCnWWbppkvrDbwpVLtksfVERM2AC+R+EBKyLvOYaY=;
        b=eI2E7R5pKE0q12Z16KygXtzcv2cP7n9bINoIPZfdQETdB+dL+LGK+zNTGU76fMBVRG
         fV2qYLaQnP9C6s5kOiQu0cloHboAZ4o+3bcnSMbPbeZw4vXtQhsXkYsvsoaNhgVVK1c/
         im6dtSeDaWCb9GZwL3YOvlvMNadrt8usct7f5AUbdfbqdXTIWhdkSLZuhHoDWmA8trWn
         iJebqh+CSjB1fV1a06vXgCdJ2ElQRHnX47+70vezTbg1Lp81mpi4VUirIDpv/Izpth9F
         Yqr1p2ZhfG4u6fruCWes5TfCj3Wxr32oeTb9x+5s8WvSC0njKbxHy5gzgAkw2jvnoAw7
         LIxQ==
X-Gm-Message-State: AOAM532tcEHEp0ytF2D9uUvDuW95mBpEo1EUxz5EDIjl12T7fSBiemNo
        RvTitFtmgqas3WtEYWx9dYff7TD3aGTSEXcRwlDy3Q==
X-Google-Smtp-Source: ABdhPJyM2fEegL2yG/tw1M0+0LliYAZOnipPktmBVoj1rbS/1dMLF/GYgwwKbBSFz57uuEslK3SrGg==
X-Received: by 2002:a63:2350:: with SMTP id u16mr12447672pgm.195.1621891637165;
        Mon, 24 May 2021 14:27:17 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id u12sm11416891pfh.122.2021.05.24.14.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:27:16 -0700 (PDT)
Message-ID: <60ac1a34.1c69fb81.e1d42.6175@mx.google.com>
Date:   Mon, 24 May 2021 14:27:16 -0700 (PDT)
X-Google-Original-Date: Mon, 24 May 2021 21:27:14 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/104] 5.10.40-rc1 review
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

On Mon, 24 May 2021 17:24:55 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.40-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

