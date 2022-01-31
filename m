Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD544A42F2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiAaLPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:15:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47422 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiAaLOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC43A6114D;
        Mon, 31 Jan 2022 11:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86029C340E8;
        Mon, 31 Jan 2022 11:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627642;
        bh=4OSZBtWLrvk3XZbaNpArCk8kQ9Usrw+AeQKGcKTYR1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RV8tdSmzH0ew3IJmHEk7wlBODLd1RZUzZsJTKAElbLrkVDJDHO5uzKg6b7vmutYak
         qaFh0Uvf+iSB9QciltWr6Ve4Iy0c4geQNB5D2a5CkgBCaHW7niYz/wGMoCr0r5J4yr
         JZSC9dGocSHozXqLkrIjkVQgevV5x4Pdu9yZUCZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/171] Revert "drm/ast: Support 1600x900 with 108MHz PCLK"
Date:   Mon, 31 Jan 2022 11:56:56 +0100
Message-Id: <20220131105235.127760394@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 76cea3d95513fe40000d06a3719c4bb6b53275e2 ]

This reverts commit 9bb7b689274b67ecb3641e399e76f84adc627df1.

This caused a regression reported to Red Hat.

Fixes: 9bb7b689274b ("drm/ast: Support 1600x900 with 108MHz PCLK")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220120040527.552068-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_tables.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_tables.h b/drivers/gpu/drm/ast/ast_tables.h
index d9eb353a4bf09..dbe1cc620f6e6 100644
--- a/drivers/gpu/drm/ast/ast_tables.h
+++ b/drivers/gpu/drm/ast/ast_tables.h
@@ -282,8 +282,6 @@ static const struct ast_vbios_enhtable res_1360x768[] = {
 };
 
 static const struct ast_vbios_enhtable res_1600x900[] = {
-	{1800, 1600, 24, 80, 1000,  900, 1, 3, VCLK108,		/* 60Hz */
-	 (SyncPP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo), 60, 3, 0x3A },
 	{1760, 1600, 48, 32, 926, 900, 3, 5, VCLK97_75,		/* 60Hz CVT RB */
 	 (SyncNP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo |
 	  AST2500PreCatchCRT), 60, 1, 0x3A },
-- 
2.34.1



