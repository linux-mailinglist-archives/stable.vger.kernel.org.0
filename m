Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3312961EDC0
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 09:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKGIyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 03:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiKGIyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 03:54:54 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB7D118
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 00:54:53 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A30E55C0105;
        Mon,  7 Nov 2022 03:54:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 07 Nov 2022 03:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667811292; x=1667897692; bh=MEEECed86t
        pJJkdAvjg/qBHF371TsotOWNmBQ70a8MA=; b=RfVBi9WkXzoNyQJ43nq2gDZ5KW
        bQWer/oVGbhxmEggq2tT71qiyc5BSml1XEp1MRpUTe9M0nfiT7BecNGWn96/LuBO
        pkyGTVtMBIJTSdWAJE9j9FkUIxrQDgVgHotZALN3Yts7ScidthNO0jMWFgpY5yK5
        eHmHZNspI1khOrEZe0LL++uWyg842a3bAvmPW/Xi5WrDrKsrCyzBCXUhlD/BstUw
        SRHwCgEWuA3OViL/3QhuilUN/wC0G4TFNfvq0/QUB11zqOv7UyqoCncn0QzfvDAT
        tcfLIqiKY+RyLWfQsXdK6Poc3bmTLF+hoftI6D6E8cbkD4PwFksCe/ds/wpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667811292; x=1667897692; bh=MEEECed86tpJJkdAvjg/qBHF371T
        sotOWNmBQ70a8MA=; b=wCbT2RqOQKI0L/8anPZT2LqLDwszAQr62L3YVXGkkVpU
        g/Wu1OoV7oPG3XLfgYW0CNTPrZScMxRtddmmEloyOOIb0JmZVwhCtUL0VE7DtnlR
        RPBSDv/yIdcZBHDAXqyDqI/+z2U5cNc9eEcb1gwtNZDhMMBl1ntpkTwvfIo3mww0
        xu5HvWKfk+L/gU8xNYlgCCDd3OLqpEBlQgVkTLfyrPyypg+uxFP4/datUVrGjEiV
        pRqthjDqHQi7fCrbSDXwwb03c5UYuJMxbqFGGCyNzqaG1RbUz/Gosum8SiBUt+MY
        Lxz35fBy5PVczR7KeJ57SPbR+FbnetEMoqUulFXWJQ==
X-ME-Sender: <xms:3MdoY4W7V1YUxOCdUT_E3t2Nsqtw0q4MArBbv2N34YbaRBCNJAnPDw>
    <xme:3MdoY8lxZhLHV6aC9lp9K78DMvvrMkhcJbo_U7azIaXuZFyrd5hzO3gcf-e7lWHgE
    3NVi0i4yP8-5A>
X-ME-Received: <xmr:3MdoY8ZghQokkR0RpT7PYBBw5hS7ZqVD-8g5Q5JqfDWDShHRgUn_Eh2ndoLwZyEnUMkAzSxm2j6HuaEBx4YjDNKI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdejgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:3MdoY3WEJ38NEfMAbokT_0h0o7MCN5cDfUIyXCvU-crM8JCn7y5hKA>
    <xmx:3MdoYylI9HJuB0ELZNG-Hd9GX2Zj4A9gcufR4tu3Hyn15Zz-E6D7Rg>
    <xmx:3MdoY8criv-Gdj7fyPQ7oQP3gBD-FMEz7tvl53Wvh3XpPqEQNNoGcA>
    <xmx:3MdoY84GBgiH4t6NeAuaUydjjEVVhDdtRrvzrL2B59rn2Y5P1EN_yQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 03:54:51 -0500 (EST)
Date:   Mon, 7 Nov 2022 09:54:47 +0100
From:   Greg KH <greg@kroah.com>
To:     Khazhy Kumykov <khazhy@chromium.org>
Cc:     stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: bfq fix for missing lock
Message-ID: <Y2jH17vUg5W5qMGK@kroah.com>
References: <CACGdZYJajC76+92imPwBHUFcYQLmJKkX2xjjpoTvhgH=v9+JZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGdZYJajC76+92imPwBHUFcYQLmJKkX2xjjpoTvhgH=v9+JZg@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 03, 2022 at 11:19:02AM -0700, Khazhy Kumykov wrote:
> Please consider backporting 181490d5321806e537dc5386db5ea640b826bf78
> ("block, bfq: protect 'bfqd->queued' by 'bfqd->lock'"), which was
> merged in 5.19
> 
> applies cleanly to the lts trees I have (4.14 - 5.15), glancing at the
> git history it looks like this bug has been present since bfq was
> introduced in 4.14ish, so the above stables should be enough.

Now queued up, thanks.

greg k-h
