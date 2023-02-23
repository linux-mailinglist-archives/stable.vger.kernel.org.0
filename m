Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DF96A0994
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbjBWNIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbjBWNIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A3D28209
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D74CCE2026
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDABBC433D2;
        Thu, 23 Feb 2023 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157678;
        bh=IHGHq7o3RdIFyabZDAY0oXamIhW2ibTQzXDyEA2cSf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwxqpORuppuH/zC1Kj4bQEQbAICIyGql2ev9rs5PsPJCYM1C8WsoOFAAQryU1OFF0
         wjhodSp13OUuKD7RpHGQ2zHb1YCa7hdPIWFXkjCj2mJ4E7rI70vTyyiRarrg4mfYoX
         fdO5PA9kMhByDNclvL1nIdCxa8ugbnSgocR4iisI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 23/25] audit: update the mailing list in MAINTAINERS
Date:   Thu, 23 Feb 2023 14:06:40 +0100
Message-Id: <20230223130427.830990355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
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
@@ -3001,7 +3001,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git


