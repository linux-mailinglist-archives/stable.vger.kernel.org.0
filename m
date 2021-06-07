Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6430F39E1E1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhFGQOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhFGQOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341DF6135A;
        Mon,  7 Jun 2021 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082349;
        bh=wLqUqQ5/Iqfc9Oy83QP6UppFMYb64xzebx6U2xVQono=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHvO1AnjvgYJiYvNEa9rK43xwX8mn0oP34NBcAmsWjcFdVpAMo8AFzmjHzSoErRiM
         /BB7eekdcvqcVdTmCSr/P6mEqik5pTIghWLIB+D8QhFqRRfHXghZGggOjaapj1iucD
         c66py6T8Iaw+H6VkmBPf/E5i60U4Ye2kh+nw/kjEgq+9n5spSx2x4uCvxVqp9qn7Id
         IvPKlg4BgJcMWyAOdHI8QPQzwOfbfT0SFfmiwdx1W6vgCOuUrHe1jHhH+sINU21Ljc
         AdotdTXJCq4kmnqDTelkb5/vK647Mtz8syToIPsycD+4p+Hos5JXCSx2mCRMwDicZY
         E1SsreS+qJoPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 11/49] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon,  7 Jun 2021 12:11:37 -0400
Message-Id: <20210607161215.3583176-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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

