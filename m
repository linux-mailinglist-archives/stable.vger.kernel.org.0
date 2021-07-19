Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700223CE003
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345867AbhGSPNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344280AbhGSPLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:11:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C2161248;
        Mon, 19 Jul 2021 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709939;
        bh=MZJStAWkc9toouQJGxD6XdV11GOUg3Sb8Tk+To+341k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JxZAZ3FjLTHE4d9pyiGYTHbQ07bUXAgzgNHryYCkNwKdQ6jMnxHfnh8OuTtXz1Uq
         k6r1ADYGEBgi+IBA3UJqgSCEgeh+8u5uour3GGboCHZNXA11TjyzxtrQCKaO5CP4MQ
         U2KVVZHNVF+100qTkeOHBihf/Si9seph2HvY4mvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 001/243] certs: add x509_revocation_list to gitignore
Date:   Mon, 19 Jul 2021 16:50:30 +0200
Message-Id: <20210719144940.956376089@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 81f202315856edb75a371f3376aa3a47543c16f0 upstream.

Commit d1f044103dad ("certs: Add ability to preload revocation certs")
created a new generated file for revocation certs, but didn't tell git
to ignore it.  Thus causing unnecessary "git status" noise after a
kernel build with CONFIG_SYSTEM_REVOCATION_LIST enabled.

Add the proper gitignore magic.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 certs/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/certs/.gitignore
+++ b/certs/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 x509_certificate_list
+x509_revocation_list


