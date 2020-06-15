Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDAB1FA018
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 21:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgFOTYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 15:24:03 -0400
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:44374 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728093AbgFOTYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 15:24:03 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id A63731818F1C1;
        Mon, 15 Jun 2020 19:24:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3874:4321:5007:6119:7903:8603:10004:10400:10848:10967:11026:11232:11658:11914:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21627:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: push89_210d4b126df8
X-Filterd-Recvd-Size: 1648
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Mon, 15 Jun 2020 19:24:01 +0000 (UTC)
Message-ID: <7abefbc81fc6aaefed6bbd2117e7bc97b90babe9.camel@perches.com>
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for value
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 15 Jun 2020 12:24:00 -0700
In-Reply-To: <20200615151139.5cc223fc@oasis.local.home>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
         <159197539793.80267.10836787284189465765.stgit@devnote2>
         <20200615151139.5cc223fc@oasis.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-06-15 at 15:11 -0400, Steven Rostedt wrote:
> On Sat, 13 Jun 2020 00:23:18 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
[]
> > diff --git a/fs/proc/bootconfig.c b/fs/proc/bootconfig.c
[]
> > @@ -27,6 +27,7 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
> >  {
> >  	struct xbc_node *leaf, *vnode;
> >  	const char *val;
> > +	char q;
> >  	char *key, *end = dst + size;
> >  	int ret = 0;
> 
> Hmm, shouldn't the above have the upside-down xmas tree format?
> 
> 	struct xbc_node *leaf, *vnode;
> 	char *key, *end = dst + size;
> 	const char *val;
> 	char q;
> 	int ret = 0;

Please don't infect kernel sources with that style oddity.


