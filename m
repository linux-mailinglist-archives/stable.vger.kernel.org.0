Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86225441C4
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 05:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbiFIDIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 23:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiFIDId (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 23:08:33 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D1B14AC94;
        Wed,  8 Jun 2022 20:08:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r71so20684178pgr.0;
        Wed, 08 Jun 2022 20:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67bIcBJxkdHMwodE6TZHTnr6h/1O1DDdmeeU0CyUDGM=;
        b=b3UEvGQzNb7mEFiWVFdjpy1EUyGNyFXVb1Ak/H/prr9bWavu9redg0bilShz6c2key
         LLkvGAFklXBog/o2sBmneH2eBu+S2LSzSzu4GTGqPBV6qFu3/HWHfa5KzsKKhW0yos+v
         3nLjFbmNHi/de8pmKZOZi6ZjoCCskP1fBF7HRJl1J0hVcuNK8vs0WCO/UHRJ5GLXUv2t
         xc0K1ptGqQHiv3/eXxV/Bx/IT2pEDQDn9OCeR8Cn3DIf181raCe6PK4KEXSaH3TGNyiQ
         86HKEz/7gjaKix6WaYc8NixM5cGVAHFtaX3Iewsj4DczrtBIcOn3D/HveKmGKz5KbCsg
         xpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=67bIcBJxkdHMwodE6TZHTnr6h/1O1DDdmeeU0CyUDGM=;
        b=0umWzL1yPnqSiVxH2y8EjSRZjhpgbtVCICwCm0TU0hbMipvKFW83tEY55WHw7uZ6/4
         Jm/40GP20auDxJeO18xOqiE+FwF1o/SI6EOQt3aKWRQg9tOrbDkF5IvT/dwtC+L1gzt0
         3CC6TbSJFsYhFULn9V1PxY/ni39AgUyhHaZlmns1VgulQjjy8nNGx4+vqXXIjatmpBVa
         Z1ErnlCNfe5Ew6O5wuek9cBk7m/kIEMA8Ku0IUYa6gmYgRWCXShneNYparmvqdCFP8DN
         17+WbdaOzO7mH/34v5A1y7lk1gvCYXp++M/YwCijey4QR9JJ8rPDmdqXNMgYxzwTbtms
         NaXw==
X-Gm-Message-State: AOAM5330BRJfxGVSBxneg0yS4EfSkHHGbad6KUmd3jqEuip3G4rGOqNj
        nOegW3UloBgHnGpV37qE7aw=
X-Google-Smtp-Source: ABdhPJy4/FG6aAyHA+xGFV+bNbj1TyeEfrhH2qKtw8zG+oJTHarUhVKaNiOwdg8IfD844fYt7USPqQ==
X-Received: by 2002:a63:90c8:0:b0:3fc:ad6f:6e96 with SMTP id a191-20020a6390c8000000b003fcad6f6e96mr32999010pge.256.1654744112191;
        Wed, 08 Jun 2022 20:08:32 -0700 (PDT)
Received: from localhost (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id b13-20020a17090acc0d00b001e2d4ef6160sm14829916pju.27.2022.06.08.20.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 20:08:31 -0700 (PDT)
Date:   Thu, 9 Jun 2022 10:08:29 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
Message-ID: <YqFkLQ7Dh5xVACQW@debian.me>
References: <20220607165002.659942637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:51:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon fpu) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
