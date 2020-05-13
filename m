Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C374C1D0A57
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 09:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgEMH7U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 13 May 2020 03:59:20 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:18811 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgEMH7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 03:59:20 -0400
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 6DAD7240011;
        Wed, 13 May 2020 07:59:17 +0000 (UTC)
Date:   Wed, 13 May 2020 09:59:15 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Richard Weinberger <richard@nod.at>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 12/62] mtd: rawnand: diskonchip: Fix the probe error
 path
Message-ID: <20200513095915.7f88d189@xps13>
In-Reply-To: <20200513004939.E8D1C23129@mail.kernel.org>
References: <20200510121220.18042-13-miquel.raynal@bootlin.com>
        <20200513004939.E8D1C23129@mail.kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Sasha Levin <sashal@kernel.org> wrote on Wed, 13 May 2020 00:49:39
+0000:

> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources").
> 
> The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222.
> 
> v5.6.11: Build OK!
> v5.4.39: Build OK!
> v4.19.121: Failed to apply! Possible dependencies:
>     00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
>     59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
> 
> v4.14.179: Failed to apply! Possible dependencies:
>     00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
>     02f26ecf8c77 ("mtd: nand: add reworked Marvell NAND controller driver")
>     1c782b9a8517 ("mtd: nand: mtk: change the compile sequence of mtk_nand.o and mtk_ecc.o")
>     263c68afb521 ("mtd: nand: pxa3xx_nand: Update Kconfig information")
>     34832dc44d44 ("mtd: nand: gpmi-nand: Remove wrong Kconfig help text")
>     577e010c24bc ("mtd: rawnand: atmel: convert driver to nand_scan()")
>     7928225ffcb3 ("mtd: rawnand: atmel: clarify NAND addition/removal paths")
>     7cce5d835467 ("MAINTAINERS: mtd/nand: update Microchip nand entry")
>     7da45139d264 ("mtd: rawnand: better name for the controller structure")
>     93db446a424c ("mtd: nand: move raw NAND related code to the raw/ subdir")
>     b4525db6f0c6 ("MAINTAINERS: Add entry for Marvell NAND controller driver")
>     d7d9f8ec77fe ("mtd: rawnand: add NVIDIA Tegra NAND Flash controller driver")
> 
> v4.9.222: Failed to apply! Possible dependencies:
>     00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
>     24755a55b01f ("Documentation/00-index: update for new core-api folder")
>     4ad4b21b1b81 ("docs-rst: convert usb docbooks to ReST")
>     609f212f6a12 ("docs-rst: convert mtdnand book to ReST")
>     66115335fbb4 ("docs: Fix build failure")
>     7ddedebb03b7 ("ALSA: doc: ReSTize writing-an-alsa-driver document")
>     8551914a5e19 ("ALSA: doc: ReSTize alsa-driver-api document")
>     90f9f118b75c ("docs-rst: convert filesystems book to ReST")
>     93dc3a112bf8 ("doc: Convert the debugobjects DocBook template to sphinx")
>     c441a4781ff1 ("crypto: doc - remove crypto API DocBook")
>     d6ba7a9c8b5a ("doc: Sphinxify the tracepoint docbook")
>     e7f08ffb1855 ("Documentation/workqueue.txt: convert to ReST markup")
>     f3fc83e55533 ("docs: Fix htmldocs build failure")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

I knew applying these patches would quickly be an issue, I think
having these backported to the latest kernels is enough.

Thanks,
Miquèl
