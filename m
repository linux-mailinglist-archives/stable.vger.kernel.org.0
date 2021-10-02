Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF741F99A
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 06:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhJBEUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Oct 2021 00:20:54 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:56705 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhJBEUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Oct 2021 00:20:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5C56C580F78;
        Sat,  2 Oct 2021 00:19:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 02 Oct 2021 00:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=DylGuvJdATMpY2rkZNSmEhOXei
        4V9ICF4PCv80+yHZU=; b=uQGVcLLvCwd9i2ayafKDsKP/VbvpMY+Sr6VU7RrtU+
        Jl6O1p94E67UPYEiY0oy+uf2iARPa65iLiQ80HIz73ToOYzyklY1J7qJf11Xadql
        mxjPY92QKBX7YkCkiHyIjE7JzMAUdso5B/xiKaLxND1sDQ8hmLDwQKBX+zRFV7R1
        nNCB3R5zQbslSfQg7UFLquu1WL9S77tZUfAPT438GLSJ1y2AfAJJzEBGxC52+tde
        l42DmwVL76xQinziGdP3IQWhx52Sk3eWWsflVxln5IwOxdAe60JHA3Hu+qpv8OFz
        46JKKi5RnYaJc96/YD9cDrr1o0pz+Ivhhr/RYrCa38Hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DylGuvJdATMpY2rkZ
        NSmEhOXei4V9ICF4PCv80+yHZU=; b=ualAtLYMQ2osHUxoNLlsPQ6qo0dffpcdi
        28MPCRVSz/kTzoCPFzzB9cSn+P2rJMztYJUWw8/xa4E2kirp9d94UKT6H2LWP472
        fPRX6v3mHkdnnLrG8ll3cCdV5EN/8GrCQrPKJ3bO0OHbnO+9ySncq5c81WunlmKk
        D6imId/DbyRe/hAqJc9twNhlUKxdi4khZIC2C7pHzppWt2oq4KgyAKNP0JFTgkaA
        ApZeunTwBe8rWM/Na7l9qmNTgG96R3o/fBkmJOPRkfwLatarp5gaLZuYvLUabnxo
        wlmyFIVgJyUD3MCRzTTS57FUdslAxW7sN016mAVCn9A1Iu4nEIIjA==
X-ME-Sender: <xms:ut1XYddSqXNoMVO768Tcq20_hyuY2qTBJJOXf_K_nQ2QvhWcsxx9dg>
    <xme:ut1XYbOLr3fwzj8Gv5cJyLYBgPxLpX5kqTwuZHRmjBgwKUzRI9GfYXW1aeE6mq-_K
    -eADjO6ssknOddXIw>
X-ME-Received: <xmr:ut1XYWilpaeajnW4vTwgdonpwR2Arlk9qu0KPPrIJsEqYqUEdRMTNZ90FSaSZNVt6DrypHQFbR4vnah0I1v5MlRLViLK0bKvg-wx5hAc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekjedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepufgrtghhihcumfhinhhguceonhgrkhgrthhosehnrghkrghtohdr
    ihhoqeenucggtffrrghtthgvrhhnpefgjeegieejleelkeeikefhleevudehheehgfeuud
    dtheetheetvddvfeehjeeitdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehnrghkrghtohesnhgrkhgrthhordhioh
X-ME-Proxy: <xmx:ut1XYW9J5iSh0hazEC7TruTGh9oIVZiSsYBgsZDGZ0DBeLeqKPrPkA>
    <xmx:ut1XYZvCnswo-3TCNR36AaZaIowRzOjq3pLi64w8beIY04-ai6vLUA>
    <xmx:ut1XYVG6OhSbyIm890ntqchOwhP8VjahjoekSzGWUUH_ZBiXC7qseg>
    <xmx:u91XYfKjbC5fQLJzo54mQ_9hwYDQHenk8KF9eysfy_M7YPhM0ln9xw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Oct 2021 00:19:02 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     Shyam-sundar.S-k@amd.com, hdegoede@redhat.com,
        mgross@linux.intel.com, mario.limonciello@amd.com,
        rafael@kernel.org, lenb@kernel.org
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Sachi King <nakato@nakato.io>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for PMC controller
Date:   Sat,  2 Oct 2021 14:18:39 +1000
Message-Id: <20211002041840.2058647-1-nakato@nakato.io>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Surface Laptop 4 AMD has used the AMD0005 to identify this
controller instead of using the appropriate ACPI ID AMDI0005.  Include
AMD0005 in the acpi id list.

Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Sachi King <nakato@nakato.io>
---
 drivers/platform/x86/amd-pmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index d6a7c896ac86..fc95620101e8 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -476,6 +476,7 @@ static const struct acpi_device_id amd_pmc_acpi_ids[] = {
 	{"AMDI0006", 0},
 	{"AMDI0007", 0},
 	{"AMD0004", 0},
+	{"AMD0005", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmc_acpi_ids);
-- 
2.33.0

