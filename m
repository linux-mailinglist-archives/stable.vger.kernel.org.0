Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6E4D7E58
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiCNJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiCNJUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:20:13 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24A8433B4;
        Mon, 14 Mar 2022 02:19:03 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7F5ED3200A2E;
        Mon, 14 Mar 2022 05:19:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 14 Mar 2022 05:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=iv+ksUDVdMe5HbfK0QvBmH/tkqgpJ2kejWYiRW
        ICHRY=; b=rPDK8foFS0J3adNv3oXo7e0kjc5VNHEh3DxxGD/+ySEuBhD95Y9N4W
        vOvJ4C/YnUAPtxwvrDjtyTjiZj987424gDIzn85UM9fBCh9ymyGzom0tvAkV68jn
        F9E+WvYRZ6/iPWha21ykLZSMScQxnkpBsK+2Iwhfxp+dIvRJ3PWgI358e/ur5iGr
        adIQwdNZGa6FmQCh035fhrGBa3RMs92rb1OJ0EySkcXJhncqtUAwMoUYhCSbYH1t
        i4EO9bKnBTdyCJ1Zg0ujpZtrjU2zofKiB6IGnMr9U2/bCFwfGQLegCc+Fv2oXXUH
        eKrDcK/G/W5vQE3dM0jQXy+/j+0jrZuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iv+ksUDVdMe5HbfK0
        QvBmH/tkqgpJ2kejWYiRWICHRY=; b=V71J0boSZvNM6XGwbifqyI7ewhm1JgY8U
        VlPR8DO2omDUrOVx/oRgt2DANrp8bn24HajgjKp9qEhARHryuqbh833EQxVWAlkt
        WhWmYFvweWR31kgXr7bB+kcoFL7se3qrUlflNgev3kQn5XsiFz1HRjhsynkYRXfZ
        jQcoMcgNqj0kcbKALyWAx5Ll1d0txHPPS9Q2HfjGC7ppADXXGTYtSFletA1t3yk6
        W4iO+/Dh4dXVD1KL/LpkE98BxYQN7SjUaZue8T01lt+AzFCo37rXgicDD7n4+8KG
        1F8CJXSFQRB3vayXmoyxjACx8q1ESq7Igtdth5q/BAtchTzJMo+Hg==
X-ME-Sender: <xms:hQgvYqFRbMKYC9t3XPwFXKW-h7pFRFrGlhYJhvyqRisZ4urAIj3kvA>
    <xme:hQgvYrWD1z_0AmnOqbzu_ppTvYFbD9KcPEXVbqfWd2rxo2USbHkVZsEtyrx4W_4Rp
    Xi3baY-XjnrIg>
X-ME-Received: <xmr:hQgvYkIKVCe4rqV-dWrbggNPLkX1ydo3rrCjnRcGkMtFkW9O45f2V7kcnuJ8yAomaS42vKpyLVShXWJizoQetUPlXnobwCBZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:hQgvYkEWuzWY0v4KDL4_tn9w6vJ6C2XFOXIQo9UFDL16ej2L1jZrWA>
    <xmx:hQgvYgWk1hQXaR6rdpLR1g6uN9y36wgo7f4M414C5QJUysk2Y5Gcmw>
    <xmx:hQgvYnPwQsKpWHfRDojQ_SlVA654ACj566z4wA3dJhnsUNlUl9vsiQ>
    <xmx:hggvYkoHAkLQzZVATQMHu56dRHLpbkptucMSiusVk43p7HGQZfNK6g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 05:19:00 -0400 (EDT)
Date:   Mon, 14 Mar 2022 10:18:57 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.15.y stable-5.16.y] btrfs: make send work with
 concurrent block group relocation
Message-ID: <Yi8Iga4RMdqmJG69@kroah.com>
References: <bc51b8d12cfc0768a8e4965cce9814901bc5e0c9.1646885512.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc51b8d12cfc0768a8e4965cce9814901bc5e0c9.1646885512.git.anand.jain@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 12:40:23PM +0800, Anand Jain wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit d96b34248c2f4ea8cd09286090f2f6f77102eaab upstream.
> 
> We don't allow send and balance/relocation to run in parallel in order
> to prevent send failing or silently producing some bad stream. This is
> because while send is using an extent (specially metadata) or about to
> read a metadata extent and expecting it belongs to a specific parent
> node, relocation can run, the transaction used for the relocation is
> committed and the extent gets reallocated while send is still using the
> extent, so it ends up with a different content than expected. This can
> result in just failing to read a metadata extent due to failure of the
> validation checks (parent transid, level, etc), failure to find a
> backreference for a data extent, and other unexpected failures. Besides
> reallocation, there's also a similar problem of an extent getting
> discarded when it's unpinned after the transaction used for block group
> relocation is committed.
> 
> The restriction between balance and send was added in commit 9e967495e0e0
> ("Btrfs: prevent send failures and crashes due to concurrent relocation"),
> kernel 5.3, while the more general restriction between send and relocation
> was added in commit 1cea5cf0e664 ("btrfs: ensure relocation never runs
> while we have send operations running"), kernel 5.14.
> 
> Both send and relocation can be very long running operations. Relocation
> because it has to do a lot of IO and expensive backreference lookups in
> case there are many snapshots, and send due to read IO when operating on
> very large trees. This makes it inconvenient for users and tools to deal
> with scheduling both operations.
> 
> For zoned filesystem we also have automatic block group relocation, so
> send can fail with -EAGAIN when users least expect it or send can end up
> delaying the block group relocation for too long. In the future we might
> also get the automatic block group relocation for non zoned filesystems.
> 
> This change makes it possible for send and relocation to run in parallel.
> This is achieved the following way:
> 
> 1) For all tree searches, send acquires a read lock on the commit root
>    semaphore;
> 
> 2) After each tree search, and before releasing the commit root semaphore,
>    the leaf is cloned and placed in the search path (struct btrfs_path);
> 
> 3) After releasing the commit root semaphore, the changed_cb() callback
>    is invoked, which operates on the leaf and writes commands to the pipe
>    (or file in case send/receive is not used with a pipe). It's important
>    here to not hold a lock on the commit root semaphore, because if we did
>    we could deadlock when sending and receiving to the same filesystem
>    using a pipe - the send task blocks on the pipe because it's full, the
>    receive task, which is the only consumer of the pipe, triggers a
>    transaction commit when attempting to create a subvolume or reserve
>    space for a write operation for example, but the transaction commit
>    blocks trying to write lock the commit root semaphore, resulting in a
>    deadlock;
> 
> 4) Before moving to the next key, or advancing to the next change in case
>    of an incremental send, check if a transaction used for relocation was
>    committed (or is about to finish its commit). If so, release the search
>    path(s) and restart the search, to where we were before, so that we
>    don't operate on stale extent buffers. The search restarts are always
>    possible because both the send and parent roots are RO, and no one can
>    add, remove of update keys (change their offset) in RO trees - the
>    only exception is deduplication, but that is still not allowed to run
>    in parallel with send;
> 
> 5) Periodically check if there is contention on the commit root semaphore,
>    which means there is a transaction commit trying to write lock it, and
>    release the semaphore and reschedule if there is contention, so as to
>    avoid causing any significant delays to transaction commits.
> 
> This leaves some room for optimizations for send to have less path
> releases and re searching the trees when there's relocation running, but
> for now it's kept simple as it performs quite well (on very large trees
> with resulting send streams in the order of a few hundred gigabytes).
> 
> Test case btrfs/187, from fstests, stresses relocation, send and
> deduplication attempting to run in parallel, but without verifying if send
> succeeds and if it produces correct streams. A new test case will be added
> that exercises relocation happening in parallel with send and then checks
> that send succeeds and the resulting streams are correct.
> 
> A final note is that for now this still leaves the mutual exclusion
> between send operations and deduplication on files belonging to a root
> used by send operations. A solution for that will be slightly more complex
> but it will eventually be built on top of this change.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/block-group.c |   9 +-
>  fs/btrfs/ctree.c       |  98 ++++++++---
>  fs/btrfs/ctree.h       |  14 +-
>  fs/btrfs/disk-io.c     |   4 +-
>  fs/btrfs/relocation.c  |  13 --
>  fs/btrfs/send.c        | 357 +++++++++++++++++++++++++++++++++++------
>  fs/btrfs/transaction.c |   4 +
>  7 files changed, 395 insertions(+), 104 deletions(-)

Now queued up, thanks.

greg k-h
