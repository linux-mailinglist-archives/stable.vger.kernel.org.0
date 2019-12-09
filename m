Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BBF117234
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfLIQx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:53:28 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42212 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIQx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 11:53:28 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so16418206ljo.9
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 08:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i5E/MjKk+9tYZWtGZA1a9KLp73tWSU0dUrUonc2BCv0=;
        b=XaTVJLJfWlKX09vHbBZqLgQHhIzb61to2XSi+0tBML3Fs+XWcHtUBPpNPkrT4aqsgu
         PIXvN1qitHpUD+SthBOyBpwZZ5cmvflOXxgZuLuIiz0sVqeNiuJQfqyE93KYFMvQbWgY
         wweRMbjaTmBBG7oiBMip6qDqCzisMUuCcVnogNUIvqJEaEM3bYvY8aSepPsHH3K8pE7R
         UIbzPBkPgTSzoydXKR8fE/EY+Cu3I6jEuAKqV31zpcRKSzq3I+Pj/w4LCBNPJBS0bLdU
         gj8KCVZ3RXfNLOFobtQq/SjYtlXlnS7b/8aW3fyhD5kfGyJNlXl/3aYdUbD5eGxcD/vK
         dHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i5E/MjKk+9tYZWtGZA1a9KLp73tWSU0dUrUonc2BCv0=;
        b=d5xdnWifm/+uYkGvpxdmKBO1Q7+QbusYiysllmKCj9R09XkKANZZSvHS/JmqA9oQ5v
         HZKEd3kymiM3PqjxCWnYCP+xBDTzFpGZFW/xs7V659Dooi3kAYJzCfNA9qhSc5+GIs8Y
         vGCwJR+YnOCEUV4XXQEsnOmIvi9QzTKtsV2epb2J+J/bDX5FS5WAD1sZdLuMlCCgyF0A
         HiTDNfuHTqXsS/vBIdTryzSf0o1vqC0/gx6JrPWFh4Evd6Qq4/KkG6ccU8hUenIlCUo6
         nnoNIAP9A1g1ETRpyltZXfbNRMWeUTpZZ6U4Esu1hTy6pJ6l78phjdQELR4NLoyGjOxs
         eLaA==
X-Gm-Message-State: APjAAAV2eAkCtovmYzptYYn3rpCa1OAH9vHFCNHQLk+jhIL3jECAkF+R
        jkKhN5QBA7kfaXmtsAkEigSYdAy+hsfCi5In8XRl85eEgfQ=
X-Google-Smtp-Source: APXvYqyt6v9tawMagAo2T7JXD7W/NSTu0EZs88ZOqHlnK6NCRUTr3fezUuY12MONfG4T+jSZu3B/AQXrXHyzFX/90sE=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr17765222ljd.227.1575910406040;
 Mon, 09 Dec 2019 08:53:26 -0800 (PST)
MIME-Version: 1.0
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 9 Dec 2019 22:23:14 +0530
Message-ID: <CA+G9fYt84QXQh4YLvV0QeC9gxLhQjLVEg6MSG1wcfZQ5o8Yi6w@mail.gmail.com>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        cip-dev@lists.cip-project.org,
        Chris Paterson <Chris.Paterson2@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Dec 2019 at 21:59, Chris Paterson <Chris.Paterson2@renesas.com> wrote:
>
> Hello Greg, all,
>
> I've seen a few errors with 4.19.89-rc1 (5944fcdd).

LKFT build system noticed these issues on stable-rc-4.19.

>
> 1)
> Config: arm64 defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484093#L267
> Probable culprit: 227b635dcae6 ("bpf, arm64: fix getting subprog addr from aux for calls")
> Issue log:
> 267 arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
> 268 arch/arm64/net/bpf_jit_comp.c:633:9: error: implicit declaration of function 'bpf_jit_get_func_addr'; did you mean 'bpf_jit_binary_hdr'? [-Werror=implicit-function-declaration]
> 269    ret = bpf_jit_get_func_addr(ctx->prog, insn, extra_pass,
> 270          ^~~~~~~~~~~~~~~~~~~~~
> 271          bpf_jit_binary_hdr
>
>
> 2)
> Config: arm multi_v7_defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484091#L2147
> Probable culprit: 192929fd944d ("dmaengine: xilinx_dma: Fix 64-bit simple CDMA transfer")

This build issue occurred on 4.19, 4.14 and 4.9 branches for armv7.

> Issue log:
> 2147 drivers/dma/xilinx/xilinx_dma.c: In function 'xilinx_cdma_start_transfer':
> 2148 drivers/dma/xilinx/xilinx_dma.c:1252:9: error: implicit declaration of function 'xilinx_prep_dma_addr_t'; did you mean 'xilinx_dma_start'? [-Werror=implicit-function-declaration]
> 2149          xilinx_prep_dma_addr_t(hw->src_addr));
> 2150          ^~~~~~~~~~~~~~~~~~~~~~
> 2151          xilinx_dma_start
>
>

This issue is specific to stable-rc 4.19 for arm64 build error.
I have reverted these patches and verified builds are successful.

> 3)
> Config: arm shmobile_defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484089#L2249
> Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN versioned groups")
> Issue log:
> 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> 2251                                       ^
> 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error: 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you mean 'PIN_MAP_TYPE_MUX_GROUP'?
> 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> 2254   ^~~~~~~~~~~~~~~~~~
> 2255   PIN_MAP_TYPE_MUX_GROUP
> 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> 2258                                       ^
> 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),

- Naresh
> 2261                                       ^
>
>
> Kind regards, Chris
>
