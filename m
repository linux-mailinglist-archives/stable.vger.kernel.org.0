Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5733AF0CD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhFUQxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhFUQu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 332EA6145F;
        Mon, 21 Jun 2021 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293305;
        bh=VWTWqWDThjyYacHVM/W8MTX4Ff57iC4zwzsQ9dpEVDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnD6t1g5NFmBMcWlj4WgFakf58vDtRarP+BEMJjEz/kQigelrYEngStDllfohkn3K
         yUhZLqmX1qTad4W6O/f+V+RB/f2XYJegj1InGiirQNV6IffeJlqeP7akcFv3oxhCSF
         BegQh8sllolPpJqCetcTrQGFTlSQ0DUKGDJmEhWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.12 176/178] perf beauty: Update copy of linux/socket.h with the kernel sources
Date:   Mon, 21 Jun 2021 18:16:30 +0200
Message-Id: <20210621154928.740864744@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
@@ -438,6 +438,4 @@ extern int __sys_socketpair(int family,
 			    int __user *usockvec);
 extern int __sys_shutdown_sock(struct socket *sock, int how);
 extern int __sys_shutdown(int fd, int how);
-
-extern struct ns_common *get_net_ns(struct ns_common *ns);
 #endif /* _LINUX_SOCKET_H */


