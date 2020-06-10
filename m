Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5021D1F4B03
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 03:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgFJBmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 21:42:50 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:46482 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726016AbgFJBmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 21:42:50 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2020 21:42:49 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 9497E18021845
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 01:35:49 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5F1EB2E184;
        Wed, 10 Jun 2020 01:35:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:4321:5007:6119:7576:8957:10004:10400:10848:11232:11658:11914:12297:12555:12740:12760:12895:13069:13255:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:30054:30064:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: park07_140ccfa26dc7
X-Filterd-Recvd-Size: 1923
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jun 2020 01:35:47 +0000 (UTC)
Message-ID: <d086a1a412de3079cefbfb15f38c4dc9aae0045d.camel@perches.com>
Subject: Re: [PATCH v2] scripts/spelling: Recommend blocklist/allowlist
 instead of blacklist/whitelist
From:   Joe Perches <joe@perches.com>
To:     SeongJae Park <sjpark@amazon.com>, akpm@linux-foundation.org
Cc:     colin.king@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>
Date:   Tue, 09 Jun 2020 18:35:46 -0700
In-Reply-To: <20200609122549.26304-1-sjpark@amazon.com>
References: <20200609122549.26304-1-sjpark@amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-06-09 at 14:25 +0200, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
>
> This commit recommends the patches to replace 'blacklist' and
> 'whitelist' with the 'blocklist' and 'allowlist', because the new
> suggestions are incontrovertible, doesn't make people hurt, and more
> self-explanatory.

nack.  Spelling is for typos not for politics.

> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  scripts/spelling.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/spelling.txt b/scripts/spelling.txt
> index d9cd24cf0d40..ea785568d8b8 100644
> --- a/scripts/spelling.txt
> +++ b/scripts/spelling.txt
> @@ -230,6 +230,7 @@ beter||better
>  betweeen||between
>  bianries||binaries
>  bitmast||bitmask
> +blacklist||blocklist
>  boardcast||broadcast
>  borad||board
>  boundry||boundary
> @@ -1495,6 +1496,7 @@ whcih||which
>  whenver||whenever
>  wheter||whether
>  whe||when
> +whitelist||allowlist
>  wierd||weird
>  wiil||will
>  wirte||write

