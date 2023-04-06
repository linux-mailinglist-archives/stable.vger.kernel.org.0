Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4C46D9577
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbjDFLeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbjDFLd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:33:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A4A903D;
        Thu,  6 Apr 2023 04:32:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92A26468E;
        Thu,  6 Apr 2023 11:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B8BC433EF;
        Thu,  6 Apr 2023 11:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780737;
        bh=3dVPcMbV3ggeR+q8y8Q6SKl2kZ8tYqnwVf4u6VuwgMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evNZe6JZuWjAXOWba/SAjA/YbzEyN0H0zaR++yQRPCjQymFSbbWIiMiEcwK16BW0F
         JhI4M7NOgNqwbs+YBJsJ3in0+j8vo3lIKE8JmG4OCehAPuXXS4wgh4wZNG60Rc5WrQ
         u9MRI1v02FHuZXE0epZ+yMEPM6AVy8fxx+XXU4Vcl6XsXahyuUFSRHTL2ECLt58riZ
         RgJQKd/HvtnFjcPndDf7C3cagVbRDIbkExs1tZWCbArmA4xhFH0qFeCihFGBj2QXsZ
         rjGr+xKp9yuz7lhJzhwaxRPMQ429DEgsr8Oxyrz6wyXJzKZ8yygOf4DlpfoxgphbJK
         KKGb3fSipI13g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Crawford <frank@crawford.emu.id.au>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/17] platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2
Date:   Thu,  6 Apr 2023 07:31:57 -0400
Message-Id: <20230406113211.648424-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113211.648424-1-sashal@kernel.org>
References: <20230406113211.648424-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Crawford <frank@crawford.emu.id.au>

[ Upstream commit b7c994f8c35e916e27c60803bb21457bc1373500 ]

Add support for A320M-S2H V2.  Tested using module force_load option.

Signed-off-by: Frank Crawford <frank@crawford.emu.id.au>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230318091441.1240921-1-frank@crawford.emu.id.au
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 322cfaeda17ba..4dd39ab6ecfa2 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("A320M-S2H V2-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
-- 
2.39.2

