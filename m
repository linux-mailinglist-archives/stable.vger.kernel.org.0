Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A781FA817
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 07:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFPFF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 01:05:28 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:48522 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726052AbgFPFF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 01:05:28 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id BC50112150A;
        Tue, 16 Jun 2020 05:05:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2731:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:9025:9040:10004:10400:10848:10967:11232:11658:11914:12043:12297:12555:12740:12760:12895:13069:13311:13357:13439:13845:14181:14659:14721:21080:21627:21740:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bite75_290569326dfc
X-Filterd-Recvd-Size: 1972
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Tue, 16 Jun 2020 05:05:26 +0000 (UTC)
Message-ID: <ac93acd4f757f3286f7782ad7c8117a6ad224b5c.camel@perches.com>
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for value
From:   Joe Perches <joe@perches.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 15 Jun 2020 22:05:25 -0700
In-Reply-To: <a3cbc2cf-7371-3e2b-e794-4fbfc52aaad9@infradead.org>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
         <159197539793.80267.10836787284189465765.stgit@devnote2>
         <20200615151139.5cc223fc@oasis.local.home>
         <7abefbc81fc6aaefed6bbd2117e7bc97b90babe9.camel@perches.com>
         <20200615172123.1fe77f3c@oasis.local.home>
         <ddb4adb9-bf01-abd4-38dd-d6d064569d6e@infradead.org>
         <20200615184218.752a17fa@oasis.local.home>
         <a3cbc2cf-7371-3e2b-e794-4fbfc52aaad9@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-06-15 at 16:12 -0700, Randy Dunlap wrote:
> On 6/15/20 3:42 PM, Steven Rostedt wrote:
> > On Mon, 15 Jun 2020 15:30:41 -0700
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> > 
> > > > > Please don't infect kernel sources with that style oddity.  
> > > > 
> > > > What do you mean? It's already "infected" all over the kernel, (has
> > > > been for years!)

Not really.  For instance:

$ git grep -A6 "^{" fs/proc/*.[ch]

> But yes, we all have preferences. For data declaration, mine is more like
> order of use or some grouping having to do with locality.
> 
> cheers.

Mine too.

But a few years ago I submitted this:
https://lore.kernel.org/patchwork/patch/732076/


