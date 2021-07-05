Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4B3BBDEB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 15:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhGEN6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 09:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhGEN6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 09:58:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB77C061574;
        Mon,  5 Jul 2021 06:55:44 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i13so10259619plb.10;
        Mon, 05 Jul 2021 06:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sBKxZg6PD9doHfQdDLNhOy+vX8H2bzlFPtwLXuBHOfQ=;
        b=mzGzRfFR4HYCg1voRm8TggOSE31Dmlwt1B74jKu83Tjuw6zeC32fiQk7ez/KpMMYth
         oxFxSZ4p+4ZIwBm16Z+/hLrfRsc/Agv+pqxQ3FKsBgmZq9+L4/O6LXyr6VDU6NJ93fxI
         dgZCAc9Jf1TxUVZKk4syC4UlsZ9bvtUOYSUmQEQrTSjd6g31pRGMxKNvQclVhl/T5W76
         hMqkaGDNsCJ75I2rQpB+hpLRxC5pCmN+hXZKhJZrQzGSUZSAH+mI4Xn5ZJVI99oZ/Lh8
         gHFClXSbDFQqx8eBJYsVPRYiCAC63tb2TYQ2giuTt3ZLP6tHlBD/2W9Yw0Ph7UQRstfE
         XcHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sBKxZg6PD9doHfQdDLNhOy+vX8H2bzlFPtwLXuBHOfQ=;
        b=L/073jq4xMQ0vXhwa1iu1BfIxAL4Ppoh0u8TFr4bkN8tesNu7TxM5c0vrrSOLtnfgL
         uYzUusN7K69J+v4IFy1FMcsYVMtMne6VmNiXgRjYpWTc31O51tVX+MK4e0xl2RVb25/z
         hL1nALxVveln96bMa8mpXNJQzldziwJe1dDzuFjVfFpxdMCY9fH/MT3XBjW1dexBy4wt
         mWDlN/NuCJ4MUQ+zn5CMBY6h4g6EHWXQtRbf9aS8RbHuVRK2AZyVLquM7128XmeKOfPV
         VU+BPNxI828uan4y+9KPD8mW172PP+pzeKySfZaRSIvnc3kF7teuwUiGBafnTCFd7Z1p
         2n1g==
X-Gm-Message-State: AOAM531HzJrj8BFOsEJqkBrvQwiUAs67km/5Izx7dtcKyQd5xa1R+Bq5
        cR/n/7Qq37SCu9x/bJWsMDMHH/viFQy17E0U
X-Google-Smtp-Source: ABdhPJz7te8zFZbrg8CVzPPMZiUpMmTHo7TVSCh6WhRbiPvrJPx+//4HWhWLYJri0SWRNLQJSdKPKg==
X-Received: by 2002:a17:902:e309:b029:129:54da:782d with SMTP id q9-20020a170902e309b029012954da782dmr12711493plc.9.1625493343892;
        Mon, 05 Jul 2021 06:55:43 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h11sm12720391pfc.107.2021.07.05.06.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:55:43 -0700 (PDT)
Message-ID: <60e30f5f.1c69fb81.9792f.5e75@mx.google.com>
Date:   Mon, 05 Jul 2021 06:55:43 -0700 (PDT)
X-Google-Original-Date: Mon, 05 Jul 2021 13:55:41 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
Subject: RE: [PATCH 5.12 0/7] 5.12.15-rc1 review
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  5 Jul 2021 06:59:27 -0400, Sasha Levin <sashal@kernel.org> wrote:
> 
> This is the start of the stable review cycle for the 5.12.15 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:20 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.14
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

5.12.15-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

