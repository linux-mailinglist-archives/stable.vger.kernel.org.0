Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9812BA866
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgKTLHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbgKTLHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C848206E3;
        Fri, 20 Nov 2020 11:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870449;
        bh=Bq9fWJvn/ED3T15Rflhn21NOWgs4nQaVhL21aR20ux0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmvVpJtEdHyuGIVS/EP8vxNHLE3n7vfdaOSZlDz11s1VjiQHf1UGxBZbxYRUqYfOO
         1q2XnIo79UlX/LwTmJUHFQ/OSMRwmCeDEwown/Pfo3Cjy70oJmkYu9WgEzV6VCENr2
         J8mxkJhV26SLRO0G7P7WVLELtw6rMEbktykw1xIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.9 10/14] selftests/harness: prettify SKIP message whitespace again
Date:   Fri, 20 Nov 2020 12:03:48 +0100
Message-Id: <20201120104541.677544498@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

commit ef7086347c82c53a6c5238bd2cf31379f6acadde upstream.

Commit 9847d24af95c ("selftests/harness: Refactor XFAIL into SKIP")
replaced XFAIL with SKIP in the output. Add one more space to make the
output aligned and pretty again.

Fixes: 9847d24af95c ("selftests/harness: Refactor XFAIL into SKIP")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/kselftest_harness.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -126,7 +126,7 @@
 	snprintf(_metadata->results->reason, \
 		 sizeof(_metadata->results->reason), fmt, ##__VA_ARGS__); \
 	if (TH_LOG_ENABLED) { \
-		fprintf(TH_LOG_STREAM, "#      SKIP     %s\n", \
+		fprintf(TH_LOG_STREAM, "#      SKIP      %s\n", \
 			_metadata->results->reason); \
 	} \
 	_metadata->passed = 1; \


