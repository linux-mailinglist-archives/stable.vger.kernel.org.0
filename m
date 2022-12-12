Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0095E64A8AA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 21:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiLLUWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 15:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiLLUWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 15:22:37 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26062EB
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:22:36 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c7so697500pfc.12
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T6m4oJyqW7YP/7b8bP79gaG9JOlzFsGskUClBSJM9lg=;
        b=KTSnMDhZUuvC/ECxs4deMGyzsjYq27dKkyPi5+Ggi0tNdxfp+xcXq6YmDSA66i2BN8
         lZC5PLPQBqcLE3YnsxyjeYqj8mSytVVegDt9eAxeFuD/vBBGNjsGeAHWrMh+kdOdYziu
         AyIXzPyF0/2mDEUs/QMK3KTh2Th1wUW0+b5FzJ7VSNloVoz2O1S1eVdZ5SHw98pEQLDN
         9MxMkPkcsAEkB0mwXr/PF2129xVVw2W4ky/nL6MQCE6K8LHG2GBfYs09MbLAFJ8iWpAu
         ciwVJ7tXnuIESWkq+iPksWvBgY6gMPEdqYBN24oOQ4V2HGHxMfAMoaC1G7h7u1f1r3Oi
         xjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T6m4oJyqW7YP/7b8bP79gaG9JOlzFsGskUClBSJM9lg=;
        b=H2KUaqEuAd+4i/vG8PfQv6cskYhMkH2cMN+x7llbi2QDlqnqISWF9Owt2PFGIGfjnZ
         +AuootTMElDvKnKQA9eK8lflaEMMCwZcxZltgOrg2xz7pzUDdIP5Y7FcnG9mTgLtiLTN
         PJfhvnf0nWBkwGlsfjlEoYaGQpCs6pMlAm7dEAZTVsGth646Wn4mTbFhaj95XDO2EtSQ
         pGHoY4Q1OuyknsihnScGOoM3Th4FWfH3iIDQOoGjmEbD80OpKH1bILXHueVJQrb6GDd7
         Rp4AjjOIRSFeTixv7kIs+gSGMgu5elZaKPwtPoJtDrSzbNQQeJD6zb6MlokSHLN2A6a/
         kiIA==
X-Gm-Message-State: ANoB5pmfJ08NI9O3RqWOCQAtanxCaEMWCa1t0WKns93puANkSm4QJ7fj
        yCRTpOvaTO+vrd6+Cq378t7KG0M3v+3Tfm/6AviBOgv91dbGoF0SsOc=
X-Google-Smtp-Source: AA0mqf5Q61HiOiCPy5J3cYbEgHQgC+WkYNhTgryqXz7O8vybYzMll1M1ZeVWkktCQJ/mwIhESeUg6djT9yFLfqf6UFY=
X-Received: by 2002:a63:ed10:0:b0:479:3bf5:df35 with SMTP id
 d16-20020a63ed10000000b004793bf5df35mr342822pgi.572.1670876555633; Mon, 12
 Dec 2022 12:22:35 -0800 (PST)
MIME-Version: 1.0
References: <20221212130913.666185567@linuxfoundation.org>
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Mon, 12 Dec 2022 15:22:24 -0500
Message-ID: <CA+pv=HPCviyakX1YjY5sq4ZoeN7gKPhW8dSVzC_Yp1LS4UjL3Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
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

On Mon, Dec 12, 2022 at 8:48 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

4.19.269-rc1 compiled and booted on x86_64 test systems, no errors or
regressions.

Yours,
-- Slade
