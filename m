Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A0541F99D
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 06:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhJBEU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Oct 2021 00:20:57 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54897 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhJBEU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Oct 2021 00:20:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id E3135580F81;
        Sat,  2 Oct 2021 00:19:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 02 Oct 2021 00:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=XliFWXIjL29k8
        nU0RjgNu6OyBCt8KghjoRwqfcsYNzM=; b=buUJjmOBa1OZVow7BwEnPKxU3u6Q0
        yBlx2aCL5/sVxqhErLM0ij/EVVpdLjelPFepZ2gGwzB6Pl3qf13NPUJbLYZ3RfrD
        mohG+uPJn9G28qUSOzi7j8mS3Mmw+na5OGr/0sbkIai/FyfthfOm1tBPvS9AG5vd
        SX5xONoTogOjBhtc3/dM4tA8zUIqnSLFP/LRRSn0O3voF3W+izeF/wMJ7LhqCtl8
        yVHmLK5oBZ2y6NQBTt3Gj6RSre3V23sVx8Zdrg6IlVLzmYerpFu3G0FksUbSFYZO
        EjmYtVLzr9addiqvP8+4gdfS9ab3rLhPCX5B3r9H/OwBF4mJtdV13ZsjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XliFWXIjL29k8nU0RjgNu6OyBCt8KghjoRwqfcsYNzM=; b=uLzp6brD
        aQLKvEXiN90RDd8kVc49eJH4E3iAMnQrOpDnHFsKqp60kUoy0aAKr/dLJN27reMO
        E6jUrYrWcHbNxJRooXsLbesW8LoVxM5L12GwmgDskghGGl6bzonU751aD0pQIpU5
        ncIDfv5NW5ZS1wYvCvAlsbFZQ87S/q2QcAvu0Vgm9UkgYAmTPsIG4hLsOd+c4ZRR
        84ii7wAPkYibaKQExqtfBMxMYSrcdRGS0bwVQiMIJ6nXX2HenHmCtrnd+3xNTICf
        MfxLszSs8MkibthVCq+rM1SgVLI6dpFUGEbSjISjKGwzNlDmAOVy1SEXpdpV4g3f
        dhHrXM6XLcwgxA==
X-ME-Sender: <xms:v91XYReG1wThITEGaLlSKFAqqZHMovsgROQv5tJXJJmwDO9Ww9eJ9Q>
    <xme:v91XYfPdZomyB28SvBAf3csgt3HZfcKpcYUkt97Hz76wyAv5ia7Xy2b7BOfDlRKk-
    1hNlh71OVmDbehUVQ>
X-ME-Received: <xmr:v91XYagqmTmNIkZO0ImJnGigOytzaHavw7gKOrWKUntkTwz4_uoOWb--wNgsu1TEyeDBygYdYZUodwgDwTnfspGiHCAPMc3F4ZpKGahC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekjedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepufgrtghhihcumfhinhhguceonhgrkhgrthhosehnrghkrght
    ohdrihhoqeenucggtffrrghtthgvrhhnpedufeethfetgeektdeuvdetiefhteffuddule
    dukeektdfhtdefudeiheejgffhhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehnrghkrghtohesnhgrkhgrthhordhioh
X-ME-Proxy: <xmx:v91XYa-FTWor_WV_eNSCu1-cFJTkUv7L1sBb57M2TH_51boDkKezIg>
    <xmx:v91XYdvptCRGMHLxRtipD0R-g4Tvmr-XZ5oZRajlFPDkgZpM6wQB5A>
    <xmx:v91XYZHw7CvI0erGmsJJp8XVelL58gFPrkTR2tyEZKPLowsnEGeWTg>
    <xmx:v91XYTJwG-lXLRh6gjjQiMU_fex-92g6h-fpOgW_QzoWnJyxINZG4w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Oct 2021 00:19:07 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     Shyam-sundar.S-k@amd.com, hdegoede@redhat.com,
        mgross@linux.intel.com, mario.limonciello@amd.com,
        rafael@kernel.org, lenb@kernel.org
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Sachi King <nakato@nakato.io>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ACPI: PM: Include alternate AMDI0005 id in special behaviour
Date:   Sat,  2 Oct 2021 14:18:40 +1000
Message-Id: <20211002041840.2058647-2-nakato@nakato.io>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002041840.2058647-1-nakato@nakato.io>
References: <20211002041840.2058647-1-nakato@nakato.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Surface Laptop 4 AMD has used the AMD0005 to identify this
controller instead of using the appropriate ACPI ID AMDI0005.  The
AMD0005 needs the same special casing as AMDI0005.

Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Sachi King <nakato@nakato.io>
---
 drivers/acpi/x86/s2idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index bd92b549fd5a..1c48358b43ba 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -371,7 +371,7 @@ static int lps0_device_attach(struct acpi_device *adev,
 		return 0;
 
 	if (acpi_s2idle_vendor_amd()) {
-		/* AMD0004, AMDI0005:
+		/* AMD0004, AMD0005, AMDI0005:
 		 * - Should use rev_id 0x0
 		 * - function mask > 0x3: Should use AMD method, but has off by one bug
 		 * - function mask = 0x3: Should use Microsoft method
@@ -390,6 +390,7 @@ static int lps0_device_attach(struct acpi_device *adev,
 					ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
 					&lps0_dsm_guid_microsoft);
 		if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
+						 !strcmp(hid, "AMD0005") ||
 						 !strcmp(hid, "AMDI0005"))) {
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
-- 
2.33.0

