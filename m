Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B712727F
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 01:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLTAdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 19:33:42 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44808 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfLTAdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 19:33:42 -0500
Received: by mail-ot1-f68.google.com with SMTP id h9so6931729otj.11
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 16:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nigauri-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J/H/mTjA3sQ1iOfBfppKp5HMvTlpRkG5DtVATYOXb5A=;
        b=DBASogu2Ym9iK05Kjr3e6WMHITpDpePmfHOpvegCi5BEqn6mJWSsoCGDbziNkmnXhC
         XtRDzZspc2Rit43S/8M0XJARo4AHN0GZ5f3rlUO7mt3eZ+o4BzeY9AinGncpvxMuNAGS
         WxU0Bgmn2wz7oUf5RTbdcasyDo0SREY/DK6jiNJtD6nM/o7BPyXV5/yvDvkXeEXdlZYv
         cCCY3SYr0+tb151jFZZ3MG7NYEPbRwA172mx07glzVll/sa6oolu89SZu5rQVSGFpAb4
         b/+7/kHlJS+JQjx79NuuwmmDznr3Q192TLo4SC4dOgPPjgsu64OJ6zqEwMZaFrATILzf
         D7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J/H/mTjA3sQ1iOfBfppKp5HMvTlpRkG5DtVATYOXb5A=;
        b=gyKp/irZQFIQY/qFt37B6G0ggxcD0NqUrnhjIzWguLQX/36zTLsngK19ViZhEI/fZd
         5ovgCSTRfTDncIM7bwqFI3b4QtoJPwJZQiDO8CWeL4W6DS0iPFAz690B6hOj2Rnh3JWo
         2eNGe33ygf/R6eOqL4f7GG5IlvtfKwt12vXLAlo9NDB4GOAsw/PIf14J2XeYXwRO3DbZ
         lxBvrVwvwpcIj89CChhdKS74kXZRy2zCtCdh9Rj5Y+FhQUWAfGkHhvM0S/PbGUoN7URk
         7kL03S2uVbAIr5riX/yb0qQWrRosaeup8fnwZGRV09A5Gnx8j59kJ83ZG3pQt9PFf4tr
         gFCg==
X-Gm-Message-State: APjAAAUJZZzJPHBIN8ulsdSC0VogtkzzrQ9BygSryNAibbgnGAJ9CRVu
        dDLduri+bsY00HXeZcsa3rqdd3RtsyuB2uQ8LEab
X-Google-Smtp-Source: APXvYqyI0sanJXYNa+PROXXcdSjYGyaP7oHkehTfzlVwqRdUSx7lQaFcW/aD7zajc7mmGeNgHjT5CbCipkaSwaDPTS0=
X-Received: by 2002:a9d:7519:: with SMTP id r25mr3230812otk.284.1576802021009;
 Thu, 19 Dec 2019 16:33:41 -0800 (PST)
MIME-Version: 1.0
References: <1576746207205192@kroah.com>
In-Reply-To: <1576746207205192@kroah.com>
From:   Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date:   Fri, 20 Dec 2019 09:33:15 +0900
Message-ID: <CABMQnVJfKnu35B4K3OF2JGnDgykbaFM+Ym93Yr-RuskJ4M=KyA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] PCI: rcar: Fix missing MACCTLR register
 setting in" failed to apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        erosca@de.adit-jv.com, geert+renesas@glider.be,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

2019=E5=B9=B412=E6=9C=8819=E6=97=A5(=E6=9C=A8) 18:03 <gregkh@linuxfoundatio=
n.org>:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h

This is already applied to 4.19.y tree.
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit=
/?h=3Dlinux-4.19.y&id=3D2de11b2e5dd2dce4f0f44101bb7aadb49e13de41

Best regards,
  Nobuhiro

>
> ------------------ original commit in Linus's tree ------------------
>
> From 7c7e53e1c93df14690bd12c1f84730fef927a6f1 Mon Sep 17 00:00:00 2001
> From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Date: Tue, 5 Nov 2019 19:51:29 +0900
> Subject: [PATCH] PCI: rcar: Fix missing MACCTLR register setting in
>  initialization sequence
>
> The R-Car Gen2/3 manual - available at:
>
> https://www.renesas.com/eu/en/products/microcontrollers-microprocessors/r=
z/rzg/rzg1m.html#documents
>
> "RZ/G Series User's Manual: Hardware" section
>
> strictly enforces the MACCTLR inizialization value - 39.3.1 - "Initial
> Setting of PCI Express":
>
> "Be sure to write the initial value (=3D H'80FF 0000) to MACCTLR before
> enabling PCIETCTLR.CFINIT".
>
> To avoid unexpected behavior and to match the SW initialization sequence
> guidelines, this patch programs the MACCTLR with the correct value.
>
> Note that the MACCTLR.SPCHG bit in the MACCTLR register description
> reports that "Only writing 1 is valid and writing 0 is invalid" but this
> "invalid" has to be interpreted as a write-ignore aka "ignored", not
> "prohibited".
>
> Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in r=
esume_noirq()")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: <stable@vger.kernel.org> # v5.2+
>
> diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/=
pcie-rcar.c
> index 40d8c54a17d1..94ba4fe21923 100644
> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -91,8 +91,11 @@
>  #define  LINK_SPEED_2_5GTS     (1 << 16)
>  #define  LINK_SPEED_5_0GTS     (2 << 16)
>  #define MACCTLR                        0x011058
> +#define  MACCTLR_NFTS_MASK     GENMASK(23, 16) /* The name is from SH778=
6 */
>  #define  SPEED_CHANGE          BIT(24)
>  #define  SCRAMBLE_DISABLE      BIT(27)
> +#define  LTSMDIS               BIT(31)
> +#define  MACCTLR_INIT_VAL      (LTSMDIS | MACCTLR_NFTS_MASK)
>  #define PMSR                   0x01105c
>  #define MACS2R                 0x011078
>  #define MACCGSPSETR            0x011084
> @@ -613,6 +616,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
>         if (IS_ENABLED(CONFIG_PCI_MSI))
>                 rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
>
> +       rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
> +
>         /* Finish initialization - establish a PCI Express link */
>         rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>
> @@ -1235,6 +1240,7 @@ static int rcar_pcie_resume_noirq(struct device *de=
v)
>                 return 0;
>
>         /* Re-establish the PCIe link */
> +       rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
>         rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>         return rcar_pcie_wait_for_dl(pcie);
>  }
>


--=20
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6
