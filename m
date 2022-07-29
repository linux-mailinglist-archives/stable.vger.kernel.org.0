Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5AF584A7B
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 06:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiG2EBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 00:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiG2EBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 00:01:43 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6A97CB69;
        Thu, 28 Jul 2022 21:01:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b133so3600072pfb.6;
        Thu, 28 Jul 2022 21:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=LiQcanxLsd2sF5yWwZ7FDklM9nT42055W+uDlVC8KWg=;
        b=TNldjJivlgmrc+1+fNIu5EfMm9NFw5EGqQwgpG28JD72hgfeUtXenAlpsj+CE6jDno
         SIsw+UE3l5RhfbBdH2+wTRIeatkRXNgf0+aPdDaa53ROwSupqZ1gt5K/45YhDJwFfuKj
         vDr2HwnPnK3QcPLmbSGSeG/BjQYggDk4tcMzSG3qvvx1vHEk9vJo/rUxxSZzmIZLtk+A
         LuzPNvztM1tDFwW5NHJ8NQAITkTW68NbTAEhp4J1YbeWlmRdnXsYJz4/s88vsMkWIish
         E8+t0hfZKPOzce7ldR+yP7zTz4PVSa/b7xL3uELdr+zDbmAg8hdCEDiu628DyxgPPOmK
         mMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=LiQcanxLsd2sF5yWwZ7FDklM9nT42055W+uDlVC8KWg=;
        b=yuhTrFNdhLpvxvDGRWld3C8GQbC1f3XSPTBFqvHQsxFxQcjefLT1SdjjioVIq4vLWR
         Og5YHI8ZyyiBGwSYUOz9fFH6zM1UjD8VS6HWX8HJ11FGjqDp3riAh7i3/Be4Vnbxnl21
         3sXWLkk+Kg/BeLhM1WhiaT3Cl6pSuXrVegDquukdwE6uiIQfReiQTtxkhROERQYxRVxq
         ZFlo6PEXI716fpKvmiEVepT5uSSAzA5r8dR4PiinrU2SpHWKkKKXGfVPhWy5mlMMNECJ
         4phSqVXv58kdtgOYBw8GetpavODFujN+uoyZsPuyJYoF1kv0gTX/FOvzqrDj3Jj7Pwxc
         qyrw==
X-Gm-Message-State: AJIora/RelTJtCRTv72LtMZeCz/wT7luIiOgLdO3GqZHW2RidSUsY6WR
        FCzHISmhprI3aQqHrMtWjNg=
X-Google-Smtp-Source: AGRyM1sYESwHfJNQnK0XATUHU/eiM/el7/ukIv3TD8XCke3tNl0JF4m+Xcf5BtvA1aCo9PjQ7AY/Xw==
X-Received: by 2002:a05:6a00:1496:b0:52a:c3fb:8ec7 with SMTP id v22-20020a056a00149600b0052ac3fb8ec7mr1885899pfu.25.1659067301670;
        Thu, 28 Jul 2022 21:01:41 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-48.three.co.id. [116.206.12.48])
        by smtp.gmail.com with ESMTPSA id z7-20020a626507000000b0052ad6d627a6sm1583455pfb.166.2022.07.28.21.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 21:01:41 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 25C3A103B92; Fri, 29 Jul 2022 11:01:36 +0700 (WIB)
Date:   Fri, 29 Jul 2022 11:01:36 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/202] 5.15.58-rc2 review
Message-ID: <YuNboK4keUqO5O6i@debian.me>
References: <20220728133327.660846209@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220728133327.660846209@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 03:33:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
