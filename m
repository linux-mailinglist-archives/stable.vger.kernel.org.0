Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5C1F42C9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732163AbgFIRrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732156AbgFIRrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2299820812;
        Tue,  9 Jun 2020 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724867;
        bh=yoGrA38esDLQ8SgY4VYMWUjj6qYv8c6hWJsXS2aZk1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xX5CJsxp79PtGR2nsci9LrHj0JBK1fPqM1yBoLHFfHRCAMPJkvaOJmu5/i9Q5kTt4
         zUnZlOUqlgqFJDkJfZrrMxzjYo74DqYtdhYhE3XKOZ24sds0deJGhwufTRZMNaJXtg
         BWwowGx8GZsXeJZDB18oOCMrc+hWNwSRRbNRB8pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 14/42] HID: i2c-hid: add Schneider SCL142ALM to descriptor override
Date:   Tue,  9 Jun 2020 19:44:20 +0200
Message-Id: <20200609174017.028132158@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sax <jsbc@gmx.de>

commit 6507ef10660efdfee93f0f3b9fac24b5e4d83e56 upstream.

This device uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override list.

Cc: stable@vger.kernel.org
Signed-off-by: Julian Sax <jsbc@gmx.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -381,6 +381,14 @@ static const struct dmi_system_id i2c_hi
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "Schneider SCL142ALM",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SCHNEIDER"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SCL142ALM"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };
 


