Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4164BE228
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245374AbiBUJss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:48:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352067AbiBUJrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B292A40A13;
        Mon, 21 Feb 2022 01:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48C3E60F54;
        Mon, 21 Feb 2022 09:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E281C340E9;
        Mon, 21 Feb 2022 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435139;
        bh=+Y2jXDovMWPwfVBxYPnVbiXJyF4dnYA52EIXfnkRdCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTPKvnOwIF6xWwIpFc1v9PVUmhmXWzNeWZN6+Y9TziCMuxqtdvTe5VBvNyK5kgvP8
         B0o1BknG8ISsLKllzujEfwNRaeWQK+34VisTNIgD704ogRdlODFDk7Y9AelLT1QSfo
         RhBjpf3eqE8pPPcFDq5/MLciVaPkA8uROw+UEy/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 059/227] mailmap: update Christian Brauners email address
Date:   Mon, 21 Feb 2022 09:47:58 +0100
Message-Id: <20220221084936.842816848@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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



