Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C53843A055
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhJYT3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235582AbhJYT2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F403E6108B;
        Mon, 25 Oct 2021 19:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189916;
        bh=HMlC0kyHkKpsgtW/taxnEk5MdFnACBK2zvKsMtI2K2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LbOtW6csYPLfKp2ja0Fk2Dvg63OLhMDM5FKm05gB9lRthHgOYjllsOolEwYg9bRn
         JqmHWyArU8yuwsunRovbFPF9YnhqVFkmPV/DEi8hFpqsaigSzYpx0BwmyS1Ja7lmrf
         ynge3MHhI+sLXn93sjxlX6LriQXB/hixY/f0zcKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 25/37] netfilter: Kconfig: use default y instead of m for bool config option
Date:   Mon, 25 Oct 2021 21:14:50 +0200
Message-Id: <20211025190933.275647478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>

commit 77076934afdcd46516caf18ed88b2f88025c9ddb upstream.

This option, NF_CONNTRACK_SECMARK, is a bool, so it can never be 'm'.

Fixes: 33b8e77605620 ("[NETFILTER]: Add CONFIG_NETFILTER_ADVANCED option")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -93,7 +93,7 @@ config NF_CONNTRACK_MARK
 config NF_CONNTRACK_SECMARK
 	bool  'Connection tracking security mark support'
 	depends on NETWORK_SECMARK
-	default m if NETFILTER_ADVANCED=n
+	default y if NETFILTER_ADVANCED=n
 	help
 	  This option enables security markings to be applied to
 	  connections.  Typically they are copied to connections from


