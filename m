Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D751476A2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAXBWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:22:47 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41213 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAXBWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 20:22:46 -0500
Received: by mail-qt1-f193.google.com with SMTP id k40so329198qtk.8;
        Thu, 23 Jan 2020 17:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=phGwo+pDXf6bF+gF8aK5SXhe6NHtsdTb5Ox/q8isBRk=;
        b=ldMSr6BrgSIK0aY1BELR8h72NuIAXhgOVdDnjW8N7nx/HKdDhfOLZr3NLQy6yQ3yIi
         YWiAnx5adD1yMX2mlaqBGRLCX8Cec4O2/h+whOq90/e4Nm98MlfGtuWRtIfJzex80527
         5lkmtfLK+whfgwlnuGZJdPajF59rIS4SRcX4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=phGwo+pDXf6bF+gF8aK5SXhe6NHtsdTb5Ox/q8isBRk=;
        b=Y9UYXGR0xEK0bz0lo0KBhC78qpo80+jonkVnNJmLo+rn9Y40332Z6oNI5veAoxy2uo
         Td2OnuYhdV5waYSkcRGdUqw/NzR85B9V1BRFKXEmRye0ZH9pVGTvcK7KuAnBTocP+9m4
         P1lZRzp0R9JxSL2Eb+UDevczZR9XGKH59ynU179hoOXXsVpzGJ8hyf1YmXyCQzQI1SxX
         /RYX3X5B+MHKj1Jj+oO/lueCzNcsti//G+19fnuCZLsja/XYw175riiyPlMHbcGh0F0T
         qgCLUUL0DA2YaNpoodthlycrck6vXaXZQmFS96HCHVu90zA8MIgArUgRc0dzm4bv15Hv
         BUHw==
X-Gm-Message-State: APjAAAVjCCDPTH5lIXcWUj2T4P90wUce0GyWznUQjWUgcFdcxQG6fhQK
        b+kFprXEm8USmJAXbPn5lbKbr0Ob2q8HVanyDiM=
X-Google-Smtp-Source: APXvYqxgfz4Zw0PQe3tGHa9Wg4sjEbGekFBUPqOcMg5JxkIQChmOWlM1gWfBxIkoJXDoObnt764EEJ+L6PXnaUm63tA=
X-Received: by 2002:ac8:1ac1:: with SMTP id h1mr1008470qtk.255.1579828965827;
 Thu, 23 Jan 2020 17:22:45 -0800 (PST)
MIME-Version: 1.0
References: <20200124011808.18801-1-sashal@kernel.org>
In-Reply-To: <20200124011808.18801-1-sashal@kernel.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Fri, 24 Jan 2020 01:22:33 +0000
Message-ID: <CACPK8XdNmF0GN_PkXttSmvAVSqUh7FtDzYOD-=LFeL-0=NHOkA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 1/2] ARM: config: aspeed-g5: Enable 8250_DW quirks
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

On Fri, 24 Jan 2020 at 01:18, Sasha Levin <sashal@kernel.org> wrote:
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
> index 4f366b0370e93..3fb6bcba79942 100644
> --- a/arch/arm/configs/aspeed_g5_defconfig
> +++ b/arch/arm/configs/aspeed_g5_defconfig
> @@ -53,6 +53,7 @@ CONFIG_SERIAL_8250_NR_UARTS=3D6
>  CONFIG_SERIAL_8250_RUNTIME_UARTS=3D6
>  CONFIG_SERIAL_8250_EXTENDED=3Dy
>  CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
> +CONFIG_SERIAL_8250_DW=3Dy
>  CONFIG_SERIAL_OF_PLATFORM=3Dy
>  # CONFIG_HW_RANDOM is not set
>  # CONFIG_USB_SUPPORT is not set
> --
> 2.20.1
>
