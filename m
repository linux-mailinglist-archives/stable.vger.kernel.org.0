Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A05635933
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbiKWKIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbiKWKHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:07:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1F921E04
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8795A61B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC07C433C1;
        Wed, 23 Nov 2022 09:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197472;
        bh=Pi1Rh5BKUq7UdB7u38NCY0wqfSGxl9jsX0lMoXfqTOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr5XRcyoGs2WB8WlDHj6hh1oP956jlvnQFXOcAT5qQjQsbiEvWKgmUhQMiN5XdDZA
         W43AOF7Kuj3NX/3SH8Jae0Vk02+R44SYuueUNgOXgZvZ+cKa+PPUhA6D7PdjKgi35S
         PN7XjVdJzpdnMOB+CpdVPUxWfiABEjUW5Fy2EWFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akira Yokosawa <akiyks@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.0 273/314] docs/driver-api/miscellaneous: Remove kernel-doc of serial_core.c
Date:   Wed, 23 Nov 2022 09:51:58 +0100
Message-Id: <20221123084637.902950494@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

commit 3ec17cb325ac731c2211e13f7eaa4b812694e218 upstream.

Since merge of tty-6.0-rc1, "make htmldocs" with Sphinx >=3.1 emits
a bunch of warnings indicating duplicate kernel-doc comments from
drivers/tty/serial/serial_core.c.

This is due to the kernel-doc directive for serial_core.c in
serial/drivers.rst added in the merge. It conflicts with an existing
kernel-doc directive in miscellaneous.rst.

Remove the latter directive and resolve the duplicates.

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 607ca0f742b7 ("Merge tag 'tty-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty")
Cc: stable@vger.kernel.org # 6.0
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/4e54c76a-138a-07e0-985a-dd83cb622208@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/miscellaneous.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/miscellaneous.rst b/Documentation/driver-api/miscellaneous.rst
index 304ffb146cf9..4a5104a368ac 100644
--- a/Documentation/driver-api/miscellaneous.rst
+++ b/Documentation/driver-api/miscellaneous.rst
@@ -16,12 +16,11 @@ Parallel Port Devices
 16x50 UART Driver
 =================
 
-.. kernel-doc:: drivers/tty/serial/serial_core.c
-   :export:
-
 .. kernel-doc:: drivers/tty/serial/8250/8250_core.c
    :export:
 
+See serial/driver.rst for related APIs.
+
 Pulse-Width Modulation (PWM)
 ============================
 
-- 
2.38.1



