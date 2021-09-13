Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2078408BC1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhIMNF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240176AbhIMNE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 09:04:56 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F5CC0613CF;
        Mon, 13 Sep 2021 06:03:39 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id n2so21037074lfk.0;
        Mon, 13 Sep 2021 06:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9sTLBz67v50uxjPLGpmhcnOPvRMUIhtkAWqB/GTMNGI=;
        b=SNqyq33VjffTGxubIW/LVFzPl1THnHS0OjXILWJlGHhs3uOPKtGPlG+cnXP+YAnbwg
         BIdtfwwWXkRAwENahNcuRhu96N2IkmlxCLKKjVUq39lf3jWb6FZ1803OksGuXuYfdxWj
         rwM6eDfauAsUaGST3r5DUVwV8Fm3qyQ6k3n+VTzTvcf3He+J3CXwcqyIi3Ig6yUzb8BG
         pJmhSV9JKmk9QuRUfKzh4bNehnhhZDNOb9ytRrxLf8ekFaAbNfhbj3rlV/3ooo+4EHON
         EfeS8d453noCzt25XSSARXvv1Cnx3WJ6PqzK9KqKzIx1lpV1vjyZuyKAdHNkBYyApJuy
         KouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9sTLBz67v50uxjPLGpmhcnOPvRMUIhtkAWqB/GTMNGI=;
        b=MXyUHO9DchFKB5UZ3BkApHf7/k5KrFzKV9ngq5Nd+zIk+JkZp0X3V5IzDQJjtr08wH
         nTQtLN+mz9LYDMWgYqA+ElSP82qC2H2x65tPDzX9cV4XJ4MWlpTNebLDI79Gm4xzemaA
         4bi6ti5VDV+B5PyIPxhsk6Z9Ck2l6OAyzLcnmq1hZ3owaMwtr4NXrccp2diBPWg1IHnL
         j8FTpvBM8+06w94OAZCQnaz6PkPIVcnYs6SyY/5LlnbjEvPckmwJph9giCCVqBT2AHTB
         8HC2IyDUwfpvzsTQD9mDmcw8VUZD2tP08drodM2d/7GlPQdNCYbw98E8RcqyjOAqPJy3
         Jvqg==
X-Gm-Message-State: AOAM531uGBcrm9yXPUt3mePmi91xYcm5tlyzBnKKxiGPytEr8hy0GPF2
        NeYRRIvEMWo42fGLBYHtsQSKqhN6nmflZeuZnjE=
X-Google-Smtp-Source: ABdhPJz98Iy3VQAyl6qYBfputzhJiJ/oqeAlSmgwWwR0nmZWXPhHu2AvEn65dsd71VopVkjo1fi+DYZFawZc1oQRStc=
X-Received: by 2002:ac2:5f1b:: with SMTP id 27mr9222856lfq.79.1631538218197;
 Mon, 13 Sep 2021 06:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210818070209.1540451-1-michal.vokac@ysoft.com>
In-Reply-To: <20210818070209.1540451-1-michal.vokac@ysoft.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 13 Sep 2021 10:03:27 -0300
Message-ID: <CAOMZO5DgMN8OptVAs0JMkFC51WoD7t8rE3rPqzZGXBcT+5x9wA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe
To:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michal,

On Wed, Aug 18, 2021 at 4:02 AM Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.=
com> wrote:
>
> Since the LED multicolor framework support was added in commit
> 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> LEDs on this platform stopped working.
>
> Author of the framework attempted to accommodate this DT to the
> framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg proper=
ty
> to the lp5562 channel node") but that is not sufficient. A color property
> is now required even if the multicolor framework is not used, otherwise
> the driver probe fails:
>
>   lp5562: probe of 1-0030 failed with error -22
>
> Add the color property to fix this.
>
> Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to l=
p55xx")
> Cc: <stable@vger.kernel.org>
> Cc: linux-leds@vger.kernel.org
> Signed-off-by: Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
