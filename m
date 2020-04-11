Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C621A4F97
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 13:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDKLtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 07:49:47 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:45475 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbgDKLtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 07:49:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 564F4580571;
        Sat, 11 Apr 2020 07:49:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 11 Apr 2020 07:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=krqovpoPp/fLob5GVLrjBvd7LUd
        jdh9o82V9DaK/66k=; b=GMIZ0YU8q3sHQnR6Xuyqv2zBHBRdygcePfHahGhfO80
        xCCLOMIx11oEmITwFfhD1v3re+7QdMIaJXP6SSwGVGY9uKuKbzeoXlL8ePtw1As/
        wRuL9KoU9PaXCJJphRIHo5FmrPfNMlkQ+fvMvGWx0to5jO6LlbRZVjMaP+o2B3V3
        5aDxUnlqIl/phmQNc/ijLqHIcgibLz03dQ5X2YSGJZwDSusa5H7Qa4J4yDxJaKFP
        ygBUcJhTPzfTKKa4UXHvuzAN/qJePzeinqbk2pwehS7nC3JD5Na9nbt4wY7fRleN
        hfTUxmnLOZeXtionoBrKUvCHCuITHr1eAxTEw+3BMgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=krqovp
        oPp/fLob5GVLrjBvd7LUdjdh9o82V9DaK/66k=; b=lIfV8JZrauYdBwtuX20Ann
        zEAVSeO7+4vGGR3qtuBqojKa6i99jxB1xhIucaJDPLVunXPenXsHQGZGlPJQ/7QN
        91dnQO77y9y9g906ZYa0Yrt7wQG2BhLlIEXByPEJXmnI5Se6wAhXpyJs/hYA2EtJ
        bpRMQWVgZUM1PAodU22mrc9nBjyDFp4BtEVHzbqONxAKqVbWUzu4KfT0hIyxOehs
        ApF8tI8RFQmM6/D1jl8KckA0nN84djJSsKcjgt7bh1F7jqOpp019qQ0HuK+a6hyH
        LLeFGNFoBEF/v4IU+PrFdq0Ya/oT8J1bL7GfD+wexTdbpFtgdJNUFqrrGBUMQDtQ
        ==
X-ME-Sender: <xms:066RXiXe2KEoUJ0Dt9Wfd6LJaOTPRPZSvogHc734gO_j2O5ZsyFQPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvdeggdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:066RXktDzerb07tFZvdZriNaWzeu12JXs8wjma9Qz3xmKMyRQgGUgg>
    <xmx:066RXtUtId-e3LXu-_EPJ-EyGqHIq1O42Xcyr11AFtPYJIT8QTH47w>
    <xmx:066RXgdf0JUUkmPUpNBAVMXJOl40pUFjYPwmf_7ANJ4XvPQHnO3ffw>
    <xmx:2q6RXpfh0FzRJ9N_8x8emX996OoyvtJp8fKIHaKZmdEA7RTVcGc9_g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CAE0F328005D;
        Sat, 11 Apr 2020 07:49:38 -0400 (EDT)
Date:   Sat, 11 Apr 2020 13:49:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Lee Jones <lee.jones@linaro.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4.19 11/13] perf/core: Reattach a misplaced comment
Message-ID: <20200411114937.GG2606747@kroah.com>
References: <20200403121859.901838-1-lee.jones@linaro.org>
 <20200403121859.901838-12-lee.jones@linaro.org>
 <20200403122604.GA3928660@kroah.com>
 <20200403125246.GE30614@dell>
 <87y2rc66u9.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2rc66u9.fsf@ashishki-desk.ger.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 04:23:42PM +0300, Alexander Shishkin wrote:
> Lee Jones <lee.jones@linaro.org> writes:
> 
> > On Fri, 03 Apr 2020, Greg KH wrote:
> >
> >> > +	/*
> >> > +	 * Get the target context (task or percpu):
> >> > +	 */
> >> >  	ctx = find_get_context(event->pmu, task, event);
> >> >  	if (IS_ERR(ctx)) {
> >> >  		err = PTR_ERR(ctx);
> >> 
> >> Unless this is needed by a follow-on patch, I kind of doubt thsi is
> >> needed in a stable kernel release :)
> >
> > I believe you once called this "debugging the comments", or
> > similar. :)
> >
> > No problem though - happy to drop it from this and other sets.
> 
> It's a precursor to dce5affb94eb54edfff17727a6240a6a5d998666, which I
> think is a stable candidate.

Ok, but that's not part of this patch series, so how was I supposed to
know that?  :)
