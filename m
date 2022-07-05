Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F387566D9F
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbiGEM04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiGEMZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFFE1B7AF;
        Tue,  5 Jul 2022 05:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 269A761983;
        Tue,  5 Jul 2022 12:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACA3C341C7;
        Tue,  5 Jul 2022 12:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023455;
        bh=E/RhKELd2XMIJKei+fQXXP00rg8+FgoKBR2TNdH2JsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4d7+8yjAf2/XQJT3UrtyEXmZ1y6L8OIBXRks/UoBKAzb5X6ZyTkw6SomTJw92O2c
         K67vd/X6KhLqpbYSx8m1pqEtSuVbjkw3icvuOIk035sSZQEbfg/if9cEDo7/aoPaUY
         uqexbN3xe4WUfN19yBJEYZtb3szwwZSvoUBu2O/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.18 065/102] platform/x86: ideapad-laptop: Add Ideapad 5 15ITL05 to ideapad_dytc_v4_allow_table[]
Date:   Tue,  5 Jul 2022 13:58:31 +0200
Message-Id: <20220705115620.251879929@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 8853e8ce9b576e0a3aad8381e19a117964d445fa upstream.

The Ideapad 5 15ITL05 uses DYTC version 4 for platform-profile
control. This has been tested successfully with the ideapad-laptop
DYTC version 5 code; Add the Ideapad 5 15ITL05 to the
ideapad_dytc_v4_allow_table[].

Fixes: 599482c58ebd ("platform/x86: ideapad-laptop: Add platform support for Ideapad 5 Pro 16ACH6-82L5")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213297
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220627130850.313537-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -871,12 +871,18 @@ static void dytc_profile_refresh(struct
 static const struct dmi_system_id ideapad_dytc_v4_allow_table[] = {
 	{
 		/* Ideapad 5 Pro 16ACH6 */
-		.ident = "LENOVO 82L5",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82L5")
 		}
 	},
+	{
+		/* Ideapad 5 15ITL05 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "IdeaPad 5 15ITL05")
+		}
+	},
 	{}
 };
 


