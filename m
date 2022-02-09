Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267864AFA63
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbiBIShA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiBISgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:36:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C59CC05CBA3;
        Wed,  9 Feb 2022 10:36:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F96861B38;
        Wed,  9 Feb 2022 18:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA17C340E9;
        Wed,  9 Feb 2022 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431792;
        bh=+Y2jXDovMWPwfVBxYPnVbiXJyF4dnYA52EIXfnkRdCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOBstf6VLLmB6yEnA49mh9vLyWfub/OYQfvTQRJOER0R+m6mAuvHRHzOi00AtvfAq
         2iqleoJux9Qp6dKe1hDwk9h/3sQZfSD4JSNENFlhMEFQk90Cp3dekrdJoG6hv7O323
         SbDVAK19PskMxrvTJByvQ2FjbcAuTK2b4xiMxUS6dqJGEp0nlAFyFay5DVIzYP2YvI
         UJ7ji6Bo1ow1dmGWe0+jilgbm3e97sH6FvIVM6MWkNVxQc/gPAXf+FXoQaLM5tPWUI
         Af58J5GOYW66CE8xQO1tKVKrpZK18P4aMh+bpfrS3RAyWQxGveicCYuQdLqqQqgFiQ
         WqGyiagJNbKPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        mkl@pengutronix.de, anup@brainfault.org, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org, quic_abhinavk@quicinc.com,
        willy@infradead.org, borntraeger@linux.ibm.com, alexs@kernel.org
Subject: [PATCH AUTOSEL 5.16 31/42] mailmap: update Christian Brauner's email address
Date:   Wed,  9 Feb 2022 13:33:03 -0500
Message-Id: <20220209183335.46545-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 1a2beb3d5a0b4051067ecf49ea799bee340e0e7c ]

At least one of the addresses will stop functioning after February.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .mailmap | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.mailmap b/.mailmap
index b344067e0acb6..3979fb166e0fd 100644
--- a/.mailmap
+++ b/.mailmap
@@ -74,6 +74,9 @@ Chris Chiu <chris.chiu@canonical.com> <chiu@endlessos.org>
 Christian Borntraeger <borntraeger@linux.ibm.com> <borntraeger@de.ibm.com>
 Christian Borntraeger <borntraeger@linux.ibm.com> <cborntra@de.ibm.com>
 Christian Borntraeger <borntraeger@linux.ibm.com> <borntrae@de.ibm.com>
+Christian Brauner <brauner@kernel.org> <christian@brauner.io>
+Christian Brauner <brauner@kernel.org> <christian.brauner@canonical.com>
+Christian Brauner <brauner@kernel.org> <christian.brauner@ubuntu.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
-- 
2.34.1

