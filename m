Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED06586D2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 21:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiL1UrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 15:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiL1UrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 15:47:08 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA54312A87
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 12:47:07 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g16so7391473plq.12
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 12:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sOlbV4pVuTrR4K7vYl051PtLayKzACg/bpHOG7JoG+c=;
        b=ZVlkF0vh9TYZ3NdiMd0rSXUwj4lTQlldN+ERK7nWJPIm3v3TK2RIerCh0pf/4EWMJ8
         sQfWz4IZhFdNRqsRMY4oK4vRQBj6CIPltvdgu8gGrpU+g9SyK72A3D2uLXIAqHYgfYiN
         kVM1J36/5P/0+QNsTxIVaR5LO80jIURLICkC/nBr/p6P2/Z5q1H91FlgBVp4ILHWthp2
         YbBo8kKECHrNtBoF9QAiAo2V8POKN+610lUEOBxXR6Yhp+Mciwy4HZ2AFFrN3m1QktzZ
         67HEJUa75K5WqMPrlQ4pqQ5SDhBOFBPmxM9YEjT6f72v9ePH01lqs272GtWL218FaUza
         RVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sOlbV4pVuTrR4K7vYl051PtLayKzACg/bpHOG7JoG+c=;
        b=IFucA36+pclHlb4paowyDVUZxZoMDM1c208n6cXpmb2DD4vSmpDmwkrCbBHYM/U9WG
         o66rFLh/asIo03ACRP4YyToSIZvHyl3bDT7For7V9LW50NOZM462B7IJDAshhKXsTCZq
         OUxJ0WP7WPvbz5o9pABAkleZGY0kz++/2HP8racztRgyn7naU5ozbhhdxCjxyrhvGa91
         YCPwJGhXR2iNIxV8m12L3TvDZt9T20q/rt7qwCbOtuMCSnTLgPbzJuP2CHoalHg/jvVz
         H+X1GnbzUtYz49CpaRoNEs/4XlkBAYSsQuxL+WrzaDG4JJ9Ua2tgMoso67b3efpDjbDc
         qqqg==
X-Gm-Message-State: AFqh2krvr+pEJEdoVOnDab5VQNNyKYlS/tjfL5+OfYYuTYlPrEz985Fa
        4V35gbjtWcODzonOq3EVMbpXVIZtgAWeEfyHWSXlDQ==
X-Google-Smtp-Source: AMrXdXsCg0XdSXOAPFAc83qqX3enR1D/euK7Qz+bUp7sA0KghDQA/lFRvR6WzxlB7gZ4M6EPfFRVyA8D39SHlW0wbkE=
X-Received: by 2002:a17:902:e845:b0:191:ef6:a73e with SMTP id
 t5-20020a170902e84500b001910ef6a73emr1612447plg.90.1672260427368; Wed, 28 Dec
 2022 12:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20221228144330.180012208@linuxfoundation.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Wed, 28 Dec 2022 15:46:56 -0500
Message-ID: <CA+pv=HNoOeKaqANvE3d70j39qb0cqnAfgvHzht7-QsNLNuU4fQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 9:45 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.

Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
