Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA7468F1
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfFNU3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfFNU3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:17 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C3022184D;
        Fri, 14 Jun 2019 20:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544157;
        bh=0gs+mJ6GRnFjxn0TGwgB/OBpyxDh7oPRNYR3bdnWLmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBinhT4HPwkGF8BEkym5FLve9VrPJz7QMh6hHGMmbiEiWdW1bTCXRbZ0W6WIiIBwZ
         qcO9TYsPRoenriP80mFAr7kJ1PVAAVvXsGZsuHqmo6bmNkbdE1clRXYN528Wpb64/2
         Qmw50+awBvxb1Si5UEieLSXT7fwyp8sL4m0sALag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alakesh Haloi <alakesh.haloi@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 31/59] userfaultfd: selftest: fix compiler warning
Date:   Fri, 14 Jun 2019 16:28:15 -0400
Message-Id: <20190614202843.26941-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alakesh Haloi <alakesh.haloi@gmail.com>

[ Upstream commit 98a13a8d253999cf25eb16d901c35fbd2a8455c4 ]

Fixes following compiler warning

userfaultfd.c: In function ‘usage’:
userfaultfd.c:126:2: warning: format not a string literal and no format
	arguments [-Wformat-security]
  fprintf(stderr, examples);

Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 5d1db824f73a..b3e6497b080c 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -123,7 +123,7 @@ static void usage(void)
 	fprintf(stderr, "Supported <test type>: anon, hugetlb, "
 		"hugetlb_shared, shmem\n\n");
 	fprintf(stderr, "Examples:\n\n");
-	fprintf(stderr, examples);
+	fprintf(stderr, "%s", examples);
 	exit(1);
 }
 
-- 
2.20.1

