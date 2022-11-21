Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358266320C7
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiKULgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiKULgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:36:14 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF22253D;
        Mon, 21 Nov 2022 03:32:48 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4BAB3320085B;
        Mon, 21 Nov 2022 06:32:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Nov 2022 06:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669030364; x=1669116764; bh=woC/8LFFsF
        PfyCPBhiRALW7BOweiWNTUxIZltnosklA=; b=E+tE9iNh4uUu0B/XkUfS6o7lGd
        G1mZkS7md6OBYYA7sxE9hzUV+xedu7u7kkYOL23beIG3pDi/1uA0kbgEALx2YeOr
        0JwN89pjXXyt6nMv3dkFbWgT5AOpyIcaH47vgKKTvmUWgmH5Y/8TouzD+l43dYHn
        FajgLdE9CwoRheA0IK/C5p0+ugLEb4iU4/5IOa91q4HZmAoH70YAbkHYTMUmA6XM
        iIP/izU8+mgla9ycPRxTUH3j9Te32Nc9mVjMO3VqDUj4yBu79f835lK4DcR8Oonv
        lsl23DJeHSwJ76ZhM4m4716Kwqih794DumBlz6kpyd1R1aXjbfWmZHg7IueQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669030364; x=1669116764; bh=woC/8LFFsFPfyCPBhiRALW7BOwei
        WNTUxIZltnosklA=; b=UlBQ7efpIPaTFcFLQVqZ8A3qOH7ulCxyA/9mqxhb/1VY
        UXylcsS6005KZpvOwF2NGpzMQu6hdI3/HnyJOi5AjFp6sS4IfhxETj/orFAEGRku
        QlEp2IB4sSAIiji2ih7y+gX+AqAeWa4ibyyc3uuUlxvtumWcXu8hilT4ZNU1x3E6
        eCjeT2+IJ3mHBJhXthkUIBvtDg+NCrjBhOgYK1y9Ax1arp0WAcTi9njUgrNWBCRu
        aU5/tcTLFwySqjENt8H9wBM7dyd9e0+0g6lHsWV9p7bPtyCLVC7EmBN2xsb9BqET
        HCFbxXa3L8qW816sNBUicwvIJoEJFSoIs8b1YYYgsQ==
X-ME-Sender: <xms:3GF7Y2VPUMh4spU7f0xeD7318d_pqS5ZyzwTCyWhTlnmFQKpyFSwLQ>
    <xme:3GF7YymomICeOo8fQiBRNjpWJIHs4FCXTrhKYi3wNInFRhbqLssPlsoIZDNgWyIWL
    rBLcAwtedJ5jg>
X-ME-Received: <xmr:3GF7Y6bHQHMVhbJvBQU9Zcl4YERFBEoblGE6e4yW6gcGnO1I3s11Og6X7Q5NPUl3l0BlxLPrs1hG4--YKXnN17wsCDJT-ecd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3GF7Y9WR34thDt88M8xZTzs0QtFTzrSEo2i5dqDI7DphSAmj9cO3kw>
    <xmx:3GF7Ywk61s3ZE0r0ZDLd2NDalPNC5NDTfKvkJ3RDraUEHLH1qZ01mw>
    <xmx:3GF7Yydojev0V4qIdcYUhnJXIH-Sb3js8R_fdt-T8O5nMr3IHT7JVA>
    <xmx:3GF7Y18WiIcbfm9uYU5AHWg8eUfNSVasGsQm6193xWfvyMA7TVqb-g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 06:32:43 -0500 (EST)
Date:   Mon, 21 Nov 2022 12:31:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        stable-commits@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: Patch "l2tp: Serialize access to sk_user_data with
 sk_callback_lock" has been added to the 6.0-stable tree
Message-ID: <Y3thooxAN2Are7Ai@kroah.com>
References: <20221121050850.2600439-1-sashal@kernel.org>
 <87o7t07k4l.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7t07k4l.fsf@cloudflare.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 10:05:11AM +0100, Jakub Sitnicki wrote:
> 
> On Mon, Nov 21, 2022 at 12:08 AM -05, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> >
> >     l2tp: Serialize access to sk_user_data with sk_callback_lock
> >
> > to the 6.0-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      l2tp-serialize-access-to-sk_user_data-with-sk_callba.patch
> > and it can be found in the queue-6.0 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Please don't add the commit below to stable tree, yet.
> We have a fix-up for it under review:
> 
> https://lore.kernel.org/netdev/20221121085426.21315-1-jakub@cloudflare.com/

Ok, now dropped from both queues, thanks.

greg k-h
