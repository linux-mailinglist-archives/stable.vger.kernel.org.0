Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1453541EB6
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382762AbiFGWdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385655AbiFGWbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7003C27B9A1;
        Tue,  7 Jun 2022 12:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C159609D0;
        Tue,  7 Jun 2022 19:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F770C385A2;
        Tue,  7 Jun 2022 19:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629913;
        bh=WzfUMMZDGJGJSNtqrDv32v58DBuYIdaIuwsPM1Gnm3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G64+gvlabjOFLG26rxEoSzplc+DmipXXvkUf/evn9GRB0RtmQ4GV9JxQqN8suSUEP
         oB0CBFvXkWzkoocMjtx0kuOeIVcuex7pp/l1ik79Mup43KFPZ7+2BagM4QCCttIfQt
         7zqzjAeke5TUf5zAu29cy0Piw+xE0IFO7aiMxmBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.18 863/879] media: lirc: add missing exceptions for lirc uapi header file
Date:   Tue,  7 Jun 2022 19:06:21 +0200
Message-Id: <20220607165027.904324404@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit b1c8312c6bd70e2c41f96183936fdb6f4f07cc0e upstream.

Commit e5499dd7253c ("media: lirc: revert removal of unused feature
flags") reintroduced unused feature flags in the lirc uapi header, but
failed to reintroduce the necessary exceptions for the docs.

Fixes: e5499dd7253c ("media: lirc: revert removal of unused feature flags")
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/userspace-api/media/lirc.h.rst.exceptions | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/userspace-api/media/lirc.h.rst.exceptions b/Documentation/userspace-api/media/lirc.h.rst.exceptions
index 913d17b49831..1aeb7d7afe13 100644
--- a/Documentation/userspace-api/media/lirc.h.rst.exceptions
+++ b/Documentation/userspace-api/media/lirc.h.rst.exceptions
@@ -30,6 +30,8 @@ ignore define LIRC_CAN_REC
 
 ignore define LIRC_CAN_SEND_MASK
 ignore define LIRC_CAN_REC_MASK
+ignore define LIRC_CAN_SET_REC_FILTER
+ignore define LIRC_CAN_NOTIFY_DECODE
 
 # Obsolete ioctls
 
-- 
2.36.1



