Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7400557B8DC
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbiGTOtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbiGTOth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:49:37 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D6253D2E;
        Wed, 20 Jul 2022 07:49:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d8so6509468wrp.6;
        Wed, 20 Jul 2022 07:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0rlY198aOUhmB4p1QF8bVOmhl2ayzesAEy2gf+oeib8=;
        b=MO8OHVu2FBGhB/rftEondqXgrWaDk97X4vDFULaJCBKsbNhEKIf/7O6iuJyVC1usw3
         vBhoAi1InVcG+ikICKrRwp8OQP875a9mKfMQB83wsiQaSA3mkEKFXJmYIs4O9wAR38E2
         S5ny1EvIrzXr/iL6MK00p9wK7GDAtCJm3sh9EMKLDsgMRnOfAvClNOCbPW2lwcX6Qrox
         6x2/5sDQvHoHCnlLPPD2E6IYl2YIT2PFAEv0oPZabfdhx+cXBvYXhwr2OcCEh2CP2p2P
         pq1V62QWbtmllQl9tTB/Z8ZkJ3yT0X1zIqeKcEzr0lCqzWZTRrfoxQbOHyB4HXJRiv5a
         sHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0rlY198aOUhmB4p1QF8bVOmhl2ayzesAEy2gf+oeib8=;
        b=B/aD2fu7HL6MC1hETBfxqdnq6jIW08af3WncigYTMKE89ROunkaLhSQMGlBmClD+LD
         3/kkTe+VX8ZvZANm1+Wb+FONF3BpM7UMKc6D9QWmEZ7IW9cSJEyuYcv5/fnBxeyln8G0
         2wIjiJ4rVjeEuDj3zdFfvg6bheAjwl1VMji57nI6+dyCWFk+lC4u+Oml6dAIFYqFLhJI
         sJrYYwCLN2nDCnMl/5qboe0ytw9UYJxXUAPtDIbx1TYuX6+IW2Y/SETBk2X1CEfA3Yzg
         QD14evu5GFJiMshl1Zh9hfoD2YmXig6fbcAmIaYtlXQ8oyuP9hmLnYRJicyeyvjT4VpZ
         syzQ==
X-Gm-Message-State: AJIora/zMK4JfWaG4+1Sg5wQ0tR3+YJy2HbhmEPiV8y/g5fxkPv0m8Aa
        QwTZisKc+upzdAoOhxhRetmCrVaMuSE=
X-Google-Smtp-Source: AGRyM1siaSV9gtq/8wsMjPQ1ibD9+jL5a6cFSJXfs5RcGMaZhcWH9zTcbmvadRBQjgBh5Gwi4AQjCg==
X-Received: by 2002:a05:6000:1110:b0:21d:ea73:a47e with SMTP id z16-20020a056000111000b0021dea73a47emr18127792wrw.82.1658328570867;
        Wed, 20 Jul 2022 07:49:30 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 189-20020a1c02c6000000b003a2e42ae9a4sm3334154wmc.14.2022.07.20.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:49:30 -0700 (PDT)
Date:   Wed, 20 Jul 2022 15:49:28 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/112] 5.10.132-rc1 review
Message-ID: <YtgV+NduF50atumD@debian>
References: <20220719114626.156073229@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jul 19, 2022 at 01:52:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.132 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1521
[2]. https://openqa.qa.codethink.co.uk/tests/1529


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
