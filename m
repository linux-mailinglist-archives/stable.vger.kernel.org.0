Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6893A7B08
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 11:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFOJsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhFOJsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 05:48:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BAFC061574;
        Tue, 15 Jun 2021 02:46:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z8so17587641wrp.12;
        Tue, 15 Jun 2021 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VLgYJtEWcsWSSq1KB2ZPXSuP5NMn96xDrBEWW5MnrCc=;
        b=b4YopHQ/fH8R+G17NmMbtyQ7bLz0vHCMFy3z/Sdm68X0/ICV934c0Xd0SrplzolNg8
         3qD6INXK6gWqQ9cMGIl/ZNmzkUw3UiQ1y6UThLZGUJWCJjcYLfP/BACZObUOabje7deF
         zl5/rBcVFV/uFALmEaDaP1Y+ttYOAvkCH32Q1GhKrzugRVwvTIlcv4UMgABMmN9wa2XL
         7I++fQ/dDriphYtX2ad13HVp6r3NualHflYvY0WbgkKwkgPB9GPJkIDFiJ5Y9z4Mulhl
         nDQ/u1VZIozcPLRcph1ZQZwwkTDTroc0+rdcoYyngI07K/2QlDrb/aX2GaaIsPqxh+9w
         cbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VLgYJtEWcsWSSq1KB2ZPXSuP5NMn96xDrBEWW5MnrCc=;
        b=I5xXCu4i4nCrDPgdRQrUTeE6DXWGRad+EicRJcvYKe7C0HWz2+Z+CjGbR8wtdfMK5l
         1Ol6YOlREQ7igXWczMyZd28DWY1wEFn4Ch4PXUESWEhh8Tlr3Lonw8HCq5elx5pnCjzy
         TYQxa5VUisJD6c9mNJ5ZitKRENc9Xpk9Hoc50coruXGCBcBflNYK+DeM+Lrj2XDRhW3h
         ZJXEnLlvVRAHugx40bxQx9zbqhyI55orScq6mjn0psANYdOMdJvhfLU/CR9pF45kAPzM
         ZfxPHLt6HrMZDww0DOjHIjXPoGu2tDZ2j/UABmFs9HYI9MQwD6oQ6gXwyzXMAVWkRRzi
         0D7w==
X-Gm-Message-State: AOAM533acdgqGfCfvPVZ6eihsbSM2daCwX/rls+P9EOW2fWcEFLTSIUs
        NPogHq3kjr1cNr9RHt6Ob/c=
X-Google-Smtp-Source: ABdhPJzhwF6cRKMtfawaOjRDGaCf89MKHrpd3E229ALHEvpOIB1N7BizCcEocoUx2BQ4Q82g3q9yyw==
X-Received: by 2002:a5d:6a82:: with SMTP id s2mr4629397wru.247.1623750386177;
        Tue, 15 Jun 2021 02:46:26 -0700 (PDT)
Received: from debian (host-84-13-31-66.opaltelecom.net. [84.13.31.66])
        by smtp.gmail.com with ESMTPSA id d15sm1121577wrb.42.2021.06.15.02.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 02:46:25 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:46:23 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
Message-ID: <YMh27x/IoC5wTQLf@debian>
References: <20210614161424.091266895@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 14, 2021 at 06:15:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

