Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC7B4BE1E5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348887AbiBUJXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349947AbiBUJVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5E336B7B;
        Mon, 21 Feb 2022 01:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8202E60B24;
        Mon, 21 Feb 2022 09:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65674C340E9;
        Mon, 21 Feb 2022 09:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434558;
        bh=vFB4jm4tqsqdEAJFExFocfMg7OTQmV4n+HJ+sHOMTG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lj2Nv2Fc9UekfqD/GuSkJ2U0FnJrJHVe2jaC8lXMxNxdWtW8FrHlSZbn+d24qMPU0
         cmcIA+YVttWZPwZGpo5iYFa+HizrZvTpGhb8EUqjwlLke48NDCt1qMTxDQ4Ape4qrr
         yodi23lBW7zyV0uNjwRJKE2HIU4Uh3VXVs5BdSQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 017/196] HID: amd_sfh: Correct the structure field name
Date:   Mon, 21 Feb 2022 09:47:29 +0100
Message-Id: <20220221084931.467387688@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit aa0b724a2bf041036e56cbb3b4b3afde7c5e7c9e upstream.

Misinterpreted intr_enable field name. Hence correct the structure
field name accordingly to reflect the functionality.

Fixes: f264481ad614 ("HID: amd_sfh: Extend driver capabilities for multi-generation support")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -48,7 +48,7 @@ union sfh_cmd_base {
 	} s;
 	struct {
 		u32 cmd_id : 4;
-		u32 intr_enable : 1;
+		u32 intr_disable : 1;
 		u32 rsvd1 : 3;
 		u32 length : 7;
 		u32 mem_type : 1;


