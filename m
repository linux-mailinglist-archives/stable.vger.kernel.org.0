Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D099D1060AB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKVFvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfKVFvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9B12071F;
        Fri, 22 Nov 2019 05:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401861;
        bh=ghWIX+m6hgr7up8H2IEj/4iJDmGytA1qPuXv0RVTtfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EHxdevvFPHBCNS5+gONhoZVNJAv+tbV3PmeFoFxKZMVrOJpO+zPrwvV4DPCwt55L
         bxuY5MAW/SZkTaztpmYaPa0WOkqXowP2u5MB5X0D6YMwZwt3J7i4A/cEDB0mWbZFI/
         NzpaX4fRT5O3sOat0oAyJGNWMw6hL3lEII7XVjiQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/219] HID: doc: fix wrong data structure reference for UHID_OUTPUT
Date:   Fri, 22 Nov 2019 00:47:09 -0500
Message-Id: <20191122054911.1750-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Hutterer <peter.hutterer@who-t.net>

[ Upstream commit 46b14eef59a8157138dc02f916a7f97c73b3ec53 ]

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hid/uhid.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/hid/uhid.txt b/Documentation/hid/uhid.txt
index c8656dd029a91..958fff9453044 100644
--- a/Documentation/hid/uhid.txt
+++ b/Documentation/hid/uhid.txt
@@ -160,7 +160,7 @@ them but you should handle them according to your needs.
   UHID_OUTPUT:
   This is sent if the HID device driver wants to send raw data to the I/O
   device on the interrupt channel. You should read the payload and forward it to
-  the device. The payload is of type "struct uhid_data_req".
+  the device. The payload is of type "struct uhid_output_req".
   This may be received even though you haven't received UHID_OPEN, yet.
 
   UHID_GET_REPORT:
-- 
2.20.1

