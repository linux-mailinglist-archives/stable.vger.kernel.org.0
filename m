Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E824A150A91
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgBCQMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:12:49 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39021 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727720AbgBCQMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 11:12:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D78B3767;
        Mon,  3 Feb 2020 11:12:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Feb 2020 11:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=T04XSwyjMbuTrZ8RrXZ1jTd9Aq1
        3NgbD3drNl9rsUno=; b=L/MQx3+hBVbxAnfhNQBTsToLERfOqMy8u+OLwA0qnX+
        JKzhvJNdP8Z+O00CfVBjlDFWRtSLxDN71wm9Jt+oe9dhMEkHh8WNhQQdWCZ2W9kK
        UVbRzEXBWtvkg3rnsZFlZumvCjHLHMGOErPr1+kn5MvuzRjMurlEvgQgbudjzMFW
        sVA9am6gGs/rwqy96Ll/ciGhOr64Xb6YIWjRwa43pW0/btxZBJyghG218nDsRuhu
        da1LUOk34p3poMRPwqBVWX2ukbOuZymCfJQJfas5pmHKWD8NUrKQoOb88GPDcvrL
        sq0Znslz/Ua0BCJKPY2pu0fUHSxNPQblGF6ozLf3yog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=T04XSw
        yjMbuTrZ8RrXZ1jTd9Aq13NgbD3drNl9rsUno=; b=wToBjnVsb8wepXXqf75C6q
        gQUR+uqrQ6+9YP5el7Dhaf7i0YSpG2lQHnD00CsGAq8ik8HOalBsJVw9k+UGjJ2f
        S/aakAyv3yb24YuqC27A4ZqzuyirGsL49JVTRb0fHO/JKRKF7mBHWILgf80mkGmk
        p/xfO/LbfEsuTbU9hk59Bt32GfWfGHLG2OklsJa/goXUBWEYEDRUD4guQyPRvTh6
        oYmQDioWZLVaXOmI4uKK6rhxFrUxmvpCOREx0SXW/dInNiY/ecnXYPeAll235Jqw
        VXKRffFvIuP5yC/FTuRTkniikK90mRnqDGBvysZb8p+JfbNuKIhUI0vI9XOp2ygw
        ==
X-ME-Sender: <xms:fUY4XlkFhsG6eA6nvihqiZ9GCX0wM7Ac-JAD60GJaeRmu0bK2IJ8zA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeejgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucfkphepuddtgedrudefvddrgeehrdelleenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fUY4XvVmf3jaAymgyAHViwsoi6w8jtfZnp8_BndD5gxzpXMhbLxX3w>
    <xmx:fUY4XmcbCyhCCD42S002kbg3BvF5WQ_-U7Gbd7CtbdrkZO6HHFPQpA>
    <xmx:fUY4XrzAw4FPndTYkAVGhI-5hrLDlt9GYV1gj3EnZ5LGU25SgDVyMA>
    <xmx:fUY4XrBapvmMQgT6vHSBrilJ8-UtSI6GhtU1NNu8P3ercXtC994Csw>
Received: from localhost (unknown [104.132.45.99])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3DF930605C8;
        Mon,  3 Feb 2020 11:12:44 -0500 (EST)
Date:   Mon, 3 Feb 2020 16:12:43 +0000
From:   Greg KH <greg@kroah.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     Sasha Levin <sashal@kernel.org>, dsterba@suse.com,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "btrfs: dev-replace: remove warning for unknown return
 codes when finished" has been added to the 5.4-stable tree
Message-ID: <20200203161243.GA3424016@kroah.com>
References: <20200203151217.B722421582@mail.kernel.org>
 <20200203155236.GC3929@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203155236.GC3929@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:52:36PM +0100, David Sterba wrote:
> On Mon, Feb 03, 2020 at 10:12:16AM -0500, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     btrfs: dev-replace: remove warning for unknown return codes when finished
> > 
> > to the 5.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      btrfs-dev-replace-remove-warning-for-unknown-return-.patch
> > and it can be found in the queue-5.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> 
> > commit 87058e8dca6c3ecb0ae52d1275ee0e775fac06b9
> > Author: David Sterba <dsterba@suse.com>
> > Date:   Sat Jan 25 12:35:38 2020 +0100
> > 
> >     btrfs: dev-replace: remove warning for unknown return codes when finished
> 
> Please remove the commit from stable-queue, the patch makes sense with
> 1bbb97b8ce7ddf3a56 ("btrfs: scrub: Require mandatory block group RO for
> dev-replace") which was a regression fix in 5.5.

Now dropped, thanks!
