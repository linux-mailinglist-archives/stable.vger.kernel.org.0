Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3106A7065
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfICQjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbfICQZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83AC22377B;
        Tue,  3 Sep 2019 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527954;
        bh=VUr8/gL+HwNDBli2Fr8nY5NVsSZHaE0f72ury9fFXfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Et7Q+O0X6m0ZczvgyvYdi6V894pTw8uZA/j0GeMkst25+W46Q1Nv/xrAP2PQCPllC
         dRR+BpV6XJFY8szimomAe/dPtrwoqOoz+pVRetiupm+MWb0XCIEvl8L5XmsEC7UfTP
         9nHQ2gtvoyMoI0yv39aUojhUc5374K07wHmchnLE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 020/167] Drivers: hv: kvp: Fix the indentation of some "break" statements
Date:   Tue,  3 Sep 2019 12:22:52 -0400
Message-Id: <20190903162519.7136-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit d544c22d6951be3386ac59bb9a99c9bc566b3f09 ]

No functional change.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_kvp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 57715a0c81202..a7513a8a8e372 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -420,7 +420,7 @@ kvp_send_key(struct work_struct *dummy)
 				UTF16_LITTLE_ENDIAN,
 				message->body.kvp_set.data.value,
 				HV_KVP_EXCHANGE_MAX_VALUE_SIZE - 1) + 1;
-				break;
+			break;
 
 		case REG_U32:
 			/*
@@ -456,7 +456,7 @@ kvp_send_key(struct work_struct *dummy)
 			UTF16_LITTLE_ENDIAN,
 			message->body.kvp_set.data.key,
 			HV_KVP_EXCHANGE_MAX_KEY_SIZE - 1) + 1;
-			break;
+		break;
 
 	case KVP_OP_DELETE:
 		message->body.kvp_delete.key_size =
@@ -466,12 +466,12 @@ kvp_send_key(struct work_struct *dummy)
 			UTF16_LITTLE_ENDIAN,
 			message->body.kvp_delete.key,
 			HV_KVP_EXCHANGE_MAX_KEY_SIZE - 1) + 1;
-			break;
+		break;
 
 	case KVP_OP_ENUMERATE:
 		message->body.kvp_enum_data.index =
 			in_msg->body.kvp_enum_data.index;
-			break;
+		break;
 	}
 
 	kvp_transaction.state = HVUTIL_USERSPACE_REQ;
-- 
2.20.1

