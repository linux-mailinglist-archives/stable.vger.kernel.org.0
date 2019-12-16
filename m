Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0191217D8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfLPSDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbfLPSDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:03:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41CE720733;
        Mon, 16 Dec 2019 18:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519433;
        bh=QjRFcHf8Bi/1I3pfsuukgrDsxgYbyrHesBPlsk46Kqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5hWZG0AZJv3VSGMR84GFRErE3e8eB8pQ1839hbJAdwEwpJ6VfKipItrW3LJlo4RG
         dnWvnsLGwUAmzeSP8hqmycTwsdCPq7rieXa+V5Ib6WrRx7r9jS96xSgqnofbh9XXdX
         L0o3AYFydXhjiSTeU3Lb+qlSUWPiWm3v3DibO41A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jiunn Chang <c0d1n61at3@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 065/140] media: cec.h: CEC_OP_REC_FLAG_ values were swapped
Date:   Mon, 16 Dec 2019 18:48:53 +0100
Message-Id: <20191216174805.410177666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 806e0cdfee0b99efbb450f9f6e69deb7118602fc upstream.

CEC_OP_REC_FLAG_NOT_USED is 0 and CEC_OP_REC_FLAG_USED is 1, not the
other way around.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Jiunn Chang <c0d1n61at3@gmail.com>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/cec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -767,8 +767,8 @@ struct cec_event {
 #define CEC_MSG_SELECT_DIGITAL_SERVICE			0x93
 #define CEC_MSG_TUNER_DEVICE_STATUS			0x07
 /* Recording Flag Operand (rec_flag) */
-#define CEC_OP_REC_FLAG_USED				0
-#define CEC_OP_REC_FLAG_NOT_USED			1
+#define CEC_OP_REC_FLAG_NOT_USED			0
+#define CEC_OP_REC_FLAG_USED				1
 /* Tuner Display Info Operand (tuner_display_info) */
 #define CEC_OP_TUNER_DISPLAY_INFO_DIGITAL		0
 #define CEC_OP_TUNER_DISPLAY_INFO_NONE			1


