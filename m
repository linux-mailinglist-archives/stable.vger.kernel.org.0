Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400AB509191
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382220AbiDTUsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 16:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382204AbiDTUrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 16:47:46 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600262FF;
        Wed, 20 Apr 2022 13:44:49 -0700 (PDT)
Received: from mail-wm1-f47.google.com ([209.85.128.47]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MBUuP-1ncaDQ1aAx-00Cy14; Wed, 20 Apr 2022 22:44:47 +0200
Received: by mail-wm1-f47.google.com with SMTP id n40-20020a05600c3ba800b0038ff1939b16so2039631wms.2;
        Wed, 20 Apr 2022 13:44:47 -0700 (PDT)
X-Gm-Message-State: AOAM531/amy6vpVqdLyvh/km3RQ5zXWyAw3BLbtAl0Oxiolcdq+SfXB+
        qFvGibAIq+l/vK+WwQQhvF3pwBvAUhkolAc2NKM=
X-Google-Smtp-Source: ABdhPJwoE/46hGiARhv3tKg+p0kqAu/eocy+mBiqzPM2R0nAAwz2tdGE9MsZwAZOi3w4jDqBoyNBFzmBVn/t1jr6p8g=
X-Received: by 2002:a05:600c:4e4a:b0:392:88e1:74a7 with SMTP id
 e10-20020a05600c4e4a00b0039288e174a7mr5387757wmq.174.1650487486994; Wed, 20
 Apr 2022 13:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220420141407.470955-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220420141407.470955-1-krzysztof.kozlowski@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Apr 2022 22:44:30 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0QRgv3ebv_=UYHb61PdqprB0wC+mfQpsGHsw3KqQSo7w@mail.gmail.com>
Message-ID: <CAK8P3a0QRgv3ebv_=UYHb61PdqprB0wC+mfQpsGHsw3KqQSo7w@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:oIBco06TIdU9VvNTN6sHftImfHgEgvzAg6iix2VW0bJhJZH37Ar
 LxlkYVOYUTccFs4pvMqSJoAzoVu43cO6EkSMrtBjUWdtHClJMlJWHGLAIQGpLCFFkwFZVPA
 J96sPqhjHNyS/dOUJ8t+HWDMi7DsaWzn5uUKIVClXNJ7l3K1QUbKaJfPO0kB+7Rfkb9J/RT
 lhKX/tLqUT6hRPcSywrMA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bBDsRkeS32o=:RsHYfojhNEFP3LuPV743Pf
 4vFHPMS+ZTQ6s9nu/MXWgp/b/cuvCkIVVjb3hDb198r4/73KEclSZqIiHhkm/MvrfgObi+h3/
 Z9r0vmv3FKbn7bcJZegG2C7Tgq3FBcR+6Y/uzmRZopUzllCpe8Yw1/kgK2YlyFYoLTh6j5vtF
 AtkgC5+uGzVHWVLb03ApgZIiA5x4Sx9vELiPStplh9kVrkFVUq+OQyWXyYUI+cwj1yySaJJmO
 muhDPWNAzZBLXnjU4gdsEPY7TNGI1ad4gnEV60drIHeLXmys+Ems5kZReju0IdARjwI2SJ2nd
 CiQbnj6knrk3XF8PtySXnCXPchJRKyzuJ4LQI0QFLc2G/lrA+R4AqLu4msj2XCSMNP3+yT6l4
 JcFPtf9h8vfD97Thd6vn/Id3linQs/mUT5SFb/q+GwN2z1hmU0Qf4VS0rxwfvRm5L9TQfZ8ZT
 3FEMNyceqCwe2FgiDGJzsJ6scKW10gAXeZgRsWK1ZQNmiJ2mKlmd6EkGA153B5lapd6ax1LtW
 hFjPmIz5YSfUXwV7X+1nBXFDPohBaEPZo2KNbndJpL7TThANLFdiPA+KgiQAaMOluDVbtA4P4
 QrnE/uSGS99Jq8XL53M+XyOWcugQy9mOAIIOkAAYdcQNDrNTdZiHkkeEt5PtYA2+owc3UGE1h
 6XcoYG7qZDUqNeyFIMq8T/v9IAurQcpo/EcbUEnCPmuj3n7HQDnkLkzBvFZJFCb5U3jKthwrr
 efh0WL14uk0fJv1DF+oGuLjOYs8GD7NPj/hrMKy60LJb91uCiJLRvKrP+XfxPluo9z648MsR+
 6qXTk5bBPZh+ozEIBNgkNUDnI6zvX6034AG/ZaTsyRL8jJhGn4=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 4:14 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> The Samsung pinctrl drivers depend on OF_GPIO, which is part of GPIOLIB.
> ARMv7 Exynos platform selects GPIOLIB and Samsung pinctrl drivers. ARMv8
> Exynos selects only the latter leading to possible wrong configuration
> on ARMv8 build:
>
>   WARNING: unmet direct dependencies detected for PINCTRL_EXYNOS
>     Depends on [n]: PINCTRL [=y] && OF_GPIO [=n] && (ARCH_EXYNOS [=y] || ARCH_S5PV210 || COMPILE_TEST [=y])
>     Selected by [y]:
>     - ARCH_EXYNOS [=y]
>
> Always select the GPIOLIB from the Samsung pinctrl drivers to fix the
> issue.  This requires removing of OF_GPIO dependency (to avoid recursive
> dependency), so add dependency on OF for COMPILE_TEST cases.
>
> Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
> Fixes: eed6b3eb20b9 ("arm64: Split out platform options to separate Kconfig")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Looks good to me,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
