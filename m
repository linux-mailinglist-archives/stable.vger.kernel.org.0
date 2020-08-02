Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE52355C1
	for <lists+stable@lfdr.de>; Sun,  2 Aug 2020 08:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgHBGz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Aug 2020 02:55:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38059 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgHBGz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Aug 2020 02:55:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 46F535C00B9;
        Sun,  2 Aug 2020 02:55:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 02 Aug 2020 02:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=cWDIbpmbm/crt0rtm0kWzqyFjnD
        Ztfw+wdOJ4nuUN7c=; b=iiF0rEv/xW3HpqhUNjEpuhoz8lVr7lfEj/e7nsvhkAT
        Xde3uKi2cC9y+3C8pfZLJ//KyWOC8eXOWtrfYncdpc0xIb5Kt/wBEEpn1F77/EOF
        AL1qbHeBqemT3/gh3i3PWCkVkY++49YWkFOJiEzABp5NrFixau19ppjspvpgSSQu
        fkbcPRRVk9QTkkj2ZB988yLVGVG36xVhvxbgrRIJqzWDTKAUUNP28JkZKC0gO71t
        uwSnsm1WjxbkrfjRlh5bZvsDp563D8xK7MqviYFOPJpbU9KhYZBzFYSxdfDNUGbF
        frNMcA8/uluqkI7j8nvMSdYP3xh14Wh3F9AD8hWR6dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cWDIbp
        mbm/crt0rtm0kWzqyFjnDZtfw+wdOJ4nuUN7c=; b=kfPW1TwR7qrI8NnRwhMIf5
        9klbTGfWKsgxCgqEySpvrYDCMc4C/Q533e2P1XTXZTYpau/epELL63nJBi3/qpZZ
        8cc364/UDJP+zsOooQWqR/fSIDa/QhgYxhk1FiN176Lt13a4uzNL6lNyPSDUPqLB
        57C/lILdaE8vOI+Ztyzrs9Swa7puudwjDxZD3UpYWlIayMGy732KTtRiBav8t8id
        RJmjT77XztQMi6l6/fBHMTX9lzwKNr5iy440iMLmbVhAXYbnFqT4of+g3GeDRi4U
        lQWQfid0DUlRljEy5GZCuALcAgMRK6anfJP4A3BBy4mqiOMCxpSX+C82x3iwCH+g
        ==
X-ME-Sender: <xms:fWMmX4TIEh_PXuEEDGicbiWk9hCmaDJwMm4WeoEL-MDCFJgMktGvKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedugdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fWMmX1wUzLRKD_qgFEfrsySbW0kFGzPeXL7olRSA21pZgN8Orjlr1Q>
    <xmx:fWMmX12rX9myZSupAp3NTREJED5ztFFZ4TDMCUpWianPcAJqYqjS_w>
    <xmx:fWMmX8DwUGbRK0AYQ5FbtapK7y7D5COfvj5bqk3Q3BHsEjXIrkxxbA>
    <xmx:fWMmX0t-KzLx_fhJkYaub9_xAld82KqMJF3oNmznxXk0bT_TmzBiBw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5E6130600A9;
        Sun,  2 Aug 2020 02:55:56 -0400 (EDT)
Date:   Sun, 2 Aug 2020 08:55:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     stable@vger.kernel.org, fllinden@amazon.com, surajjs@amazon.com,
        benh@amazon.com, anchalag@amazon.com
Subject: Re: [PATCH 4.9 4.19] xfs: fix missed wakeup on l_flush_wait
Message-ID: <20200802065538.GA3889624@kroah.com>
References: <20200730213507.24791-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730213507.24791-1-samjonas@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 02:35:07PM -0700, Samuel Mendoza-Jonas wrote:
> From: Rik van Riel <riel@surriel.com>
> 
> commit cdea5459ce263fbc963657a7736762ae897a8ae6 upstream
> 
> The code in xlog_wait uses the spinlock to make adding the task to
> the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
> with respect to the waker.
> 
> Doing the wakeup after releasing the spinlock opens up the following
> race condition:
> 
> Task 1					task 2
> add task to wait queue
> 					wake up task
> set task state to UNINTERRUPTIBLE
> 
> This issue was found through code inspection as a result of kworkers
> being observed stuck in UNINTERRUPTIBLE state with an empty
> wait queue. It is rare and largely unreproducable.
> 
> Simply moving the spin_unlock to after the wake_up_all results
> in the waker not being able to see a task on the waitqueue before
> it has set its state to UNINTERRUPTIBLE.
> 
> This bug dates back to the conversion of this code to generic
> waitqueue infrastructure from a counting semaphore back in 2008
> which didn't place the wakeups consistently w.r.t. to the relevant
> spin locks.
> 
> [dchinner: Also fix a similar issue in the shutdown path on
> xc_commit_wait. Update commit log with more details of the issue.]
> 
> Fixes: d748c62367eb ("[XFS] Convert l_flushsema to a sv_t")
> Reported-by: Chris Mason <clm@fb.com>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: stable@vger.kernel.org # 4.9.x-4.19.x
> [modified for contextual change near xlog_state_do_callback()]
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> Reviewed-by: Suraj Jitindar Singh <surajjs@amazon.com>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Reviewed-by: Anchal Agarwal <anchalag@amazon.com>
> ---
> This issue was fixed in v5.4 but didn't appear to make it to stable. The
> fixed commit goes back to v2.6, so backport this to stable kernels
> before v5.4. The only difference is a contextual change at
> 	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
> Which in v5.4 is
> 	xlog_state_do_callback(log, true, NULL);

Now queued up, thanks.

greg k-h
