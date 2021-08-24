Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9473F69EB
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhHXTfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 15:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbhHXTfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 15:35:54 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E896EC061764
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:35:09 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id r4so43184842ybp.4
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXS7VP7AkViDruDTXAZRot09Ok43DQntHPmae+YHPMY=;
        b=u5meDRqKoVQI/Smrqh0VhvImdpYWFmvqhg3aMd2H6gDvdJ/gOpaeXSZi8GgqBJwwfn
         IVi4IDRhQa80mAr4laLytJvn5s5tC59chlNdz4e69tI6TNmMpM8f9yxXLsdUoMwo6FCE
         m5h1t1fLUJPI9uV9WaDlwbFNwC/ORDxYN68EQPEBeRT7AERK2Izo06GXoWAEZblyPpu5
         RjDwQCZ7e/niMw5mNVP59BhkUE2WhqWtNiHbZvDHXKaD763AKy3kdumY0ztIzD3ZKnuE
         zPaYicBxNewuELju8JSBNTRK3tqXyPK1ldheCPnJjDRYoalOZbFNNk1/4L/C+Y6JgInV
         E1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXS7VP7AkViDruDTXAZRot09Ok43DQntHPmae+YHPMY=;
        b=Jl8bJwmRQnDbefKhdKMk1K3lA5O4MarWpmM7yy2PybPOZp0T1HYTl171QrIP70v/dG
         mkc134fYLQgdWx3ZZug/cPOYFLx3rTQkJBreT2/lF3xgd2Jaeec3x9zfHFQDOKkPZqfc
         Kqkz5+vpwLmqxERG0y4mYWRoD6IS1XJBDFszTztD+dyORcJpzUxFd2tToIKyI8gpwxrU
         36h0TOMLYjOi5Kpzz94R7t7iJV54QlBTNkj1jqttx8SO5DDfrMskzHM//B+Sg5bozSvO
         VzzO4Mr5jPmo/hB1plOFiNmgYBJMhXSC+ucExkQt4CALqaeTJIcpfrcBfD9jKvu1feGt
         I46Q==
X-Gm-Message-State: AOAM530SDh0bhAKEPq5jMn5EKBe9mXjseXlfdJitzGkrA1FKDZd6sAHO
        IyblJhQaVAn7paxCVItyjC0u1NWXuptjxnTXHx94Yg==
X-Google-Smtp-Source: ABdhPJzRaloDZXC7PxhsHlzQAHKnhsSqU9nIbgHnNk9uw2oykTOqyF63IEGyqA8bkc7iRmt7jI/R+P9TTw71GHC4qHY=
X-Received: by 2002:a5b:50b:: with SMTP id o11mr26994008ybp.466.1629833709050;
 Tue, 24 Aug 2021 12:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210824165908.709932-1-sashal@kernel.org> <20210824165908.709932-65-sashal@kernel.org>
 <20210824190009.GA16752@duo.ucw.cz>
In-Reply-To: <20210824190009.GA16752@duo.ucw.cz>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 24 Aug 2021 12:34:33 -0700
Message-ID: <CAGETcx93J_gpTLhANbjfiBrZ=PCN4bUabfHGG-jv0KdfOUMyjg@mail.gmail.com>
Subject: Re: [PATCH 5.10 64/98] net: mdio-mux: Handle -EPROBE_DEFER correctly
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 12:00 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi1
>
> > When registering mdiobus children, if we get an -EPROBE_DEFER, we shouldn't
> > ignore it and continue registering the rest of the mdiobus children. This
> > would permanently prevent the deferring child mdiobus from working instead
> > of reattempting it in the future. So, if a child mdiobus needs to be
> > reattempted in the future, defer the entire mdio-mux initialization.
> >
> > This fixes the issue where PHYs sitting under the mdio-mux aren't
> > initialized correctly if the PHY's interrupt controller is not yet ready
> > when the mdio-mux is being probed. Additional context in the link
> > below.
>
> I don't believe this is quite right. AFAICT it leaks memory in the
> EPROBE_DEFER case. Could someone double-check? Suggested fix is below.

devm_ APIs would take care of releasing the resource (memory)
automatically because the probe didn't succeed. So I'm not sure
there's a leak. Does that make sense?

-Saravana

>
> > +++ b/drivers/net/mdio/mdio-mux.c
> > @@ -175,11 +175,15 @@ int mdio_mux_init(struct device *dev,
> >               cb->mii_bus->write = mdio_mux_write;
> >               r = of_mdiobus_register(cb->mii_bus, child_bus_node);
> >               if (r) {
> > +                     mdiobus_free(cb->mii_bus);
> > +                     if (r == -EPROBE_DEFER) {
> > +                             ret_val = r;
> > +                             goto err_loop;
> > +                     }
> > +                     devm_kfree(dev, cb);
> >                       dev_err(dev,
> >                               "Error: Failed to register MDIO bus for child %pOF\n",
> >                               child_bus_node);
> > -                     mdiobus_free(cb->mii_bus);
> > -                     devm_kfree(dev, cb);
> >               } else {
> >                       cb->next = pb->children;
> >                       pb->children = cb;
>
>
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
>
> diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
> index ccb3ee704eb1..6d0e505343c5 100644
> --- a/drivers/net/mdio/mdio-mux.c
> +++ b/drivers/net/mdio/mdio-mux.c
> @@ -163,6 +163,7 @@ int mdio_mux_init(struct device *dev,
>                 cb->mii_bus = mdiobus_alloc();
>                 if (!cb->mii_bus) {
>                         ret_val = -ENOMEM;
> +                       devm_kfree(dev, cb);
>                         goto err_loop;
>                 }
>                 cb->mii_bus->priv = cb;
> @@ -176,11 +177,11 @@ int mdio_mux_init(struct device *dev,
>                 r = of_mdiobus_register(cb->mii_bus, child_bus_node);
>                 if (r) {
>                         mdiobus_free(cb->mii_bus);
> +                       devm_kfree(dev, cb);
>                         if (r == -EPROBE_DEFER) {
>                                 ret_val = r;
>                                 goto err_loop;
>                         }
> -                       devm_kfree(dev, cb);
>                         dev_err(dev,
>                                 "Error: Failed to register MDIO bus for child %pOF\n",
>                                 child_bus_node);
>
>
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
