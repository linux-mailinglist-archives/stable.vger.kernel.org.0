Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B6A17F9DB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgCJNAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730147AbgCJNAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:00:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5F32468D;
        Tue, 10 Mar 2020 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845232;
        bh=B9PFaMli9uM7nog+zc9NrAEfWprE6fi05I1j4+vXZ8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyuiLthmImV3ug86h9fvjsKwucyM7N0ui18Ve8th86nTaYVrl0snK8aAOyiUv1yqp
         kV6IYD+enhT0vsJfpl0+NiLmTiZqsREgtYC7cLBs1wX+6kPCq4znN3z54L0gWJDKe3
         C9AffPC4/ir19bQWv253tfrHfFLDtm1Mlhe+hEZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.5 108/189] selftests: pidfd: Add pidfd_fdinfo_test in .gitignore
Date:   Tue, 10 Mar 2020 13:39:05 +0100
Message-Id: <20200310123650.629562564@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 186e28a18aeb0fec99cc586fda337e6b23190791 upstream.

The commit identified below added pidfd_fdinfo_test
but failed to add it to .gitignore

Fixes: 2def297ec7fb ("pidfd: add tests for NSpid info in fdinfo")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/966567c7dbaa26a06730d796354f8a086c0ee288.1582847778.git.christophe.leroy@c-s.fr
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/pidfd/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/pidfd/.gitignore
+++ b/tools/testing/selftests/pidfd/.gitignore
@@ -2,3 +2,4 @@ pidfd_open_test
 pidfd_poll_test
 pidfd_test
 pidfd_wait
+pidfd_fdinfo_test


