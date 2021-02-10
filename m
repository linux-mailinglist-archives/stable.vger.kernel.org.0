Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD55E315C0F
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 02:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhBJBS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 20:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbhBJBQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 20:16:48 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84113C0613D6;
        Tue,  9 Feb 2021 17:16:07 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id m20so350896ilj.13;
        Tue, 09 Feb 2021 17:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y8jzPEMod6HplRFXmW8yKHoG8Vn5ZPL326ibkvCl1w4=;
        b=ka4mrlwld4wjwjqUQmm/vmJIWxU2V9xa6DMLBbsu1rHFwcJitKcCHV4TspY6eIwBhE
         oBKj3AWTvc+RZXVfwefRqe3sHOYsdk05SqJ+3JjrE1Xw75Go4jLFmLdRLIu+tjgk7Jsc
         ZtGUso3IYwa8jd+FB7hZcc/sIFLwq9iXcwB/clw6E0QYqMMBHOkkoL7s7KFTrqMD2dVv
         xr81bFp7HMYd4fZHqHQXh28VcApDx/fvNfTn8X7NfTX+/oa+cwSdCsuLZbXDa+H4Ndtq
         fASzwXAMch3ippCyZuEMGU3YO5rlnpSoiQh81XeZnAl4KeafMPr8nvGOHzA8JZxhbMoy
         8SYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y8jzPEMod6HplRFXmW8yKHoG8Vn5ZPL326ibkvCl1w4=;
        b=bnMlOUpSoWrrnSkkf0Qhqjs1Xr5iDFY8t4MkscaGHxSg2KG23Nza3eTqs/S6wuQCRQ
         MvoVv1qJUfCCTdHBfmkqbf74Ef8hccxvYQcPCbRwgVPyno7V8XTpC3kIv/le4/XxElJ9
         cruJ4WKsQ1mnN+rYpVxfLCFkcSXJVLSCR/QO8cWBSQ47hfJ70nAdYVsrroeTBxaFlVrj
         WgJZhCwb11lqNef5XLU+44qng0HeX2bPDW4wPJeHG7CgVmPNdIxOUlBn/csJdyyoutCF
         Oc4NhHEBnn+mvWN4mz0O+qTy61/TJensD2hTw4Guu2RILBy+Jed4wss+c7AKjYZdjbJX
         3fMQ==
X-Gm-Message-State: AOAM531q9zGrrsIhHI1YUMmpuoXZe/WTdYA7+hSX0DPmm2VTGKaBMOgE
        YZgCeaWzjehKsMSGVaeRVc9c1CmP6xPJ5A==
X-Google-Smtp-Source: ABdhPJzzFPSDKjogefLfOw6d+0T+IbLR7rYJUIdWl9LfvZhbVpjIaxE9bmyD+rOkDuSJFPcZwX6WTA==
X-Received: by 2002:a05:6e02:1be1:: with SMTP id y1mr629706ilv.101.1612919765497;
        Tue, 09 Feb 2021 17:16:05 -0800 (PST)
Received: from book ([2601:445:8200:6c90::d0e5])
        by smtp.gmail.com with ESMTPSA id r12sm200116ile.59.2021.02.09.17.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 17:16:04 -0800 (PST)
Date:   Tue, 9 Feb 2021 19:16:02 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/38] 4.19.175-rc1 review
Message-ID: <20210210011602.GA5618@book>
References: <20210208145806.141056364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.175 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
