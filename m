Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5999A236E8
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbfETMRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732968AbfETMRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74817213F2;
        Mon, 20 May 2019 12:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354673;
        bh=47h56TplLtOuTZk9bZBytonkt83xqba2oE7Wh9cojE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hb7ZWNmX07XhqzsomIsMWJ1JkPRa7L6hKbtr4/ThUAxCLNMGP9NA/5YlG5zwrbCee
         UwNBIPxiKHDrE79U9ROQHNZEAHIS5QRojejIvT/7t1vTiu1JHlh1ztKZpg6qHD3r+g
         bpainBQOFU1MPd7xhhzfK12/leAyxTsikaPg2Vtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 24/44] mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L
Date:   Mon, 20 May 2019 14:14:13 +0200
Message-Id: <20190520115233.686875814@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
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


