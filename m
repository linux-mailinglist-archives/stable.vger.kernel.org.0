Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086E7604F5
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 13:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGELBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 07:01:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36349 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfGELBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 07:01:40 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 880B12148D;
        Fri,  5 Jul 2019 07:01:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 05 Jul 2019 07:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3nEACSZMYF4P+9vLi7rD5rFYOky
        3Qp0LOHUiGLtOT9g=; b=g0pjsKMlZYUfJQifpH79VIv1rb6hW3LoDF/OqfTWxdB
        b3G29W7Nt8OD7v5yCRXM74TGNDoLDOP4DCxPoFIUl3hgZQEhuAPmgvk0dMWl7JgS
        sk5D5hIsOFFZjEjTIPBmGV/SVmJLzQOL50bkCp7xJptw5WVrtxWaTN6Aq91UVpV3
        dy+143WdayG+KklC/038iO+iAU7HbzJCYHa66FqSTrrksT5XCzi9uuID2Nq8pGnw
        pm9vibXJkXKkWLrRSEEJAAAN7FIqbzoXaMoYOurHyLX6UdcRN7XXCOj7KjFa82gB
        CZlivoEGCfyBaGtJ5LHdp9d9AN4ybi5oZ0zrUhJhPXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3nEACS
        ZMYF4P+9vLi7rD5rFYOky3Qp0LOHUiGLtOT9g=; b=u9kZoqs3qw0PExY1n9Cz8v
        vErY7sNTX51tzWcY7vB+TtXu0uBQSdbQf/mpGpO1W5uXOu5jMMiJGJZblPYLBf/D
        vM77G2VxXCfLQInWwQgSY5jcDR9AKa5QdlvSvYyzS6IwcOG74sQ4fJPwMInmbAAm
        KSWHERTzyOxAxkihqykrQQQ3u4GzMRsAifQ5KNqgJpWrFi4VoyZsSb4jxySF4wH6
        Rn1b9UTAFNQ1Cn1niwWiggs9vyam2OZASB1BLwATfCoLUNfRj52rf9XSS+Hrto5G
        OagmOeh8UwaNZxTTqLvlitzv9oH0Wilv8pla1fvcrDcLkuZ4cy1dh7/NrK9TyRmQ
        ==
X-ME-Sender: <xms:Ei4fXW5Hk1ESE2eZC8HaaucMYb4gZEnT3qn1BRTcStxeKm4Q-0Ia4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeggdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekgedruddviedrvd
    egvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Ey4fXTJGyH_inrOyxGie6Z_yrmKnnkIW6v0JFs77Q1FcOpIrIYB3hg>
    <xmx:Ey4fXe5SOVLq9imoV40jLwz77kgbJdq3h0tOn1elBq01mE7haprmaQ>
    <xmx:Ey4fXeyes8RSU9GeR3jAfL5VOoAq_vKz0xN2X0XfnDKUYvue56eogA>
    <xmx:Ey4fXdXr_B7OxCz-3Xxen2Y0NLOBUm3hJ0iC7UuemYJt6oAMCapGkQ>
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A0CA80059;
        Fri,  5 Jul 2019 07:01:38 -0400 (EDT)
Date:   Fri, 5 Jul 2019 13:01:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Ensure replaced device doesn't have pending chunk
 allocation
Message-ID: <20190705110136.GA14533@kroah.com>
References: <20190703094552.15833-2-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703094552.15833-2-nborisov@suse.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 12:45:49PM +0300, Nikolay Borisov wrote:
> Recent FITRIM work, namely bbbf7243d62d ("btrfs: combine device update
> operations during transaction commit") combined the way certain
> operations are recoded in a transaction. As a result an ASSERT was added
> in dev_replace_finish to ensure the new code works correctly.
> Unfortunately I got reports that it's possible to trigger the assert,
> meaning that during a device replace it's possible to have an unfinished
> chunk allocation on the source device.
> 
> This is supposed to be prevented by the fact that a transaction is
> committed before finishing the replace oepration and alter acquiring the
> chunk mutex. This is not sufficient since by the time the transaction is
> committed and the chunk mutex acquired it's possible to allocate a chunk
> depending on the workload being executed on the replaced device. This
> bug has been present ever since device replace was introduced but there
> was never code which checks for it.
> 
> The correct way to fix is to ensure that there is no pending device
> modification operation when the chunk mutex is acquire and if there is
> repeat transaction commit. Unfortunately it's not possible to just
> exclude the source device from btrfs_fs_devices::dev_alloc_list since
> this causes ENOSPC to be hit in transaction commit.
> 
> Fixing that in another way would need to add special cases to handle the
> last writes and forbid new ones. The looped transaction fix is more
> obvious, and can be easily backported. The runtime of dev-replace is
> long so there's no noticeable delay caused by that.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Hello Greg, 
> 
> Please merge the following backport of upstream commit debd1c065d2037919a7da67baf55cc683fee09f0
> to 4.4.y stable branch. 

Thanks for all of these, now queued up.

greg k-h
