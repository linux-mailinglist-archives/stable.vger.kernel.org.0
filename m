Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CF5111D37
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfLCWvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbfLCWvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C1A20848;
        Tue,  3 Dec 2019 22:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413475;
        bh=ghWIX+m6hgr7up8H2IEj/4iJDmGytA1qPuXv0RVTtfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdFccFMh26T3gwG6P9l7V8BQjoBMxhrK6Y8p8TRtmqeezdtb1cmCKz9SPra9hi9o0
         dMsB0pQaO12n9ws/4mZt7QitW86DgpUEM8hlhdAVemXR6RxuyF6gpBp2Udc10KU2G3
         gPQedOqP75DkFqBD8JBXmsIZKbgWeQtLv3rgT2lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/321] HID: doc: fix wrong data structure reference for UHID_OUTPUT
Date:   Tue,  3 Dec 2019 23:33:29 +0100
Message-Id: <20191203223434.597217255@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



