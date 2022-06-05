Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0053D96B
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 05:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiFEDhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 23:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiFEDhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 23:37:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FB94ECFF;
        Sat,  4 Jun 2022 20:37:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so15195488pju.1;
        Sat, 04 Jun 2022 20:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ZOChcgwzBDlVgM1N8B0pRUhhOfUT8/pv0U4FxB5B0I=;
        b=M95MiWf6kWmzFna3YuivxQU3C6W02thHF81sw4yQXyYSX2m4na2pprZnMKchpG9DWo
         68X/UIHaGG5RQvB86FrGEvO6TiwI661xgifthPRoOMEItAG7TYcS+StpOGPupDjBDN0+
         l4Dr7ohdkGva45fUkEya0U+pOvCvGHhc3SFluV0l2OvbU7SR5RrotqmwA9C0tj5mNHHs
         qNmdJEGRubnTIcZ8/WaKvzvEGaInIawbGstdxLgaUPOwkijRlhOipQ2+PEB+KDLuBTe8
         +l/AXM9q2XMVhQvS5hOv7IEooBocSY7Q7Vk+246ZravKciqNTu8LCe9V7bE+XUbGL6i0
         79dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ZOChcgwzBDlVgM1N8B0pRUhhOfUT8/pv0U4FxB5B0I=;
        b=BkHQX0Qv2LcZ058qMhuVb0403rCJWhyhvhJTW1eVK5vVt3L8KNrOjytOEfBl8p2sKc
         tDTWOHwFSPj2CsZ87JW43hIr0VsiOjGwoSOQ00Xx8EnRy8dRLlkrLASVJLYGUGErJUhl
         1zKdmj/BybE5bXWhTJwlnZ2zQCogP0Qbq1OjX+xF2rfE7CJK+jhFdWdqGdcV+Frwr7Yq
         oYKB0qfzgemTltdJGDlnFwEgWZs15tsWcjuS1iSFfDBlI2n2wrss+x8TDb89fnxHeTbt
         gdS0N8crv5ejkE3MfrkHUUqw52ah8cWsqYtJV+8K4s5O4bIA+brrxHkJt9sjPNCF+UH4
         Beow==
X-Gm-Message-State: AOAM532FSfhTzhiu8L74Z/Ff3mUw/uD2pc/GjhcPz0L4nBsKsp9Xr7jS
        cDpQqJGWeuLP2BSgA0BtL4k=
X-Google-Smtp-Source: ABdhPJwp9PCMgo0eewj3xv1CDXcT9sT9znT4anOREClj/aGpVeK1ZZ0SLb7EJWgVGNZGWAXbtGrFiA==
X-Received: by 2002:a17:902:ea0e:b0:164:1a71:beee with SMTP id s14-20020a170902ea0e00b001641a71beeemr17737349plg.10.1654400257055;
        Sat, 04 Jun 2022 20:37:37 -0700 (PDT)
Received: from localhost (subs28-116-206-12-46.three.co.id. [116.206.12.46])
        by smtp.gmail.com with ESMTPSA id f16-20020aa782d0000000b0051b291c2778sm7937063pfn.134.2022.06.04.20.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 20:37:36 -0700 (PDT)
Date:   Sun, 5 Jun 2022 10:37:32 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/66] 5.15.45-rc1 review
Message-ID: <Ypwk/GVw7//G/t1m@debian.me>
References: <20220603173820.663747061@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:42:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.45 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
