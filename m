Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD7F523041
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 12:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiEKKFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 06:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbiEKKFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 06:05:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA935DA68;
        Wed, 11 May 2022 03:05:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s15so927377wrb.7;
        Wed, 11 May 2022 03:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a78p1AjzrapLqC0ERAtlikRKGtUZly0gff/iNB5DsF4=;
        b=L1EpaP1GsqseXhKqiTJUTeYmtOApce0H2IMGbP68Ua9uHDWq1KDsGPDzyOJIvA/06f
         6PRhA5/Wf8DdZUootLdQUgH+NlzyJw6gVIsPQbznbYGQxJcyKu97A2DnIM0Uy5V+HFDG
         /l6DR2SbD8Jy2vdPRPMQK7M8ZyPUkzsoUILsYTmtZs3OrVc8KkJwcjJsGNhFvfYGgDaE
         pBoX3m8EJk7W5TEE5307oR3DuaIbYFIx1rhwkSQn26k0nqGyJrk4oz/0X6dUY13RlUv2
         oNz2BNNTDfFzUC9C+d5jjwR1F7JtBxlUeBDun/GeFnDwRJaRtVtTimyovzJTOOYuj5fk
         k5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a78p1AjzrapLqC0ERAtlikRKGtUZly0gff/iNB5DsF4=;
        b=8FAq3+vp0GWeahqnHFq8DW9BGqqBHiOb9QQKabFbBlc2OSvjM88hdB4eZHsD7+8U/z
         QYB+PTQvE9pxwuUbTSp3fECHkIz1I5uHnEz60bWPjJeVFnklKCTlbGIm5VJuQejfhKEa
         fUPxjCK+QfCvreLEkx26J886IJPT5s7q47bBEmiNx4FfZmVqYt1onCFj1N6AbBXKlkUF
         NPRmRsr7aZhpwyBPcvhWhPDFS/hQjYYBuJccSdysT3jxzymM7yghlq/8wCsig/MX543D
         dRD5bV+n0PTFzGDf7vPz6uIUvUZ2UI6Rk4OyYAETIOSlQale2knGVFH9cU9HNJLVO5W4
         Mwrw==
X-Gm-Message-State: AOAM530ZnGjg3FNIYlGy7EASKnHJUU2H9fjSIJ4LQ05Gmj3Jhg/VwvlB
        riF2bjW7GmxvtLvbLb/XKrc=
X-Google-Smtp-Source: ABdhPJwLwzmIo8fcmm8XOYcwiy/1EqvXdCuMvJT4lQxkLjhnMPfwJVWY7dmdRC6ufIZT5IdzpOUeWQ==
X-Received: by 2002:a5d:5885:0:b0:20c:7048:2951 with SMTP id n5-20020a5d5885000000b0020c70482951mr22457098wrf.28.1652263516031;
        Wed, 11 May 2022 03:05:16 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id a8-20020a7bc1c8000000b00394867d66ddsm1617158wmj.35.2022.05.11.03.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 03:05:15 -0700 (PDT)
Date:   Wed, 11 May 2022 11:05:13 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
Message-ID: <YnuKWQzXyoGhEElv@debian>
References: <20220510130732.861729621@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, May 10, 2022 at 03:07:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

Build test (gcc-11):
mips (gcc version 11.2.1 20220408): 63 configs -> 1 new failure
arm (gcc version 11.2.1 20220408): 105 configs -> 1 new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

mips xway_defconfig and arm hisi_defconfig both failed with:

drivers/usb/phy/phy-generic.c: In function 'usb_phy_gen_create_phy':
drivers/usb/phy/phy-generic.c:271:26: error: implicit declaration of function 'devm_regulator_get_exclusive'; did you mean 'regulator_get_exclusive'? [-Werror=implicit-function-declaration]
  271 |         nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");

It was introduced in v5.10.114 by d22d92230ffb ("usb: phy: generic: Get the vbus supply")

Build test (gcc-12):
Mips builds are failing. Needs d422c6c0644b ("MIPS: Use address-of operator on section
symbols")
arm64 allmodconfig failed. Will check later what is needed for arm64.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1123
[2]. https://openqa.qa.codethink.co.uk/tests/1125


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

