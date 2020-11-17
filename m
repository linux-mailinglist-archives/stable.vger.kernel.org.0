Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D572B64E6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbgKQNuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732233AbgKQNcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1125A24199;
        Tue, 17 Nov 2020 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619923;
        bh=47IPrL0asU8oi80tS8IPYiYgSn7isRtz8jqSsZg4gV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7rmu4ZExZag3l/MwSkaYcmCC6v4kkK9emcNVhutd+hzdkVqlJiZZddm94CYlb4zA
         Lm83eX6ryV5VaX24fIRQ9ve1TSyeusuk9GkC4LrHsIP9Hyh5DffHy11sbZrOsy4Pm2
         hoVMbkmFbc7jsnWGOsez7ZFWqc/yk+6Q4vghdPaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 049/255] can: j1939: swap addr and pgn in the send example
Date:   Tue, 17 Nov 2020 14:03:09 +0100
Message-Id: <20201117122141.337663068@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

[ Upstream commit ea780d39b1888ed5afc243c29b23d9bdb3828c7a ]

The address was wrongly assigned to the PGN field and vice versa.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20201022083708.8755-1-yegorslists@googlemail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/j1939.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index f5be243d250a4..4b0db514b2010 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -414,8 +414,8 @@ Send:
 		.can_family = AF_CAN,
 		.can_addr.j1939 = {
 			.name = J1939_NO_NAME;
-			.pgn = 0x30,
-			.addr = 0x12300,
+			.addr = 0x30,
+			.pgn = 0x12300,
 		},
 	};
 
-- 
2.27.0



