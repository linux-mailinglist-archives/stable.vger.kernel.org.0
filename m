Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A596051B5AE
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiEECSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiEECSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:18:07 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C425F473B7;
        Wed,  4 May 2022 19:14:29 -0700 (PDT)
Received: from mercury.. (097-089-247-249.biz.spectrum.com [97.89.247.249])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7E6EE41074;
        Thu,  5 May 2022 02:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1651716867;
        bh=+kiBDwMB6jg1ZLP34LWc/QdKOZ0jnghNEem5EEnhQn4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=uCTsmAaHg3pZHCIoHwh1PerN6TKQySTQJErWCu3WbNYZFaaB+Sww+4ysi2GLTxMHu
         wWmTZ8xfYPfniONKZUXUqwfaESrvJkjmI9S2jl7Rqu5N6hBf7eYa0zEkXxhoWhlGRo
         lmtX258ZVX31vPlu74J1mFRnDbrJyQoKDPxO7i8pGkk2YeIrS8vxl8BlohMMilQYLF
         2xaUSUvMfHpbnq+YeSMHdzAZ4qcibs3l5E104DHuhnjLPI4WsZdlrp/lOu1oQES9ID
         O7Rc/eZimbhr5MFUDx+G1vKSfJT08iFmhLD6kN+4Zd8qcdiaiHfK//3Zgxb6bkglfx
         apWqV2p93AE6Q==
From:   Joseph Salisbury <joseph.salisbury@canonical.com>
To:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
Cc:     stable@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
Subject: [PATCH] docs: sched: Update sched-rt-group Documentation For Gender Inclusiveness
Date:   Wed,  4 May 2022 22:14:24 -0400
Message-Id: <20220505021424.12656-1-joseph.salisbury@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Document assumes root user is he:
"assumes root knows what he is doing."

Update documentation for inclusivness, since root is not limited by gender.

Fixes: 60aa605dfce2 ("sched: rt: document the risk of small values in the bandwidth settings")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
---
 Documentation/scheduler/sched-rt-group.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
index 655a096ec8fb..e55fee6772c4 100644
--- a/Documentation/scheduler/sched-rt-group.rst
+++ b/Documentation/scheduler/sched-rt-group.rst
@@ -19,7 +19,7 @@ Real-Time group scheduling
 ==========
 
  Fiddling with these settings can result in an unstable system, the knobs are
- root only and assumes root knows what he is doing.
+ root only and assumes root knows what they are doing.
 
 Most notable:
 
-- 
2.34.1

