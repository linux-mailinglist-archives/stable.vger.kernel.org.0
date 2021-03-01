Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18F3328901
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbhCARsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbhCARmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:42:46 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925D3C061756;
        Mon,  1 Mar 2021 09:41:51 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e7so15423268ile.7;
        Mon, 01 Mar 2021 09:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YRu6T4YCSQTuJhSWDKrymzoDkoEYPpwNaxC0bwqR6X8=;
        b=k5QCiQEW6IU+Q0tM9RE5n6kSHfo0DgwlihhNRmzWoz43jroJz1yUl/QVs0q4Osf3Ek
         C0iIUvJQtfKEeA8GQAuTrFakWg78CA9yCApyIXp2We0ebOGgn5ULK99LfUBu51AtvUZ3
         H20t4z/tdRXolC5/gn90e1lE8I8xNsPuNXb/aak53DpQvELcP6HbqvLVgu5nXlpcivwb
         pIIjH8xf5KJLpn0BiI+FtIiy+/iIgcUnHYvFpNS8Aka29gM0wHrnfFS9AsskA5ZoAd4v
         WcjSBpUzx6SACOojgiGdbKjCmMumVxxVhsyxDEXoPVfpH6BbRcaDloTcJJoCtCLLmyLg
         UMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YRu6T4YCSQTuJhSWDKrymzoDkoEYPpwNaxC0bwqR6X8=;
        b=ZwbwqmctBFQBGi8NlJEK+jQOrDvl1Bo4k02fiQb9CBSBrTb8rybYzuCQMi/RS92hlv
         s8DP0QejS0VYHZLBDe3gOVy2JDY7meDx0a3pf+LPEmZzTGMCTN8TRZWTmgKTjk3WM3wU
         lUgU334u6lFiCdfPV7yJz1vrwwkWcEJ3xk1l0g1FBxcOkpFltfST7UCp2r5uOgNXrKdg
         gGgIV1gUcQwGfQ+zfHR9crFN9DxnyKnrT+oLcNKw0X0/gyhQWRZNfGQZCYmw6mHs6pHT
         kirxoI+mhMLhojsfmeuiLDYFNRfjyOQ/k3N9k4SFQgm6QavnKT6dkTzCxY66B3DMIj/A
         F8kQ==
X-Gm-Message-State: AOAM5300AvToSCbNDYlzwY7adgy0x//WWoPE1h3orJCk78hYUd3UHh3F
        M6TZXDJ5t73kLTe94ZF8Qvo7LmdH/mHVJA7ruLk=
X-Google-Smtp-Source: ABdhPJy5Xhs6rpWGKFPrnYmW7TFZ77dgsgoI86R53mpTQEudVyvmxRQwAS7TfA+F4jPNbikQYOexeOD7Ea47fu6yVk0=
X-Received: by 2002:a92:cb49:: with SMTP id f9mr13492557ilq.0.1614620510844;
 Mon, 01 Mar 2021 09:41:50 -0800 (PST)
MIME-Version: 1.0
References: <20210301161031.684018251@linuxfoundation.org> <20210301161041.907312533@linuxfoundation.org>
In-Reply-To: <20210301161041.907312533@linuxfoundation.org>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 1 Mar 2021 09:41:39 -0800
Message-ID: <CALCv0x36mPwPwFpB8P6nc4kfu_PB=U81RoY9=q31Osx4sGtC3g@mail.gmail.com>
Subject: Re: [PATCH 4.19 209/247] staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, I should have been more clear in my original email, but we
don't strictly need this in 4.19 as the check only became fatal in
5.10 (actually, before 5.10, but 5.10 is the first stable release with
it). Feel free to take or omit this from 4.19.

On Mon, Mar 1, 2021 at 8:45 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
>
> commit 1f92798cbe7fe923479cff754dd06dd23d352e36 upstream.
>
> Also use KBUILD_MODNAME for module name.
>
> This driver is only used by RALINK MIPS MT7621 SoCs. Tested by building
> against that target using OpenWrt with Linux 5.10.10.
>
> Fixes the following error:
> error: the following would cause module name conflict:
>   drivers/dma/mediatek/mtk-hsdma.ko
>   drivers/staging/mt7621-dma/mtk-hsdma.ko
>
> Cc: stable@vger.kernel.org
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Link: https://lore.kernel.org/r/20210130034507.2115280-1-ilya.lipnitskiy@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/mt7621-dma/Makefile       |    2
>  drivers/staging/mt7621-dma/hsdma-mt7621.c |  771 ++++++++++++++++++++++++++++++
>  drivers/staging/mt7621-dma/mtk-hsdma.c    |  771 ------------------------------
>  3 files changed, 772 insertions(+), 772 deletions(-)
>  rename drivers/staging/mt7621-dma/{mtk-hsdma.c => hsdma-mt7621.c} (99%)
>
> --- a/drivers/staging/mt7621-dma/Makefile
> +++ b/drivers/staging/mt7621-dma/Makefile
> @@ -1,4 +1,4 @@
>  obj-$(CONFIG_DMA_RALINK) += ralink-gdma.o
> -obj-$(CONFIG_MTK_HSDMA) += mtk-hsdma.o
> +obj-$(CONFIG_MTK_HSDMA) += hsdma-mt7621.o
>
>  ccflags-y += -I$(srctree)/drivers/dma
> --- /dev/null
> +++ b/drivers/staging/mt7621-dma/hsdma-mt7621.c
> @@ -0,0 +1,771 @@
> +/*
> + *  Copyright (C) 2015, Michael Lee <igvtee@gmail.com>
> + *  MTK HSDMA support
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under  the terms of the GNU General         Public License as published by the
> + *  Free Software Foundation;  either version 2 of the License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/irq.h>
> +#include <linux/of_dma.h>
> +#include <linux/reset.h>
> +#include <linux/of_device.h>
> +
> +#include "virt-dma.h"
> +
> +#define HSDMA_BASE_OFFSET              0x800
> +
> +#define HSDMA_REG_TX_BASE              0x00
> +#define HSDMA_REG_TX_CNT               0x04
> +#define HSDMA_REG_TX_CTX               0x08
> +#define HSDMA_REG_TX_DTX               0x0c
> +#define HSDMA_REG_RX_BASE              0x100
> +#define HSDMA_REG_RX_CNT               0x104
> +#define HSDMA_REG_RX_CRX               0x108
> +#define HSDMA_REG_RX_DRX               0x10c
> +#define HSDMA_REG_INFO                 0x200
> +#define HSDMA_REG_GLO_CFG              0x204
> +#define HSDMA_REG_RST_CFG              0x208
> +#define HSDMA_REG_DELAY_INT            0x20c
> +#define HSDMA_REG_FREEQ_THRES          0x210
> +#define HSDMA_REG_INT_STATUS           0x220
> +#define HSDMA_REG_INT_MASK             0x228
> +#define HSDMA_REG_SCH_Q01              0x280
> +#define HSDMA_REG_SCH_Q23              0x284
> +
> +#define HSDMA_DESCS_MAX                        0xfff
> +#define HSDMA_DESCS_NUM                        8
> +#define HSDMA_DESCS_MASK               (HSDMA_DESCS_NUM - 1)
> +#define HSDMA_NEXT_DESC(x)             (((x) + 1) & HSDMA_DESCS_MASK)
> +
> +/* HSDMA_REG_INFO */
> +#define HSDMA_INFO_INDEX_MASK          0xf
> +#define HSDMA_INFO_INDEX_SHIFT         24
> +#define HSDMA_INFO_BASE_MASK           0xff
> +#define HSDMA_INFO_BASE_SHIFT          16
> +#define HSDMA_INFO_RX_MASK             0xff
> +#define HSDMA_INFO_RX_SHIFT            8
> +#define HSDMA_INFO_TX_MASK             0xff
> +#define HSDMA_INFO_TX_SHIFT            0
> +
> +/* HSDMA_REG_GLO_CFG */
> +#define HSDMA_GLO_TX_2B_OFFSET         BIT(31)
> +#define HSDMA_GLO_CLK_GATE             BIT(30)
> +#define HSDMA_GLO_BYTE_SWAP            BIT(29)
> +#define HSDMA_GLO_MULTI_DMA            BIT(10)
> +#define HSDMA_GLO_TWO_BUF              BIT(9)
> +#define HSDMA_GLO_32B_DESC             BIT(8)
> +#define HSDMA_GLO_BIG_ENDIAN           BIT(7)
> +#define HSDMA_GLO_TX_DONE              BIT(6)
> +#define HSDMA_GLO_BT_MASK              0x3
> +#define HSDMA_GLO_BT_SHIFT             4
> +#define HSDMA_GLO_RX_BUSY              BIT(3)
> +#define HSDMA_GLO_RX_DMA               BIT(2)
> +#define HSDMA_GLO_TX_BUSY              BIT(1)
> +#define HSDMA_GLO_TX_DMA               BIT(0)
> +
> +#define HSDMA_BT_SIZE_16BYTES          (0 << HSDMA_GLO_BT_SHIFT)
> +#define HSDMA_BT_SIZE_32BYTES          (1 << HSDMA_GLO_BT_SHIFT)
> +#define HSDMA_BT_SIZE_64BYTES          (2 << HSDMA_GLO_BT_SHIFT)
> +#define HSDMA_BT_SIZE_128BYTES         (3 << HSDMA_GLO_BT_SHIFT)
> +
> +#define HSDMA_GLO_DEFAULT              (HSDMA_GLO_MULTI_DMA | \
> +               HSDMA_GLO_RX_DMA | HSDMA_GLO_TX_DMA | HSDMA_BT_SIZE_32BYTES)
> +
> +/* HSDMA_REG_RST_CFG */
> +#define HSDMA_RST_RX_SHIFT             16
> +#define HSDMA_RST_TX_SHIFT             0
> +
> +/* HSDMA_REG_DELAY_INT */
> +#define HSDMA_DELAY_INT_EN             BIT(15)
> +#define HSDMA_DELAY_PEND_OFFSET                8
> +#define HSDMA_DELAY_TIME_OFFSET                0
> +#define HSDMA_DELAY_TX_OFFSET          16
> +#define HSDMA_DELAY_RX_OFFSET          0
> +
> +#define HSDMA_DELAY_INIT(x)            (HSDMA_DELAY_INT_EN | \
> +               ((x) << HSDMA_DELAY_PEND_OFFSET))
> +#define HSDMA_DELAY(x)                 ((HSDMA_DELAY_INIT(x) << \
> +               HSDMA_DELAY_TX_OFFSET) | HSDMA_DELAY_INIT(x))
> +
> +/* HSDMA_REG_INT_STATUS */
> +#define HSDMA_INT_DELAY_RX_COH         BIT(31)
> +#define HSDMA_INT_DELAY_RX_INT         BIT(30)
> +#define HSDMA_INT_DELAY_TX_COH         BIT(29)
> +#define HSDMA_INT_DELAY_TX_INT         BIT(28)
> +#define HSDMA_INT_RX_MASK              0x3
> +#define HSDMA_INT_RX_SHIFT             16
> +#define HSDMA_INT_RX_Q0                        BIT(16)
> +#define HSDMA_INT_TX_MASK              0xf
> +#define HSDMA_INT_TX_SHIFT             0
> +#define HSDMA_INT_TX_Q0                        BIT(0)
> +
> +/* tx/rx dma desc flags */
> +#define HSDMA_PLEN_MASK                        0x3fff
> +#define HSDMA_DESC_DONE                        BIT(31)
> +#define HSDMA_DESC_LS0                 BIT(30)
> +#define HSDMA_DESC_PLEN0(_x)           (((_x) & HSDMA_PLEN_MASK) << 16)
> +#define HSDMA_DESC_TAG                 BIT(15)
> +#define HSDMA_DESC_LS1                 BIT(14)
> +#define HSDMA_DESC_PLEN1(_x)           ((_x) & HSDMA_PLEN_MASK)
> +
> +/* align 4 bytes */
> +#define HSDMA_ALIGN_SIZE               3
> +/* align size 128bytes */
> +#define HSDMA_MAX_PLEN                 0x3f80
> +
> +struct hsdma_desc {
> +       u32 addr0;
> +       u32 flags;
> +       u32 addr1;
> +       u32 unused;
> +};
> +
> +struct mtk_hsdma_sg {
> +       dma_addr_t src_addr;
> +       dma_addr_t dst_addr;
> +       u32 len;
> +};
> +
> +struct mtk_hsdma_desc {
> +       struct virt_dma_desc vdesc;
> +       unsigned int num_sgs;
> +       struct mtk_hsdma_sg sg[1];
> +};
> +
> +struct mtk_hsdma_chan {
> +       struct virt_dma_chan vchan;
> +       unsigned int id;
> +       dma_addr_t desc_addr;
> +       int tx_idx;
> +       int rx_idx;
> +       struct hsdma_desc *tx_ring;
> +       struct hsdma_desc *rx_ring;
> +       struct mtk_hsdma_desc *desc;
> +       unsigned int next_sg;
> +};
> +
> +struct mtk_hsdam_engine {
> +       struct dma_device ddev;
> +       struct device_dma_parameters dma_parms;
> +       void __iomem *base;
> +       struct tasklet_struct task;
> +       volatile unsigned long chan_issued;
> +
> +       struct mtk_hsdma_chan chan[1];
> +};
> +
> +static inline struct mtk_hsdam_engine *mtk_hsdma_chan_get_dev(
> +               struct mtk_hsdma_chan *chan)
> +{
> +       return container_of(chan->vchan.chan.device, struct mtk_hsdam_engine,
> +                       ddev);
> +}
> +
> +static inline struct mtk_hsdma_chan *to_mtk_hsdma_chan(struct dma_chan *c)
> +{
> +       return container_of(c, struct mtk_hsdma_chan, vchan.chan);
> +}
> +
> +static inline struct mtk_hsdma_desc *to_mtk_hsdma_desc(
> +               struct virt_dma_desc *vdesc)
> +{
> +       return container_of(vdesc, struct mtk_hsdma_desc, vdesc);
> +}
> +
> +static inline u32 mtk_hsdma_read(struct mtk_hsdam_engine *hsdma, u32 reg)
> +{
> +       return readl(hsdma->base + reg);
> +}
> +
> +static inline void mtk_hsdma_write(struct mtk_hsdam_engine *hsdma,
> +                                  unsigned reg, u32 val)
> +{
> +       writel(val, hsdma->base + reg);
> +}
> +
> +static void mtk_hsdma_reset_chan(struct mtk_hsdam_engine *hsdma,
> +                                struct mtk_hsdma_chan *chan)
> +{
> +       chan->tx_idx = 0;
> +       chan->rx_idx = HSDMA_DESCS_NUM - 1;
> +
> +       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CTX, chan->tx_idx);
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CRX, chan->rx_idx);
> +
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RST_CFG,
> +                       0x1 << (chan->id + HSDMA_RST_TX_SHIFT));
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RST_CFG,
> +                       0x1 << (chan->id + HSDMA_RST_RX_SHIFT));
> +}
> +
> +static void hsdma_dump_reg(struct mtk_hsdam_engine *hsdma)
> +{
> +       dev_dbg(hsdma->ddev.dev, "tbase %08x, tcnt %08x, " \
> +                       "tctx %08x, tdtx: %08x, rbase %08x, " \
> +                       "rcnt %08x, rctx %08x, rdtx %08x\n",
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_BASE),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_CNT),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_CTX),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_DTX),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_BASE),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_CNT),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_CRX),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_DRX));
> +
> +       dev_dbg(hsdma->ddev.dev, "info %08x, glo %08x, delay %08x, " \
> +                       "intr_stat %08x, intr_mask %08x\n",
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_INFO),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_GLO_CFG),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_DELAY_INT),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_INT_STATUS),
> +                       mtk_hsdma_read(hsdma, HSDMA_REG_INT_MASK));
> +}
> +
> +static void hsdma_dump_desc(struct mtk_hsdam_engine *hsdma,
> +                           struct mtk_hsdma_chan *chan)
> +{
> +       struct hsdma_desc *tx_desc;
> +       struct hsdma_desc *rx_desc;
> +       int i;
> +
> +       dev_dbg(hsdma->ddev.dev, "tx idx: %d, rx idx: %d\n",
> +                       chan->tx_idx, chan->rx_idx);
> +
> +       for (i = 0; i < HSDMA_DESCS_NUM; i++) {
> +               tx_desc = &chan->tx_ring[i];
> +               rx_desc = &chan->rx_ring[i];
> +
> +               dev_dbg(hsdma->ddev.dev, "%d tx addr0: %08x, flags %08x, " \
> +                               "tx addr1: %08x, rx addr0 %08x, flags %08x\n",
> +                               i, tx_desc->addr0, tx_desc->flags, \
> +                               tx_desc->addr1, rx_desc->addr0, rx_desc->flags);
> +       }
> +}
> +
> +static void mtk_hsdma_reset(struct mtk_hsdam_engine *hsdma,
> +                           struct mtk_hsdma_chan *chan)
> +{
> +       int i;
> +
> +       /* disable dma */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, 0);
> +
> +       /* disable intr */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, 0);
> +
> +       /* init desc value */
> +       for (i = 0; i < HSDMA_DESCS_NUM; i++) {
> +               chan->tx_ring[i].addr0 = 0;
> +               chan->tx_ring[i].flags = HSDMA_DESC_LS0 |
> +                       HSDMA_DESC_DONE;
> +       }
> +       for (i = 0; i < HSDMA_DESCS_NUM; i++) {
> +               chan->rx_ring[i].addr0 = 0;
> +               chan->rx_ring[i].flags = 0;
> +       }
> +
> +       /* reset */
> +       mtk_hsdma_reset_chan(hsdma, chan);
> +
> +       /* enable intr */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, HSDMA_INT_RX_Q0);
> +
> +       /* enable dma */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, HSDMA_GLO_DEFAULT);
> +}
> +
> +static int mtk_hsdma_terminate_all(struct dma_chan *c)
> +{
> +       struct mtk_hsdma_chan *chan = to_mtk_hsdma_chan(c);
> +       struct mtk_hsdam_engine *hsdma = mtk_hsdma_chan_get_dev(chan);
> +       unsigned long timeout;
> +       LIST_HEAD(head);
> +
> +       spin_lock_bh(&chan->vchan.lock);
> +       chan->desc = NULL;
> +       clear_bit(chan->id, &hsdma->chan_issued);
> +       vchan_get_all_descriptors(&chan->vchan, &head);
> +       spin_unlock_bh(&chan->vchan.lock);
> +
> +       vchan_dma_desc_free_list(&chan->vchan, &head);
> +
> +       /* wait dma transfer complete */
> +       timeout = jiffies + msecs_to_jiffies(2000);
> +       while (mtk_hsdma_read(hsdma, HSDMA_REG_GLO_CFG) &
> +                       (HSDMA_GLO_RX_BUSY | HSDMA_GLO_TX_BUSY)) {
> +               if (time_after_eq(jiffies, timeout)) {
> +                       hsdma_dump_desc(hsdma, chan);
> +                       mtk_hsdma_reset(hsdma, chan);
> +                       dev_err(hsdma->ddev.dev, "timeout, reset it\n");
> +                       break;
> +               }
> +               cpu_relax();
> +       }
> +
> +       return 0;
> +}
> +
> +static int mtk_hsdma_start_transfer(struct mtk_hsdam_engine *hsdma,
> +                                   struct mtk_hsdma_chan *chan)
> +{
> +       dma_addr_t src, dst;
> +       size_t len, tlen;
> +       struct hsdma_desc *tx_desc, *rx_desc;
> +       struct mtk_hsdma_sg *sg;
> +       unsigned int i;
> +       int rx_idx;
> +
> +       sg = &chan->desc->sg[0];
> +       len = sg->len;
> +       chan->desc->num_sgs = DIV_ROUND_UP(len, HSDMA_MAX_PLEN);
> +
> +       /* tx desc */
> +       src = sg->src_addr;
> +       for (i = 0; i < chan->desc->num_sgs; i++) {
> +               tx_desc = &chan->tx_ring[chan->tx_idx];
> +
> +               if (len > HSDMA_MAX_PLEN)
> +                       tlen = HSDMA_MAX_PLEN;
> +               else
> +                       tlen = len;
> +
> +               if (i & 0x1) {
> +                       tx_desc->addr1 = src;
> +                       tx_desc->flags |= HSDMA_DESC_PLEN1(tlen);
> +               } else {
> +                       tx_desc->addr0 = src;
> +                       tx_desc->flags = HSDMA_DESC_PLEN0(tlen);
> +
> +                       /* update index */
> +                       chan->tx_idx = HSDMA_NEXT_DESC(chan->tx_idx);
> +               }
> +
> +               src += tlen;
> +               len -= tlen;
> +       }
> +       if (i & 0x1)
> +               tx_desc->flags |= HSDMA_DESC_LS0;
> +       else
> +               tx_desc->flags |= HSDMA_DESC_LS1;
> +
> +       /* rx desc */
> +       rx_idx = HSDMA_NEXT_DESC(chan->rx_idx);
> +       len = sg->len;
> +       dst = sg->dst_addr;
> +       for (i = 0; i < chan->desc->num_sgs; i++) {
> +               rx_desc = &chan->rx_ring[rx_idx];
> +               if (len > HSDMA_MAX_PLEN)
> +                       tlen = HSDMA_MAX_PLEN;
> +               else
> +                       tlen = len;
> +
> +               rx_desc->addr0 = dst;
> +               rx_desc->flags = HSDMA_DESC_PLEN0(tlen);
> +
> +               dst += tlen;
> +               len -= tlen;
> +
> +               /* update index */
> +               rx_idx = HSDMA_NEXT_DESC(rx_idx);
> +       }
> +
> +       /* make sure desc and index all up to date */
> +       wmb();
> +       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CTX, chan->tx_idx);
> +
> +       return 0;
> +}
> +
> +static int gdma_next_desc(struct mtk_hsdma_chan *chan)
> +{
> +       struct virt_dma_desc *vdesc;
> +
> +       vdesc = vchan_next_desc(&chan->vchan);
> +       if (!vdesc) {
> +               chan->desc = NULL;
> +               return 0;
> +       }
> +       chan->desc = to_mtk_hsdma_desc(vdesc);
> +       chan->next_sg = 0;
> +
> +       return 1;
> +}
> +
> +static void mtk_hsdma_chan_done(struct mtk_hsdam_engine *hsdma,
> +                               struct mtk_hsdma_chan *chan)
> +{
> +       struct mtk_hsdma_desc *desc;
> +       int chan_issued;
> +
> +       chan_issued = 0;
> +       spin_lock_bh(&chan->vchan.lock);
> +       desc = chan->desc;
> +       if (likely(desc)) {
> +               if (chan->next_sg == desc->num_sgs) {
> +                       list_del(&desc->vdesc.node);
> +                       vchan_cookie_complete(&desc->vdesc);
> +                       chan_issued = gdma_next_desc(chan);
> +               }
> +       } else
> +               dev_dbg(hsdma->ddev.dev, "no desc to complete\n");
> +
> +       if (chan_issued)
> +               set_bit(chan->id, &hsdma->chan_issued);
> +       spin_unlock_bh(&chan->vchan.lock);
> +}
> +
> +static irqreturn_t mtk_hsdma_irq(int irq, void *devid)
> +{
> +       struct mtk_hsdam_engine *hsdma = devid;
> +       u32 status;
> +
> +       status = mtk_hsdma_read(hsdma, HSDMA_REG_INT_STATUS);
> +       if (unlikely(!status))
> +               return IRQ_NONE;
> +
> +       if (likely(status & HSDMA_INT_RX_Q0))
> +               tasklet_schedule(&hsdma->task);
> +       else
> +               dev_dbg(hsdma->ddev.dev, "unhandle irq status %08x\n",
> +                       status);
> +       /* clean intr bits */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_INT_STATUS, status);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void mtk_hsdma_issue_pending(struct dma_chan *c)
> +{
> +       struct mtk_hsdma_chan *chan = to_mtk_hsdma_chan(c);
> +       struct mtk_hsdam_engine *hsdma = mtk_hsdma_chan_get_dev(chan);
> +
> +       spin_lock_bh(&chan->vchan.lock);
> +       if (vchan_issue_pending(&chan->vchan) && !chan->desc) {
> +               if (gdma_next_desc(chan)) {
> +                       set_bit(chan->id, &hsdma->chan_issued);
> +                       tasklet_schedule(&hsdma->task);
> +               } else
> +                       dev_dbg(hsdma->ddev.dev, "no desc to issue\n");
> +       }
> +       spin_unlock_bh(&chan->vchan.lock);
> +}
> +
> +static struct dma_async_tx_descriptor *mtk_hsdma_prep_dma_memcpy(
> +               struct dma_chan *c, dma_addr_t dest, dma_addr_t src,
> +               size_t len, unsigned long flags)
> +{
> +       struct mtk_hsdma_chan *chan = to_mtk_hsdma_chan(c);
> +       struct mtk_hsdma_desc *desc;
> +
> +       if (len <= 0)
> +               return NULL;
> +
> +       desc = kzalloc(sizeof(struct mtk_hsdma_desc), GFP_ATOMIC);
> +       if (!desc) {
> +               dev_err(c->device->dev, "alloc memcpy decs error\n");
> +               return NULL;
> +       }
> +
> +       desc->sg[0].src_addr = src;
> +       desc->sg[0].dst_addr = dest;
> +       desc->sg[0].len = len;
> +
> +       return vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
> +}
> +
> +static enum dma_status mtk_hsdma_tx_status(struct dma_chan *c,
> +                                          dma_cookie_t cookie,
> +                                          struct dma_tx_state *state)
> +{
> +       return dma_cookie_status(c, cookie, state);
> +}
> +
> +static void mtk_hsdma_free_chan_resources(struct dma_chan *c)
> +{
> +       vchan_free_chan_resources(to_virt_chan(c));
> +}
> +
> +static void mtk_hsdma_desc_free(struct virt_dma_desc *vdesc)
> +{
> +       kfree(container_of(vdesc, struct mtk_hsdma_desc, vdesc));
> +}
> +
> +static void mtk_hsdma_tx(struct mtk_hsdam_engine *hsdma)
> +{
> +       struct mtk_hsdma_chan *chan;
> +
> +       if (test_and_clear_bit(0, &hsdma->chan_issued)) {
> +               chan = &hsdma->chan[0];
> +               if (chan->desc)
> +                       mtk_hsdma_start_transfer(hsdma, chan);
> +               else
> +                       dev_dbg(hsdma->ddev.dev, "chan 0 no desc to issue\n");
> +       }
> +}
> +
> +static void mtk_hsdma_rx(struct mtk_hsdam_engine *hsdma)
> +{
> +       struct mtk_hsdma_chan *chan;
> +       int next_idx, drx_idx, cnt;
> +
> +       chan = &hsdma->chan[0];
> +       next_idx = HSDMA_NEXT_DESC(chan->rx_idx);
> +       drx_idx = mtk_hsdma_read(hsdma, HSDMA_REG_RX_DRX);
> +
> +       cnt = (drx_idx - next_idx) & HSDMA_DESCS_MASK;
> +       if (!cnt)
> +               return;
> +
> +       chan->next_sg += cnt;
> +       chan->rx_idx = (chan->rx_idx + cnt) & HSDMA_DESCS_MASK;
> +
> +       /* update rx crx */
> +       wmb();
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CRX, chan->rx_idx);
> +
> +       mtk_hsdma_chan_done(hsdma, chan);
> +}
> +
> +static void mtk_hsdma_tasklet(unsigned long arg)
> +{
> +       struct mtk_hsdam_engine *hsdma = (struct mtk_hsdam_engine *)arg;
> +
> +       mtk_hsdma_rx(hsdma);
> +       mtk_hsdma_tx(hsdma);
> +}
> +
> +static int mtk_hsdam_alloc_desc(struct mtk_hsdam_engine *hsdma,
> +                               struct mtk_hsdma_chan *chan)
> +{
> +       int i;
> +
> +       chan->tx_ring = dma_alloc_coherent(hsdma->ddev.dev,
> +                       2 * HSDMA_DESCS_NUM * sizeof(*chan->tx_ring),
> +                       &chan->desc_addr, GFP_ATOMIC | __GFP_ZERO);
> +       if (!chan->tx_ring)
> +               goto no_mem;
> +
> +       chan->rx_ring = &chan->tx_ring[HSDMA_DESCS_NUM];
> +
> +       /* init tx ring value */
> +       for (i = 0; i < HSDMA_DESCS_NUM; i++)
> +               chan->tx_ring[i].flags = HSDMA_DESC_LS0 | HSDMA_DESC_DONE;
> +
> +       return 0;
> +no_mem:
> +       return -ENOMEM;
> +}
> +
> +static void mtk_hsdam_free_desc(struct mtk_hsdam_engine *hsdma,
> +                               struct mtk_hsdma_chan *chan)
> +{
> +       if (chan->tx_ring) {
> +               dma_free_coherent(hsdma->ddev.dev,
> +                               2 * HSDMA_DESCS_NUM * sizeof(*chan->tx_ring),
> +                               chan->tx_ring, chan->desc_addr);
> +               chan->tx_ring = NULL;
> +               chan->rx_ring = NULL;
> +       }
> +}
> +
> +static int mtk_hsdma_init(struct mtk_hsdam_engine *hsdma)
> +{
> +       struct mtk_hsdma_chan *chan;
> +       int ret;
> +       u32 reg;
> +
> +       /* init desc */
> +       chan = &hsdma->chan[0];
> +       ret = mtk_hsdam_alloc_desc(hsdma, chan);
> +       if (ret)
> +               return ret;
> +
> +       /* tx */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_TX_BASE, chan->desc_addr);
> +       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CNT, HSDMA_DESCS_NUM);
> +       /* rx */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RX_BASE, chan->desc_addr +
> +                       (sizeof(struct hsdma_desc) * HSDMA_DESCS_NUM));
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CNT, HSDMA_DESCS_NUM);
> +       /* reset */
> +       mtk_hsdma_reset_chan(hsdma, chan);
> +
> +       /* enable rx intr */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, HSDMA_INT_RX_Q0);
> +
> +       /* enable dma */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, HSDMA_GLO_DEFAULT);
> +
> +       /* hardware info */
> +       reg = mtk_hsdma_read(hsdma, HSDMA_REG_INFO);
> +       dev_info(hsdma->ddev.dev, "rx: %d, tx: %d\n",
> +                (reg >> HSDMA_INFO_RX_SHIFT) & HSDMA_INFO_RX_MASK,
> +                (reg >> HSDMA_INFO_TX_SHIFT) & HSDMA_INFO_TX_MASK);
> +
> +       hsdma_dump_reg(hsdma);
> +
> +       return ret;
> +}
> +
> +static void mtk_hsdma_uninit(struct mtk_hsdam_engine *hsdma)
> +{
> +       struct mtk_hsdma_chan *chan;
> +
> +       /* disable dma */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, 0);
> +
> +       /* disable intr */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, 0);
> +
> +       /* free desc */
> +       chan = &hsdma->chan[0];
> +       mtk_hsdam_free_desc(hsdma, chan);
> +
> +       /* tx */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_TX_BASE, 0);
> +       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CNT, 0);
> +       /* rx */
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RX_BASE, 0);
> +       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CNT, 0);
> +       /* reset */
> +       mtk_hsdma_reset_chan(hsdma, chan);
> +}
> +
> +static const struct of_device_id mtk_hsdma_of_match[] = {
> +       { .compatible = "mediatek,mt7621-hsdma" },
> +       { },
> +};
> +
> +static int mtk_hsdma_probe(struct platform_device *pdev)
> +{
> +       const struct of_device_id *match;
> +       struct mtk_hsdma_chan *chan;
> +       struct mtk_hsdam_engine *hsdma;
> +       struct dma_device *dd;
> +       struct resource *res;
> +       int ret;
> +       int irq;
> +       void __iomem *base;
> +
> +       ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +       if (ret)
> +               return ret;
> +
> +       match = of_match_device(mtk_hsdma_of_match, &pdev->dev);
> +       if (!match)
> +               return -EINVAL;
> +
> +       hsdma = devm_kzalloc(&pdev->dev, sizeof(*hsdma), GFP_KERNEL);
> +       if (!hsdma) {
> +               dev_err(&pdev->dev, "alloc dma device failed\n");
> +               return -EINVAL;
> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(base))
> +               return PTR_ERR(base);
> +       hsdma->base = base + HSDMA_BASE_OFFSET;
> +       tasklet_init(&hsdma->task, mtk_hsdma_tasklet, (unsigned long)hsdma);
> +
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq < 0) {
> +               dev_err(&pdev->dev, "failed to get irq\n");
> +               return -EINVAL;
> +       }
> +       ret = devm_request_irq(&pdev->dev, irq, mtk_hsdma_irq,
> +                              0, dev_name(&pdev->dev), hsdma);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to request irq\n");
> +               return ret;
> +       }
> +
> +       device_reset(&pdev->dev);
> +
> +       dd = &hsdma->ddev;
> +       dma_cap_set(DMA_MEMCPY, dd->cap_mask);
> +       dd->copy_align = HSDMA_ALIGN_SIZE;
> +       dd->device_free_chan_resources = mtk_hsdma_free_chan_resources;
> +       dd->device_prep_dma_memcpy = mtk_hsdma_prep_dma_memcpy;
> +       dd->device_terminate_all = mtk_hsdma_terminate_all;
> +       dd->device_tx_status = mtk_hsdma_tx_status;
> +       dd->device_issue_pending = mtk_hsdma_issue_pending;
> +       dd->dev = &pdev->dev;
> +       dd->dev->dma_parms = &hsdma->dma_parms;
> +       dma_set_max_seg_size(dd->dev, HSDMA_MAX_PLEN);
> +       INIT_LIST_HEAD(&dd->channels);
> +
> +       chan = &hsdma->chan[0];
> +       chan->id = 0;
> +       chan->vchan.desc_free = mtk_hsdma_desc_free;
> +       vchan_init(&chan->vchan, dd);
> +
> +       /* init hardware */
> +       ret = mtk_hsdma_init(hsdma);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to alloc ring descs\n");
> +               return ret;
> +       }
> +
> +       ret = dma_async_device_register(dd);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to register dma device\n");
> +               goto err_uninit_hsdma;
> +       }
> +
> +       ret = of_dma_controller_register(pdev->dev.of_node,
> +                                        of_dma_xlate_by_chan_id, hsdma);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to register of dma controller\n");
> +               goto err_unregister;
> +       }
> +
> +       platform_set_drvdata(pdev, hsdma);
> +
> +       return 0;
> +
> +err_unregister:
> +       dma_async_device_unregister(dd);
> +err_uninit_hsdma:
> +       mtk_hsdma_uninit(hsdma);
> +       return ret;
> +}
> +
> +static int mtk_hsdma_remove(struct platform_device *pdev)
> +{
> +       struct mtk_hsdam_engine *hsdma = platform_get_drvdata(pdev);
> +
> +       mtk_hsdma_uninit(hsdma);
> +
> +       of_dma_controller_free(pdev->dev.of_node);
> +       dma_async_device_unregister(&hsdma->ddev);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver mtk_hsdma_driver = {
> +       .probe = mtk_hsdma_probe,
> +       .remove = mtk_hsdma_remove,
> +       .driver = {
> +               .name = KBUILD_MODNAME,
> +               .of_match_table = mtk_hsdma_of_match,
> +       },
> +};
> +module_platform_driver(mtk_hsdma_driver);
> +
> +MODULE_AUTHOR("Michael Lee <igvtee@gmail.com>");
> +MODULE_DESCRIPTION("MTK HSDMA driver");
> +MODULE_LICENSE("GPL v2");
> --- a/drivers/staging/mt7621-dma/mtk-hsdma.c
> +++ /dev/null
> @@ -1,771 +0,0 @@
> -/*
> - *  Copyright (C) 2015, Michael Lee <igvtee@gmail.com>
> - *  MTK HSDMA support
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under  the terms of the GNU General         Public License as published by the
> - *  Free Software Foundation;  either version 2 of the License, or (at your
> - *  option) any later version.
> - *
> - */
> -
> -#include <linux/dmaengine.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/err.h>
> -#include <linux/init.h>
> -#include <linux/list.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/slab.h>
> -#include <linux/spinlock.h>
> -#include <linux/irq.h>
> -#include <linux/of_dma.h>
> -#include <linux/reset.h>
> -#include <linux/of_device.h>
> -
> -#include "virt-dma.h"
> -
> -#define HSDMA_BASE_OFFSET              0x800
> -
> -#define HSDMA_REG_TX_BASE              0x00
> -#define HSDMA_REG_TX_CNT               0x04
> -#define HSDMA_REG_TX_CTX               0x08
> -#define HSDMA_REG_TX_DTX               0x0c
> -#define HSDMA_REG_RX_BASE              0x100
> -#define HSDMA_REG_RX_CNT               0x104
> -#define HSDMA_REG_RX_CRX               0x108
> -#define HSDMA_REG_RX_DRX               0x10c
> -#define HSDMA_REG_INFO                 0x200
> -#define HSDMA_REG_GLO_CFG              0x204
> -#define HSDMA_REG_RST_CFG              0x208
> -#define HSDMA_REG_DELAY_INT            0x20c
> -#define HSDMA_REG_FREEQ_THRES          0x210
> -#define HSDMA_REG_INT_STATUS           0x220
> -#define HSDMA_REG_INT_MASK             0x228
> -#define HSDMA_REG_SCH_Q01              0x280
> -#define HSDMA_REG_SCH_Q23              0x284
> -
> -#define HSDMA_DESCS_MAX                        0xfff
> -#define HSDMA_DESCS_NUM                        8
> -#define HSDMA_DESCS_MASK               (HSDMA_DESCS_NUM - 1)
> -#define HSDMA_NEXT_DESC(x)             (((x) + 1) & HSDMA_DESCS_MASK)
> -
> -/* HSDMA_REG_INFO */
> -#define HSDMA_INFO_INDEX_MASK          0xf
> -#define HSDMA_INFO_INDEX_SHIFT         24
> -#define HSDMA_INFO_BASE_MASK           0xff
> -#define HSDMA_INFO_BASE_SHIFT          16
> -#define HSDMA_INFO_RX_MASK             0xff
> -#define HSDMA_INFO_RX_SHIFT            8
> -#define HSDMA_INFO_TX_MASK             0xff
> -#define HSDMA_INFO_TX_SHIFT            0
> -
> -/* HSDMA_REG_GLO_CFG */
> -#define HSDMA_GLO_TX_2B_OFFSET         BIT(31)
> -#define HSDMA_GLO_CLK_GATE             BIT(30)
> -#define HSDMA_GLO_BYTE_SWAP            BIT(29)
> -#define HSDMA_GLO_MULTI_DMA            BIT(10)
> -#define HSDMA_GLO_TWO_BUF              BIT(9)
> -#define HSDMA_GLO_32B_DESC             BIT(8)
> -#define HSDMA_GLO_BIG_ENDIAN           BIT(7)
> -#define HSDMA_GLO_TX_DONE              BIT(6)
> -#define HSDMA_GLO_BT_MASK              0x3
> -#define HSDMA_GLO_BT_SHIFT             4
> -#define HSDMA_GLO_RX_BUSY              BIT(3)
> -#define HSDMA_GLO_RX_DMA               BIT(2)
> -#define HSDMA_GLO_TX_BUSY              BIT(1)
> -#define HSDMA_GLO_TX_DMA               BIT(0)
> -
> -#define HSDMA_BT_SIZE_16BYTES          (0 << HSDMA_GLO_BT_SHIFT)
> -#define HSDMA_BT_SIZE_32BYTES          (1 << HSDMA_GLO_BT_SHIFT)
> -#define HSDMA_BT_SIZE_64BYTES          (2 << HSDMA_GLO_BT_SHIFT)
> -#define HSDMA_BT_SIZE_128BYTES         (3 << HSDMA_GLO_BT_SHIFT)
> -
> -#define HSDMA_GLO_DEFAULT              (HSDMA_GLO_MULTI_DMA | \
> -               HSDMA_GLO_RX_DMA | HSDMA_GLO_TX_DMA | HSDMA_BT_SIZE_32BYTES)
> -
> -/* HSDMA_REG_RST_CFG */
> -#define HSDMA_RST_RX_SHIFT             16
> -#define HSDMA_RST_TX_SHIFT             0
> -
> -/* HSDMA_REG_DELAY_INT */
> -#define HSDMA_DELAY_INT_EN             BIT(15)
> -#define HSDMA_DELAY_PEND_OFFSET                8
> -#define HSDMA_DELAY_TIME_OFFSET                0
> -#define HSDMA_DELAY_TX_OFFSET          16
> -#define HSDMA_DELAY_RX_OFFSET          0
> -
> -#define HSDMA_DELAY_INIT(x)            (HSDMA_DELAY_INT_EN | \
> -               ((x) << HSDMA_DELAY_PEND_OFFSET))
> -#define HSDMA_DELAY(x)                 ((HSDMA_DELAY_INIT(x) << \
> -               HSDMA_DELAY_TX_OFFSET) | HSDMA_DELAY_INIT(x))
> -
> -/* HSDMA_REG_INT_STATUS */
> -#define HSDMA_INT_DELAY_RX_COH         BIT(31)
> -#define HSDMA_INT_DELAY_RX_INT         BIT(30)
> -#define HSDMA_INT_DELAY_TX_COH         BIT(29)
> -#define HSDMA_INT_DELAY_TX_INT         BIT(28)
> -#define HSDMA_INT_RX_MASK              0x3
> -#define HSDMA_INT_RX_SHIFT             16
> -#define HSDMA_INT_RX_Q0                        BIT(16)
> -#define HSDMA_INT_TX_MASK              0xf
> -#define HSDMA_INT_TX_SHIFT             0
> -#define HSDMA_INT_TX_Q0                        BIT(0)
> -
> -/* tx/rx dma desc flags */
> -#define HSDMA_PLEN_MASK                        0x3fff
> -#define HSDMA_DESC_DONE                        BIT(31)
> -#define HSDMA_DESC_LS0                 BIT(30)
> -#define HSDMA_DESC_PLEN0(_x)           (((_x) & HSDMA_PLEN_MASK) << 16)
> -#define HSDMA_DESC_TAG                 BIT(15)
> -#define HSDMA_DESC_LS1                 BIT(14)
> -#define HSDMA_DESC_PLEN1(_x)           ((_x) & HSDMA_PLEN_MASK)
> -
> -/* align 4 bytes */
> -#define HSDMA_ALIGN_SIZE               3
> -/* align size 128bytes */
> -#define HSDMA_MAX_PLEN                 0x3f80
> -
> -struct hsdma_desc {
> -       u32 addr0;
> -       u32 flags;
> -       u32 addr1;
> -       u32 unused;
> -};
> -
> -struct mtk_hsdma_sg {
> -       dma_addr_t src_addr;
> -       dma_addr_t dst_addr;
> -       u32 len;
> -};
> -
> -struct mtk_hsdma_desc {
> -       struct virt_dma_desc vdesc;
> -       unsigned int num_sgs;
> -       struct mtk_hsdma_sg sg[1];
> -};
> -
> -struct mtk_hsdma_chan {
> -       struct virt_dma_chan vchan;
> -       unsigned int id;
> -       dma_addr_t desc_addr;
> -       int tx_idx;
> -       int rx_idx;
> -       struct hsdma_desc *tx_ring;
> -       struct hsdma_desc *rx_ring;
> -       struct mtk_hsdma_desc *desc;
> -       unsigned int next_sg;
> -};
> -
> -struct mtk_hsdam_engine {
> -       struct dma_device ddev;
> -       struct device_dma_parameters dma_parms;
> -       void __iomem *base;
> -       struct tasklet_struct task;
> -       volatile unsigned long chan_issued;
> -
> -       struct mtk_hsdma_chan chan[1];
> -};
> -
> -static inline struct mtk_hsdam_engine *mtk_hsdma_chan_get_dev(
> -               struct mtk_hsdma_chan *chan)
> -{
> -       return container_of(chan->vchan.chan.device, struct mtk_hsdam_engine,
> -                       ddev);
> -}
> -
> -static inline struct mtk_hsdma_chan *to_mtk_hsdma_chan(struct dma_chan *c)
> -{
> -       return container_of(c, struct mtk_hsdma_chan, vchan.chan);
> -}
> -
> -static inline struct mtk_hsdma_desc *to_mtk_hsdma_desc(
> -               struct virt_dma_desc *vdesc)
> -{
> -       return container_of(vdesc, struct mtk_hsdma_desc, vdesc);
> -}
> -
> -static inline u32 mtk_hsdma_read(struct mtk_hsdam_engine *hsdma, u32 reg)
> -{
> -       return readl(hsdma->base + reg);
> -}
> -
> -static inline void mtk_hsdma_write(struct mtk_hsdam_engine *hsdma,
> -                                  unsigned reg, u32 val)
> -{
> -       writel(val, hsdma->base + reg);
> -}
> -
> -static void mtk_hsdma_reset_chan(struct mtk_hsdam_engine *hsdma,
> -                                struct mtk_hsdma_chan *chan)
> -{
> -       chan->tx_idx = 0;
> -       chan->rx_idx = HSDMA_DESCS_NUM - 1;
> -
> -       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CTX, chan->tx_idx);
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CRX, chan->rx_idx);
> -
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RST_CFG,
> -                       0x1 << (chan->id + HSDMA_RST_TX_SHIFT));
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RST_CFG,
> -                       0x1 << (chan->id + HSDMA_RST_RX_SHIFT));
> -}
> -
> -static void hsdma_dump_reg(struct mtk_hsdam_engine *hsdma)
> -{
> -       dev_dbg(hsdma->ddev.dev, "tbase %08x, tcnt %08x, " \
> -                       "tctx %08x, tdtx: %08x, rbase %08x, " \
> -                       "rcnt %08x, rctx %08x, rdtx %08x\n",
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_BASE),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_CNT),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_CTX),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_TX_DTX),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_BASE),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_CNT),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_CRX),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_RX_DRX));
> -
> -       dev_dbg(hsdma->ddev.dev, "info %08x, glo %08x, delay %08x, " \
> -                       "intr_stat %08x, intr_mask %08x\n",
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_INFO),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_GLO_CFG),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_DELAY_INT),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_INT_STATUS),
> -                       mtk_hsdma_read(hsdma, HSDMA_REG_INT_MASK));
> -}
> -
> -static void hsdma_dump_desc(struct mtk_hsdam_engine *hsdma,
> -                           struct mtk_hsdma_chan *chan)
> -{
> -       struct hsdma_desc *tx_desc;
> -       struct hsdma_desc *rx_desc;
> -       int i;
> -
> -       dev_dbg(hsdma->ddev.dev, "tx idx: %d, rx idx: %d\n",
> -                       chan->tx_idx, chan->rx_idx);
> -
> -       for (i = 0; i < HSDMA_DESCS_NUM; i++) {
> -               tx_desc = &chan->tx_ring[i];
> -               rx_desc = &chan->rx_ring[i];
> -
> -               dev_dbg(hsdma->ddev.dev, "%d tx addr0: %08x, flags %08x, " \
> -                               "tx addr1: %08x, rx addr0 %08x, flags %08x\n",
> -                               i, tx_desc->addr0, tx_desc->flags, \
> -                               tx_desc->addr1, rx_desc->addr0, rx_desc->flags);
> -       }
> -}
> -
> -static void mtk_hsdma_reset(struct mtk_hsdam_engine *hsdma,
> -                           struct mtk_hsdma_chan *chan)
> -{
> -       int i;
> -
> -       /* disable dma */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, 0);
> -
> -       /* disable intr */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, 0);
> -
> -       /* init desc value */
> -       for (i = 0; i < HSDMA_DESCS_NUM; i++) {
> -               chan->tx_ring[i].addr0 = 0;
> -               chan->tx_ring[i].flags = HSDMA_DESC_LS0 |
> -                       HSDMA_DESC_DONE;
> -       }
> -       for (i = 0; i < HSDMA_DESCS_NUM; i++) {
> -               chan->rx_ring[i].addr0 = 0;
> -               chan->rx_ring[i].flags = 0;
> -       }
> -
> -       /* reset */
> -       mtk_hsdma_reset_chan(hsdma, chan);
> -
> -       /* enable intr */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, HSDMA_INT_RX_Q0);
> -
> -       /* enable dma */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, HSDMA_GLO_DEFAULT);
> -}
> -
> -static int mtk_hsdma_terminate_all(struct dma_chan *c)
> -{
> -       struct mtk_hsdma_chan *chan = to_mtk_hsdma_chan(c);
> -       struct mtk_hsdam_engine *hsdma = mtk_hsdma_chan_get_dev(chan);
> -       unsigned long timeout;
> -       LIST_HEAD(head);
> -
> -       spin_lock_bh(&chan->vchan.lock);
> -       chan->desc = NULL;
> -       clear_bit(chan->id, &hsdma->chan_issued);
> -       vchan_get_all_descriptors(&chan->vchan, &head);
> -       spin_unlock_bh(&chan->vchan.lock);
> -
> -       vchan_dma_desc_free_list(&chan->vchan, &head);
> -
> -       /* wait dma transfer complete */
> -       timeout = jiffies + msecs_to_jiffies(2000);
> -       while (mtk_hsdma_read(hsdma, HSDMA_REG_GLO_CFG) &
> -                       (HSDMA_GLO_RX_BUSY | HSDMA_GLO_TX_BUSY)) {
> -               if (time_after_eq(jiffies, timeout)) {
> -                       hsdma_dump_desc(hsdma, chan);
> -                       mtk_hsdma_reset(hsdma, chan);
> -                       dev_err(hsdma->ddev.dev, "timeout, reset it\n");
> -                       break;
> -               }
> -               cpu_relax();
> -       }
> -
> -       return 0;
> -}
> -
> -static int mtk_hsdma_start_transfer(struct mtk_hsdam_engine *hsdma,
> -                                   struct mtk_hsdma_chan *chan)
> -{
> -       dma_addr_t src, dst;
> -       size_t len, tlen;
> -       struct hsdma_desc *tx_desc, *rx_desc;
> -       struct mtk_hsdma_sg *sg;
> -       unsigned int i;
> -       int rx_idx;
> -
> -       sg = &chan->desc->sg[0];
> -       len = sg->len;
> -       chan->desc->num_sgs = DIV_ROUND_UP(len, HSDMA_MAX_PLEN);
> -
> -       /* tx desc */
> -       src = sg->src_addr;
> -       for (i = 0; i < chan->desc->num_sgs; i++) {
> -               tx_desc = &chan->tx_ring[chan->tx_idx];
> -
> -               if (len > HSDMA_MAX_PLEN)
> -                       tlen = HSDMA_MAX_PLEN;
> -               else
> -                       tlen = len;
> -
> -               if (i & 0x1) {
> -                       tx_desc->addr1 = src;
> -                       tx_desc->flags |= HSDMA_DESC_PLEN1(tlen);
> -               } else {
> -                       tx_desc->addr0 = src;
> -                       tx_desc->flags = HSDMA_DESC_PLEN0(tlen);
> -
> -                       /* update index */
> -                       chan->tx_idx = HSDMA_NEXT_DESC(chan->tx_idx);
> -               }
> -
> -               src += tlen;
> -               len -= tlen;
> -       }
> -       if (i & 0x1)
> -               tx_desc->flags |= HSDMA_DESC_LS0;
> -       else
> -               tx_desc->flags |= HSDMA_DESC_LS1;
> -
> -       /* rx desc */
> -       rx_idx = HSDMA_NEXT_DESC(chan->rx_idx);
> -       len = sg->len;
> -       dst = sg->dst_addr;
> -       for (i = 0; i < chan->desc->num_sgs; i++) {
> -               rx_desc = &chan->rx_ring[rx_idx];
> -               if (len > HSDMA_MAX_PLEN)
> -                       tlen = HSDMA_MAX_PLEN;
> -               else
> -                       tlen = len;
> -
> -               rx_desc->addr0 = dst;
> -               rx_desc->flags = HSDMA_DESC_PLEN0(tlen);
> -
> -               dst += tlen;
> -               len -= tlen;
> -
> -               /* update index */
> -               rx_idx = HSDMA_NEXT_DESC(rx_idx);
> -       }
> -
> -       /* make sure desc and index all up to date */
> -       wmb();
> -       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CTX, chan->tx_idx);
> -
> -       return 0;
> -}
> -
> -static int gdma_next_desc(struct mtk_hsdma_chan *chan)
> -{
> -       struct virt_dma_desc *vdesc;
> -
> -       vdesc = vchan_next_desc(&chan->vchan);
> -       if (!vdesc) {
> -               chan->desc = NULL;
> -               return 0;
> -       }
> -       chan->desc = to_mtk_hsdma_desc(vdesc);
> -       chan->next_sg = 0;
> -
> -       return 1;
> -}
> -
> -static void mtk_hsdma_chan_done(struct mtk_hsdam_engine *hsdma,
> -                               struct mtk_hsdma_chan *chan)
> -{
> -       struct mtk_hsdma_desc *desc;
> -       int chan_issued;
> -
> -       chan_issued = 0;
> -       spin_lock_bh(&chan->vchan.lock);
> -       desc = chan->desc;
> -       if (likely(desc)) {
> -               if (chan->next_sg == desc->num_sgs) {
> -                       list_del(&desc->vdesc.node);
> -                       vchan_cookie_complete(&desc->vdesc);
> -                       chan_issued = gdma_next_desc(chan);
> -               }
> -       } else
> -               dev_dbg(hsdma->ddev.dev, "no desc to complete\n");
> -
> -       if (chan_issued)
> -               set_bit(chan->id, &hsdma->chan_issued);
> -       spin_unlock_bh(&chan->vchan.lock);
> -}
> -
> -static irqreturn_t mtk_hsdma_irq(int irq, void *devid)
> -{
> -       struct mtk_hsdam_engine *hsdma = devid;
> -       u32 status;
> -
> -       status = mtk_hsdma_read(hsdma, HSDMA_REG_INT_STATUS);
> -       if (unlikely(!status))
> -               return IRQ_NONE;
> -
> -       if (likely(status & HSDMA_INT_RX_Q0))
> -               tasklet_schedule(&hsdma->task);
> -       else
> -               dev_dbg(hsdma->ddev.dev, "unhandle irq status %08x\n",
> -                       status);
> -       /* clean intr bits */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_INT_STATUS, status);
> -
> -       return IRQ_HANDLED;
> -}
> -
> -static void mtk_hsdma_issue_pending(struct dma_chan *c)
> -{
> -       struct mtk_hsdma_chan *chan = to_mtk_hsdma_chan(c);
> -       struct mtk_hsdam_engine *hsdma = mtk_hsdma_chan_get_dev(chan);
> -
> -       spin_lock_bh(&chan->vchan.lock);
> -       if (vchan_issue_pending(&chan->vchan) && !chan->desc) {
> -               if (gdma_next_desc(chan)) {
> -                       set_bit(chan->id, &hsdma->chan_issued);
> -                       tasklet_schedule(&hsdma->task);
> -               } else
> -                       dev_dbg(hsdma->ddev.dev, "no desc to issue\n");
> -       }
> -       spin_unlock_bh(&chan->vchan.lock);
> -}
> -
> -static struct dma_async_tx_descriptor *mtk_hsdma_prep_dma_memcpy(
> -               struct dma_chan *c, dma_addr_t dest, dma_addr_t src,
> -               size_t len, unsigned long flags)
> -{
> -       struct mtk_hsdma_chan *chan = to_mtk_hsdma_chan(c);
> -       struct mtk_hsdma_desc *desc;
> -
> -       if (len <= 0)
> -               return NULL;
> -
> -       desc = kzalloc(sizeof(struct mtk_hsdma_desc), GFP_ATOMIC);
> -       if (!desc) {
> -               dev_err(c->device->dev, "alloc memcpy decs error\n");
> -               return NULL;
> -       }
> -
> -       desc->sg[0].src_addr = src;
> -       desc->sg[0].dst_addr = dest;
> -       desc->sg[0].len = len;
> -
> -       return vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
> -}
> -
> -static enum dma_status mtk_hsdma_tx_status(struct dma_chan *c,
> -                                          dma_cookie_t cookie,
> -                                          struct dma_tx_state *state)
> -{
> -       return dma_cookie_status(c, cookie, state);
> -}
> -
> -static void mtk_hsdma_free_chan_resources(struct dma_chan *c)
> -{
> -       vchan_free_chan_resources(to_virt_chan(c));
> -}
> -
> -static void mtk_hsdma_desc_free(struct virt_dma_desc *vdesc)
> -{
> -       kfree(container_of(vdesc, struct mtk_hsdma_desc, vdesc));
> -}
> -
> -static void mtk_hsdma_tx(struct mtk_hsdam_engine *hsdma)
> -{
> -       struct mtk_hsdma_chan *chan;
> -
> -       if (test_and_clear_bit(0, &hsdma->chan_issued)) {
> -               chan = &hsdma->chan[0];
> -               if (chan->desc)
> -                       mtk_hsdma_start_transfer(hsdma, chan);
> -               else
> -                       dev_dbg(hsdma->ddev.dev, "chan 0 no desc to issue\n");
> -       }
> -}
> -
> -static void mtk_hsdma_rx(struct mtk_hsdam_engine *hsdma)
> -{
> -       struct mtk_hsdma_chan *chan;
> -       int next_idx, drx_idx, cnt;
> -
> -       chan = &hsdma->chan[0];
> -       next_idx = HSDMA_NEXT_DESC(chan->rx_idx);
> -       drx_idx = mtk_hsdma_read(hsdma, HSDMA_REG_RX_DRX);
> -
> -       cnt = (drx_idx - next_idx) & HSDMA_DESCS_MASK;
> -       if (!cnt)
> -               return;
> -
> -       chan->next_sg += cnt;
> -       chan->rx_idx = (chan->rx_idx + cnt) & HSDMA_DESCS_MASK;
> -
> -       /* update rx crx */
> -       wmb();
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CRX, chan->rx_idx);
> -
> -       mtk_hsdma_chan_done(hsdma, chan);
> -}
> -
> -static void mtk_hsdma_tasklet(unsigned long arg)
> -{
> -       struct mtk_hsdam_engine *hsdma = (struct mtk_hsdam_engine *)arg;
> -
> -       mtk_hsdma_rx(hsdma);
> -       mtk_hsdma_tx(hsdma);
> -}
> -
> -static int mtk_hsdam_alloc_desc(struct mtk_hsdam_engine *hsdma,
> -                               struct mtk_hsdma_chan *chan)
> -{
> -       int i;
> -
> -       chan->tx_ring = dma_alloc_coherent(hsdma->ddev.dev,
> -                       2 * HSDMA_DESCS_NUM * sizeof(*chan->tx_ring),
> -                       &chan->desc_addr, GFP_ATOMIC | __GFP_ZERO);
> -       if (!chan->tx_ring)
> -               goto no_mem;
> -
> -       chan->rx_ring = &chan->tx_ring[HSDMA_DESCS_NUM];
> -
> -       /* init tx ring value */
> -       for (i = 0; i < HSDMA_DESCS_NUM; i++)
> -               chan->tx_ring[i].flags = HSDMA_DESC_LS0 | HSDMA_DESC_DONE;
> -
> -       return 0;
> -no_mem:
> -       return -ENOMEM;
> -}
> -
> -static void mtk_hsdam_free_desc(struct mtk_hsdam_engine *hsdma,
> -                               struct mtk_hsdma_chan *chan)
> -{
> -       if (chan->tx_ring) {
> -               dma_free_coherent(hsdma->ddev.dev,
> -                               2 * HSDMA_DESCS_NUM * sizeof(*chan->tx_ring),
> -                               chan->tx_ring, chan->desc_addr);
> -               chan->tx_ring = NULL;
> -               chan->rx_ring = NULL;
> -       }
> -}
> -
> -static int mtk_hsdma_init(struct mtk_hsdam_engine *hsdma)
> -{
> -       struct mtk_hsdma_chan *chan;
> -       int ret;
> -       u32 reg;
> -
> -       /* init desc */
> -       chan = &hsdma->chan[0];
> -       ret = mtk_hsdam_alloc_desc(hsdma, chan);
> -       if (ret)
> -               return ret;
> -
> -       /* tx */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_TX_BASE, chan->desc_addr);
> -       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CNT, HSDMA_DESCS_NUM);
> -       /* rx */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RX_BASE, chan->desc_addr +
> -                       (sizeof(struct hsdma_desc) * HSDMA_DESCS_NUM));
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CNT, HSDMA_DESCS_NUM);
> -       /* reset */
> -       mtk_hsdma_reset_chan(hsdma, chan);
> -
> -       /* enable rx intr */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, HSDMA_INT_RX_Q0);
> -
> -       /* enable dma */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, HSDMA_GLO_DEFAULT);
> -
> -       /* hardware info */
> -       reg = mtk_hsdma_read(hsdma, HSDMA_REG_INFO);
> -       dev_info(hsdma->ddev.dev, "rx: %d, tx: %d\n",
> -                (reg >> HSDMA_INFO_RX_SHIFT) & HSDMA_INFO_RX_MASK,
> -                (reg >> HSDMA_INFO_TX_SHIFT) & HSDMA_INFO_TX_MASK);
> -
> -       hsdma_dump_reg(hsdma);
> -
> -       return ret;
> -}
> -
> -static void mtk_hsdma_uninit(struct mtk_hsdam_engine *hsdma)
> -{
> -       struct mtk_hsdma_chan *chan;
> -
> -       /* disable dma */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_GLO_CFG, 0);
> -
> -       /* disable intr */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_INT_MASK, 0);
> -
> -       /* free desc */
> -       chan = &hsdma->chan[0];
> -       mtk_hsdam_free_desc(hsdma, chan);
> -
> -       /* tx */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_TX_BASE, 0);
> -       mtk_hsdma_write(hsdma, HSDMA_REG_TX_CNT, 0);
> -       /* rx */
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RX_BASE, 0);
> -       mtk_hsdma_write(hsdma, HSDMA_REG_RX_CNT, 0);
> -       /* reset */
> -       mtk_hsdma_reset_chan(hsdma, chan);
> -}
> -
> -static const struct of_device_id mtk_hsdma_of_match[] = {
> -       { .compatible = "mediatek,mt7621-hsdma" },
> -       { },
> -};
> -
> -static int mtk_hsdma_probe(struct platform_device *pdev)
> -{
> -       const struct of_device_id *match;
> -       struct mtk_hsdma_chan *chan;
> -       struct mtk_hsdam_engine *hsdma;
> -       struct dma_device *dd;
> -       struct resource *res;
> -       int ret;
> -       int irq;
> -       void __iomem *base;
> -
> -       ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> -       if (ret)
> -               return ret;
> -
> -       match = of_match_device(mtk_hsdma_of_match, &pdev->dev);
> -       if (!match)
> -               return -EINVAL;
> -
> -       hsdma = devm_kzalloc(&pdev->dev, sizeof(*hsdma), GFP_KERNEL);
> -       if (!hsdma) {
> -               dev_err(&pdev->dev, "alloc dma device failed\n");
> -               return -EINVAL;
> -       }
> -
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       base = devm_ioremap_resource(&pdev->dev, res);
> -       if (IS_ERR(base))
> -               return PTR_ERR(base);
> -       hsdma->base = base + HSDMA_BASE_OFFSET;
> -       tasklet_init(&hsdma->task, mtk_hsdma_tasklet, (unsigned long)hsdma);
> -
> -       irq = platform_get_irq(pdev, 0);
> -       if (irq < 0) {
> -               dev_err(&pdev->dev, "failed to get irq\n");
> -               return -EINVAL;
> -       }
> -       ret = devm_request_irq(&pdev->dev, irq, mtk_hsdma_irq,
> -                              0, dev_name(&pdev->dev), hsdma);
> -       if (ret) {
> -               dev_err(&pdev->dev, "failed to request irq\n");
> -               return ret;
> -       }
> -
> -       device_reset(&pdev->dev);
> -
> -       dd = &hsdma->ddev;
> -       dma_cap_set(DMA_MEMCPY, dd->cap_mask);
> -       dd->copy_align = HSDMA_ALIGN_SIZE;
> -       dd->device_free_chan_resources = mtk_hsdma_free_chan_resources;
> -       dd->device_prep_dma_memcpy = mtk_hsdma_prep_dma_memcpy;
> -       dd->device_terminate_all = mtk_hsdma_terminate_all;
> -       dd->device_tx_status = mtk_hsdma_tx_status;
> -       dd->device_issue_pending = mtk_hsdma_issue_pending;
> -       dd->dev = &pdev->dev;
> -       dd->dev->dma_parms = &hsdma->dma_parms;
> -       dma_set_max_seg_size(dd->dev, HSDMA_MAX_PLEN);
> -       INIT_LIST_HEAD(&dd->channels);
> -
> -       chan = &hsdma->chan[0];
> -       chan->id = 0;
> -       chan->vchan.desc_free = mtk_hsdma_desc_free;
> -       vchan_init(&chan->vchan, dd);
> -
> -       /* init hardware */
> -       ret = mtk_hsdma_init(hsdma);
> -       if (ret) {
> -               dev_err(&pdev->dev, "failed to alloc ring descs\n");
> -               return ret;
> -       }
> -
> -       ret = dma_async_device_register(dd);
> -       if (ret) {
> -               dev_err(&pdev->dev, "failed to register dma device\n");
> -               goto err_uninit_hsdma;
> -       }
> -
> -       ret = of_dma_controller_register(pdev->dev.of_node,
> -                                        of_dma_xlate_by_chan_id, hsdma);
> -       if (ret) {
> -               dev_err(&pdev->dev, "failed to register of dma controller\n");
> -               goto err_unregister;
> -       }
> -
> -       platform_set_drvdata(pdev, hsdma);
> -
> -       return 0;
> -
> -err_unregister:
> -       dma_async_device_unregister(dd);
> -err_uninit_hsdma:
> -       mtk_hsdma_uninit(hsdma);
> -       return ret;
> -}
> -
> -static int mtk_hsdma_remove(struct platform_device *pdev)
> -{
> -       struct mtk_hsdam_engine *hsdma = platform_get_drvdata(pdev);
> -
> -       mtk_hsdma_uninit(hsdma);
> -
> -       of_dma_controller_free(pdev->dev.of_node);
> -       dma_async_device_unregister(&hsdma->ddev);
> -
> -       return 0;
> -}
> -
> -static struct platform_driver mtk_hsdma_driver = {
> -       .probe = mtk_hsdma_probe,
> -       .remove = mtk_hsdma_remove,
> -       .driver = {
> -               .name = "hsdma-mt7621",
> -               .of_match_table = mtk_hsdma_of_match,
> -       },
> -};
> -module_platform_driver(mtk_hsdma_driver);
> -
> -MODULE_AUTHOR("Michael Lee <igvtee@gmail.com>");
> -MODULE_DESCRIPTION("MTK HSDMA driver");
> -MODULE_LICENSE("GPL v2");
>
>
