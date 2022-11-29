Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC91163C1D9
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiK2OGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 09:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiK2OGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 09:06:46 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31360391E6;
        Tue, 29 Nov 2022 06:06:43 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id bj12so33976416ejb.13;
        Tue, 29 Nov 2022 06:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ezv4Cua1pgsuoHuPrWFFVv2BRJpPw4+8hGPgf8J/Hyg=;
        b=AdBEIKJ09u8waNl2wy5d78c50AAKMASyK1tqB3okY7hkJCOx/twp+I2qzX26AzNkzI
         S3zl4DzEuWLNVH/G3Jo7l5rKfGpE3CcJXkmFTTjOAtS68IElImV1z+LaU7EqF6nGHGtf
         Jn9O5rvL/GEpJHGeaUk3157BQQnVmqUxExcpArkBhBNyPy4tkfUDW45G4+tVj3/kndcL
         N/Ov94qKssSKZrTra2yCfpj/tSjulaMzQyu2m1ykhDDloqTFw48wCmlLUCjoNXcF1huk
         2pLEtTaAvB3dtRNFXDO/8ZHeJLUN9OgKP2oSMWxCOR8sHV4YsKTSZaJYDvAqwlBpFgt9
         YuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ezv4Cua1pgsuoHuPrWFFVv2BRJpPw4+8hGPgf8J/Hyg=;
        b=os4d8+Gc0KabE0QjpPPxhhy23wj0xPMUbi4NtVOt2kth3bU1S3vU7k0UdEhJ2xIBOB
         tBuq3/VofIyMjeXZNQVgqZcpMYGr2xuHCwuT94Yg0PWlBfKxKkRjF3qFiQFpOoxVzgxk
         0n731/UWBsfMSdE4qR+lhZWPvnaAIYnNY+MgfAxsj+8uFEraHPbH/IOqt24Cv8ev7Ck9
         WPOpCVvXLKWye3kpsJaE31sJqbyCQSwe9mPmPGoYOYGk3DEQNpuWVcZSmAhoe2HQmnXX
         AiGHVi0yLDvAE7gBe0iR/Af8n1LbZY+EFMshU2+CenTJOH17UzxkP5xEO9xQUaYbbMYM
         V5Ug==
X-Gm-Message-State: ANoB5pkf3cjoMQyBamSYGC+FhQL3rptobKTQtG1rmMw33yMy8xvCPdSg
        1DrvmTjvqXro3UMOb+sIpSwkYKpIWs33e5DAMpg=
X-Google-Smtp-Source: AA0mqf7mi+xCfKpjk7VbrNOwH0zHT/pSLjAMJB8mSbvRLksVmfdThCMphMsZDrk29TcqPnXNZgPQVypixGS1wazD058=
X-Received: by 2002:a17:906:cc8f:b0:78b:8ce7:fe3c with SMTP id
 oq15-20020a170906cc8f00b0078b8ce7fe3cmr47964958ejb.557.1669730801633; Tue, 29
 Nov 2022 06:06:41 -0800 (PST)
MIME-Version: 1.0
References: <20220714084136.570176-1-chenhuacai@loongson.cn>
 <20220714084136.570176-2-chenhuacai@loongson.cn> <CAAhV-H7W8V8XdJXX5FvyvvSCAbeTSgLEKhHLivm89T-Nd59Umw@mail.gmail.com>
 <28f1be2e-ca7c-1c95-535a-2099ebf607f2@physik.fu-berlin.de>
In-Reply-To: <28f1be2e-ca7c-1c95-535a-2099ebf607f2@physik.fu-berlin.de>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Tue, 29 Nov 2022 22:06:29 +0800
Message-ID: <CAAhV-H4VEqkeXpwCmZE=VqB-TTtnteAqAxbTbeT+s38QHTGdig@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] LoongArch: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, loongarch@lists.linux.dev,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Guo Ren <guoren@kernel.org>,
        Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
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

On Thu, Jul 28, 2022 at 8:53 PM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
>
> Hi!
>
> On 7/28/22 14:42, Huacai Chen wrote:
> > Since the SH maintainer hasn't responded, I suppose it is better to
> > let both LoongArch fix and SH fix go through your asm-generic tree?
>
> I could test on actual SuperH hardware if needed. CC'ing Geert who has
> SH hardware as well.
Any updates?

Huacai
>
> Adrian
>
> --
>   .''`.  John Paul Adrian Glaubitz
> : :' :  Debian Developer
> `. `'   Physicist
>    `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
>
