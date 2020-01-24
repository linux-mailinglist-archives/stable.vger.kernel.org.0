Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8871514769C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgAXBVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:21:54 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46024 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbgAXBVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 20:21:54 -0500
Received: by mail-qk1-f195.google.com with SMTP id x1so498595qkl.12;
        Thu, 23 Jan 2020 17:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=17LlDvr3P+aPnbiTd/Xv0AEpyX3plN5wLIAiiiLM3JM=;
        b=T9dkl4o2yEUKj+mpTrje5F4r+Sy39rUUnsVelGI8H1iTPAY9q6tnTk2rdnu78ranin
         99U0gCXbQ0OQCO7ibpHdBQz5Lw/mACQcGZDkkH7VDcUUYiR1rmPWJNCcorE5kEOsIyuF
         +HWUw6W8WnOVeB5jH81Wh5l37Sh4JwGP9V1JI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=17LlDvr3P+aPnbiTd/Xv0AEpyX3plN5wLIAiiiLM3JM=;
        b=akU+C7mBcc5+ter5WfeUy+xN0D4WEBDkrJljnfGYxmip0g2ruy3umkoc+We320cPrp
         XD8GsuQwJfX7sCXBXIiyrYilEUwVfiGF4taVcvgXI60hvhAXErOdWjyJIRCUag5lEbBq
         QmzekYemCPLNSk0KV03oUD2Cd0nnODDj/nZiQXeStwJCXcVFnb4wFziU7zkDlu6tLK5t
         iyCsl/LcYr7qf3AHe6nbfPgaj0Qsgvo1wOcfxiZTRebmSa1deXCLKiXOWE6Eb8V7JPSY
         LmfYR0rj49EQdc4NSv1qqrkpuCpZU3dYEZCBD/vH55dfrkvlfg4r0AtOLe7EgmsHbZyu
         oLqw==
X-Gm-Message-State: APjAAAVuSUsxHknsOyWfziVgRfAolI4Ihw8Bnb0pRPFdCr4dgMa9zj0s
        Wi9jp4jV5CS+f1sBFlfOUpWQ8WpjOP7Exm7W8p4=
X-Google-Smtp-Source: APXvYqyNwDovBIOpVeX3aeLO2sskA0EZZmPzVBRqgbojfXQFpYEHw2wY9F00g8420CfluzcZbzVJOCQFPD7svOkBKtQ=
X-Received: by 2002:a37:9dc8:: with SMTP id g191mr322080qke.171.1579828913107;
 Thu, 23 Jan 2020 17:21:53 -0800 (PST)
MIME-Version: 1.0
References: <20200124011747.18575-1-sashal@kernel.org> <20200124011747.18575-5-sashal@kernel.org>
In-Reply-To: <20200124011747.18575-5-sashal@kernel.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Fri, 24 Jan 2020 01:21:40 +0000
Message-ID: <CACPK8XeGLW6cm9UV7gqrOF18BzsRBppzLQLY6G=Y2MDj2Yrnhw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 05/11] ARM: config: aspeed-g5: Enable 8250_DW quirks
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI Sasha,

On Fri, 24 Jan 2020 at 01:17, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Joel Stanley <joel@jms.id.au>
>
> [ Upstream commit a5331a7a87ec81d5228b7421acf831b2d0c0de26 ]
>
> This driver option is used by the AST2600 A0 boards to work around a
> hardware issue.

This hardware was only supported from 5.4+, so I think we can drop this pat=
ch.

Cheers,

Joel

>
> Reviewed-by: C=C3=A9dric Le Goater <clg@kaod.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/configs/aspeed_g5_defconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspe=
ed_g5_defconfig
> index 02fa3a41add5c..247be6c23d2c6 100644
> --- a/arch/arm/configs/aspeed_g5_defconfig
> +++ b/arch/arm/configs/aspeed_g5_defconfig
> @@ -138,6 +138,7 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=3D6
>  CONFIG_SERIAL_8250_EXTENDED=3Dy
>  CONFIG_SERIAL_8250_ASPEED_VUART=3Dy
>  CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
> +CONFIG_SERIAL_8250_DW=3Dy
>  CONFIG_SERIAL_OF_PLATFORM=3Dy
>  CONFIG_ASPEED_KCS_IPMI_BMC=3Dy
>  CONFIG_ASPEED_BT_IPMI_BMC=3Dy
> --
> 2.20.1
>
