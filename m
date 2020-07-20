Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3591226539
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbgGTPvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731285AbgGTPvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 342F0206E9;
        Mon, 20 Jul 2020 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260313;
        bh=2SI/obxwnO+F9HcxmYMvx5zfZB5dUmpSq9hdVd+K+0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3p5LuVwasnqcT82CRwuT74wjLAtk+allki5MV8FuXRsXVEgwvY1fNPz6cv1wIqwv
         yz7se1JeTOFf/GQePaqarfwPjMmBXdK+2ha26vzbGZyf1sWdbKUqMbHeTu6nOPOeuB
         EMnqccYkFKF5YhV5b2LAgdjxRIbx1Csz8txz5fD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoffer Nielsen <cn@obviux.dk>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/133] ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S
Date:   Mon, 20 Jul 2020 17:36:44 +0200
Message-Id: <20200720152806.481069031@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoffer Nielsen <cn@obviux.dk>

[ Upstream commit 73094608b8e214952444fb104651704c98a37aeb ]

Similar to the Kingston HyperX AMP, the Kingston HyperX Cloud
Alpha S (0951:0x16ea) uses two interfaces, but only the second
interface contains the capture stream. This patch delays the
registration until the second interface appears.

Signed-off-by: Christoffer Nielsen <cn@obviux.dk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAOtG2YHOM3zy+ed9KS-J4HkZo_QGzcUG9MigSp4e4_-13r6B=Q@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 15d7d1e92245c..e9ec6166acc65 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1528,6 +1528,7 @@ struct registration_quirk {
 static const struct registration_quirk registration_quirks[] = {
 	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
 	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
+	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
 	{ 0 }					/* terminator */
 };
 
-- 
2.25.1



