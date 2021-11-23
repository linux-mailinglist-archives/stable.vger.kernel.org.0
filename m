Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5145A0DB
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhKWLGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:06:22 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:53665 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231702AbhKWLGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 06:06:21 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 508522B01453;
        Tue, 23 Nov 2021 06:03:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 06:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=oWc2vzhrYc1jGwqIggT9FtG26pa
        qnkl6UTa7ET4HxiI=; b=pQghMJ0VqgX8bX0UcPhjTj5i/5dKqWCFpdZo6NeR99p
        SCaOQ+fMljtwJO9M6RE3+7bvHnAXQpJV2DAlkUN2pSGjWKRTacf9/JgEtj2lcKV0
        jk4TTrh7xAzwfupppCF+yN2e+oRf1HObuz08tcfkZfeqCb5+w8wFkIIoSC7QVmL1
        BbdUJ5InvcRXQCK2izbiujrGzXGFp11ODtXZlePrI3uVBYNWygM0veGiRGf1zcfh
        a9kuo/VJi1nl3cO/eE6VsmubWw3QiZz6clHptJn7Vew0OgD5vEb06bgSnld7LmEo
        6/1pXDBN5bt4qEwwacBTJOOJzGDWDwjtOVFQYmtIASA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oWc2vz
        hrYc1jGwqIggT9FtG26paqnkl6UTa7ET4HxiI=; b=Vi5L/h0cknM7DwkdQFxjn0
        b2TMtdrQO9jsyuDGp4fRLAdPR5xpZ3WolrVmBh0hI2xIv1tOIYZXI/NLRY9XrMLV
        rClsEb4Xal+9VHbkkrr8MB6pUvC9398uskiTuyxWSGXZATYisE5NcpQRJ+0lFrCP
        VjFlyljRuOcu0435mucZeDbhEY0CjBPnhrzWADsa0vS18e7NyLQEeRSJ4CdtqpyP
        3zHCMeIc+qqVEOzNfr4iodY51+irmlRUbfOkoqrF9v1zpdZPrOJPq04pjWPzpHXq
        ceLHRiiY8H7BoGhQuxwS8CirWJ7vQue2SPtprJtx6PzB56ovIgiTN6p6BcZx8Z6g
        ==
X-ME-Sender: <xms:b8qcYdDjFsXHzzfwu3frjxSZ5NjQmucnaXO2BP3049WAJz6j5G8Glw>
    <xme:b8qcYbj7ISfJqP2ldJ-JuLIwk3z55IreCq7Lyqp755PyEuTKT6b_aqOyRRWSK9bMi
    SazgS9KvmP1Qg>
X-ME-Received: <xmr:b8qcYYnVn8ZQhlSrlABawa8vEJmucjppj8UsrQGdsDYJLVocjadbE1BzTtqAWp39FlUd2E_C9WtoLSc3m1DPPCQXIJyKRDgX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:b8qcYXxtFhkyfEyz1LHNIwvRnDymYLuvz9PGFVzmDiKinV4-oIh9yA>
    <xmx:b8qcYSTKfYcfc_BvxRHBpdAkyq_SCY5Uc4vs27x2ojdJeIXfOeIbdQ>
    <xmx:b8qcYaYFQsZU17e_nFaxHd-f4GX3mKMfxmgBJ8p3B6uS22nVaDYwkg>
    <xmx:b8qcYXItOwvA43RKp7cfe-2ww8yfqsVK8xAPz7Xgpk7cJNX5ke9kePMSLW0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 06:03:11 -0500 (EST)
Date:   Tue, 23 Nov 2021 12:03:08 +0100
From:   Greg KH <greg@kroah.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, "3.8+" <stable@vger.kernel.org>,
        stable-commits@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Kosina <jikos@kernel.org>
Subject: Re: Patch "HID: playstation: require multicolor LED functionality"
 has been added to the 5.15-stable tree
Message-ID: <YZzKbKseHT5xoxSj@kroah.com>
References: <20211121230439.76777-1-sashal@kernel.org>
 <CAO-hwJLkmZPj25O49Xr++jWcoBUEJHQAtPZFkXTjwFZvRqFKJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJLkmZPj25O49Xr++jWcoBUEJHQAtPZFkXTjwFZvRqFKJA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 11:59:25AM +0100, Benjamin Tissoires wrote:
> On Mon, Nov 22, 2021 at 12:04 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     HID: playstation: require multicolor LED functionality
> >
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      hid-playstation-require-multicolor-led-functionality.patch
> > and it can be found in the queue-5.15 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> I am deeply puzzled by this cherry-pick.
> 
> The purpose of this patch was to fix fc97b4d6a1a6 ("HID: playstation:
> expose DualSense lightbar through a multi-color LED.")
> 
> So unless this patch gets backported in stable (and this is *not* a
> request to do so), bringing in this patch in 5.15 is wrong.

You are right, thanks for catching this, I'll go drop this commit now.

greg k-h
