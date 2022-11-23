Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2533635B5C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiKWLOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 06:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiKWLOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 06:14:18 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7881211DA0B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 03:11:15 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r18so16444369pgr.12
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 03:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcfXEcruqvTE2G0on9M/bXzLRbEd9FM+dGkOzqj5auE=;
        b=STg8oyDVjJ95ozkHYKBwCxoKKj15bLbGMbv335PGZHqMTJw86ZgweIhxINoun+8qds
         uxQIDZFk9WU19P0ojQ+Zu7EwZb8TThefYKUdIHexlXfDaSh5nHv0xV7/m2r7dXJd7Neq
         J44TUAqxfGi7ELpSAOc1UaAUtTyDQEDuMZziQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcfXEcruqvTE2G0on9M/bXzLRbEd9FM+dGkOzqj5auE=;
        b=KqM+Z/Nmm1cJHOKRBEGWhOON6as3W9tmG54tY6zkLKfZL5J0MygMskxxhGoAGn/90v
         hE/SEU/L7QjqfuqdGSGVJ6kRISe/MYV4bdG+zCx23kyceWouAOKYMc2VPc794hGIwbGC
         sz4D3LTjJDtMjpWy7VYqollU1yClEYG8v5VuDhPnFK3UU0MeN2ysczi4IRu8RoYvy1In
         Q3KLzw2Cb7Yi4aW0Fk3GYys2URTBY3NpMoQyxDlrJyhXUeHbR9rVCUIAMcUxLwo8fuXY
         HtwCPvQWwGz80LceBcSjtBR6yjif0mZscWptoKAgCjLFKIp8KXghhT5gf6nt1zf3SH2P
         CbnQ==
X-Gm-Message-State: ANoB5pnOYu7r8sA6YW7uGIY/vDG3DuboGp/VUFmjBL0GtvqfLhpZd64W
        PGFw0DL4EiLodm/y3cLkDUFJ2w==
X-Google-Smtp-Source: AA0mqf5DeCVCvYGoX+mI5w2NZxsP2alnVqmS3+XGoCLpIGrKuvlbL77Knf091D8CiTaTFYjdMJf/BA==
X-Received: by 2002:a05:6a00:298d:b0:561:5d08:761 with SMTP id cj13-20020a056a00298d00b005615d080761mr11655969pfb.14.1669201874767;
        Wed, 23 Nov 2022 03:11:14 -0800 (PST)
Received: from 1682a9d2d5f8 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id f5-20020a63f745000000b0046fe244ed6esm10626904pgk.23.2022.11.23.03.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:11:13 -0800 (PST)
Date:   Wed, 23 Nov 2022 11:11:06 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <20221123111106.GA3974538@1682a9d2d5f8>
References: <20221123084557.945845710@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:49:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.156-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
