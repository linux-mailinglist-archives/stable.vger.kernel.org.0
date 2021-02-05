Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454E31135E
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhBEVUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233051AbhBEPCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC5164FDD;
        Fri,  5 Feb 2021 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534193;
        bh=4kYIIM5cwZWMLwHxVu8MnUjgt8ay7iIp/3ZFIi4krDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mx6e/IAeqjuo9vc8YFpar6y0jooCKVUhH772TeNk2r0rkEsf5vAJvTXg3+vouP5fG
         aN1XA1NPDJQQnPB0STbW5n5g5w/GdCvYtEhTEk7xD1k8p+P11Q08XW7Nx+3qj08jCB
         utnlnNjbYbWIJz+TpJ9K+Y0M5D0YktDKgthK+8wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnold Gozum <arngozum@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/57] platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352
Date:   Fri,  5 Feb 2021 15:06:48 +0100
Message-Id: <20210205140656.925435764@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnold Gozum <arngozum@gmail.com>

[ Upstream commit fcd38f178b785623c0325958225744f0d8a075c0 ]

The Dell Inspiron 7352 is a 2-in-1 model that has chassis-type "Notebook".
Add this model to the dmi_switches_allow_list.

Signed-off-by: Arnold Gozum <arngozum@gmail.com>
Link: https://lore.kernel.org/r/20201226205307.249659-1-arngozum@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 65fb3a3031470..30a9062d2b4b8 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -216,6 +216,12 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Switch SA5-271"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7352"),
+		},
+	},
 	{} /* Array terminator */
 };
 
-- 
2.27.0



