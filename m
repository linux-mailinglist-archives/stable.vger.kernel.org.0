Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812843AEF20
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhFUQfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232849AbhFUQem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 252E9613B2;
        Mon, 21 Jun 2021 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292824;
        bh=PosM8L+FdB0ZjcnBTvnlLkr3NWSwXrYfA6I6BwB0pa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m31bbQP8akoBr9CxC7PwWgje+wcf6jxkm0vjSjEw1LtA+kfzfifjhQ3GpybaygpbX
         WCKk3QjzLC9RTIcxjlvAgyRvdbbTYkh7pPQG9ZGtMv2VFteRRR/2FVIE7/PY1nsPVy
         pvSY2fyw3yuT+2pO1htlU1LJDpeYCcCg/mlJNU2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 144/146] perf beauty: Update copy of linux/socket.h with the kernel sources
Date:   Mon, 21 Jun 2021 18:16:14 +0200
Message-Id: <20210621154920.761624594@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit ef83f9efe8461b8fd71eb60b53dbb6a5dd7b39e9 upstream.

To pick the changes in:

  ea6932d70e223e02 ("net: make get_net_ns return error if NET_NS is disabled")

That don't result in any changes in the tables generated from that
header.

This silences this perf build warning:

  Warning: Kernel ABI header at 'tools/perf/trace/beauty/include/linux/socket.h' differs from latest version at 'include/linux/socket.h'
  diff -u tools/perf/trace/beauty/include/linux/socket.h include/linux/socket.h

Cc: Changbin Du <changbin.du@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/trace/beauty/include/linux/socket.h |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -437,6 +437,4 @@ extern int __sys_getpeername(int fd, str
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
 extern int __sys_shutdown(int fd, int how);
-
-extern struct ns_common *get_net_ns(struct ns_common *ns);
 #endif /* _LINUX_SOCKET_H */


