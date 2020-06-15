Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713C11FA3F1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 01:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgFOXM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 19:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgFOXM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 19:12:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31104C061A0E;
        Mon, 15 Jun 2020 16:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=LtcgqswidDAh1TGx28PEvhiX42PmovYfIp8aD84tuVI=; b=p2TtdrCtmKF8Prq8BRAYMRM8H1
        rVEvD7B5NsOnv1OtZL3XSB1CFq5x/VPY5ElUsicHyz7npUdIRk3awMp3Mc92QCzi6E9vUQU2GRxVj
        75uEC4niNvcTTqLOGSQtZTBq12nm4JuLUsrffbS+jsLp/Hbsyh0ViIgHJ27MA62epFLDgo5zyIiJu
        ViIpl6d4oCPG7BNV9OBdVi2HbpM/o6/lxeWN4MyJIYPxNpypE37UgOnuhuL+eoF4tozUYV1xKp645
        3Uu6fGz50h9nbleDhfNMoeceSmBQJy82XHK5CwCmsujUhrG815hxb3FGOxq6AReqyBz8kxw5+MYcF
        yGLEhzTg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkyH7-0007Nh-U6; Mon, 15 Jun 2020 23:12:21 +0000
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for value
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joe Perches <joe@perches.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
 <159197539793.80267.10836787284189465765.stgit@devnote2>
 <20200615151139.5cc223fc@oasis.local.home>
 <7abefbc81fc6aaefed6bbd2117e7bc97b90babe9.camel@perches.com>
 <20200615172123.1fe77f3c@oasis.local.home>
 <ddb4adb9-bf01-abd4-38dd-d6d064569d6e@infradead.org>
 <20200615184218.752a17fa@oasis.local.home>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a3cbc2cf-7371-3e2b-e794-4fbfc52aaad9@infradead.org>
Date:   Mon, 15 Jun 2020 16:12:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615184218.752a17fa@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/20 3:42 PM, Steven Rostedt wrote:
> On Mon, 15 Jun 2020 15:30:41 -0700
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>>>> Please don't infect kernel sources with that style oddity.  
>>>
>>> What do you mean? It's already "infected" all over the kernel, (has
>>> been for years!) and I kinda like it. It makes reading variables much
>>> easier on the eyes, and as I get older, that means a lot more ;-)  
>>
>> Yeah, there is some infection, more in some places than others,
>> but I agree with Joe -- it's not needed or wanted by some of us.
> 
> We all have preferences. But for code that I need to review, I prefer
> it.
> 
> Why would you be bothered by it? Which is easier on the eyes to read
> variables?

"to read variables"?  I mostly read code, not variables.

>  	struct xbc_node *leaf, *vnode;
>  	const char *val;
> 	char q;
>  	char *key, *end = dst + size;
>  	int ret = 0;
> 
> or
> 
>  	struct xbc_node *leaf, *vnode;
>  	char *key, *end = dst + size;
>  	const char *val;
> 	char q;
>  	int ret = 0;
> 
> ?

But yes, we all have preferences. For data declaration, mine is more like
order of use or some grouping having to do with locality.

cheers.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
