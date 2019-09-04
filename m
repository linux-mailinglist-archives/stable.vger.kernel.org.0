Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935CEA8F77
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388620AbfIDSDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388063AbfIDSDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B32422CF7;
        Wed,  4 Sep 2019 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620228;
        bh=2JqQvux28qzqiQiG86sbz00E1q+ZPZB1ah/c7nNZNI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11GomNU5/K6vEBCxn+HbFlgu1cDnabug/gCXyJlgoHEfvd7+sEvVtXd77H8i8BO2w
         iarCa52MAQLcs3pOlegEoc2lj877duyYLvMFcQf1fOKNJhIJ4Yo7RsqbCHyYfov8KF
         eBC+KC2cSsBr4OQK7zyEhkI0h0E9L/GLPqkIOvd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.14 36/57] USB: storage: ums-realtek: Update module parameter description for auto_delink_en
Date:   Wed,  4 Sep 2019 19:54:04 +0200
Message-Id: <20190904175305.642752374@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f6445b6b2f2bb1745080af4a0926049e8bca2617 upstream.

The option named "auto_delink_en" is a bit misleading, as setting it to
false doesn't really disable auto-delink but let auto-delink be firmware
controlled.

Update the description to reflect the real usage of this parameter.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190827173450.13572-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/realtek_cr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -50,7 +50,7 @@ MODULE_LICENSE("GPL");
 
 static int auto_delink_en = 1;
 module_param(auto_delink_en, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(auto_delink_en, "enable auto delink");
+MODULE_PARM_DESC(auto_delink_en, "auto delink mode (0=firmware, 1=software [default])");
 
 #ifdef CONFIG_REALTEK_AUTOPM
 static int ss_en = 1;


