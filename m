Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65D68AD3E
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 00:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjBDXBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 18:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDXBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 18:01:39 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9980E26CC6;
        Sat,  4 Feb 2023 15:01:37 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-15ff0a1f735so11055195fac.5;
        Sat, 04 Feb 2023 15:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cVsHER4Yof2lEQueL0RY30lS4pwURHfmMFaF6gV4zLU=;
        b=AKHSK8YJPv5+ZblpmnNjZfbfGIygi+MUXqZwYQUoUr3M7DZYyshlclnDCBTwBiwtY+
         sFHe79+66hDBDiKYUHzbUqWgqaJrzRqoM04V3PtAmXlQ5bROrxvkJgqow1X7rlSTbNQU
         O0BxdJYx4PgLyUyyZNU4HZAIoDYmAXAQsdbqslyQDrpEmrO7A+uzlu4/B7SIrUh+iS5y
         mzc0z8kpBKcD/kaa6r5wWYHWewwByOHViJqDupa3uxXLTFfYiWJ72Bld8yrurLOFnghZ
         4atotDXmP7Az/sWBjgB72EdqZj62hsLS3q5EH81kdKQDWGTRSfq26ijM4V0yCGcFHVOB
         uIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVsHER4Yof2lEQueL0RY30lS4pwURHfmMFaF6gV4zLU=;
        b=fganOHipttm4xX7qTcmgopSd+A3/Jh2rAH+c8+W7TyMbm3zKKiJMNiTvml42iNTfDE
         EymCuO7XeCfx/Gocgiyc85/4RFZaR1op0u+UYvuZucxowcfLbn9Fh6Vj5LFUjbfWAqQy
         2t+JYaezfE4LjoIocIUbfwgFP8giMjoBWp3ZRjuC4+exIC87muKKvMKUqvmuKT/ASCdQ
         vh4waGqfRnTV0bLc8cYpyem+BEMFz11c1Q+uzicet0Rs7H4bx/0+VwDt1DPmyak8OpZS
         eZh6/U7+oxS0fhX0WVXBJHb2rcqXrYrZSRXCvbrwqtGFQvZcdsso9ILy90/okFT7A2Pz
         V7CA==
X-Gm-Message-State: AO0yUKXs3K9e4v1vtYT6sJqBIz5hbN1nCrZrZRyeHBBKXfknD2KoXeTV
        3VpFgwMsjZvsvF7JHsXoJkE=
X-Google-Smtp-Source: AK7set8s0K8k078nldDtTg/8E3XYe4g3PJLVfwGzAGIl2kWCyreMQ3fCjWhjngjbdOmVmKar/JyPGA==
X-Received: by 2002:a05:6870:562b:b0:163:263f:84ce with SMTP id m43-20020a056870562b00b00163263f84cemr8367716oao.27.1675551696860;
        Sat, 04 Feb 2023 15:01:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j21-20020a4a7515000000b0051a5b963423sm1954928ooc.33.2023.02.04.15.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:01:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Feb 2023 15:01:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc2 review
Message-ID: <20230204230134.GA114073@roeck-us.net>
References: <20230204143556.057468358@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204143556.057468358@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 04, 2023 at 03:42:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
