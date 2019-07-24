Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB373989
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390114AbfGXTk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390109AbfGXTk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0184321873;
        Wed, 24 Jul 2019 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997257;
        bh=hTvctI67OAGel7Y/AmmJNfE8upZmcP/pqGiIw7yODSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXoTOEdAC+TPGmlLXPyAs8rrs2oS9USzvXh3UR7pDN2y0brxDFcKqnHOR5SfdhBkK
         s36aaazNUfJ4hGCxe29rMg42YGJixbjd/s72uF8vW+Wh88sBoEjZzlEvxdhNCVtWO0
         aNO3+GnWn+V3X8LN1QeEQtUVF90BUkBsL4eaz2hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.2 374/413] HID: wacom: correct touch resolution x/y typo
Date:   Wed, 24 Jul 2019 21:21:05 +0200
Message-Id: <20190724191801.994846662@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
@@ -3712,7 +3712,7 @@ int wacom_setup_touch_input_capabilities
 					     0, 5920, 4, 0);
 		}
 		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
-		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_Y, 40);
 
 		/* fall through */
 


