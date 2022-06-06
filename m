Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8E53E697
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbiFFQQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 12:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241442AbiFFQQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 12:16:51 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BC4194BEC;
        Mon,  6 Jun 2022 09:16:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id h23so18843696ejj.12;
        Mon, 06 Jun 2022 09:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Tk+N75tJTI9hi8uqQs5f8Gf5UITpmFcXsge4oITgtY=;
        b=WZ9q5Yynon/OxkUjbDytKQS/aaGa7C6tLJzyYpcUeXIjiLZFG+LyCU8tCfzwhcGNJ+
         T5opZTpuTOcgeEb+/Y8CX2CJDujwZbWB3bwcvvQkz2NrHV8zDe//JGMeIxSXkeANYGzd
         qq6FNSP/9Okz3SD0Nc32VXNtVuRakknTGy3K1r90779dH4dGJOdluDjHLA+CkxnM/vpz
         yPtV/lgnq645+hh7ejU7zOFCanCzqizRab6L0LyHzVVmuwjBkVPgousIC3qfxWUE6AZs
         jdTzqiA2T5HHYMa5+iXnKuHRx1sDaS/7Pccvpw35lzd3HW0wFN4j7Kf9C+qfYWMLQaat
         quDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Tk+N75tJTI9hi8uqQs5f8Gf5UITpmFcXsge4oITgtY=;
        b=VBjnklfhbpsIzNacA2iCoFkCk0oS1KuBJEEdRWuO3I+yz9z0N9bln2iR7bzx6Lk0W2
         gQ/ols5ZESseWVOArIJrgVmr7tzY8jmdeddsF/af4V+MER7r7ZjV1manECdEmGje49El
         R7YU4iPwVu9twyI4cQumJwtZEs1vR8ayKDZ8nlmSUHZnqzuXc0x5JYqCWaTUaN2lFV1s
         EFgZGzB06VRosuMpp49moGTO9jx4lEI0Sk6/poyuJIWy9fK+j8ce4YVy0zLg6VhMsRfI
         c6pkv7MFKgB1KlNLlR+oeCqB1sDvqPNUK1swWsJjIu6c9pULqL7WHsDXbfBB35+RGS8q
         /wGw==
X-Gm-Message-State: AOAM531OgDZtin8wNe+BAZDNCQm8ZbeSGuK76PSeAMA1KefdRM59htb7
        ymSpbrpso3RGoQPGQnylraaY1ySDXVD8tTevhTA=
X-Google-Smtp-Source: ABdhPJy49qSaivBNWiVFdGFFktt149nyneP9NO7NehgaIrw85A3oecc50WzlR/J8gZ0wgimt3lGOkpQdZfp6h89Mtio=
X-Received: by 2002:a17:907:2d8d:b0:711:d1bd:d738 with SMTP id
 gt13-20020a1709072d8d00b00711d1bdd738mr4474784ejc.658.1654532207455; Mon, 06
 Jun 2022 09:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220606161034.3544803-1-pbrobinson@gmail.com>
In-Reply-To: <20220606161034.3544803-1-pbrobinson@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 6 Jun 2022 13:16:38 -0300
Message-ID: <CAOMZO5DYpWGYuDF_04NBRwO093McDy9oOjQdy24K4TKjBNQ6Hw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: imx-sdma: Allow imx8m for imx7 FW revs
To:     Peter Robinson <pbrobinson@gmail.com>
Cc:     Vinod Koul <vkoul@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        dmaengine@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
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

On Mon, Jun 6, 2022 at 1:10 PM Peter Robinson <pbrobinson@gmail.com> wrote:
>
> The revision of the imx-sdma IP that is in the i.MX8M series is the
> same is that as that in the i.MX7 series but the imx7d MODULE_FIRMWARE
> directive is wrapped in a condiditional which means it's not defined
> when built for aarch64 SOC_IMX8M platforms and hence you get the
> following errors when the driver loads on imx8m devices:
>
> imx-sdma 302c0000.dma-controller: Direct firmware load for imx/sdma/sdma-imx7d.bin failed with error -2
> imx-sdma 302c0000.dma-controller: external firmware not found, using ROM firmware
>
> Add the SOC_IMX8M into the check so the firmware can load on i.MX8.
>
> Fixes: 1474d48bd639 ("arm64: dts: imx8mq: Add SDMA nodes")
> Fixes: 941acd566b18 ("dmaengine: imx-sdma: Only check ratio on parts that support 1:1")
> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> Cc: stable@vger.kernel.org   # v5.2+

Reviewed-by: Fabio Estevam <festevam@gmail.com>
