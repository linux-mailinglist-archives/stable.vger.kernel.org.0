Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C8959D36A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiHWIMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241520AbiHWIJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:29 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CDD6744A;
        Tue, 23 Aug 2022 01:06:20 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-11cab7d7e0fso14731655fac.6;
        Tue, 23 Aug 2022 01:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3DUNim7WTmzHmRObYLAWDZd3QPXFrzWMAVJ6u950fVw=;
        b=PEfKzVZ9zdDK7xpYNrTaOE8LDRrYuccID4DJC18ZZ1dOGcM/PFel+HYpWII3aKbIeF
         DWC52FU81Nk6KSpVp4uhLoJusR/zqCu0JxHLuRXzPlJVYhVVh7+wgUCecv/5N6zsniIx
         QvDxhVIuMs/EghKCfi/T39Sz+o9TQQaQXXA9k7Mo5jS0wfJcezhj4E8fkG3R75mS/MOr
         n1ULmf4rkLai8G/6SCv55h0BGAWvJH87B0IvIdLCJ0EyM22FH8AIfJndotB+YyGD0hRS
         K9As7UA+MPl9h+9Fa89Ygw7FFNqg7YRIl6gspf3za/PHuxAI/xFLO81HxY/QSBj4UIEM
         Wz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3DUNim7WTmzHmRObYLAWDZd3QPXFrzWMAVJ6u950fVw=;
        b=DslT6HfCfSaOk48qI7tcWj4PNM9/7IgIoeeO/qb6lNZJ+ebQYIWpUfPCRvez5SmBXb
         7gr3sLdyTh8NI4ZPw1BzOqAWv3pfuvkMBu+ydXvcB1v1zcy/7afK+iudz6xeIBOeLEDW
         m+f5C76bj4UxuDBo8pawGIzBVhrjclvLHZQWlXJ54rbV2JvTdr7LsMZcuGEHqtcF/Zz6
         6pcHAj2ev+VcK/SvCopjWqjpLsf4GvIp7HVgE/rLOEQj1tfLJQSwpyMeB8jidKYCii3e
         j8Lm4Uj46Hs7dCA75eCOS23RuOQAYRyj+SJP/fxY6EnyruCQyf1cL+kCev/7fkEVNo9u
         k9tg==
X-Gm-Message-State: ACgBeo1HSHF2dhSfK8T4F0yjlEpuWuoZH0So18F5GAHpoKr+lBjGeHsd
        X0Sh4gKlbWJP68+v30CU6F0LuAAplLNcreI4GL+lVlv7
X-Google-Smtp-Source: AA6agR7u0uAvaNIkWvMT1B9z9RQ3S+vI04sURkMJs02g+rhl0HQ6KWE6yptMMcC6zUNNTZ6gciyBV1GEw8LrC624xeM=
X-Received: by 2002:a05:6870:8912:b0:11b:a59c:f533 with SMTP id
 i18-20020a056870891200b0011ba59cf533mr894982oao.220.1661241979113; Tue, 23
 Aug 2022 01:06:19 -0700 (PDT)
MIME-Version: 1.0
References: <202208221854.8ASrzjKa-lkp@intel.com> <20220823030056.123709-1-bagasdotme@gmail.com>
In-Reply-To: <20220823030056.123709-1-bagasdotme@gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 23 Aug 2022 11:06:08 +0300
Message-ID: <CAHNKnsRUJzRGJ+muGfYAW-5EM91_j9AK-WTeV9pBZeXjH6L_6g@mail.gmail.com>
Subject: Re: [PATCH] mips: pci: remove extraneous asterisk from top level
 comment of ar2315 PCI driver
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-mips@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Aditya Srivastava <yashsri421@gmail.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 6:01 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> kernel test robot reported kernel-doc warning:
>
> arch/mips/pci/pci-ar2315.c:6: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Both AR2315 and AR2316 chips have PCI interface unit, which supports DMA
>
> The warning above is caused by an extraneous asterisk on the top level
> (description) comment of pci-ar2315.c, for which the comment is confused as
> kernel-doc comment instead.
>
> Remove the asterisk.
>
> Link: https://lore.kernel.org/linux-doc/202208221854.8ASrzjKa-lkp@intel.com/
> Fixes: 3ed7a2a702dc0f ("MIPS: ath25: add AR2315 PCI host controller driver")
> Fixes: 3e58e839150db0 ("scripts: kernel-doc: add warning for comment not following kernel-doc syntax")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: stable@vger.kernel.org # v5.15, v5.19
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
