Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD32463593
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 14:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbhK3NjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 08:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbhK3NjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 08:39:21 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBD9C061574;
        Tue, 30 Nov 2021 05:36:02 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l16so44483001wrp.11;
        Tue, 30 Nov 2021 05:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kd/PIpmYaLUF1O2eJ98CX6rZ8nmgEvejw2gH2/LRG4Y=;
        b=HJ7W5FGbNE3/u2oB438mBrtAFyavCbqGa87yKoYhwlil3eLvSGmZ/41E2zB9fNJr8W
         6D6jrNqFDYy8B4kmNcakQqBSPoN/XUWEx740RIOx8XTarh47tttuZPOLBaNVb2dxt+ZH
         VGJFdsAAnsR//l0Ena+5wD7eG0vJuZAQCURwRrGAFdr43FGzRNULm1N7cOwYyhI1tySk
         1cK1S9sFkAIPP0tvrWAmuHVT+TzmTVh+4RDkzY+Q1cTE4G0O8xCeNOPm07nYmIEImLaZ
         S23KcLoCuxjpIb2QBOe204GvrzQJMvsWOW7JFQM26b8JlkQzI5prpIVcfmqH3s7ph3IM
         fznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kd/PIpmYaLUF1O2eJ98CX6rZ8nmgEvejw2gH2/LRG4Y=;
        b=FOvC3f1o/ELVfTRHsl6Huzloyrn0mHVRuxYgXZbTLF0b3L4qqT4gPFE84xcVp7hAoO
         BiSY5y80EYj12E7rL7vCGgLN47o0ZVFYrOd+q2PoRA1pHscj0dG0NjvgFBs7mCrburua
         6lyNygM9We9ePrH5dzrigsp/N/jo26XJIq6xPzq+aSqFZp3kZutMBvZrTxRVgT6Vl0/n
         C+WSCkjgjJHYUcSdWrAbHoraRCDmuZAU+/qkS7x87c1hOBxQSwV25yWMxxcpxFrL03BR
         QIr8L7UyHwk8COTfoal3L97l354agIo18LcjXemK49hel82cSHR4IZ9i/YFylGi+9o3E
         tYPA==
X-Gm-Message-State: AOAM533GkqgzYN310+wlTvQjUv0RB3dBYYgl7rAxWGbjf1w+AmO/pGlG
        +pAy9QESpc3RWAmiM342aaXgOtW31OA=
X-Google-Smtp-Source: ABdhPJwPQ4CbgKVFJFMipUY07IGCj7+eKtDT+kkFUE3RgfiqFDHqqNuWxN7wcmF2ElMi2fp43dxe8A==
X-Received: by 2002:adf:f189:: with SMTP id h9mr42486139wro.463.1638279360678;
        Tue, 30 Nov 2021 05:36:00 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id w7sm16719370wru.51.2021.11.30.05.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 05:36:00 -0800 (PST)
Date:   Tue, 30 Nov 2021 13:35:58 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
Message-ID: <YaYovvQ9sXKEI4i/@debian>
References: <20211129181711.642046348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 29, 2021 at 07:17:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/455
[2]. https://openqa.qa.codethink.co.uk/tests/450


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
