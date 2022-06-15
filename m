Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A5854C4A8
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbiFOJ3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 05:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347208AbiFOJ2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 05:28:52 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7816526AEB;
        Wed, 15 Jun 2022 02:28:51 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-31332df12a6so55021217b3.4;
        Wed, 15 Jun 2022 02:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jZiaPZ0ztzZi9sQqqnXkLriNEs5DS/AorKKZ/pc584o=;
        b=fARbgYFuiloDj2xJOMqKaZhdYrOKBxSHUnhCQ3qzm65OM5rwzBIpMuJ7tAkFnyoF1r
         OY6TrEbAwBJ/J1kfJsJQU8PLu3hYx/TADoTZlq2YVss6y070F2lu3BJZRm8YNKMuVXfp
         O8W8KSm6jUASgr7mCV6ro6Gf2Obha9J6IQ+k3aiu919qYFgJYW3aGpt0zt7cpA7omG+8
         1U2gLli4yuKDrRhwSRlJCBLFWpS+ibEqa7DTUYefaNX8Pb8co7qFaiMQtA1AnNuFb1pl
         UjC2QMokCzP5J2lFPvDiojwj7TKjYOKAYktkgrbeDrdJzivS5ADV28un+CqqCScBHC2E
         Hspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jZiaPZ0ztzZi9sQqqnXkLriNEs5DS/AorKKZ/pc584o=;
        b=S0vu8TGR4L/1ph14QXttwpTXZ46iQnJWeUgK32GEQP1jS9EUvvmb+uHUko77u04t4W
         +ayq8gBbxv3KFWf0zJ4gtLijIAkj6hyRT//O3y+zso65G6zXXt5Qj30vk34h9e2pSnsX
         QjdYvgyxTfeAlzvoRcLwSNSWN4lEJbJ9pcLMZ0CZH3m7HKgqEYi40MiDwKUfdS8BUJqY
         FC5FPMW8H2zo0UG/8ez0LDxKxckO52/06VtTyhIIRYz1lvt4jVPy7FpKUr10m1tI6YBM
         rFJ4qPSh3uDqkph8nye959wcaj3jsKUyB6Cb9k9zHeNuIb8YwrgHtQ6VAeCvDekqGPQ2
         u4Aw==
X-Gm-Message-State: AJIora84wzdM5ZS6s04k9Fr+SPBliy7uQRrCzbKCtPG4cqRy0UEg8HGs
        A95vr/MwnJWnDcI8xuWW15bu0yo2AE8Qh1uXVMc=
X-Google-Smtp-Source: AGRyM1sKf3+5EXx7587X3j6rcCEYz5L/YPi5hi5GgALX4dLxsAIJ+twSErqgT83BDoHXF9HRxqLoqz/rATFICRG/0Ak=
X-Received: by 2002:a81:6ad5:0:b0:317:52a2:2111 with SMTP id
 f204-20020a816ad5000000b0031752a22111mr1883442ywc.233.1655285330726; Wed, 15
 Jun 2022 02:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183721.656018793@linuxfoundation.org> <Yqmk8DRLrZMVTj00@debian>
In-Reply-To: <Yqmk8DRLrZMVTj00@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 15 Jun 2022 10:28:14 +0100
Message-ID: <CADVatmMCt4cVpXEZ9YurL6rWSwg6KpHgAYOz0n0=J4Gw87RmCw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
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

On Wed, Jun 15, 2022 at 10:22 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Tue, Jun 14, 2022 at 08:40:09PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.199 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> > Anything received after that time might be too late.
>
> Build test (gcc version 11.3.1 20220612):
> mips: 65 configs -> no failure
> arm: 106 configs -> no failure
> arm64: 2 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure

Correction: powerpc and risc allmodconfig failed to build. Backported
patches sent to list.

-- 
Regards
Sudip
