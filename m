Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADA41D747
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 12:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349743AbhI3KLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 06:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349788AbhI3KL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 06:11:28 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833AAC06176E
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 03:09:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 187so115343pfc.10
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 03:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3+c3UE16rJ9BR0MTbPZO9N91uTIEelpE5RANhlK6WiE=;
        b=eyAuYMm9qnVsbCfsQoCyDIjh/yYLCsA6bRYvkPaz7IP94IQixLeM7pKSaBLVLMBXYd
         9NIPmzk38v40v7bS54lepvYyozW9YuGqhgEtfLGFBvzM7S9Zh9U9c9tjA1vm/QQGJDrK
         1Pk2F30/4TQU07p681r0lkSGB+2bMh6FFhcrhY8nXFqXe1Z85oLMXpgzk2Gbj5TV//cE
         WI51Ho/cQhpuQgHyqwkzC0/54pMpQgE8HWe7qRpY2v+LfdTdfWTnxx/UjMfmz3WvJR66
         sJ8uNlZr1IvPDbDiE+KSVDiG9pQ63zPR4NH3VH7qV2uA6c+EsU8H+XskOK49I3KAX5iA
         2N8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3+c3UE16rJ9BR0MTbPZO9N91uTIEelpE5RANhlK6WiE=;
        b=FJ/3+DCZaqDCAmVN0PQUAYPiBDR22qn5/rydjj9tns9mzBlfbN9IFh/GL0s/VdPh8c
         ELCTq4K1ZenzeuC+LvmO3lkN0fclyS/VJ3ksnNvyM6ABWHNLX8zrsY/tCUP0vxl98QWs
         G1Riv+wH10VP1sJapzPNBrkEio1TvdPLBkhjaHO+3pmpo6YIZP5Br6OjJ7pdL33NXgXA
         QbPJPgJNipXH2W+acWfqFlJDsWZJ5Wl0qViEu1rFizEvRI3I1sXV4ztrwvUs1yiQYHm+
         m4MwCMBLNzgc29eUQxxp7pVmJ6im8X09uEouJNopEJlpkYdMUUc1368nM7K+YVxcQNWA
         TS0w==
X-Gm-Message-State: AOAM531d0KTIrRS+WptBwrmhI6HT7h3IjK+vasNW8K79PNau6KzdubMk
        ijNHam1RUA55arFOMIqi4oDJNhLZFMQtTTL8I//5vA==
X-Google-Smtp-Source: ABdhPJwWy7UsYM2fkX9Oa6LZWEgdFci76Uc/5eUdtn/u6UV+lN6scl+RDfAy6+X+TdTHukpJq28oSeuUz4HCSq17XPY=
X-Received: by 2002:aa7:980a:0:b0:43e:670:8505 with SMTP id
 e10-20020aa7980a000000b0043e06708505mr3569717pfl.74.1632996583959; Thu, 30
 Sep 2021 03:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210805140231.268273-1-thomas.perrot@bootlin.com>
 <f358044a-78d0-ad63-a777-87b4b9d94745@aleksander.es> <73A52D61-FCAB-4A2B-BA96-0117F6942842@linaro.org>
 <CAAP7ucL1Zv6g8G0SWAjEAjr6OSVTyDmvmFkH+vMmmBwOH2=ZUQ@mail.gmail.com> <54c063613fe63282a1c26b312c772e89b662eae6.camel@bootlin.com>
In-Reply-To: <54c063613fe63282a1c26b312c772e89b662eae6.camel@bootlin.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 30 Sep 2021 12:19:48 +0200
Message-ID: <CAMZdPi9AJcdVC2AS08ZtHU6sv1CMLhudgJHVpQF2zLfF+OV=Og@mail.gmail.com>
Subject: Re: [PATCH] bus: mhi: pci_generic: increase timeout value for
 operations to 24000ms
To:     Thomas Perrot <thomas.perrot@bootlin.com>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Sept 2021 at 10:08, Thomas Perrot <thomas.perrot@bootlin.com> wrote:
>
> Hello,
>
> On Wed, 2021-09-29 at 15:17 +0200, Aleksander Morgado wrote:
> > Hey Mani,
> >
> > > > > diff --git a/drivers/bus/mhi/pci_generic.c
> > > > > b/drivers/bus/mhi/pci_generic.c
> > > > > index 4dd1077354af..e08ed6e5031b 100644
> > > > > --- a/drivers/bus/mhi/pci_generic.c
> > > > > +++ b/drivers/bus/mhi/pci_generic.c
> > > > > @@ -248,7 +248,7 @@ static struct mhi_event_config
> > > > > modem_qcom_v1_mhi_events[] = {
> > > > >
> > > > >   static const struct mhi_controller_config
> > > > > modem_qcom_v1_mhiv_config = {
> > > > >      .max_channels = 128,
> > > > > -    .timeout_ms = 8000,
> > > > > +    .timeout_ms = 24000,
> > > >
> > > >
> > > > This modem_qcom_v1_mhiv_config config applies to all generic SDX24,
> > > > SDX55 and SDX65 modules.
> > > > Other vendor-branded SDX55 based modules in this same file (Foxconn
> > > > SDX55, MV31), have 20000ms as timeout.
> > > > Other vendor-branded SDX24 based modules in this same file (Quectel
> > > > EM12xx), have also 20000ms as timeout.
> > > > Maybe it makes sense to have a common timeout for all?
> > > >
> > >
> > > Eventhough the baseport coming from Qualcomm for the modem chipsets
> > > are same, it is possible that the vendors might have customized the
> > > firmware for their own usecase. That could be the cause of the delay
> > > for modem booting.
> > >
> > > So I don't think we should use the same timeout of 2400ms for all
> > > modems.
> > >
> >
> > Please note it's 24000ms what's being suggested here, not 2400ms.
> >
> > > > Thomas, is the 24000ms value taken from experimentation, or is it a
> > > > safe enough value? Maybe 20000ms as in other modules would have
> > > > been enough?
> > > >
>
> I made experimentation on a Sierra EM9190 (SDX55) engineering sample,
> using a old development firmware.
>
> So, I agree that setting the same timeout of 24000ms for all modems, is
> not necessarily relevant.
> However, the current default value seems too low, in view of timeouts
> used on vendor-branded, then using a higher value seems relevant.

I agree, let's set a conservative high value for generic SDX55, so
have wider support, that can be tuned per vendor IDs if necessary
anyway.

Regards,
Loic

>
> Moreover, Sierra EM919x modems use a custom controller configuration,
> we are currently working on it. As our tests not being sufficiently
> conclusive, so we have not yet submitted.
>
> Best regards,
> Thomas
>
> > >
> > > It was derived from testing I believe.
> >
> > Following your reasoning above, shouldn't this 24000ms timeout be
> > applied only to the Sierra Wireless EM91xx devices (which may have
> > custom firmware bits delaying the initialization a bit longer), and
> > not to the generic SDX24, SDX55 and SDX65?
> >
> > If I'm not mistaken, Thomas is testing with a custom mhi_pci_generic
> > entry for the EM91xx; as in
> > https://forum.sierrawireless.com/t/sierra-wireless-airprime-em919x-pcie-support/24927
> > .
> > I'm also playing with that same entry on my own setup, but have other
> > problems of my own :)
> >
> >
> > --
> > Aleksander
> > https://aleksander.es
>
> --
> Thomas Perrot, Bootlin
> Embedded Linux and kernel engineering
> https://bootlin.com
>
