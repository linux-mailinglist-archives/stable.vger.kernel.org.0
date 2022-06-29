Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9DB55FEE4
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiF2LjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiF2LjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:39:03 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58253EF37;
        Wed, 29 Jun 2022 04:39:01 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7C14720002;
        Wed, 29 Jun 2022 11:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656502740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dp9QFpW9yNe+NuEsqLP3vN5J77NH2L3Sp/QQ3fi1Plo=;
        b=irYKoF7luqxuCRu/LpepIm6OPkZz2O+6DuLdjlpzAYM+vP3RhYyB5IpkbPA68aaRWQR/hQ
        efR55rMBzbX4Id3j+Icjvbo5vO1OB54vQUwgrf631lenO4can5f2GhtchFolRTHqMfuVIz
        ZSrvhbJ46Iojn3c1DtijNOVwus/pY81KBu2mcRU1BBKRYTfaJiMVrXKM1TA6qJUrxvrRWA
        CY4dpYQLZ8o20XFmfHEHLT2t7s9Q4Cc92ITAuXCrjaRWmjZ/GRRB9Ylb+IdRGl+S2lqZBr
        V7uvYJIVrrXqVzkgD20n5zy1b+3lPAXekAvuxG9xgo1L3FVBEMRBNr42wkYUDg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        miquel.raynal@bootlin.com, nagasure@xilinx.com, vigneshr@ti.com
Cc:     boris.brezillon@collabora.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@amd.com, richard@nod.at,
        amit.kumar-mahapatra@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mtd: rawnand: arasan: Update NAND bus clock instead of system clock
Date:   Wed, 29 Jun 2022 13:38:58 +0200
Message-Id: <20220629113859.283805-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628154824.12222-2-amit.kumar-mahapatra@xilinx.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'7499bfeedb47efc1ee4dc793b92c610d46e6d6a6'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-06-28 at 15:48:23 UTC, Amit Kumar Mahapatra wrote:
> In current implementation the Arasan NAND driver is updating the
> system clock(i.e., anand->clk) in accordance to the timing modes
> (i.e., SDR or NVDDR). But as per the Arasan NAND controller spec the
> flash clock or the NAND bus clock(i.e., nfc->bus_clk), need to be
> updated instead. This patch keeps the system clock unchanged and updates
> the NAND bus clock as per the timing modes.
> 
> Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
> CC: stable@vger.kernel.org # 5.8+
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
