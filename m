Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A809236551B
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 11:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhDTJQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 05:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDTJQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 05:16:17 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2526C06174A;
        Tue, 20 Apr 2021 02:15:44 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c15so27872936wro.13;
        Tue, 20 Apr 2021 02:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BkbCKM/k1ykwGySKHLTVANKO9KHTQV/DlbBFp2FzjMs=;
        b=M0DDpb0hp6D4DqMInI/HFBWTD/8gQKbY/u8dISndEyYR9QvRKm0n7CEpLaw/I9r/d5
         0QgLz2FPzyrfB9A+Fz5ZuGdrJJFbeB9XAM6QVDPOYfmQnQ5rG6346BHBztEFuWplnWpq
         Cmf4TyGOjB5qI04TBa5cEAITTyDrmcIIvaWY8VGmyWDIDhFIzXtlnP5rqfM/vfY7Ho1M
         gOaM8VboyfQDljar3foT3mTxKKUHvAFls1E69gk6X1RdBWWULe1M75mfk9pyiShRK4Wg
         BOAFTEjVrlE/hXKIxSsdP4hjfIxQf//rQw1O7R8lnEE/45JqAuBZsW6cVk002Yytlbk9
         lz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BkbCKM/k1ykwGySKHLTVANKO9KHTQV/DlbBFp2FzjMs=;
        b=bUtng2xLbVSQrNiLCtVcYKJCEbgIFDSNrZlfMwdfiDuO17FMwl1kIP/QsaXLFVU7Fz
         JvbL6gMy8IpEepmFQv4+tQcI/3cLdi1T2TvWf/DFgu2c1UtEiu1oTALwORKu4cxyCF6T
         0AVtHbNGEKHiN1NOk6U8K1G3xovxwA2zWtr+2x4P9d5SbJka/yB/ThHkNbYZRBqxqDbf
         YdwC3kxLlDDIcrxomUiOdQzoPHKSWs2KtWZzUzMAUfKLEQa6NNod437JDWyjFL333t2K
         fQYObyikglxuWcZinr+TprwgQPOFYrdkwd8enccKvSi2C36fxGGJcUpCJ3d1fQb6ouVE
         mf2g==
X-Gm-Message-State: AOAM533mgG02l9ENiULs+PER3YCB5INYmwetWahSmvc5XyrBrP9spzbU
        YvlFJjqoY6Aru/ntCgy0MiGaZfxvhAJh1g==
X-Google-Smtp-Source: ABdhPJzbQp3JWiuBvNFipFhamXUXU9wKt1r2BynNt+IHaJ0qA6iGjLO6SiPOg7ruDtS1GalfIIlO9g==
X-Received: by 2002:a5d:47cb:: with SMTP id o11mr19052845wrc.378.1618910143573;
        Tue, 20 Apr 2021 02:15:43 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id m15sm23588524wrx.32.2021.04.20.02.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 02:15:43 -0700 (PDT)
Date:   Tue, 20 Apr 2021 10:15:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YH6bvUWCkchQhHrT@debian>
References: <20210419130527.791982064@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 19, 2021 at 03:05:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210419): 63 configs -> no new failure
arm (gcc version 10.3.1 20210419): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
