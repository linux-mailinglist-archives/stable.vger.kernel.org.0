Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F56E587634
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 06:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiHBESr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 00:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHBESq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 00:18:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBC546D88;
        Mon,  1 Aug 2022 21:18:45 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f11so11349032pgj.7;
        Mon, 01 Aug 2022 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=MWBqKKUb6gSnTltUkqKv2maQjhVc1oV7KeVTHNva1r0=;
        b=GfHRnyFw31i20p/H8o6MF2H8Dz7RCJ5WrWdnrJfowC82g7dQbWBGq/jZnFoA7scVUD
         xSAjhVkQ8q0UVCvN1OjDOga1hOlpWWo07qsoF+pPcwzwWMXx/Po2IxqwLwKguDFpyR2V
         G9deDujgcCuJbIr0Ur9Mgc2fQ9GLwn80FVWJX//KDBB46sLNipErTXnBI0bfa8BhrTsk
         UD8WsIjZkERGFT37JeosG50Sg2u4Wyzv3qCUEwoO4je00d1bryNUUAS/kvHHwNcZFYLP
         3nh+S+rwseC9NtrTR2QN1jTp1wtgnJHjCqVIOp3VqRho5K2BcFnBZK9lOy44RW+TsKcx
         lc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=MWBqKKUb6gSnTltUkqKv2maQjhVc1oV7KeVTHNva1r0=;
        b=udwSrXazxkfSttouWdhkS2PNlhr4CIYShaoba/w/8if7FPMw/A3b+0GY0BWb4lLw7S
         mueeAz4092B26uadsOtFvMae/3CeNlHvJtB56efFdYs9roOAkldx0uwolREbIxWFhgY6
         6kd07dc92TnP6HbCagFWqh9wu/Es7TSNXC0m4BHGJDCfRu1yBnAhShfLW/qHTF8U/cnA
         RhkGJK25HEWB2/CZDr2Cs7DgfHwHxI03nCpLxHPe72pgssjMgBFv3MHXNp9duFP/pGPf
         Qqe4VPf167pUAf4Ky6G37pT4R/Z6kI65AZ6vZL70vyv21HRMmeCNC0eiaq9JSaZyiFR4
         x8UQ==
X-Gm-Message-State: AJIora9RI4kVx8jrZs8JC6dKg7a8/MrMbrNZdkd15iVJKqFRPF/t0L/4
        20ZxDVMUTIw4focKLsMkwCaKk1xvOxg=
X-Google-Smtp-Source: AGRyM1tY3+XqUqATX++6a7Nz1FNhYIPHc+V808m7McYysOCwtG3R3EBTUiVhB58AV06OR+j1zO00Bw==
X-Received: by 2002:a63:2b15:0:b0:412:4d98:7956 with SMTP id r21-20020a632b15000000b004124d987956mr15380625pgr.325.1659413924790;
        Mon, 01 Aug 2022 21:18:44 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-52.three.co.id. [116.206.12.52])
        by smtp.gmail.com with ESMTPSA id w11-20020a63c10b000000b0040d1eb90d67sm8167495pgf.93.2022.08.01.21.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 21:18:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1CCC8103AA4; Tue,  2 Aug 2022 11:18:39 +0700 (WIB)
Date:   Tue, 2 Aug 2022 11:18:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/69] 5.15.59-rc1 review
Message-ID: <YuilnohATiiRsTUd@debian.me>
References: <20220801114134.468284027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.59 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
