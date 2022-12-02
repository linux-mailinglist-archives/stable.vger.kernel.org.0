Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B204640572
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 12:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiLBLEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 06:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiLBLEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 06:04:32 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13717BC5A1
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 03:04:30 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s196so4109801pgs.3
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 03:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D1KXzSfZtuAisNZ05G51clQ324jnx8aq/gsDbzWWu5w=;
        b=RF10Mb34k2R5dAeYwD2YhiPWcI2Lcs/g4SWXS3huGVHmzpcWS3aJCJjenoi5+J5qNL
         N3PGDtE7158fXkTpnGTBESokd8cDI4BVGr2BjHh9zxuiC0jIT0ixgMWzN5Cqrgd5aeqd
         1zCBIzqITcDuwDjvZ4zN50m/xb9TGNBnSluxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1KXzSfZtuAisNZ05G51clQ324jnx8aq/gsDbzWWu5w=;
        b=d1M9YxetGQpucZUY/+Nl8FqX/35XfQJPted0RjnjSJicclngt6sFcWt/9/E0RmKCbe
         kNhwi79LbMQVhfmgmJmIwB3VbY5v7SwmS50OiwskeJ2JE+4mmn1geT/t7I9D1b58vwVt
         YOpA4VhNcmlDCJapALt7zuoKLLQT9WxHMytXqm6ERI+mayGk9Nz+8Q5XQllDEAHzixv0
         sC9r6YegHtwDb4iSVuNN1SEzxXFUH+buR6737bVNQqOVTyGqMfhAIOKYESwPkxt3xFXj
         hJvvhpWa/G0mSU7opdidV7IQqkInhCTjMJVKugsQqTS5YUENsYCqmm8Ll/jqIQBQma+G
         UWTA==
X-Gm-Message-State: ANoB5plYs27XTwqrKiTyUebTPTVDT4FhYKJbtfMBBb5cJIM8VtWZPEAR
        jgqLo/Zo4oc16RD7T2ijMCA/ZA==
X-Google-Smtp-Source: AA0mqf7wTZc+5wt4aeoquiU5DMuMCNEz7aE23amfAwhpaX6SQfiBJKju3DcbsUGJ+ZaHl0jVjFfUGA==
X-Received: by 2002:aa7:85c8:0:b0:574:5789:b8a4 with SMTP id z8-20020aa785c8000000b005745789b8a4mr44798364pfn.47.1669979068145;
        Fri, 02 Dec 2022 03:04:28 -0800 (PST)
Received: from d86934a8d1b3 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id mm10-20020a17090b358a00b00218f9bd50c7sm4519127pjb.50.2022.12.02.03.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 03:04:27 -0800 (PST)
Date:   Fri, 2 Dec 2022 11:04:20 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Message-ID: <20221202110420.GA20583@d86934a8d1b3>
References: <20221201131113.897261583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 02:11:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

6.0.11-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
