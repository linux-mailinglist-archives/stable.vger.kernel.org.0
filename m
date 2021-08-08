Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5A3E381A
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 05:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhHHD1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 23:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHD1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 23:27:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D301C061760;
        Sat,  7 Aug 2021 20:27:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a20so12755462plm.0;
        Sat, 07 Aug 2021 20:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yMsySU8w8pIhBHUGM8yN4HEOCL9Tb335sGcRBukT2lA=;
        b=AeCoJsWZq8w5z80BOHqJvCynMoNbIVCYtlwmv/lsYPHmt+C2GsBa9OstsVA5Kp83cN
         9a11AM2Rc3fnaUpoC+Q8ZkDgQWiMca0D9Xy1w0SqkVMFDYfYxcYc78H9N2aX88lvJf9r
         hcTflhpuosl3wGmHjAFW3da77HIcCAvG8tRuVd+KJRBvf4TVKNmCXqSGAqfIrLIt8AaZ
         KwyEtbqLlC2/Zz8wu81TSivOZycHIKdaeVxhHm6KWNYNNux8P1SVeQJ+1q83sGsg3Y7X
         5T2aZenL0C22gVVNytsbqRRiLDqJVDxoQpDg9ArNF+++r6yzOrRJcgwPDJfPLJShbofO
         MphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMsySU8w8pIhBHUGM8yN4HEOCL9Tb335sGcRBukT2lA=;
        b=PP4oaoO79m05xxVm08gLLZre0y6GV16fcDlPcGzuLz17jQ7doYz4ZqBwdUR3l7qhmm
         rNe6oIHlcZTQB/iYmMl+Ql8UHLY9+i30QkpSHY4GSjSQoKMNjBWLbp0bI0vMU/2xpn0J
         rvO0Hbyq4/O+/ocB799LDsuWw3ednEAhTjjP6w+l7jjhM7qoZwzvPQSd+CoXSy9KP30U
         muk03lbgz69tnmrgZ9/EPsNhQVeQzgLMj4TAbUyrd8D6rkRxU0XuRlkwiHIIRqpVk1bk
         jbpH7i/6xUFPwVxJeCIbf1KgYr3MZL+2KRofQT0XD9JG4+mpktbc3wXFDlCyxaa71iix
         homg==
X-Gm-Message-State: AOAM532G8S9OhgqfAeuXhC96iHVvq4XEGJfV2xAupJLxybpKmIxyCTaS
        /XA6G40x2JcmTr2UzjIeVts=
X-Google-Smtp-Source: ABdhPJysrm+FYpS6kH5RI30lyko5gpEazUjqJ/D84TklJY/w2qMfC1Fum/cIaHAsC11/i4iUCUzoow==
X-Received: by 2002:a63:f4c:: with SMTP id 12mr17024pgp.304.1628393237666;
        Sat, 07 Aug 2021 20:27:17 -0700 (PDT)
Received: from localhost ([49.207.135.150])
        by smtp.gmail.com with ESMTPSA id c26sm9235207pfo.3.2021.08.07.20.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 20:27:17 -0700 (PDT)
Date:   Sun, 8 Aug 2021 08:57:14 +0530
From:   Aakash Hemadri <aakashhemadri123@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/23] 5.4.139-rc1 review
Message-ID: <20210808032714.3gdxbizqs56h2wqd@xps.yggdrail>
References: <20210806081112.104686873@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/08/06 10:16AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.139 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.

Compiled, booted, with no regressions on x86_64

Tested-by: Aakash Hemadri <aakashhemadri123@gmail.com>
