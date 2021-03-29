Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D5E34C34C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 07:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhC2FvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 01:51:17 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36649 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhC2Fur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 01:50:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7676A11E7;
        Mon, 29 Mar 2021 01:50:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Mar 2021 01:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=NfxygTjF21CkAar3h4Buj9dNcp2
        7qlZSFcwGrlo/1BI=; b=d1DbWZTJiOIh2jV0okhs/husEz7KmtTzCk8T0D/7945
        mPmrhPtAIYLAXLOVBfOfGhFWYJKS0mNtJui4G5/7HKXMEK+w29/LmRFaom/d0+Q6
        dcrZAU4JZERPzmOb7PaStSdiNJExRMEpqp+pmDlj5XCnvXNsCIFARMWyxy3Y8o0U
        XwdiDKG19OJvQTLTC2V7qKfKuMvTKzfvLTrWOnH3PPU9rp3TAGgyUoCzNOLMhS3D
        djL8e7oytVijFB14rOaGuNc+CQEA/h21okQ0RRZbCq2JxKiRXhDFFa8faysvUGWr
        xzIm4JAEt5OCS7AHQw5wDgNPqwEbwnkAXg/s0dbSTQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NfxygT
        jF21CkAar3h4Buj9dNcp27qlZSFcwGrlo/1BI=; b=jhq82gNOPxtexf73CAJHo7
        zZphbKI2sJNwvTBFzKPPtRjAYGpD9CrbJ+XplJXsA9Qim8pd45SvbK5aeZWSi/Vj
        /BfqQOF7tlN857hB+bEVSUypet0qpNIvuuQ0LHyD34HaCm55au9fPXKXKTIedoIa
        TI4ejfQdE6KZJkPBgqprAEYjp2Sy/qf79jqIGxRMAYSlBC3pBGktf8SACKzuZXme
        k2WJy/52R/MdUShhdRTryqxh0MATkIhe2JYxpEaFlbRqi6ZBnZFGkURlAic8na1N
        pAkIDiQ9Hjq8Clu80B5t7zMQQJKm6MCILYFSS5MdQlQG1+CHty0KMaZ55meUXmHQ
        ==
X-ME-Sender: <xms:tWphYPOpNQyptDmglgi6IRMDf1-5z5V8NtzejlVoP1WdVxmqrkTTlg>
    <xme:tWphYJ_KgxeESN4Rg_QdUksVfP8v5BWtZ-0lQiIej9HrWw9QvVj4bdsd86HXqCYKv
    Hm8jM0nVs4g5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehjedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:tWphYOR3HA9E1aIWZviUNZpdOszl8we0w9OjaYvSisHOt-xt-tr79g>
    <xmx:tWphYDtQ6YXnYTPBr8wHnKr2sV8KjA8jj9Uh7HjABg-5socwMTAbpA>
    <xmx:tWphYHfvE_-GKD_gdxWDzzOlsxIhUhT3FWitEvAV6AVzaTYYuOuF0Q>
    <xmx:tmphYIrUSoUQYA7VUHVnkJQOyZCDF8h1b3ioyANGaJtOUYW2Rgt-CQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56D6A24005B;
        Mon, 29 Mar 2021 01:50:45 -0400 (EDT)
Date:   Mon, 29 Mar 2021 07:50:43 +0200
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 01/13] futex: Use smp_store_release() in mark_wake_futex()
Message-ID: <YGFqs26105c1kNyr@kroah.com>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 28, 2021 at 10:40:54PM +0200, Ben Hutchings wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 1b367ece0d7e696cab1c8501bab282cc6a538b3f upstream.
> 
> Since the futex_q can dissapear the instruction after assigning NULL,
> this really should be a RELEASE barrier. That stops loads from hitting
> dead memory too.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: juri.lelli@arm.com
> Cc: bigeasy@linutronix.de
> Cc: xlpang@redhat.com
> Cc: rostedt@goodmis.org
> Cc: mathieu.desnoyers@efficios.com
> Cc: jdesfossez@efficios.com
> Cc: dvhart@infradead.org
> Cc: bristot@redhat.com
> Link: http://lkml.kernel.org/r/20170322104151.604296452@infradead.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  kernel/futex.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 796b1c860839..e112a9d4c84f 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1565,8 +1565,7 @@ static void mark_wake_futex(struct wake_q_head *wake_q, struct futex_q *q)
>  	 * memory barrier is required here to prevent the following
>  	 * store to lock_ptr from getting ahead of the plist_del.
>  	 */
> -	smp_wmb();
> -	q->lock_ptr = NULL;
> +	smp_store_release(&q->lock_ptr, NULL);
>  }
>  
>  /*
> 



All now queued up, thanks.

greg k-h
