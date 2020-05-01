Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610741C0C53
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgEACzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgEACzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:20 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 133B821582;
        Fri,  1 May 2020 02:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301720;
        bh=oFZv9k1d+TkXE+O4dFIDdGxn0iWkc4YpXMlP5o0fjeo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=TW6f1OpOFw30YGN3LcXC2lpAPVJJg3KBSifwtt/cTN3d/B8VvrclexdIbNDPsVpia
         aK5KkDS3y6szdTmMZ00DZKk0g6oCSwnY17FWzhyDSELipeiZHOkSXIuFAP60sWzRnX
         4vqh9ua2NYyamUESE1srbQQOegDk7uT/S4xglCVw=
Date:   Fri, 01 May 2020 02:55:19 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 3/9] mtd: rawnand: onfi: Fix redundancy detection check
In-Reply-To: <20200428094302.14624-4-miquel.raynal@bootlin.com>
References: <20200428094302.14624-4-miquel.raynal@bootlin.com>
Message-Id: <20200501025520.133B821582@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 39138c1f4a31 ("mtd: rawnand: use bit-wise majority to recover the ONFI param page").

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118.

v5.6.7: Build OK!
v5.4.35: Build OK!
v4.19.118: Failed to apply! Possible dependencies:
    0f808c1602bc ("mtd: rawnand: Pass a nand_chip object to chip->cmd_ctrl()")
    1c325cc5077a ("mtd: rawnand: Move ONFI code to nand_onfi.c")
    348d56a8c606 ("mtd: rawnand: Keep all internal stuff private")
    3d4af7c19585 ("mtd: rawnand: Move legacy code to nand_legacy.c")
    45240367939b ("mtd: rawnand: Deprecate ->{set,get}_features() hooks")
    47bd59e538d4 ("mtd: rawnand: plat_nand: Pass a nand_chip object to all platform_nand_ctrl hooks")
    716bbbabcc68 ("mtd: rawnand: Deprecate ->{read, write}_{byte, buf}() hooks")
    7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_xxx() hooks")
    82fc5099744e ("mtd: rawnand: Create a legacy struct and move ->IO_ADDR_{R, W} there")
    c0739d85723a ("mtd: rawnand: Pass a nand_chip object to chip->write_xxx() hooks")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
