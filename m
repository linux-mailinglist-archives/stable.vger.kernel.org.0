Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7041DDBE1
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgEVAMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgEVAMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:30 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0809207D8;
        Fri, 22 May 2020 00:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106350;
        bh=0LPfxmMVx/cSro7gH6AFVxHi/2eAD0vndH0XWLTDbeg=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=cLAlhprsJBXGJrlglO4HXJB3XVVrp4nIFsGAe38uTHzgaujpBy29YrFJUWuubpZgT
         2KpjjG4ObFqmCaWAI2ztZNhtpazosJzimGmCGPxeQnPx+faBMt+wTsyiDOrHXrSyI2
         T9QaURz69Ws6IHE41A67H1eCexRh4V3DZPfjI3A0=
Date:   Fri, 22 May 2020 00:12:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
To:     <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 12/62] mtd: rawnand: diskonchip: Fix the probe error path
In-Reply-To: <20200519130035.1883-13-miquel.raynal@bootlin.com>
References: <20200519130035.1883-13-miquel.raynal@bootlin.com>
Message-Id: <20200522001229.D0809207D8@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources").

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Failed to apply! Possible dependencies:
    00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")

v4.14.180: Failed to apply! Possible dependencies:
    00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
    02f26ecf8c77 ("mtd: nand: add reworked Marvell NAND controller driver")
    1c782b9a8517 ("mtd: nand: mtk: change the compile sequence of mtk_nand.o and mtk_ecc.o")
    263c68afb521 ("mtd: nand: pxa3xx_nand: Update Kconfig information")
    34832dc44d44 ("mtd: nand: gpmi-nand: Remove wrong Kconfig help text")
    577e010c24bc ("mtd: rawnand: atmel: convert driver to nand_scan()")
    7928225ffcb3 ("mtd: rawnand: atmel: clarify NAND addition/removal paths")
    7cce5d835467 ("MAINTAINERS: mtd/nand: update Microchip nand entry")
    7da45139d264 ("mtd: rawnand: better name for the controller structure")
    93db446a424c ("mtd: nand: move raw NAND related code to the raw/ subdir")
    b4525db6f0c6 ("MAINTAINERS: Add entry for Marvell NAND controller driver")
    d7d9f8ec77fe ("mtd: rawnand: add NVIDIA Tegra NAND Flash controller driver")

v4.9.223: Failed to apply! Possible dependencies:
    00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
    24755a55b01f ("Documentation/00-index: update for new core-api folder")
    4ad4b21b1b81 ("docs-rst: convert usb docbooks to ReST")
    609f212f6a12 ("docs-rst: convert mtdnand book to ReST")
    66115335fbb4 ("docs: Fix build failure")
    7ddedebb03b7 ("ALSA: doc: ReSTize writing-an-alsa-driver document")
    8551914a5e19 ("ALSA: doc: ReSTize alsa-driver-api document")
    90f9f118b75c ("docs-rst: convert filesystems book to ReST")
    93dc3a112bf8 ("doc: Convert the debugobjects DocBook template to sphinx")
    c441a4781ff1 ("crypto: doc - remove crypto API DocBook")
    d6ba7a9c8b5a ("doc: Sphinxify the tracepoint docbook")
    e7f08ffb1855 ("Documentation/workqueue.txt: convert to ReST markup")
    f3fc83e55533 ("docs: Fix htmldocs build failure")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
