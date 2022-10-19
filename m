Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB88460456D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiJSMgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiJSMfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:35:45 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71329AE235
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 05:15:23 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id b5so16075208pgb.6
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 05:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JhFg+I8Z30pggQd52LeEXoxZPdMxzsS1SoicPW2Qnj8=;
        b=NaXplvzwhOMeIltLtZKcP9a10bgI+nZPdZpuiJkpI4FLKsGdquxCxqAcDnRUFCK31l
         RomAFDMsxqKxYPhn0Mnd971BoY1i6v4HEtnwDzypjuYlRc2025GdTs4SCDHWJ4TOXMYK
         jOHGsnxdrlRlbTkcEyr2ern4UyhSpcA95SAHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhFg+I8Z30pggQd52LeEXoxZPdMxzsS1SoicPW2Qnj8=;
        b=BLyFdXAu3oqn5gSX8JZ37XP/8qQlj8KAXpY2GD9xL/QMUuAneuqYPWx6rgarSXNCx4
         qvmlEnu7u0f4gBu7sQGZ9aFVQJx+GNiRRnnkGvaBPVJPRFQFtU7Fz/1OZJUY4nUGeRRj
         OOvU3Llb2RRPjPAavvbWSJMAfhNEEiCoJw2Rb9LIkiJsbQtcx62xAAoKFd09Obl3aX7d
         CCWM/cude+ZH+XiC3VpaYuvEX+pJh+iK8cnjwBnUHjUrsNCxjnJRXo2/Q+zl71bX96JK
         V5lBx4Tb0DW1nXxvjKkaQrJpi5gioNLaOqhlH+W+K10QbQh80N9EkE+/yIUZtnjkBmZU
         2d3w==
X-Gm-Message-State: ACrzQf34fumB2zYZMkpYzjtfA2XZMLqANTny1cpd0NFncZehTinw3/4D
        GRvqPBcHyyBzIBB1Cwpvs9oSS9NVmkaeug==
X-Google-Smtp-Source: AMsMyM4Dxc3aBl+2slZzJ2ogfC5yNG4JAj01GK8n8y9DrCVshrj2jB3X2jMbk07YaC4gqt6NxPF6RQ==
X-Received: by 2002:a63:6a85:0:b0:43b:d845:f67d with SMTP id f127-20020a636a85000000b0043bd845f67dmr6759278pgc.349.1666180880449;
        Wed, 19 Oct 2022 05:01:20 -0700 (PDT)
Received: from 2f83a51adb98 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id u131-20020a627989000000b00561969ea721sm11548627pfc.147.2022.10.19.05.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 05:01:19 -0700 (PDT)
Date:   Wed, 19 Oct 2022 12:01:12 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Message-ID: <20221019120112.GA796174@2f83a51adb98>
References: <20221019083249.951566199@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:21:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.3-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
