Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A223C507E1
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfFXKLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfFXKLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:11:15 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4EB205C9;
        Mon, 24 Jun 2019 10:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371075;
        bh=STyf2mCKGiFgwPWkKGI9MK04g+bNAfFarWWry+fjehA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMXuzBAcdcpA9ALhQ5VmNxVIDGuNMzwrgETQzNIDTT9PMac51jMAmP1PUMyKCzAIJ
         YGNDxNWoMbEV1hy10MjdzsEWMyKDUwmjy7yL4VsxRRiLFVtncJasAFTeZfrmlu/Hbk
         jMUE9X4urNrtEJubZ/l/cWvBAXJJAYzf84gYDboI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alakesh Haloi <alakesh.haloi@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 060/121] userfaultfd: selftest: fix compiler warning
Date:   Mon, 24 Jun 2019 17:56:32 +0800
Message-Id: <20190624092323.797917645@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



