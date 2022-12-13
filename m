Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910B264B873
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 16:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiLMPcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 10:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiLMPcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 10:32:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11EC1F605;
        Tue, 13 Dec 2022 07:32:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f7so18242200edc.6;
        Tue, 13 Dec 2022 07:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9LFcn2LS2h1mCkUkoHgPOjFPfjs4oxAUSgVBVj57pOE=;
        b=bwnC1QCUTzSNR0jnSkHm6+NJvylAT9qlE995YBiYZths7yzrOPGvqQLltEoONhJ2la
         GflqEwoVSojbh60Z0i73QDq8c/1RO0QSMenTMRqDWjDd+ngpMibFdBlnslXzUTDlHH2N
         svMaYW6+fZrBRJK2/mDNV1/rVtViogyVXdvXYhF+S3i/oIa8TmTydJfWi2ly3GtH6+Mb
         G0ZcpiHYvHSplWtGeQuMcqUVA8ycgFMhuTQ//DBDnN6Ctj3SBr+L2DNfltRja0fiZJFM
         XqFuJTBPm4t3pDIErWBXEa50bq2HgMiHyDNPVL+kJBXM2pc4RfcycXqZrLYhx5JVV1KV
         3oXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LFcn2LS2h1mCkUkoHgPOjFPfjs4oxAUSgVBVj57pOE=;
        b=Hu0cCr8nFJuHtIh6/H6E0ixP9um/GCjipMYouJlB3K8Ii8ELtTdEGY5O0rHrbSRTsS
         +wZA5Essdx8s5LLdsSxPSiQrie/gbwcydlCMEYCUz3DluOumWEShgyFe82SkYXlRuoy9
         K2VJGIySMzmAuJV3+ZfLKY+x5T9N9ENKjgtQ+f7JMKsiSSGTYvQeWZdyEkKlEuE03NuC
         ZkhUbuW/DqvSfY9iV/VrzIacbo/QLMUrV4NE5jEiJH/Nk1aNewZnOmi+DbLLhMTxnCN3
         CeJjHfuK7SIjRRHvbMJNM22eMg+4sKCYAg12w4G1PcGfzZeMp1GDxtXcI+BMetqSok0k
         lF7g==
X-Gm-Message-State: ANoB5pkqObT/uC+Lrk/y3oyYbENngOcKwXh6xdrxiKbKWyR7E0Hu1qd0
        MQ/O8jFFqL8jLqA04nUEcC+cZCyQxWwO0nUGCyw=
X-Google-Smtp-Source: AA0mqf679IR0szw2P7LGnGsO9Uvt78/3pJf6iUxIbum7zMS/JIZHte0W9eaVemwbp9x2EKxXCQd99qUcs19KL2jT5S0=
X-Received: by 2002:aa7:d841:0:b0:46d:692e:8572 with SMTP id
 f1-20020aa7d841000000b0046d692e8572mr7127576eds.25.1670945531147; Tue, 13 Dec
 2022 07:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20221212130924.863767275@linuxfoundation.org> <Y5hqsggURI1Me1ik@debian>
In-Reply-To: <Y5hqsggURI1Me1ik@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 13 Dec 2022 15:31:35 +0000
Message-ID: <CADVatmPM4Q5A9jVO6-ixhqa2HWh4rWPKNpfwy75u69My=3Xhjw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
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

On Tue, 13 Dec 2022 at 12:06, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.159 release.
> > There are 106 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> > Anything received after that time might be too late.
>
> Build test (gcc version 11.3.1 20221127):
> mips: 63 configs -> no failure
> arm: 104 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
>
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression. [1]
>
> arm64: Booted on rpi4b (4GB model).
> Regression noticed:
> Failed to start Network Manager
>
> Will try a bisect and find which commit caused it.

Bisect pointed to 60aefe77fb48 ("net: broadcom: Add
PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835")


-- 
Regards
Sudip
