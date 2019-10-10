Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B206AD25B9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbfJJJCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733302AbfJJIkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735F621D56;
        Thu, 10 Oct 2019 08:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696803;
        bh=GTWgFHLwoXXGGIzbDDyDhmgz2NP0QKE5HFdI4syuReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTE7pgJN8a8gZ2i/yWiYEqayJJB3PPWxZgoXN/7uXpKGmURUo8G7F8rBqEYFn4IDJ
         kduXhbkP3zQQMCCBpMN1YNU3jviW5DQcB/hZjfKGsbAedLI3VmNePbXAySMSz72eHg
         X+Y4gRvWRC7fIRztuk0cxpEmp9D7xRVc11ZUz0t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.3 058/148] selftests: pidfd: Fix undefined reference to pthread_create()
Date:   Thu, 10 Oct 2019 10:35:19 +0200
Message-Id: <20191010083614.662526683@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 3969e76909d3aa06715997896184ee684f68d164 upstream.

Fix build failure:

undefined reference to `pthread_create'
collect2: error: ld returned 1 exit status

Fix CFLAGS to include pthread correctly.

Fixes: 740378dc7834 ("pidfd: add polling selftests")
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190924195237.30519-1-skhan@linuxfoundation.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/pidfd/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/pidfd/Makefile
+++ b/tools/testing/selftests/pidfd/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -g -I../../../../usr/include/ -lpthread
+CFLAGS += -g -I../../../../usr/include/ -pthread
 
 TEST_GEN_PROGS := pidfd_test pidfd_open_test
 


