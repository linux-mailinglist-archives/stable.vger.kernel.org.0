Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEC94B1760
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244185AbiBJVBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:01:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243229AbiBJVBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:01:33 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09A810E1;
        Thu, 10 Feb 2022 13:01:33 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id u13so7371919oie.5;
        Thu, 10 Feb 2022 13:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8CpHFaNCT2UX2FM2bq9jp7IkTTeqZATD3i593yxmTSc=;
        b=Nnd3SIXYKWfwC/boE8rmWS8yGcZxaAYLGxH8JJx3WNCTgJQkFkk4ZLUdlgg2OfLVEK
         zzkLWYIiHvKk1cUjdMCWSb6XswUY28IVUw/lt47GqWyg2lFgnCGxLdrv8FxVk8/UGadk
         kVJ/1n2LvFnoaMRmxVrcnP9UDAsK0M1CT8i1wXYVe97Wj/xSB07rAaMi0PanU7y4Ij0V
         trYhyISlAEPwttVR4t4h8seG+C4BAblMx7A4ERJYLMEAgP98TNni+cnMb51h5nHHKPpg
         avbfW3KkF+YuPU0CR17uXTQcrWV/T89iOnNO/100yuNUOdamtMGIrbKxKjlCEuW6X+7C
         4TDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8CpHFaNCT2UX2FM2bq9jp7IkTTeqZATD3i593yxmTSc=;
        b=gIXjBRz/ieFR8bDihUVaJyGRgcnh364lWMCRkOV4AO2MBhE0r85lZIKe3v63dJY2uj
         ikapBzmR6m0xkV4kN7+ZWjAxC9slx13gtxXrmk3FgLWjeHNFlBMErbV7KCHRFvnDgefI
         /muqaPCkTjWWZiBvakMblHaozzprtb1HJIwxtR1joFTS0HnRqmYa5HfRruCRCf9s0v30
         k+KwiUGuXo0bedDzYw/rxrEzIfHUr/RRNQc1pze1QHNJ7d5eBc+tf1pmZUB/YL4EQ1CJ
         88k5NXOLpll1olBTzpDqNph55loeTUUrR+Wv1a6sNJ8BA01SLRF9A7LaOVOQC4CCl2tA
         VbaQ==
X-Gm-Message-State: AOAM531LD6J3NMISw8ZwzV2I/EYcPVo2COIxDMsdSCgVonkxGzi2Hqm5
        jncvsi/EHL4UullUT80kab8=
X-Google-Smtp-Source: ABdhPJwT2f0tBMDLnND4uN0xKFXIEU/VBYtk8sFX1m2CKrJ1anKplWsBkSBGN46vgOpCpb05xuJpMw==
X-Received: by 2002:a05:6808:1292:: with SMTP id a18mr1865132oiw.314.1644526893166;
        Thu, 10 Feb 2022 13:01:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h2sm8269855ots.51.2022.02.10.13.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:01:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 13:01:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
Message-ID: <20220210210131.GD2963498@roeck-us.net>
References: <20220209191248.892853405@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 08:14:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
