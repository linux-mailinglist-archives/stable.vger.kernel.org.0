Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2117E395CBE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhEaNhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhEaNfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE146143F;
        Mon, 31 May 2021 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467505;
        bh=5BAGGJiXLxcegIokpiVUMA9UTbznoTBcL431gAL3K2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YC6gb4B5hP6uPKwKzqKIRJ7wmrH0Wv4kuUoKZF6f1J9ucvUosI0h2184hYWyRY9gW
         E9vQMg4eh1p1pKnX2BqFb03IOqSDWIyM2ejirq77B++4q/QajUqRb/3cT6PPjgKuwX
         xRvfZD1KCXgeLJpXSb4YzAUyLjicJlLesnl8cqvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/116] platform/x86: hp-wireless: add AMDs hardware id to the supported list
Date:   Mon, 31 May 2021 15:14:26 +0200
Message-Id: <20210531130643.193706022@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit f048630bdd55eb5379ef35f971639fe52fabe499 ]

Newer AMD based laptops uses AMDI0051 as the hardware id to support the
airplane mode button. Adding this to the supported list.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20210514180047.1697543-1-Shyam-sundar.S-k@amd.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wireless.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
index d6ea5e998fb8..bb95bec0b110 100644
--- a/drivers/platform/x86/hp-wireless.c
+++ b/drivers/platform/x86/hp-wireless.c
@@ -30,12 +30,14 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Hung");
 MODULE_ALIAS("acpi*:HPQ6001:*");
 MODULE_ALIAS("acpi*:WSTADEF:*");
+MODULE_ALIAS("acpi*:AMDI0051:*");
 
 static struct input_dev *hpwl_input_dev;
 
 static const struct acpi_device_id hpwl_ids[] = {
 	{"HPQ6001", 0},
 	{"WSTADEF", 0},
+	{"AMDI0051", 0},
 	{"", 0},
 };
 
-- 
2.30.2



