Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F27E1FA3A6
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 00:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgFOWmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 18:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgFOWmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 18:42:21 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A8E52074D;
        Mon, 15 Jun 2020 22:42:20 +0000 (UTC)
Date:   Mon, 15 Jun 2020 18:42:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Joe Perches <joe@perches.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for
 value
Message-ID: <20200615184218.752a17fa@oasis.local.home>
In-Reply-To: <ddb4adb9-bf01-abd4-38dd-d6d064569d6e@infradead.org>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
        <159197539793.80267.10836787284189465765.stgit@devnote2>
        <20200615151139.5cc223fc@oasis.local.home>
        <7abefbc81fc6aaefed6bbd2117e7bc97b90babe9.camel@perches.com>
        <20200615172123.1fe77f3c@oasis.local.home>
        <ddb4adb9-bf01-abd4-38dd-d6d064569d6e@infradead.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 15:30:41 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> >> Please don't infect kernel sources with that style oddity.  
> > 
> > What do you mean? It's already "infected" all over the kernel, (has
> > been for years!) and I kinda like it. It makes reading variables much
> > easier on the eyes, and as I get older, that means a lot more ;-)  
> 
> Yeah, there is some infection, more in some places than others,
> but I agree with Joe -- it's not needed or wanted by some of us.

We all have preferences. But for code that I need to review, I prefer
it.

Why would you be bothered by it? Which is easier on the eyes to read
variables?

 	struct xbc_node *leaf, *vnode;
 	const char *val;
	char q;
 	char *key, *end = dst + size;
 	int ret = 0;

or

 	struct xbc_node *leaf, *vnode;
 	char *key, *end = dst + size;
 	const char *val;
	char q;
 	int ret = 0;

?

-- Steve
