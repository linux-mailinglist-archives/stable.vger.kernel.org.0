Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C501CF392
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgELLph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:45:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51275 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgELLph (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:45:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 345BC5C00E1;
        Tue, 12 May 2020 07:45:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 May 2020 07:45:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=CgwbE++isZyh3ATrtRIk7CV0qzN
        Yg3YqRPlybExTQvQ=; b=ai/6IKq+PjIBYdqmB00V7zCtQ5OORYogAyFp6PG+Ww7
        jmFOiRjsXHKsSfhcPpLB2u2w7cZIx8j6fSNe0oChaL3Wa1/f0NXq75ZxG4pSC5tb
        D9Z7hYadD3wNShYxQvceom3G9gCkdxe2uh5ukcy/Tj+5u7WbNxr/bQH4GmWH4Whi
        kIUcsvFM+/6B9biMt7oYdymIgDZRqZazJGCxs8dLkLA2YZZmWnBpIIfqMX7ZmU9T
        LVoaNjbf+PZkrpieXFPXYH7c1cLuWo28/em+oP6JcwdqH7gKKPj+KNqTLWIKxGny
        fzJWOCc+O0tgJfbGfAqppv5gptDjZMeO30HZdkqVjcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CgwbE+
        +isZyh3ATrtRIk7CV0qzNYg3YqRPlybExTQvQ=; b=dfribv2oTfwMksipTTVAGH
        ma8ibMGxYhwHJxfugABK9kUGF9TESgHtraGsW9nNdEUUBGPtSfoCmzeyFY1ebEcO
        xEbjXL22IDyZkCbzjBSSpXRAVkO62v1oKHe/nTjZ+eynk0BjdzYGZRbTiqIQZQHv
        3b4hNvVVkOYmYZ6hKePJBB3VCts1siK0I3v6v4WytAggS+fcbsYW43eMbW1d0vAp
        XQsAZlVoJdypCoodF0WCA6rHi4H43U1dAYJCC9sCCe1JaLeIi7kg9FZh1mf07wB6
        s6ev7LKNzh4iurqzmWpEDrI7T6M86iOuGHm/eB1iL6esii9VkJp3RCgiqNqTR38g
        ==
X-ME-Sender: <xms:X4y6Xo42oE_nwJQQxEd-SKlA7huq_hL4C-Kd-dM552lRhzVGNglwuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:X4y6Xp7qGI-_7cRIjn-BgY1gcPwRdwtRhmdhLUukidQvWCgoX08vOQ>
    <xmx:X4y6XncxbpWFohzTEPPfEsYDbM7uZ8mCuYb_8FQKcZu38XV3aKgIkA>
    <xmx:X4y6XtJl87C2N_r7yr967xE6lVUijCXf4Iewxxo1yEnqGLsm4Q691w>
    <xmx:YIy6Xg3UWXtCWVw9AJ7ObGBnAaiPmY0qK7gxoJ1FB2PfQh6I2oP0MA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 674EF3280066;
        Tue, 12 May 2020 07:45:35 -0400 (EDT)
Date:   Tue, 12 May 2020 13:45:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     stable@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize
 < pagesize
Message-ID: <20200512114533.GA54730@kroah.com>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
 <20200329021728.GI53396@mit.edu>
 <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 01:37:59PM +0530, Ritesh Harjani wrote:
> Hello stable-list,
> 
> I think this subjected patch [1] missed the below fixes tag.
> I guess the subjected patch is only picked for 5.7. And
> AFAIU, this patch will be needed for 5.6 as well.
> 
> Could you please do the needful.
> 
> Fixes: 244adf6426ee31a (ext4: make dioread_nolock the default)
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=626b035b816b61a7a7b4d2205a6807e2f11a18c1

This patch does not apply to the 5.6 kernel tree at all.  Please provide
a working backport if you wish to see it present there.

thanks,

greg k-h
