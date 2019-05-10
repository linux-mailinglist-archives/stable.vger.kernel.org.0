Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9921A546
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 00:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfEJWeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 18:34:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43724 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfEJWet (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 18:34:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id t22so3645256pgi.10;
        Fri, 10 May 2019 15:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AfhCRsPrLO5ktBE/rlETYfGiAlxX8pGLDs/MHAUg5rk=;
        b=fCNC4W/cjYlgMJzEGkGLXK6D78Xo2g/Jig5kiGmVD3weaWs/+hwoggT9NO4Km20yq3
         oolVVCvUNiq3Lkivuy60B1i6AOP09D99pW6XFa18sfpAs4e/Ds9+7wr5jkwt/xGPXa8o
         eYxbheEJ49AvX/qyJnM3JqY0AuLQcb3H59lhUOVfc+fXdgWFiG3yYPKVG0yWmneKT9K6
         r0NwptthbKNIhxmCU5UbVNNfKem6FUdsU0Z5sW/xQMOW1lMRPrnamAl8wuYWAybmeBIj
         UqAFgX2RadfedGInVXiPZUaao7DzJYQmSa2pJwSci6Tjv3fTOP4gsHZtOlvtnvo3eKGi
         MhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AfhCRsPrLO5ktBE/rlETYfGiAlxX8pGLDs/MHAUg5rk=;
        b=tNkrkKSR6eBNpYNsBclRT+LKtKwk6rzjenOE1hhaHa0lvuOjp6fQM+AOWfxZWwdxDG
         9anDbyuj5LiLdmu28i74vT0wDTe+wX4fmkDERp6d6wuQHFCydQMiH1FEhVSjD8KM4r/2
         sne8CbmoHMiYQmbBtkRaaAqW2KhcvhBrDSf6/dbQA/Dd55ea4It/kSofxhHOrdnSsABW
         dIivEbcbI8gViMlxonr36hrX7qlQ/OHE3JEqysR7oRuCBt237feStTvbXszYXze76ljR
         H8/eZG+vI0oPHEay0lC+GS/Xm/SU6ncdatPahQ9Yi3RcSFgWWWcMxMQhj45Va7GE1HAX
         ijww==
X-Gm-Message-State: APjAAAVQtmZA+fHs9eXuNXPLJNQMIOicku3ytaWlnv+DXlZ2QNi+mG1u
        ieyBBGCwQF1Wsa9DJgsuS4Cs0wKz
X-Google-Smtp-Source: APXvYqzLHFSfSP02G7Z9v+xP60bPLlrp7WB9g68k3xFF+6oRPP/9XVwg9I2cPzgZC6qiFN6KsY+DZg==
X-Received: by 2002:aa7:96ec:: with SMTP id i12mr4891467pfq.82.1557527688660;
        Fri, 10 May 2019 15:34:48 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id n13sm7192405pgh.6.2019.05.10.15.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 May 2019 15:34:47 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, pinglinux@gmail.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 11+" <stable@vger.kernel.org>
Subject: [PATCH 3/4] HID: wacom: correct touch resolution x/y typo
Date:   Fri, 10 May 2019 15:34:18 -0700
Message-Id: <1557527659-9417-2-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557527659-9417-1-git-send-email-aaron.skomra@wacom.com>
References: <1557527659-9417-1-git-send-email-aaron.skomra@wacom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This affects the 2nd-gen Intuos Pro Medium and Large
when using their Bluetooth connection.

Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
---
 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index e172c7dda68c..447394cc4222 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3716,7 +3716,7 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 					     0, 5920, 4, 0);
 		}
 		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
-		input_abs_set_res(input_dev, ABS_MT_POSITION_X, 40);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_Y, 40);
 
 		/* fall through */
 
-- 
2.7.4

