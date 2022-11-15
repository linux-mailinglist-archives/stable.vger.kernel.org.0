Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771F362963E
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 11:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbiKOKtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 05:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiKOKti (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 05:49:38 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D396825C50;
        Tue, 15 Nov 2022 02:49:11 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id g12so23366637wrs.10;
        Tue, 15 Nov 2022 02:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XMMSohnvCVbOp7499SojlBT0r8qE5qU6Z9gZNctjXR0=;
        b=E64MUF2H2ETJz3HC02uwS/GeOP39O/q4BlsExCAUr+PVRzMyblTIyMaI6OWFB7TG3g
         ckBvezacg7nL0uX0eajSPZ4UvaqtmCLQIeW/mKskocAPoOFIEU6ZTfE/bsNfj44dXIvR
         1nNecJgX1LT/Mz8E78L6gt5qujrveGM+hnCcslLzUAf8UKffod1Xp5lAQTg0b2XS5QLx
         LQSynA1+PaPsu9NJhh7DF+BU3RsjI6ThkNtb/A52TecnmNLFiqNowIgG4clTCZj3bQwu
         Ea9tZ/Z73OfyUkV6gnQoGfUjrqCR1nxtrrhD4L45YmLhe0pL4hiVy2HGoqxXf4r9qXS9
         SGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMMSohnvCVbOp7499SojlBT0r8qE5qU6Z9gZNctjXR0=;
        b=WwNsyCmlsMZsApq3E4BKZpSH6x8321RPBp+NtPtzY94z3zJZSZoHE3HmXJEX063xjg
         R257DDBk8M1hRXEQNgBK4NJgLSViMFGyKT946+rwAGh52/vOhhIu4yJBOjl0GKApu4qy
         VF1nxK+P7K5WKREfKJAZSFIsyKR2Zy5ALyMAIBjPyIt81YMEjyLYZ9rdKUCSPZKGLIer
         /BKrZM6uSdyPwd7yykQL05KGASbHpnajcn38xO7Kp9UfABnIrOp8IBJfGJ/PhzXJMO4U
         Xz17drGrcKsKvWlegNilbqO35jqkVNA1QmlWj3unlVWseil4dlZ+nPJThCAHQWg6E/0h
         ezNQ==
X-Gm-Message-State: ANoB5pmi+oc68gLG43Ly3wnO/t3gzyXTgQwSyFY9lIbInaekSjac9iTJ
        lq/VPdBPoYxR9YNZ3JX8V44=
X-Google-Smtp-Source: AA0mqf497GilHII9sGxe2u4bgwFerOu7lsiejmzQfkeadj0qxxpQitUP1opS3q0d0Mlki7KsB5u/SQ==
X-Received: by 2002:a05:6000:a1d:b0:241:7d0a:65ef with SMTP id co29-20020a0560000a1d00b002417d0a65efmr7686061wrb.491.1668509350340;
        Tue, 15 Nov 2022 02:49:10 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id l9-20020a05600c4f0900b003c6f3f6675bsm22593909wmq.26.2022.11.15.02.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:49:09 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:49:08 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3NupE6nAtbpoxbk@debian>
References: <20221114124448.729235104@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
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

On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
arm: 99 configs -> 1 failure
arm64: 3 configs -> 1 failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
As already mailed by others, both arm and arm64 allmodconfig fails to build:

drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
drivers/net/ethernet/mediatek/mtk_star_emac.c:980:29: error: 'struct mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
  980 |         napi_disable(&priv->rx_napi);
      |                             ^~~~~~~
      |                             napi
drivers/net/ethernet/mediatek/mtk_star_emac.c:981:29: error: 'struct mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
  981 |         napi_disable(&priv->tx_napi);
      |                             ^~~~~~~
      |                             napi


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2158
[2]. https://openqa.qa.codethink.co.uk/tests/2163

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
