Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECD44D6A7
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 13:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhKKMcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhKKMca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 07:32:30 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74521C061766;
        Thu, 11 Nov 2021 04:29:41 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o29so4916006wms.2;
        Thu, 11 Nov 2021 04:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0tMfvP4Mz3a8Bp08U0yneAGTC8aLaMj3BxhAPrjTCe0=;
        b=BStFhoaTitL+lANSUa6KzVBFUdabVylOtySdzEbp/hzYJXFUqcfLA2tISurJRxyKL2
         NbmJjF/sHx4U0NEOnGNVLvypz8n752khBQWNJ0IMEeAimNbI7G20rOUU+wTouPDjnZtR
         FY0/bKnAJUcC6LI2AyrtpT8oU6FIFKEevIMsm+Lgux+NPyxEWDlaBzBdvJWPKKOlTkwD
         s1XA5JuCJQjXvvNwYEHU4wu4R2VYDb5NI7UiQUsAzXuVQu1Y3NZg0cL8ajGb5a6S1P0+
         zol4fZ6EKSoDztxvwrASpe4jrqwQu1OnD6VewCdvEjVCVdjUrH7T5RtLgHoiZVvoCaIi
         te0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0tMfvP4Mz3a8Bp08U0yneAGTC8aLaMj3BxhAPrjTCe0=;
        b=hOHzKughHmM+FdBw1+mIp9o4w3T6T6lQFG05990kwmeKP5xYIBvZcRpfWvVtV6somF
         749/Lu35/+ae4cNAleANm538zLJMdG1chQnKSOFpfjj9Y/SzmNX/iyAioBisbZRXU4F0
         0AQTKwDC1DDmCSYTCCUjoU1hs6ZDQPJXGw8b0cpebKiGf2jKn74R5aCOwgzYW0sW4ZcN
         tvLWyW1LK+lSiBh0xkRWq386b1HW2ixQNrzq+iFcFCPRT2EOueRQmf76aeNu1VX4aMiJ
         MkmzlTqVXKKecbhHVOPHAcmd6WiPuyQ/yYVbZz8Qlwg5vzeyiNWpuBL2NrVJVSaCLISy
         ILrA==
X-Gm-Message-State: AOAM530yzeIzaFCMNQhEZhnt9ePXblokSvzI6g3QquSNi6OqaT3+Odz1
        aNJSoT8g62Ra5j3UCk26+Ck=
X-Google-Smtp-Source: ABdhPJysmYJWBa0xKrAQEAzzbzYWtVp5mdUvmySeRld7Fj/cULJINfQrlWZjYgfF4DeBxjvUE92gzw==
X-Received: by 2002:a05:600c:4e8d:: with SMTP id f13mr25513961wmq.7.1636633780101;
        Thu, 11 Nov 2021 04:29:40 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id w7sm2799991wru.51.2021.11.11.04.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:29:39 -0800 (PST)
Date:   Thu, 11 Nov 2021 12:29:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] 5.4.159-rc1 review
Message-ID: <YY0MsN4ATTvU2hdv@debian>
References: <20211110182002.206203228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 10, 2021 at 07:43:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.159 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211104): 65 configs -> no new failure
arm (gcc version 11.2.1 20211104): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211104): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/366


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

