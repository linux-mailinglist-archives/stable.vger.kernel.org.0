Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F7513F9A
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfEENSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 09:18:01 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37847 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfEENSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 09:18:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 73E96340;
        Sun,  5 May 2019 09:17:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 05 May 2019 09:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=i+smv+iN6NpsKUAhpJGxdhV4B4f
        VDUKH69PHfOTQG1s=; b=HjsBA6cA/cB5L5tvolUa1vcD1eKqu+rxheOVTmLQwfF
        j6OJSK9Npi4coUCXM4mo9XLUl8M2XZf97Plg7k1k2uJs6kUIudnZb3E6as7WINHx
        iScNQb/mMEg6+/MDueyXFSKK74LeDTstzdVDYxdVhBnKIkZGf5wdEeXnCeteBD5T
        JFpe4Pe60NMm2cOo9Thcgvj68cID2yQzBVYkWffjhov/49SQmxnVgI4fLeyO62Jx
        MC+3B8KWuqFLD5kV45v0z4UsrdWB+KtFtBq0HSxLM1R8p8waQaAaHFY+5elQJlcr
        RW9SETsM+UpJ+vmPFohQv//vRlnAoxghq6vtSWOCBaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=i+smv+
        iN6NpsKUAhpJGxdhV4B4fVDUKH69PHfOTQG1s=; b=gtd+HAiFGx1XWWae2xkjMp
        hDZYnjvoaOt3YJFfFxLddxOZHOZAWmmTJC8N2jgiTZsKqRyVjeTJsp7MTdUn8Vft
        A5bz4iz/btybEJCcKsfD7dQ4UikyN5aJFz7RjHOl/4G1oaATB0HCKQEsLQSm/FnX
        M/BujWdWf/ktL4loqNAz6rKbaG2SC3TldNWnYfOMVvLt/E0Xl72uIBYlTYElawhb
        yXHrfItfExZCCj5hm1G0jRysFPU0qA1VTc3EqJowy2uHQzuc7fbaNdbug4++39BG
        h2Rpt1H9ZyaNZNYwr1MG+enFhy2fKeT1bx8PP2SHnK35aY1HN3EJcknv9lrsJq3w
        ==
X-ME-Sender: <xms:hOLOXEjS5FlT3UbqIavv4HQKslHN8vPKSpbR6nEQmzM8G7MPqg9obg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeehgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:hOLOXCRMl9zm7jHCWQoC4VhbWjKCjsLhZKhYwYoQdxpeu0TdL5U4NQ>
    <xmx:hOLOXOsSUGgcHf7W8BRpD6im-9VO_xiKGsaM6nI0Lhr6okE9QsQ3og>
    <xmx:hOLOXE9Mgld_AXsWuaU_lZ8phyQ-Y8JVmV-HT38AFZzJkjvVM7ilUw>
    <xmx:h-LOXP3Gh3hIBOWBx5T_igIkP83eHrxKQ8VrFRb1UqECUDWAxjfg4w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1C09103CA;
        Sun,  5 May 2019 09:17:55 -0400 (EDT)
Date:   Sun, 5 May 2019 15:17:54 +0200
From:   Greg KH <greg@kroah.com>
To:     Robert Kolchmeyer <rkolchmeyer@google.com>
Cc:     stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: do not stall register_shrinker()
Message-ID: <20190505131754.GD25640@kroah.com>
References: <20190502200905.147551-1-rkolchmeyer@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502200905.147551-1-rkolchmeyer@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 01:09:05PM -0700, Robert Kolchmeyer wrote:
> From: Minchan Kim <minchan@kernel.org>
> 
> commit e496612c5130567fc9d5f1969ca4b86665aa3cbb upstream.
> 
> Shakeel Butt reported he has observed in production systems that the job
> loader gets stuck for 10s of seconds while doing a mount operation.  It
> turns out that it was stuck in register_shrinker() because some
> unrelated job was under memory pressure and was spending time in
> shrink_slab().  Machines have a lot of shrinkers registered and jobs
> under memory pressure have to traverse all of those memcg-aware
> shrinkers and affect unrelated jobs which want to register their own
> shrinkers.
> 
> To solve the issue, this patch simply bails out slab shrinking if it is
> found that someone wants to register a shrinker in parallel.  A downside
> is it could cause unfair shrinking between shrinkers.  However, it
> should be rare and we can add compilcated logic if we find it's not
> enough.
> 
> [akpm@linux-foundation.org: tweak code comment]
> Link: http://lkml.kernel.org/r/20171115005602.GB23810@bbox
> Link: http://lkml.kernel.org/r/1511481899-20335-1-git-send-email-minchan@kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: Shakeel Butt <shakeelb@google.com>
> Tested-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [rkolchmeyer: Backported to 4.14: adjusted context]
> Signed-off-by: Robert Kolchmeyer <rkolchmeyer@google.com>
> ---
> Backport of commit e496612c5130567fc9d5f1969ca4b86665aa3cbb upstream.
> We would like to apply this to linux-4.14.y.
> I needed to change the patch context for the patch to apply to linux-4.14.y.
> The actual fix remains unchanged.

Now queued up, thanks.

greg k-h
