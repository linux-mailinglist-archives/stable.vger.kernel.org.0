Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9883CE5E8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347938AbhGSPzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350538AbhGSPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF9961370;
        Mon, 19 Jul 2021 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712208;
        bh=MZJStAWkc9toouQJGxD6XdV11GOUg3Sb8Tk+To+341k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLIr04Cju+50fKQNf+6XM92A55mScLyQ37gENNFmaONKkS+CZSc70UOdGS22KFfzG
         AsNUW1a8g9kXq9XbO68J7CAYvyp7IasKRpOie7LCrhh/QbndUTbecaJuwPV7jCv8Eh
         xDT0vhU4CPEO0rTUjJaCeH/kDRtDynNtYK3rhmv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 290/292] certs: add x509_revocation_list to gitignore
Date:   Mon, 19 Jul 2021 16:55:52 +0200
Message-Id: <20210719144952.447021987@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
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


