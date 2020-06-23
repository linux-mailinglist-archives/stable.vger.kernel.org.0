Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83567205B78
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 21:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733291AbgFWTKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 15:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733273AbgFWTKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 15:10:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60147C061573;
        Tue, 23 Jun 2020 12:10:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s9so4473385ljm.11;
        Tue, 23 Jun 2020 12:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHQMA4UMIloAnkWnBe4zD/F3dI97qrJrNziC5PnX2g0=;
        b=IbI6c2kEofavva6TOZDrMhgWUH2XEThq7tbgwyc7v9vi4A8C7HZTveNFs1qkIDK65W
         fhFFL6pbXEV3yIKsDJzrKIeNgCeFfgUv4kcjTsnfOoqvELxfTHm3kReFYH8X0AhWOqXq
         vqOP0OjgHGwvEtRTtbZKEYb19j4JTUgBChXEHbHqW5PHOo6WohYo9xKz4cCtgnSjBHJo
         X7uSdaI87B8Dk7bUF3SGyy/AbWEGFA7nvJ1U6YFprtNu14xA+woyEUT0dRi8qznXkpjG
         jZno2JJzq2w+lRT0hqlTid6IKG/aZ5GoaGsNClri5axFwK+8xZ/FzYeuaDrSDDS9Dnyr
         8wqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHQMA4UMIloAnkWnBe4zD/F3dI97qrJrNziC5PnX2g0=;
        b=TF/JEek1FEdd5NT6FdbxqZebC7XB1sdJb5natu/u3+WZzPh546kJhLUO0B7zGGZFSW
         PlihNjkkBW+9JOpDUvhofCngPwBqFo04IDcKGkHhiaRggmy9gOKRMloC4kHl3bVQntWA
         q09rjBN2wwjnIhyCDpmp0G3mSZyIv5pECGjreq8aBLTkMQlyKZX7f6T+DYEWd36GwcCv
         BioIRLvHbPzfrPnY02kxn3ICpxzwdjogPO3ZqKuMdwSxugaxIIQyrMzfxjTddOiI20uq
         PhrC21n5iTYRBjgzfKzRgvD+FkluN/Vl+bI94ht2H8CI87fLBJqeT72rkODK+tNj0B4Z
         Edzw==
X-Gm-Message-State: AOAM531UTBsj6QKovAlm6X9TIts957BdVrVXjeDJ8oyq+DgHYlRD29t3
        /BW2gImhdDeSL7A+rN6bgwSIK5CImD75uwXt7nM=
X-Google-Smtp-Source: ABdhPJwHhGkjJFBEPVdJgcvEqW+deafijsmk2UkonQ5shGuWfJwZI2ZPPhkNKshZpF9anGEQE95M9C8PJfns10JcSj4=
X-Received: by 2002:a2e:800c:: with SMTP id j12mr11123439ljg.218.1592939422627;
 Tue, 23 Jun 2020 12:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <1592937087-8885-1-git-send-email-tharvey@gateworks.com> <1592939214-13637-1-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1592939214-13637-1-git-send-email-tharvey@gateworks.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 23 Jun 2020 16:10:10 -0300
Message-ID: <CAOMZO5Bh92_qpS8VjaYxiHs6rcYBLrgnwJX8ftHshMQgm70-dg@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: dts: imx6qdl-gw551x: fix audio SSI
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

On Tue, Jun 23, 2020 at 4:07 PM Tim Harvey <tharvey@gateworks.com> wrote:
>
> The audio codec on the GW551x routes to ssi1
>
> Cc: stable@vger.kernel.org
> Fixes: 3117e851cef1 ("ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x")
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
