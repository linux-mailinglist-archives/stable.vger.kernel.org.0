Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067576B9A3E
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 16:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCNPrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 11:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjCNPrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 11:47:35 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B30CB3702;
        Tue, 14 Mar 2023 08:47:03 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso8638229oti.8;
        Tue, 14 Mar 2023 08:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678808794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wkL7da/Rc4tgZfDJba08p3nQBvevz/W1pJs6r+8hiM=;
        b=l1TKIKKkpRKwKxb/IFWMOKMfFCaiu0JzS+cCKpgDub+29WiowdhrYfMyKMGSgePP8T
         VtV4SOfbn6MFnypcKwrLV87JX3ko2E2cLNJRJcMIIQuxJnAs6yot0sPXzw+y14Bn14tD
         eln42spk6lykzoXPqncoI9/qODgeps8iynPmjm7LfQFceYNUgAW3fb2M7ALrymotnYHE
         F6OzAy95qWNMhAYGnsRzzIVVxoJ0Dvi40LsN8SaK0jtAme9h47mcuXcIEG5QeO6LjF3Q
         CXISEAsbXWP7V5SPW0Of6ENgBUx0PczcwJXvh+/XQF5uLMeFtmqZLtCOvYmC/MAlKld9
         8CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wkL7da/Rc4tgZfDJba08p3nQBvevz/W1pJs6r+8hiM=;
        b=UYbRaJAqaGlnw+yq+Bmnydet99Mkf7PBGocaw43t+w0Pg1A4xIDvg2D8EGxR/XunTG
         RkawEMRmmmAwGrh/PVZHxd8AYA2Uc1clVwWZ9KAGjjjlsPrMAWvy8v8Y6yP5YU96D6kr
         Uc9KuCINYtYFsZZIDnG1baaJ1ojoeT5n4zPMXXTh9k1hqYcfwDRzk1RDzSmKD+yr7cUF
         bEZrRe6OeLa9j6P0uteV415nJs4zxdyyd6b7oq+CD0Mw6/NA0ahtFZbZx4wRObYzqtkq
         +fAjp5imD/MO+xlxXEEnM4LsbSDtwI+AeAPwWI5NaHqfUVN8cg4QBpPdl2xbvZ1cleXB
         UXUA==
X-Gm-Message-State: AO0yUKXydhteLucnMlWLUieHzyBTyugc1UAa0fhv7F7T4TPBmHz85Kkd
        yaH+6kz8uTiDqBzFaEQKPF9EqHT3wXKMsq3fMHU=
X-Google-Smtp-Source: AK7set//Z2qMLoNwWnbRcQ8l+8WelU3TiH20TsphZ7N50Gfa09Xj34+xbWP1VnWe3BCEG+e271UZKcGXir1lYpLxCZk=
X-Received: by 2002:a9d:5a90:0:b0:688:cf52:6e18 with SMTP id
 w16-20020a9d5a90000000b00688cf526e18mr12756257oth.4.1678808792329; Tue, 14
 Mar 2023 08:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-9-rick.wertenbroek@gmail.com> <0fa5cef4-7096-7f59-422a-98011d01437c@opensource.wdc.com>
In-Reply-To: <0fa5cef4-7096-7f59-422a-98011d01437c@opensource.wdc.com>
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
Date:   Tue, 14 Mar 2023 16:45:56 +0100
Message-ID: <CAAEEuhpiQDRy6EQwwf0e+e6MVv893YU6+Sbyz5k+Owp2vAi-nQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/9] PCI: rockchip: Use u32 variable to access 32-bit registers
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     alberto.dassatti@heig-vd.ch, xxm@rock-chips.com,
        rick.wertenbroek@heig-vd.ch, stable@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 2:34=E2=80=AFAM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 2/14/23 23:08, Rick Wertenbroek wrote:
> > Previously u16 variables were used to access 32-bit registers, this
> > resulted in not all of the data being read from the registers. Also
> > the left shift of more than 16-bits would result in moving data out
> > of the variable. Use u32 variables to access 32-bit registers
> >
> > Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe co=
ntroller")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
> > ---
> >  drivers/pci/controller/pcie-rockchip-ep.c | 10 +++++-----
> >  drivers/pci/controller/pcie-rockchip.h    |  1 +
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/co=
ntroller/pcie-rockchip-ep.c
> > index ca5b363ba..b7865a94e 100644
> > --- a/drivers/pci/controller/pcie-rockchip-ep.c
> > +++ b/drivers/pci/controller/pcie-rockchip-ep.c
> > @@ -292,15 +292,15 @@ static int rockchip_pcie_ep_set_msi(struct pci_ep=
c *epc, u8 fn, u8 vfn,
> >  {
> >       struct rockchip_pcie_ep *ep =3D epc_get_drvdata(epc);
> >       struct rockchip_pcie *rockchip =3D &ep->rockchip;
> > -     u16 flags;
> > +     u32 flags;
> >
> >       flags =3D rockchip_pcie_read(rockchip,
> >                                  ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
> >                                  ROCKCHIP_PCIE_EP_MSI_CTRL_REG);
> >       flags &=3D ~ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_MASK;
> >       flags |=3D
> > -        ((multi_msg_cap << 1) <<  ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET=
) |
> > -        PCI_MSI_FLAGS_64BIT;
> > +        (multi_msg_cap << ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET) |
>
> ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET is 17 and multi_msg_cap is a u8...
> Not nice.
>
> Locally, I added the local variable:
>
> u32 mmc =3D multi_msg_cap;
>
> And use mmc instead of multi_msg_cap to avoid issues. Also,
>
> > +        (PCI_MSI_FLAGS_64BIT << ROCKCHIP_PCIE_EP_MSI_FLAGS_OFFSET);
> >       flags &=3D ~ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP;
> >       rockchip_pcie_write(rockchip, flags,
> >                           ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
> > @@ -312,7 +312,7 @@ static int rockchip_pcie_ep_get_msi(struct pci_epc =
*epc, u8 fn, u8 vfn)
> >  {
> >       struct rockchip_pcie_ep *ep =3D epc_get_drvdata(epc);
> >       struct rockchip_pcie *rockchip =3D &ep->rockchip;
> > -     u16 flags;
> > +     u32 flags;
> >
> >       flags =3D rockchip_pcie_read(rockchip,
> >                                  ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
> > @@ -374,7 +374,7 @@ static int rockchip_pcie_ep_send_msi_irq(struct roc=
kchip_pcie_ep *ep, u8 fn,
> >                                        u8 interrupt_num)
> >  {
> >       struct rockchip_pcie *rockchip =3D &ep->rockchip;
> > -     u16 flags, mme, data, data_mask;
> > +     u32 flags, mme, data, data_mask;
> >       u8 msi_count;
> >       u64 pci_addr, pci_addr_mask =3D 0xff;
> >       u32 r;
> > diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/contr=
oller/pcie-rockchip.h
> > index e90c2a2b8..11dbf53cd 100644
> > --- a/drivers/pci/controller/pcie-rockchip.h
> > +++ b/drivers/pci/controller/pcie-rockchip.h
> > @@ -227,6 +227,7 @@
> >  #define ROCKCHIP_PCIE_EP_CMD_STATUS                  0x4
> >  #define   ROCKCHIP_PCIE_EP_CMD_STATUS_IS             BIT(19)
> >  #define ROCKCHIP_PCIE_EP_MSI_CTRL_REG                        0x90
> > +#define   ROCKCHIP_PCIE_EP_MSI_FLAGS_OFFSET                  16
>
> You are not using this macro anywhere. The name is also not very
> descriptive. Better have it as:
>
> #define   ROCKCHIP_PCIE_EP_MSI_CTRL_ME          BIT(16)
>
> to match the TRM name and be clear that the bit indicates if MSI is
> enabled or not.
>

This is already the case, the #define is already there.
#define ROCKCHIP_PCIE_EP_MSI_CTRL_ME BIT(16)
The other offset is for all the MSI flags together, this offset is used
when the flags are retrieved altogether, see rockchip_pcie_ep_set_msi()
The ME bit is also used when we need to check the bit specifically, see
rockchip_pcie_ep_get_msi().

> >  #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET               17
> >  #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_MASK         GENMASK(19, 17)
> >  #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MME_OFFSET               20
>
> --
> Damien Le Moal
> Western Digital Research
>
