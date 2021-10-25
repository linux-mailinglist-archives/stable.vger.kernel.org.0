Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAE443A15B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhJYTiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235202AbhJYTbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0230C610F8;
        Mon, 25 Oct 2021 19:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190076;
        bh=bY6dMY975nx14Op7osXGDPWBnuIqKYBnpuewDahXsXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bqma55N+V9H/30v+ylJZuidUxsSLb4PCHRiG0nMixg56lyyO07SqavNtXTfsfCict
         ZkVsEz13YTs6mdtPoX/zEBjePUFHfxwyCZ7Hb+BAyGhoWzUOHWJ1KpL8aNbFKbIx1O
         /Msf28hh3XPZFZzdAxDjBXBZCzuchCtlFi3kpvuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 44/58] selftests: netfilter: remove stray bash debug line
Date:   Mon, 25 Oct 2021 21:15:01 +0200
Message-Id: <20211025190944.541183298@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
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
@@ -174,7 +174,6 @@ fi
 ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null
 if [ $? -ne 0 ];then
   echo "ERROR: ns1 cannot reach ns2" 1>&2
-  bash
   exit 1
 fi
 


