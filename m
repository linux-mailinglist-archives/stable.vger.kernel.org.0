Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1872D39E343
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhFGQWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhFGQUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843B8616EC;
        Mon,  7 Jun 2021 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082494;
        bh=kbQZK9mTHYLW8H7dpn1S/0EQM+NCx0gJV0DRioKLeQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkUOM94W0LvKLwmMKZrgqrEoF/VY9cKco68SWrBjRCIVQiOwAQyQo6mPuNnxtZEwZ
         CqE2znZXlBhdaSNVzJ2iUDQ0sn4hTfc8JW9BRB/+AbszV3O+wp1HsC5b7cUDtiMHC8
         z95bO0/3GuW2MSuPG6VK1g1l80W4WJl3dL+nD7kNqaOzIeLFh0V3pRxqHsAivbCfbW
         FwLVV3E1JNGJYB+5+LwRZfL4XDgs0Rj/UhUdb5vTe24ObK6JH0bNrDUJoB+mNTrOi2
         92vCyrTbmtvOG4n9vvBwXxpW4Gmlg/AXpB501XI/rewSl07WK3LqThjqj1eRuR9FnW
         jA3/qmEOiRtjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/21] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon,  7 Jun 2021 12:14:31 -0400
Message-Id: <20210607161448.3584332-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index 9b66eb1d42c2..acbbc21e6233 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1823,6 +1823,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
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

