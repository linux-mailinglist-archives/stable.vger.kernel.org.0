Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8342EE76
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbfE3Drl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732211AbfE3DUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:30 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A16248DD;
        Thu, 30 May 2019 03:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186429;
        bh=zcSDRYYANgVW+8OZycFrbRqXh96XqkgyNzMtKCFAmOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyDl1RZG2CMmMbRzKqkX69yHk2opdRChh+nh1fuW2NL209TLuOZwQ6xHI7HTXfc+B
         naBjXKkFb7CFz5ozXwR5Xn5xPDBElO5h0YjNN/dpJM4SAMvPrkbCX8SIipOHvjRmBF
         4bnSAWgfZ/mrWvuHM7yxVsscAmDVk3GDn8dIfrA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 020/128] perf tools: No need to include bitops.h in util.h
Date:   Wed, 29 May 2019 20:05:52 -0700
Message-Id: <20190530030438.446639479@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 6dcca6df4b73d409628c7b4464c63d4eb9d4d13a upstream.

When we switched to the kernel's roundup_pow_of_two we forgot to remove
this include from util.h, do it now.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Fixes: 91529834d1de ("perf evlist: Use roundup_pow_of_two")
Link: http://lkml.kernel.org/n/tip-kfye5rxivib6155cltx0bw4h@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[bwh: Backported to 4.9 as dependency of "tools include: Adopt linux/bits.h";
 adjusted context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/util.h |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -74,7 +74,6 @@
 #include <sys/ttydefaults.h>
 #include <api/fs/tracing_path.h>
 #include <termios.h>
-#include <linux/bitops.h>
 #include <termios.h>
 #include "strlist.h"
 


