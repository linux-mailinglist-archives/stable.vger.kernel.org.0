Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753506A0A2C
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbjBWNNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbjBWNNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4681E56792
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2107D616E9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1351C433D2;
        Thu, 23 Feb 2023 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157964;
        bh=NKTH4M2ax1KxHTUI0B2E/lKLTxjp+3crXNaQFrPx5xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJMvIfSb8b+RDHgs1ex/xSWNwrezXDA5X/NyOs9p1EnrLkLdILArYb9n8okE5tn3D
         mfrPXOL+nl/ldtH9+xOKSNH61T7gBryV+O6Uh15aMh9Ttjkqe4cuPx+i+8r0pKegUR
         Ya9QTmE2TArL83H5OTHGW3/vusqJPNPoIohGEf+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 30/36] audit: update the mailing list in MAINTAINERS
Date:   Thu, 23 Feb 2023 14:07:06 +0100
Message-Id: <20230223130430.459656371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit 6c6cd913accd77008f74a1a9d57b816db3651daa upstream.

We've moved the upstream Linux Kernel audit subsystem discussions to
a new mailing list, this patch updates the MAINTAINERS info with the
new list address.

Marking this for stable inclusion to help speed uptake of the new
list across all of the supported kernel releases.  This is a doc only
patch so the risk should be close to nil.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3114,7 +3114,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git


