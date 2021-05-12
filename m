Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A05237BE27
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhELNYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 09:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhELNYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 09:24:55 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CDDC061574;
        Wed, 12 May 2021 06:23:46 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id g4so4282994lfv.6;
        Wed, 12 May 2021 06:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UuBV4uLIY16BB/CHxGODGGp61xNMvkfPENTuvxVTdkk=;
        b=uiGxSqNxJJrpz7GTmlRq/NbSzwB4uH8Tjq3PRLWWVDe3BSpItIug9xDR8EF/klRzJn
         2z1zWF3wtGPPj4yuuW3HKrZxZTrkCP7Q0Q3Nfv4zP57TokTtSZ9kQNuCO9hbujFdVxRG
         4WcjEzOd4OnyAqdEt0oOgrsSIYgnLxvYPWFnKHZqByG3hFBTft11zmXM968zjo20eA2D
         PpFqxDRfjHflUBDp4Izq1saKGIL8qIqO1hF+HPESfgW2GVD1zb21we/JbWHI3uuOr/ai
         ICgOjTnatMWMiJ8ywModPPxP6ItlHX+lzpPLe7+KuIQs/tEW9QNGB4rleRlOz8cEAIoL
         i+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UuBV4uLIY16BB/CHxGODGGp61xNMvkfPENTuvxVTdkk=;
        b=bI2KrgjVGoVaafoHnj7Ax+FYzAYLRnNCDolB9D6Lu8WyKrZcxWOq0Fxol28TXsSsBX
         IzMktviGsO1PWjLERfUFyF9WRGa9BUhS83oyGC6G3LRSJMGqWICu6uKInIqzyOt7C28o
         s+YLNuCwjpReVbEHJeXVQo/5Ov/WjXqYwF8zffEXOAWWuZ6b+frL4ajBZ4zNYhLeb82p
         ikjWk97oeUmlHRDJZ+W49YVvJkEpP6tN/dp3uBo/TV35UbgYDmpl3nl9Ta44YZuo/b1S
         a2SH66DjqvGzw+S9XeRfpRyf8XYFxVSBMSp0hddGOpWslNBTTKauUQb4N1EMiizoINDq
         oP6w==
X-Gm-Message-State: AOAM530B7Jq20YUF8Q1fVl31s6Ee136NjPxbgyX0jiHThSS+nklgt/WF
        fnKCstLMCtca3LjCtVYWYmz9k5KZAgVlcVTsDKFCHeBN04d09A==
X-Google-Smtp-Source: ABdhPJycsjPGP9WIn9DGLod8wKr7WNsNDyvK7h5mzvO1LEViGaHIcVNFcktqMD0gjNXFc9Rb2Ujg0FYpNVhBtUB1VrE=
X-Received: by 2002:a05:6512:1031:: with SMTP id r17mr24823516lfr.583.1620825824792;
 Wed, 12 May 2021 06:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <1620813392-30933-1-git-send-email-michal.vokac@ysoft.com>
In-Reply-To: <1620813392-30933-1-git-send-email-michal.vokac@ysoft.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 12 May 2021 10:23:33 -0300
Message-ID: <CAOMZO5DH3FLXbX5RTRY_gM3uJ8MY=q6ovSOh5L3vD03YGPgDYA@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: dts: imx6dl-yapp4: Fix RGMII connection to
 QCA8334 switch
To:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 6:56 AM Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.=
com> wrote:
>
> The FEC does not have a PHY so it should not have a phy-handle. It is
> connected to the switch at RGMII level so we need a fixed-link sub-node
> on both ends.
>
> This was not a problem until the qca8k.c driver was converted to PHYLINK
> by commit b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of
> PHYLIB"). That commit revealed the FEC configuration was not correct.
>
> Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Urs=
a boards")
> Cc: stable@vger.kernel.org
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
