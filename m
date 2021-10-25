Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991FC43A2F6
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhJYTzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238750AbhJYTve (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE00610CF;
        Mon, 25 Oct 2021 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190991;
        bh=JzAe8crW01rzHWg9TFoqmT9ua9HGs/dKKEYPC8vrt9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofJ2OGKS0emA5AbWe2FxKIei4o8Mmwgaee8lNpZ9i8r6wUrRaPYSiA2Muzct0en2O
         8vQDBdD6g1dpEaagB8Lf3MEkzEnZnu6Vk/AGCU3mkmkIvTCAWLjYe3ekzuTKb5YQRd
         7KaePS9H8PtDzo61VVyYPyU7r0YfMau2rDcZv1DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.14 119/169] selftests: netfilter: remove stray bash debug line
Date:   Mon, 25 Oct 2021 21:15:00 +0200
Message-Id: <20211025191033.008360955@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 3e6ed7703dae6838c104d73d3e76e9b79f5c0528 upstream.

This should not be there.

Fixes: 2de03b45236f ("selftests: netfilter: add flowtable test script")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -199,7 +199,6 @@ fi
 # test basic connectivity
 if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: ns1 cannot reach ns2" 1>&2
-  bash
   exit 1
 fi
 


