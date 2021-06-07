Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BAB39E25A
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhFGQQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhFGQPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E69613CA;
        Mon,  7 Jun 2021 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082409;
        bh=wLqUqQ5/Iqfc9Oy83QP6UppFMYb64xzebx6U2xVQono=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LouEEQCKHMIh2cQOmv19lZqo5yM7tBh2T1SkZCiTrkm9x6qeXSgDZ5yYozzAhiZ4l
         COOvMyt7MOHUbe2UrzqLTQnZwYcUJS2b8vJ04YBWUscA9o2J1AGU4v8AREgFUpVb6e
         CDqkgs7I8NMBSot/FQchvO+dcKbsSGMfxBV2l2CtrnFU/jP+BaAKRlvgnP4nRdPNf2
         dFF2Do2BwTuDu60Bhe3NniLso9U0Xt0PGcNrql6jclNDM6v1W5DjOKSZwc8WXG0CsZ
         na1j4zF4IA2wpDuGrgfAEvu8A7zjGEQhBvDWBMya3gMcbBH3BoG/3vcRdxYGDYrSCm
         H/eYr8ZliMJiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/39] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon,  7 Jun 2021 12:12:47 -0400
Message-Id: <20210607161318.3583636-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index 097cb1ee3126..0f69f35f2957 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2005,6 +2005,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
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

