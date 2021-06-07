Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DD639E3B9
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhFGQ1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234017AbhFGQZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CAF76195C;
        Mon,  7 Jun 2021 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082569;
        bh=1FnxCJntlgt0Os8jcnbKPyGg0uGXabSxWSZ07gKkbqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhcsZSnbupvXD8/fjoKPl70n6OILDHDTX+g3FxcyjD1A0NLoNniMLG9Bdlbj2PJeJ
         eyDyqZ7ExGiKZ4ALOE20okuGToWJM00pqUhtBcBksbzvdQn+OhG6+vXRXwaQTe5Xjv
         v25RHpSNmtGyyBrFcH+XXdBz7LPtF66aOcnkz5NxmSMspgH25f4JahDqOoA+d9m8eO
         WU4thPaTgHnN2GnC+WCPK3T0E+weLcfdG3lGSpcgzo4Mq9kvGMXDmXNRkNeuaZkyZf
         EdQH/AOBlL+boJWbUNuS46aYHvT3PE5PUFalTU3rkgMiX/HupHtcEmbhkX8hOQObUi
         qyVaX2u4m66Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/14] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon,  7 Jun 2021 12:15:53 -0400
Message-Id: <20210607161605.3584954-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161605.3584954-1-sashal@kernel.org>
References: <20210607161605.3584954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bolhuis <mark@bolhuis.dev>

[ Upstream commit 48e33befe61a7d407753c53d1a06fc8d6b5dab80 ]

Add BUS_VIRTUAL to hid_connect logging since it's a valid hid bus type and it
should not print <UNKNOWN>

Signed-off-by: Mark Bolhuis <mark@bolhuis.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 25544a08fa83..1dd97f4b449a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1765,6 +1765,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	case BUS_I2C:
 		bus = "I2C";
 		break;
+	case BUS_VIRTUAL:
+		bus = "VIRTUAL";
+		break;
 	default:
 		bus = "<UNKNOWN>";
 	}
-- 
2.30.2

