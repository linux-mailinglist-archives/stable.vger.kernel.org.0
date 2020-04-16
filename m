Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640BA1AC6CE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409250AbgDPN7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409043AbgDPN7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7F62078B;
        Thu, 16 Apr 2020 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045588;
        bh=gCFa4uuwm4XERH0jUZR1oplIf17Y25xXY4RyOKeKdfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJdOH8Skh/valhlFFREfGbz+o+ah2bz8K7Be8n9aBF8HjajvEgbKDeEm4fHxskMb3
         UFt9uw2gYD2j8YQmT3bft4dlGg943XJMMKP8n0B5BdSi8gQKc0uPlesvA3xh7vomJb
         9QlzzgTx4KlE7Q/tCr8pRb2jGOYWkWLXIcOZXNco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 197/254] selftests/powerpc: Add tlbie_test in .gitignore
Date:   Thu, 16 Apr 2020 15:24:46 +0200
Message-Id: <20200416131350.820126586@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 47bf235f324c696395c30541fe4fcf99fcd24188 upstream.

The commit identified below added tlbie_test but forgot to add it in
.gitignore.

Fixes: 93cad5f78995 ("selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/259f9c06ed4563c4fa4fa8ffa652347278d769e7.1582847784.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/powerpc/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/powerpc/mm/.gitignore
+++ b/tools/testing/selftests/powerpc/mm/.gitignore
@@ -6,3 +6,4 @@ segv_errors
 wild_bctr
 large_vm_fork_separation
 bad_accesses
+tlbie_test


