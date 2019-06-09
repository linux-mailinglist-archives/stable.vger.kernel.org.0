Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64653A831
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbfFIQ5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733223AbfFIQ5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35AAC204EC;
        Sun,  9 Jun 2019 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099461;
        bh=47h56TplLtOuTZk9bZBytonkt83xqba2oE7Wh9cojE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nA/O8zC9JOlpiZUIm8xdm5+kYdGkf+Vz23kuZ6c3FLqqWDWsrsKu6T+1QOlwjE2DO
         crYX5ihWBF0AC6b7rRGJFuEfkdnFnOimcmqekTdf+XFHSLeLI3joOxkbgxqrm2pjej
         DYYODNUEWyuVaf7aI/BSP3lP/ReiSzL4owVOsXzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 014/241] mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L
Date:   Sun,  9 Jun 2019 18:39:16 +0200
Message-Id: <20190609164148.197045607@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

commit 6b4814a9451add06d457e198be418bf6a3e6a990 upstream.

Mismatch between what is found in the Datasheets for DA9063 and DA9063L
provided by Dialog Semiconductor, and the register names provided in the
MFD registers file. The changes are for the OTP (one-time-programming)
control registers. The two naming errors are OPT instead of OTP, and
COUNT instead of CONT (i.e. control).

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mfd/da9063/registers.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -215,9 +215,9 @@
 
 /* DA9063 Configuration registers */
 /* OTP */
-#define	DA9063_REG_OPT_COUNT		0x101
-#define	DA9063_REG_OPT_ADDR		0x102
-#define	DA9063_REG_OPT_DATA		0x103
+#define	DA9063_REG_OTP_CONT		0x101
+#define	DA9063_REG_OTP_ADDR		0x102
+#define	DA9063_REG_OTP_DATA		0x103
 
 /* Customer Trim and Configuration */
 #define	DA9063_REG_T_OFFSET		0x104


