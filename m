Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08C64431D
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiLFM2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiLFM2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:28:03 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37CFCE00
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:27:59 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s7so13746665plk.5
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 04:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aF6V0yGGidp6q8ssR7JdUYdu4/B6DpE3k0WEFhRk5Vw=;
        b=Vs3pZqSm4aeuLOv+nInbIXkj1GeMqkF4ZHr9AiANTVbsxKxMzxZGnUfqrsYdykK1IK
         h+5iVIl0pMZWjhSUNlzeVoyuw2rWQlmmOpxNdCjjMWR1KOk1ehxWZIgaJcLjBpzJ6nn7
         B/IZCyPLy0aGLQcbbQy02mFs/br5HnztUM3og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF6V0yGGidp6q8ssR7JdUYdu4/B6DpE3k0WEFhRk5Vw=;
        b=A0Q21BLUtSEAGr8YYtNByIZWkkU7kVVfqh8QT9NvVlRgqm7NzwoNHj7UHJ4sG4Yv43
         X/hsmnfIuMNiE/sDDbXFxPvVleqwfZsCkltLI5EUYpxabreD2XMZERvcD2+WLZzG6WI8
         g8xXGkRHxLmKDraffzG1PPJw8dg1hybWiVQLf8GMd1e1yySoOLKTfAUBp26Lw0kfpxuN
         U1+buPHBOGArmkd3EaqH8CAiu9Ha6Hz1oUumkv01J2IQXwoWD+fo4MBJvO1/P0CjQTWy
         qeXR6P7/vmNSphrLgezw2lMpNnerSZKXtZ/W7ouuXOJhCwnk6iDABy3gqYW9Tpf6EvSF
         AQkg==
X-Gm-Message-State: ANoB5pnOA3+r3YPTbhFHWDOt5biDnM7NnwLd4UtoqT2PnY1j6yoRZZSQ
        O7+/ciNu53BOHFHdojs2jrnhYg==
X-Google-Smtp-Source: AA0mqf6v6kGYQYhfDmUwl0mIDXxX6gmJ28YDaQVO56HSzFqym6MimztwgkhnqbioxoTBmYZcrmy2/A==
X-Received: by 2002:a17:90a:9c18:b0:212:fa9a:12df with SMTP id h24-20020a17090a9c1800b00212fa9a12dfmr100930150pjp.231.1670329679069;
        Tue, 06 Dec 2022 04:27:59 -0800 (PST)
Received: from 1ea210ad73b0 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id cp12-20020a170902e78c00b0017854cee6ebsm3202220plb.72.2022.12.06.04.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:27:58 -0800 (PST)
Date:   Tue, 6 Dec 2022 12:27:50 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/92] 5.10.158-rc1 review
Message-ID: <20221206122750.GA932196@1ea210ad73b0>
References: <20221205190803.464934752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 08:09:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.158-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
