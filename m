Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15D33D02BB
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhGTT3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbhGTT3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:29:01 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F71EC0613DC;
        Tue, 20 Jul 2021 13:09:38 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id b18-20020a0568303112b02904cf73f54f4bso18934ots.2;
        Tue, 20 Jul 2021 13:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wa71V16uUCrcisT7gnfAz75/4wMaXLGKfbOO5fAun8A=;
        b=aYC0mp1E98Pwu1UU8nSASKCvEntDS/6XXv/UKS0uLz3rCvxjF0SiQqfRoEbsIkmhoS
         dk5bYCsXRYpKSgzVVf+3oMtHoL8b1DgoOsnrctgu0AD+djgHsuDXznX25MjNYj7LmVQ2
         CVEDp+/BgHrEJZQv0q5N3PCzc42aF51QJ9eJ0DHab9JsnW18h4C0BLupn46B75Nvglqq
         MoBS4Y0hAhVBi4NhTzSoE+LRz1fbTfIhoi3vtL75E2pLDm//H+5KAEqGFuwFLUSsAGA/
         Dw6m2OKlriodcyCZng93+HObbVI1TWpfvYZq8RNdPlWMf2NPvp6uCPofObGAecuXO+8j
         n43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Wa71V16uUCrcisT7gnfAz75/4wMaXLGKfbOO5fAun8A=;
        b=Y9XGzZfDHiJKy2UIQn7iTChio0eEgXtUsdIhbi4I8e/7NFKSubbYc20l9kVXwHm0LH
         dPFuYla+UJJeMpsaE9RLEdvwibKiicnPchqCL1YmSjrlNT067vPLifQAy3ZSsXwtQq+4
         VGijJTCZhOLpVlOVTufzNNNggn/i0EY6dLYf31Dz761Z01wCkdISSpgi0WqrpaqzGfQX
         qJBjHraHRCB52lKFwaawu5ffA8JgnK1kNRnuITvxAfIVW/AtFNqDbuGfzjErL+MA+9pF
         iC4K4KHtP59Pmb3r4Xr+2wJX9o7qZ6T1K8gXxkN3cxiFCHuUmRDaOFHzkiQLu0hvaSS+
         Ndkg==
X-Gm-Message-State: AOAM532dGXk7a0pH3H2scFFB6Gg9i/RvsICq4IDYgB6Xd6pEOE3c4+pc
        MiNb2qik+yGtmcRLhn//ZFI=
X-Google-Smtp-Source: ABdhPJyYZdFotCyYT5/L2pSXVGPz7izj1IBxkseRQgrvCV316KENIygEJg3YrFEVxEbfnGgGgPwukw==
X-Received: by 2002:a9d:39e3:: with SMTP id y90mr24257844otb.257.1626811777644;
        Tue, 20 Jul 2021 13:09:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8sm3099225oie.43.2021.07.20.13.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:09:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:09:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
Message-ID: <20210720200935.GE2360284@roeck-us.net>
References: <20210719184316.974243081@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:45:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
