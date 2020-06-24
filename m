Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED2E2076B9
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404284AbgFXPH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404271AbgFXPHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E465FC061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so2634904wrc.7
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kSPgE+bGgsMdGhCfRjJWoo3vTL9/vYYp2AF2KnCRX7A=;
        b=BtZw33dNk6XR2atGnsBkwFUuIxaaSCIFGdnyixfM0UlnYDV3zzT6lb6+aa5UD58UCe
         tElHor7dZl5GsAKmFmBg3dY+AfhyaoGNRDv2IttT/kiYEg0K6OEVNIX2BjsVMyL6D1Vh
         pl74LjR7qUunaQwqNmFvpQ8M5npMEODYp/0U4aA7dzfTv0oXX9GuIPNlYKwdGJulKZNC
         xK911HEq5deWXhRuEJqGaat8+7llFxgHSGLbdqhi18VSQhB6s0rrfYtB0yK78ppQSKlp
         1mdd1eqdW9hbgOZwIWTNEFDWEsKFNNT8+oTEHAvTj92jtOvOonh5b99Z7mXBqFc9znrQ
         7Bow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSPgE+bGgsMdGhCfRjJWoo3vTL9/vYYp2AF2KnCRX7A=;
        b=i0MgcHNSRyPydv/z60a0/j/6hFBAakL5kR/5uHvUvRcGoRg+kJEvvjH/0iUgz9MqWZ
         BtdMHw3PMMQlLRQNgUB9Aya53PDSxQxdw5kJdhDhNjhW9y3xM9Q5YgJ+oZkM7JdyJIQY
         QVoPeyD5fYHq3q2bt0H1a8wU4deXRtI3eyfWSNIv7BD1QFrF2OrglWZKp+Tur7pl5B9H
         Xm11SjZUkOk/MGSdSPWFN0niVkMd2obvX7t7lOzVFNEhGdyw9LyEVWoIcnpkRp/c08K/
         c41XWDXuHXY/SWylAAgFBQd98HrQrDENbYYZDXoQ5aT5fyx4F4FB1DmeZ20WDB7bFkGa
         V+oA==
X-Gm-Message-State: AOAM531GFELmFZXn8DEI9iYC3CfNguAyFNgV4yvnClPGzBZ5xnDZ2JmE
        4VQghZsU8Dp3Gpf9+qDKjqcI7A==
X-Google-Smtp-Source: ABdhPJxdMcci8lbcX4ZJfwIvm45gJk47ZSdYDBO+zWr066+2R6dxBc4cWi4TqiTyAHdaGplxmjK/Kg==
X-Received: by 2002:adf:ff90:: with SMTP id j16mr17817455wrr.364.1593011243632;
        Wed, 24 Jun 2020 08:07:23 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        patches@opensource.cirrus.com
Subject: [PATCH 10/10] mfd: wm831x-core: Supply description wm831x_reg_{un}lock args
Date:   Wed, 24 Jun 2020 16:07:04 +0100
Message-Id: <20200624150704.2729736-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc syntax is used, but not complete.  Descriptions required.

Prevents warnings like:

 drivers/mfd/wm831x-core.c:119: warning: Function parameter or member 'wm831x' not described in 'wm831x_reg_lock'
 drivers/mfd/wm831x-core.c:145: warning: Function parameter or member 'wm831x' not described in 'wm831x_reg_unlock'

Cc: <stable@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.cirrus.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm831x-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 02f879b23d9f6..b0344e5353e4f 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -114,6 +114,8 @@ static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
  * The WM831x has a user key preventing writes to particularly
  * critical registers.  This function locks those registers,
  * allowing writes to them.
+ *
+ * @wm831x: pointer to local driver data structure
  */
 void wm831x_reg_lock(struct wm831x *wm831x)
 {
@@ -140,6 +142,8 @@ EXPORT_SYMBOL_GPL(wm831x_reg_lock);
  * The WM831x has a user key preventing writes to particularly
  * critical registers.  This function locks those registers,
  * preventing spurious writes.
+ *
+ * @wm831x: pointer to local driver data structure
  */
 int wm831x_reg_unlock(struct wm831x *wm831x)
 {
-- 
2.25.1

