Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E30A3C51C7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349540AbhGLHna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347858AbhGLHkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 509DE61921;
        Mon, 12 Jul 2021 07:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075400;
        bh=SQQGPPye12kX22cjIWmNRAfoJrfFV/8baIFuMBw2IsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lyv9Y/SqLn9ix36rFF8MVrfgIYXBcO9PvrexfH74tdH8Fx+C0QbIm3ebEDEkrE4Iq
         heQQ/uL4X3oiD63fuB3Jvbusl11jjMpxhDnFK50PXuV8+dwp7s4XWb1dL3ueW8bKkK
         gQKiM02SBvOF0DTy7MANjiY1z7iPXtDDiiZyTnJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Borislav Petkov <bp@suse.de>, Tero Kristo <kristo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 209/800] EDAC/ti: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 12 Jul 2021 08:03:52 +0200
Message-Id: <20210712060942.793211971@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 0a37f32ba5272b2d4ec8c8d0f6b212b81b578f7e ]

The module misses MODULE_DEVICE_TABLE() for of_device_id tables and thus
never autoloads on ID matches.

Add the missing declaration.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Tero Kristo <kristo@kernel.org>
Link: https://lkml.kernel.org/r/20210512033727.26701-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ti_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/ti_edac.c b/drivers/edac/ti_edac.c
index e7eae20f83d1..169f96e51c29 100644
--- a/drivers/edac/ti_edac.c
+++ b/drivers/edac/ti_edac.c
@@ -197,6 +197,7 @@ static const struct of_device_id ti_edac_of_match[] = {
 	{ .compatible = "ti,emif-dra7xx", .data = (void *)EMIF_TYPE_DRA7 },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ti_edac_of_match);
 
 static int _emif_get_id(struct device_node *node)
 {
-- 
2.30.2



