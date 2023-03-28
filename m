Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61326CC44D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbjC1PDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjC1PDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61F2EC57
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFD261847
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ECFC433D2;
        Tue, 28 Mar 2023 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015713;
        bh=KASXsKcwhzOFvQl9CRD+V3oEgR7AUj1FxHxAfxlkrZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzu7fzzibV28k23tDBfntKwZenvQu3h2s1gIrrx75plbM+9gnHQcVMceFW76Zng8x
         bxrbGKy0EV1xProTnWmbbElEW/8B1Khr0aqgK40Rx8XhsDmQec7bbLNp0OgkwUkJzG
         lKkr1/+ATqnqpw6MDRJUnjpG14sPTb6wJ348wcZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duc Anh Le <lub.the.studio@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/224] ASoC: amd: yc: Add DMI entries to support HP OMEN 16-n0xxx (8A43)
Date:   Tue, 28 Mar 2023 16:41:54 +0200
Message-Id: <20230328142622.275048508@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duc Anh Le <lub.the.studio@gmail.com>

[ Upstream commit d52279d5c9204a041e9ba02a66a353573b2f96e4 ]

This model requires an additional detection quirk to enable the internal microphone.

Signed-off-by: Duc Anh Le <lub.the.studio@gmail.com>
Link: https://lore.kernel.org/r/20230227234921.7784-1-lub.the.studio@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4e681e9c08fe5..4a69ce702360c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -262,6 +262,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A43"),
+		}
+	},
 	{}
 };
 
-- 
2.39.2



