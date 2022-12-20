Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88274651D22
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 10:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiLTJUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 04:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiLTJUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 04:20:42 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22F5D42
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 01:20:41 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 82so7987648pgc.0
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 01:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u0kUVeZvZDV2Kx8BbblSmig5GTII1WAhwsA2y6hEzi8=;
        b=ZVTPWKsXd1fzOA2wA22mD9Rt4Ju6SJK/sY2lgW28dsjZToWoKY0HgpHD81zIQPgDbg
         ax946E9pCm3lteOui4VJgyAD5UsRNg4YJfNKatOL4oiWTY8sSZmMAwp2ybbmJtzHqe6p
         zGedDflXJctQU/CijWcQtCZXuLss78Z1h5gbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0kUVeZvZDV2Kx8BbblSmig5GTII1WAhwsA2y6hEzi8=;
        b=vQrp9A4qUCwNvZDizl6S1zoNhpuxkbzTR0+UmMcERWM3woBDSeAoL/ANNqBu5Fhih1
         9Tj7oYsvp+eh6f+ze9xZXPKT2qitEPDVgms6EQo73gDrXW4aJirCiWHHwUL+ww8kzpGC
         gUmjlZZfVzUJmmmWYY0vvPMwwcm8+0OmpAdLly86IiyFYXBhQCpYEcVp1SYq831vY4oZ
         ZTO9F6iDuqnSTPfxse7Tp4ULdO8rFxZueb61v6uLgfrNkpDWOz96t5nPaKG2P8gvrDCD
         9YdWpMQWNbIXAczNw3L0iLQcGFDQjH39oH6u2OANk7vu1VFiQOM+HjeeNte8A7ZgPmd5
         0tug==
X-Gm-Message-State: ANoB5pkZgo98qhDuKvqpiBt9Ghr0tTQqKc/H6MgDh8wlGNnHQMnS/QJO
        5tg4yyfIXnJtEuvcqJ+1yI1o5g==
X-Google-Smtp-Source: AA0mqf49lj61k6YHOJb6LKCtzVpzarpMBrdoGW0/AkN8gST9ofl9jS8iP7p5fDZuCz57F2wvnaJkcA==
X-Received: by 2002:aa7:8c04:0:b0:578:202d:a33e with SMTP id c4-20020aa78c04000000b00578202da33emr41586500pfd.20.1671528040886;
        Tue, 20 Dec 2022 01:20:40 -0800 (PST)
Received: from ec167f3768ca ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id d26-20020aa797ba000000b005745eb7eccasm8135211pfq.112.2022.12.20.01.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:20:40 -0800 (PST)
Date:   Tue, 20 Dec 2022 09:20:33 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <20221220092032.GA955642@ec167f3768ca>
References: <20221219182943.395169070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.1-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
