Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F55D29BD80
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811103AbgJ0QhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801895AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 089AF24196;
        Tue, 27 Oct 2020 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813470;
        bh=AYKo494trzgMeRK2ETB3lzu2juyX0qX3zdZH46EToeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJspha+x3LLnR91AfWPBS+UYfFyFylpFUIFIKklELsMpWOXCK1T80hogUUBLOHxD3
         sh/xxJMBAhzs8Jd2OQPp1fvgg/Ndz47NatlKSC/RlZYuWf80RBrEuT/VFRbTh8MKxx
         SjoRQSMnwa/abLfn40w8kml+zah8S6w5pwWTJ2SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnny Chuang <johnny.chuang.emc@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 562/757] Input: elants_i2c - fix typo for an attribute to show calibration count
Date:   Tue, 27 Oct 2020 14:53:32 +0100
Message-Id: <20201027135516.858598531@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnny Chuang <johnny.chuang.emc@gmail.com>

[ Upstream commit 93f634069707cfe562c38739f5062feccbe9a834 ]

Fixed typo for command from 0xE0 to 0xD0.

Fixes: cf520c643012 ("Input: elants_i2c - provide an attribute to show calibration count")
Signed-off-by: Johnny Chuang <johnny.chuang.emc@gmail.com>
Link: https://lore.kernel.org/r/1600238783-32303-1-git-send-email-johnny.chuang.emc@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/elants_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
index b0bd5bb079bec..75b39ef39b743 100644
--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -90,7 +90,7 @@
 /* FW read command, 0x53 0x?? 0x0, 0x01 */
 #define E_ELAN_INFO_FW_VER	0x00
 #define E_ELAN_INFO_BC_VER	0x10
-#define E_ELAN_INFO_REK		0xE0
+#define E_ELAN_INFO_REK		0xD0
 #define E_ELAN_INFO_TEST_VER	0xE0
 #define E_ELAN_INFO_FW_ID	0xF0
 #define E_INFO_OSR		0xD6
-- 
2.25.1



