Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10A51DDBE6
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgEVAMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgEVAMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:36 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6231F2078B;
        Fri, 22 May 2020 00:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106355;
        bh=ZWMGGzyk42CdbQ1SRAFobbeWXiMO+xzwOTC2QljBBmA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=1ByJaNvNHuz81sYM6n6QAXcPkLp2RwedUt8japNZwYxZnloI5YcTViD3vwwioQkR5
         1D3iq4oDQFPGcygdogQKSO22nZHDxn9Co476nnTww+wgS+2eS6XnbnF5FREWttfH1C
         mudQ0dq4L1SOySA5Wo4gBvOkweuwIbrFCWdNy14w=
Date:   Fri, 22 May 2020 00:12:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
To:     <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 53/62] mtd: rawnand: sunxi: Fix the probe error path
In-Reply-To: <20200519130035.1883-54-miquel.raynal@bootlin.com>
References: <20200519130035.1883-54-miquel.raynal@bootlin.com>
Message-Id: <20200522001235.6231F2078B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 1fef62c1423b ("mtd: nand: add sunxi NAND flash controller support").

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Failed to apply! Possible dependencies:
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")

v4.14.180: Failed to apply! Possible dependencies:
    02f26ecf8c77 ("mtd: nand: add reworked Marvell NAND controller driver")
    256c4fc76a80 ("mtd: rawnand: add a way to pass an ID table with nand_scan()")
    39b77c586e17 ("mtd: rawnand: fsl_elbc: fix probe function error path")
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
    63fa37f0c512 ("mtd: rawnand: Replace printk() with appropriate pr_*() macro")
    97d90da8a886 ("mtd: nand: provide several helpers to do common NAND operations")
    98732da1a08e ("mtd: rawnand: do not export nand_scan_[ident|tail]() anymore")
    acfc33091f7a ("mtd: rawnand: fsl_ifc: fix probe function error path")

v4.9.223: Failed to apply! Possible dependencies:
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

v4.4.223: Failed to apply! Possible dependencies:
    2cca45574007 ("Merge tag 'topic/drm-misc-2016-06-07' of git://anongit.freedesktop.org/drm-intel into drm-next")
    47cb398dd75a ("Docs: sphinxify device-drivers.tmpl")
    4ad4b21b1b81 ("docs-rst: convert usb docbooks to ReST")
    59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
    5b996e93aac3 ("Documentation: include sync_file into DocBook")
    609f212f6a12 ("docs-rst: convert mtdnand book to ReST")
    90f9f118b75c ("docs-rst: convert filesystems book to ReST")
    eae1760fc838 ("doc: update/fixup dma-buf related DocBook")
    f3fc83e55533 ("docs: Fix htmldocs build failure")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
