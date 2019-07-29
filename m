Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E574798FC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbfG2Tbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbfG2Tbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:31:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E5121773;
        Mon, 29 Jul 2019 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428704;
        bh=wplSXBTVma7MrVFbXRm589LGQUK/dpHSK1of8vGYDL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdGxoyoDtj0jhs5myYQ8UMiGp4iBZ/IY9Azf4lEkYDCX0WXKKioGWHOhKFINN5xS9
         H/3h3yOfxwhAidxvBvHFarWPQb0gbqsvbuaOqHn7b+xD+Q9Da0uvDF1t8I4EpTvCbY
         X2DM7CZl4O5dcHtmFDtdyxhVwRhObAtvOsL+KHBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 161/293] HID: wacom: correct touch resolution x/y typo
Date:   Mon, 29 Jul 2019 21:20:52 +0200
Message-Id: <20190729190836.885421469@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Armstrong Skomra <skomra@gmail.com>

commit 68c20cc2164cc5c7c73f8012ae6491afdb1f7f72 upstream.

This affects the 2nd-gen Intuos Pro Medium and Large
when using their Bluetooth connection.

Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3550,7 +3550,7 @@ int wacom_setup_touch_input_capabilities
 					     0, 5920, 4, 0);
 		}
 		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
-		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_Y, 40);
 
 		/* fall through */
 


