Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDE1D03EA
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 02:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgEMAtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 20:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgEMAta (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 20:49:30 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBC8720675;
        Wed, 13 May 2020 00:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589330970;
        bh=9qJ5RZzzZN5GiUVZMI2CqHQ8Q47+EhKS8T5MvtvGDcM=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=nYMqoXjDwvpL3IIZTOdN5wy7fYYF5I/1uCimnRRLRbtn1lzjWFYL8bIjwY7PWE3Fe
         3CmcSnDOmf09YDghY91qKrJEjga17ku0MiB2088X3e4Z+QOzUpqrZOHn7DLKVFV6qP
         LqTa3Tz15BfjiV1ILuPWvcIkffDvJ4y5OLm4Pttg=
Date:   Wed, 13 May 2020 00:49:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 42/62] mtd: rawnand: plat_nand: Fix the probe error path
In-Reply-To: <20200510121220.18042-43-miquel.raynal@bootlin.com>
References: <20200510121220.18042-43-miquel.raynal@bootlin.com>
Message-Id: <20200513004929.DBC8720675@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources").

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Failed to apply! Possible dependencies:
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")

v4.14.179: Failed to apply! Possible dependencies:
    02f26ecf8c77 ("mtd: nand: add reworked Marvell NAND controller driver")
    256c4fc76a80 ("mtd: rawnand: add a way to pass an ID table with nand_scan()")
    39b77c586e17 ("mtd: rawnand: fsl_elbc: fix probe function error path")
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
    63fa37f0c512 ("mtd: rawnand: Replace printk() with appropriate pr_*() macro")
    97d90da8a886 ("mtd: nand: provide several helpers to do common NAND operations")
    98732da1a08e ("mtd: rawnand: do not export nand_scan_[ident|tail]() anymore")
    acfc33091f7a ("mtd: rawnand: fsl_ifc: fix probe function error path")

v4.9.222: Failed to apply! Possible dependencies:
    24755a55b01f ("Documentation/00-index: update for new core-api folder")
    4ad4b21b1b81 ("docs-rst: convert usb docbooks to ReST")
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
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
