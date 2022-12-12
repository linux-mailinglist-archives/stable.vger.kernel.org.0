Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4AF64A8A6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 21:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiLLUVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 15:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiLLUVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 15:21:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345412670
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:21:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id fy4so1047517pjb.0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+2Gol/W/vrCkBFnXmVYWrTmzG1dFrYwfn0LfkKp3QVw=;
        b=dz3c2UhZUInkpt3Imw6LrTTI/SKv2nCAj1lwVwpseUjw8FiPOFPPhk/FLhS4g4+1eV
         b/cZ2MG3Gd3VWU/JiDY8DdvNHTjxLqVoYa7ZJ4U+4wATTOG8N+b4ySv97ZvlUE1/IPKO
         hGOsT8Nmqm8GlhZF2QFtdKoL8Az0Q0Axvm2gpsP51BIJSwYtprj1KyMeyZI/0o8mnltc
         WZU09UAaCqRV45FpMK+MyRCAaMwgakEaILjPY4YA0k0ZP6vRlrIIoma0mRbGL0PVkJho
         6AfkGV6JoHpYRtiuLcgu02w6/yfZ5GApRHm/VudMhbA7B++rYgx2NGKFmYnciUlI5C98
         k0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+2Gol/W/vrCkBFnXmVYWrTmzG1dFrYwfn0LfkKp3QVw=;
        b=cy1QZmoEgY7PHFc+1yDU9WOZdGdUnaroKxuDr8G7JpnzrfqRma2XDiOnYzF0DnqbD7
         am340OpuOCFlzHStWnOe0DCCvnIKQ8PXXzTeHmuQtAHB1CEqRGEQry0DROyJ+4EAtHBv
         9xMlNHMPPM4QDTTqbx5gWkCn61Jn+vM4UmRJRRFYyuf1a4CiFbC1PrqJLoi316/VpcG+
         TxWGOcfmLtf0DIvg/Ot1X/HVlOtGAwGxF2zkxDL/PyAidoagor/UKLvsL72QOoDiakzK
         gqi49Ue3Rhg+4xWpVu5RRMfOR8xGYtivSpCHGfi/bd/M8Y92AhS/gNBroSdn1IOlXJA6
         +6xw==
X-Gm-Message-State: ANoB5pk5vSmCunuFSwJonEtRXGPcVYVr84lkwXVwrpvMeiQLF1KR3eVt
        xEAQ1YXKVaOV3CSLP0LV5LcGJhGJ3Heybz3AwoDd1w==
X-Google-Smtp-Source: AA0mqf5EDTFf7Lta+JlVNQNOYeNcWvG89NdL/KjJDks+33xbbjl98uIFJc4VZhz50PLmcRGlQodl9nipFN5akmcP3HI=
X-Received: by 2002:a17:90a:740f:b0:218:fb5c:a762 with SMTP id
 a15-20020a17090a740f00b00218fb5ca762mr31716pjg.241.1670876481712; Mon, 12 Dec
 2022 12:21:21 -0800 (PST)
MIME-Version: 1.0
References: <20221212130909.943483205@linuxfoundation.org>
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Mon, 12 Dec 2022 15:21:10 -0500
Message-ID: <CA+pv=HOANBfmAqBLi4wyeejs0W1BsZtbhcHqsNmhs2WA3YxGzQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
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

On Mon, Dec 12, 2022 at 8:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

4.9.336-rc1 compiled and booted on x86_64 test systems, no errors or
regressions.

Yours,
-- Slade
