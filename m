Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FAA205B38
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 20:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbgFWS4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 14:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733188AbgFWS4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 14:56:22 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA68C061573;
        Tue, 23 Jun 2020 11:56:22 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 9so24641521ljv.5;
        Tue, 23 Jun 2020 11:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLTbat6fieBqr/9/lL2FJCRZ8pEMlypsdp/zm9STPlI=;
        b=Fwnsclrpa94+GqAeSwaeAmRiYo467rG+RNbAuZclgsZROzsPA+as+fnZlVd9NUJWfz
         Ioiq6OkaTlihbsZf8bHePsQZIkPzv54IAOhUJwmQ73QT8tpqTWa8jpUvhfSl6bxwq9f5
         fOjKqg7LlA8gjeU74wR7t6TFEjrK7qIsEkl3929JAV8p5zoSRR9SynA+h6vA8DNyritZ
         CPBFha+YLuqjo8mrH0htk/vGC6VWOdJx1CTSlVd3zCtQujaCNbfcv4PlC6RxHfEBdEOQ
         u600vnccDI4Q39CtJcgnN9eGQ/k9CcazytorOaDWwCj/TYIuc3Eox11Hc/Vytimu8Y7O
         woJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLTbat6fieBqr/9/lL2FJCRZ8pEMlypsdp/zm9STPlI=;
        b=aH3wHsg7ena3wUrB2ILSORsy5GRj09jQF+wPS2tvWxhmZu3qBubEKahiMv5IK4PPAd
         /Qksup9ctbkzlsymlIafKfitQ/jj+BEsRLisRfx5yLAb5M3lXsQVef2WwOJFiTpqyfXA
         EIuwz9SK9YT1TkBQlcatXPIHqfhFNB8YkB0cSFyo9AVGNef07GLxPQIfuAd9EcdVY3/D
         TzH/wDxvlCYzj/hP3gHKocwxdKBgSEqdcT/ITKwHXXXNTpfJwo1aGc3wi/dEb4QHagEB
         +PG5XVDOBSPacoFx0cnlWNGpeVFMH5wXn2oYkoAyDzmbEbppvN0DnjoGRm421WJZyLnD
         iMJA==
X-Gm-Message-State: AOAM532Soh6ZMnm5LpQuB15Pv2j/x0kSf1N/laK3lPMtoKwh3CaZB7KM
        X5BI+Po/vP46SpqgJAHKYGOdbi4czlcPiSXQUr4=
X-Google-Smtp-Source: ABdhPJybZLPt6wRDoJv7GJYMUP085xQpCVI0BG6DAAMBhrMAnofg+cnlM820I/CLO/Af7ZZ4yslao77jBmjWws6gPQY=
X-Received: by 2002:a2e:b4eb:: with SMTP id s11mr12143822ljm.452.1592938580718;
 Tue, 23 Jun 2020 11:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <1592937087-8885-1-git-send-email-tharvey@gateworks.com>
 <CAOMZO5CbLvf_iV5K1zXZdYqgpBqrOZmTGR=NYyL+j73ojTGOnw@mail.gmail.com> <CAJ+vNU19ebj3xpOKxeHMzdMQjVdZoJCTFJ5DSYat7U4tpZTWvQ@mail.gmail.com>
In-Reply-To: <CAJ+vNU19ebj3xpOKxeHMzdMQjVdZoJCTFJ5DSYat7U4tpZTWvQ@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 23 Jun 2020 15:56:09 -0300
Message-ID: <CAOMZO5CENFuLmQ5rhs6EkXTTUVsOyX-NYwXABnS2ji_QpFYr+w@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] ARM: dts: imx6qdl-gw551x: fix audio SSI
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tim,

On Tue, Jun 23, 2020 at 3:52 PM Tim Harvey <tharvey@gateworks.com> wrote:

> Yes, it likely should as it fixes audio capture from 3117e851cef1b4e1.
> I didn't think it would apply cleanly to stable but it looks like it
> does.
>
> I cc'd stable@vger.kernel.org. Should I submit a new revision with the
> following?
>
> Cc: stable@vger.kernel.org
> Fixes: 3117e851cef1b4e1 ("ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x")

Yes, that would be better.

Please note that the commit ID used in the Fixes tag should be 12-digit long.
