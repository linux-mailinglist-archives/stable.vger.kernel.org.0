Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CAD28B6DA
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgJLNiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbgJLNh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB8720838;
        Mon, 12 Oct 2020 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509844;
        bh=lMHk6vGMQm8emrttKTj9eLIguT4SBsKvtAze+o64K4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPihAtvwFuPLhhO1xEZYDGyQSDtdS5PlVNb3Ck53txv0Pr0gyB3RUfxqM1z611Sbw
         5U6MgXlXB8q6yV0MZMXw9UEPWOyUjdJiDEe24FYobopEyZrrEisdw9XSv+OYj7m9wL
         /LibMMwOCM3c83pFprAkTTMtK6wRC1ewkd7ZVZ9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Harry Cutts <hcutts@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/70] Input: trackpoint - enable Synaptics trackpoints
Date:   Mon, 12 Oct 2020 15:26:39 +0200
Message-Id: <20201012132631.334250451@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Huang <vincent.huang@tw.synaptics.com>

[ Upstream commit 996d585b079ad494a30cac10e08585bcd5345125 ]

Add Synaptics IDs in trackpoint_start_protocol() to mark them as valid.

Signed-off-by: Vincent Huang <vincent.huang@tw.synaptics.com>
Fixes: 6c77545af100 ("Input: trackpoint - add new trackpoint variant IDs")
Reviewed-by: Harry Cutts <hcutts@chromium.org>
Tested-by: Harry Cutts <hcutts@chromium.org>
Link: https://lore.kernel.org/r/20200924053013.1056953-1-vincent.huang@tw.synaptics.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/trackpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index d68aba9c5dd62..673bfbb01ca2e 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -297,6 +297,8 @@ static int trackpoint_start_protocol(struct psmouse *psmouse,
 	case TP_VARIANT_ALPS:
 	case TP_VARIANT_ELAN:
 	case TP_VARIANT_NXP:
+	case TP_VARIANT_JYT_SYNAPTICS:
+	case TP_VARIANT_SYNAPTICS:
 		if (variant_id)
 			*variant_id = param[0];
 		if (firmware_id)
-- 
2.25.1



