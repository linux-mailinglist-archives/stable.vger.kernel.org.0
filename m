Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E412C0851
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732839AbgKWMsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732543AbgKWMr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F0CF20888;
        Mon, 23 Nov 2020 12:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135648;
        bh=rf5QMJSYPV/9FDEJvey6QY00M1CxwQUN3VoQf1f59yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP+S5cjDz87ZvKC6TAOway1Y/H0NKexq/2ev28ty3Sq/I8eKry10jQi+39osi9oxM
         KRVawu9nBCJbcrY2Y9VOZRmrm1NhFQYmv0qWtw6AePM2m1RdmrPu+Jqgo3S4S5U1Rr
         8jephrLINnazkwZYLYODeoVuLtToeU9op95iWVNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 114/252] kunit: tool: unmark test_data as binary blobs
Date:   Mon, 23 Nov 2020 13:21:04 +0100
Message-Id: <20201123121841.097007928@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit c335b4f1f65012713832d988ec06512c7bda5c04 ]

The tools/testing/kunit/test_data/ directory was marked as binary
because some of the test_data files cause checkpatch warnings. Fix this
by dropping the .gitattributes file.

Fixes: afc63da64f1e ("kunit: kunit_parser: make parser more robust")
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/.gitattributes | 1 -
 1 file changed, 1 deletion(-)
 delete mode 100644 tools/testing/kunit/.gitattributes

diff --git a/tools/testing/kunit/.gitattributes b/tools/testing/kunit/.gitattributes
deleted file mode 100644
index 5b7da1fc3b8f1..0000000000000
--- a/tools/testing/kunit/.gitattributes
+++ /dev/null
@@ -1 +0,0 @@
-test_data/* binary
-- 
2.27.0



