Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2002A0CD3
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 18:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgJ3Rtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 13:49:46 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:39904 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgJ3Rtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 13:49:46 -0400
Received: from relay5-d.mail.gandi.net (unknown [217.70.183.197])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id C63D43B15CE
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 17:27:37 +0000 (UTC)
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 0E27C1C0003;
        Fri, 30 Oct 2020 17:27:15 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sergei Antonov <saproj@gmail.com>, linux-mtd@lists.infradead.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, liang.yang@amlogic.com,
        stable@vger.kernel.org, jianxin.pan@amlogic.com
Subject: Re: [PATCH] mtd: meson: fix meson_nfc_dma_buffer_release() arguments
Date:   Fri, 30 Oct 2020 18:27:14 +0100
Message-Id: <20201030172714.29036-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201028094940.11765-1-saproj@gmail.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: db37c76e767a0d2de190959948099504c16b3e61
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-10-28 at 09:49:40 UTC, Sergei Antonov wrote:
> Arguments 'infolen' and 'datalen' to meson_nfc_dma_buffer_release() were mixed up.
> 
> Fixes: 8fae856c53500 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sergei Antonov <saproj@gmail.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
