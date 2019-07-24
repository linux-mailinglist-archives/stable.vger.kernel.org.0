Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA16273C92
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388650AbfGXUKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405164AbfGXT7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:59:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2EC206BA;
        Wed, 24 Jul 2019 19:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998369;
        bh=WPCgqJ0pKIDJfd6ZlFYpUpALSrpQnMx5dv8EiAtmfMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUvyf4yezXknSOflHDO2vCpx5OroAySG0ugNkgaBvbu95sCb+isxrg9Zg6zPYgz1c
         8upuELPRqLL8nsE5sLFk3V8le6tWokCDU2vcJndRYuRkRALVEATUzkQ3Lvp/NNWzmF
         v1E7KkMJS6XzsnreqDR12HJh36O4jmiIifkQkyFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.1 339/371] HID: wacom: correct touch resolution x/y typo
Date:   Wed, 24 Jul 2019 21:21:31 +0200
Message-Id: <20190724191749.197683004@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
@@ -3716,7 +3716,7 @@ int wacom_setup_touch_input_capabilities
 					     0, 5920, 4, 0);
 		}
 		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
-		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_Y, 40);
 
 		/* fall through */
 


