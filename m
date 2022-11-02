Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546F9616F6E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 22:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiKBVLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 17:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiKBVLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 17:11:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78F6DFBF;
        Wed,  2 Nov 2022 14:11:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id io19so38697plb.8;
        Wed, 02 Nov 2022 14:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3M+sHlNYCN7sAislo/RH+KZwpXxxsuThJWN9NTi3ze8=;
        b=SKbTIb5ZUje+04Fxqgi2dCCsr7GtjbXxYcezZeif0u27dlGuWqRqi5yFkoRVYKptH+
         yfUq72SnjZDBCdjU6toqyKvUSWHW078b9tp62Dkc88bOOrLV3oUwh3waPGb8uoGnZJET
         BdaHYCC6me2kAf1Iy6dgLb1YQVlwU88J7y6csi+CFooXQ696GsvJCv2GdtiAgo/U1buU
         VvRnApJvBEb0U5hyNbBHLrDTqa6+Poz4vX32Cv4tKjWWdQR1a/nJd+U8RuLCopKGuHOT
         2xayw/2vLA7METj+0ZiKp8ZrsVUfF6c7cA51cdSxYCLBPrsoK9uIxHfQCh9ogAambfyI
         Ymow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3M+sHlNYCN7sAislo/RH+KZwpXxxsuThJWN9NTi3ze8=;
        b=Vk4LDHrJfpuVkfEq4ExmqWNsQ+Klbd1VSRae/ZiL30l+MNrQkfrIws/wkEv2NaFvPD
         Ga6S53hWNu7Mffn4TAOnYy0F/VYeL3eA4kgCUDizYoKwLQkGkipEDtt/I29aXNtcCjfa
         V5d5PGcQNuTbpA9qCThzWzo1TC9PSe7cU+Ib3JlfyV/WZyVkWHCaz1DjQ5vdZ+JaE5jP
         qHuslwbRY1mrptBW4jfFR3MiLc+H4eD+jLs4kcC1Uip530YYZB9c6Xk1rS4JIAIaXu5q
         xrOFMHqXlp/h0k98kQRg/OrpyaCvPe9C25jkdhN+3R+it2UKgxOUYRxMYuPW5m5+OyIK
         WTkw==
X-Gm-Message-State: ACrzQf22MkmURtqkCAvHrSdlvBfwB//Rwq2yxXZsDATvvQjFmBWay9Ga
        vZs+ZDyuHl01qzRKxMChBuR7KMQLeu6+BG0WF/g=
X-Google-Smtp-Source: AMsMyM6x23xn5X6mPDToUVYK+WYedRKZPDS7hf1oCwc5mKjgz7COMLSfdhFZUOtlOSLTbI7vmEZfBTwfJeLGHFLGSZc=
X-Received: by 2002:a17:903:1211:b0:178:a692:b1e3 with SMTP id
 l17-20020a170903121100b00178a692b1e3mr27535486plh.48.1667423503511; Wed, 02
 Nov 2022 14:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022059.593236470@linuxfoundation.org>
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 2 Nov 2022 14:11:32 -0700
Message-ID: <CAJq+SaAdQOtwnRTaT0nOxtKHJD17O339fV6atmyTs_u5-wyAkQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
 Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
