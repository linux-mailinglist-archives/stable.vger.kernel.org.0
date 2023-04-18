Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110CD6E638C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjDRMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjDRMlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90F146CE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30B2F63321
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EC6C433D2;
        Tue, 18 Apr 2023 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821674;
        bh=4vCFgUB8dsAxZcLxVprlaGaNdhN18fWEIuBfIUnmKhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWr4Zx5LdjZ57bRPn+kBiuCgIVJJyonN1oK0oKEmrHaZQf9qXaAuH5w0GbIipCF9T
         IVIznjFxQqL5lDFwicJe0qZBLglz2wOq9ZFynDXasx5q2nJ/L8PILBi1NkzTDLXdPC
         A6SrAZjeUYvY4imrhsH3DGTv0AfK6TUViAnM1yLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yanteng Si <siyanteng@loongson.cn>,
        William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 5.15 90/91] counter: Add the necessary colons and indents to the comments of counter_compi
Date:   Tue, 18 Apr 2023 14:22:34 +0200
Message-Id: <20230418120308.680137501@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanteng Si <siyanteng01@gmail.com>

commit 0032ca576a79946492194ae4860b462d32815c66 upstream.

Since commit aaec1a0f76ec ("counter: Internalize sysfs interface code")
introduce a warning as:

linux-next/Documentation/driver-api/generic-counter:234: ./include/linux/counter.h:43: WARNING: Unexpected indentation.
linux-next/Documentation/driver-api/generic-counter:234: ./include/linux/counter.h:45: WARNING: Block quote ends without a blank line; unexpected unindent.

Add the necessary colons and indents.

Fixes: aaec1a0f76ec ("counter: Internalize sysfs interface code")
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Link: https://lore.kernel.org/r/26011e814d6eca02c7ebdbb92f171a49928a7e89.1640072891.git.vilhelm.gray@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/counter.h |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/include/linux/counter.h
+++ b/include/linux/counter.h
@@ -73,64 +73,64 @@ enum counter_synapse_action {
  * @type:		Counter component data type
  * @name:		device-specific component name
  * @priv:		component-relevant data
- * @action_read		Synapse action mode read callback. The read value of the
+ * @action_read:		Synapse action mode read callback. The read value of the
  *			respective Synapse action mode should be passed back via
  *			the action parameter.
- * @device_u8_read	Device u8 component read callback. The read value of the
+ * @device_u8_read:		Device u8 component read callback. The read value of the
  *			respective Device u8 component should be passed back via
  *			the val parameter.
- * @count_u8_read	Count u8 component read callback. The read value of the
+ * @count_u8_read:		Count u8 component read callback. The read value of the
  *			respective Count u8 component should be passed back via
  *			the val parameter.
- * @signal_u8_read	Signal u8 component read callback. The read value of the
+ * @signal_u8_read:		Signal u8 component read callback. The read value of the
  *			respective Signal u8 component should be passed back via
  *			the val parameter.
- * @device_u32_read	Device u32 component read callback. The read value of
+ * @device_u32_read:		Device u32 component read callback. The read value of
  *			the respective Device u32 component should be passed
  *			back via the val parameter.
- * @count_u32_read	Count u32 component read callback. The read value of the
+ * @count_u32_read:		Count u32 component read callback. The read value of the
  *			respective Count u32 component should be passed back via
  *			the val parameter.
- * @signal_u32_read	Signal u32 component read callback. The read value of
+ * @signal_u32_read:		Signal u32 component read callback. The read value of
  *			the respective Signal u32 component should be passed
  *			back via the val parameter.
- * @device_u64_read	Device u64 component read callback. The read value of
+ * @device_u64_read:		Device u64 component read callback. The read value of
  *			the respective Device u64 component should be passed
  *			back via the val parameter.
- * @count_u64_read	Count u64 component read callback. The read value of the
+ * @count_u64_read:		Count u64 component read callback. The read value of the
  *			respective Count u64 component should be passed back via
  *			the val parameter.
- * @signal_u64_read	Signal u64 component read callback. The read value of
+ * @signal_u64_read:		Signal u64 component read callback. The read value of
  *			the respective Signal u64 component should be passed
  *			back via the val parameter.
- * @action_write	Synapse action mode write callback. The write value of
+ * @action_write:		Synapse action mode write callback. The write value of
  *			the respective Synapse action mode is passed via the
  *			action parameter.
- * @device_u8_write	Device u8 component write callback. The write value of
+ * @device_u8_write:		Device u8 component write callback. The write value of
  *			the respective Device u8 component is passed via the val
  *			parameter.
- * @count_u8_write	Count u8 component write callback. The write value of
+ * @count_u8_write:		Count u8 component write callback. The write value of
  *			the respective Count u8 component is passed via the val
  *			parameter.
- * @signal_u8_write	Signal u8 component write callback. The write value of
+ * @signal_u8_write:		Signal u8 component write callback. The write value of
  *			the respective Signal u8 component is passed via the val
  *			parameter.
- * @device_u32_write	Device u32 component write callback. The write value of
+ * @device_u32_write:		Device u32 component write callback. The write value of
  *			the respective Device u32 component is passed via the
  *			val parameter.
- * @count_u32_write	Count u32 component write callback. The write value of
+ * @count_u32_write:		Count u32 component write callback. The write value of
  *			the respective Count u32 component is passed via the val
  *			parameter.
- * @signal_u32_write	Signal u32 component write callback. The write value of
+ * @signal_u32_write:		Signal u32 component write callback. The write value of
  *			the respective Signal u32 component is passed via the
  *			val parameter.
- * @device_u64_write	Device u64 component write callback. The write value of
+ * @device_u64_write:		Device u64 component write callback. The write value of
  *			the respective Device u64 component is passed via the
  *			val parameter.
- * @count_u64_write	Count u64 component write callback. The write value of
+ * @count_u64_write:		Count u64 component write callback. The write value of
  *			the respective Count u64 component is passed via the val
  *			parameter.
- * @signal_u64_write	Signal u64 component write callback. The write value of
+ * @signal_u64_write:		Signal u64 component write callback. The write value of
  *			the respective Signal u64 component is passed via the
  *			val parameter.
  */


