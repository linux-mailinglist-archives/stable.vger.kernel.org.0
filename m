Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3DB32D3F4
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbhCDNMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:12:52 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:34069 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241163AbhCDNMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:12:34 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 74B011435;
        Thu,  4 Mar 2021 08:11:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 04 Mar 2021 08:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=sCQ/5QHRHtcOSYu1YRNa/QPa+mZ
        +TmQSrDiitU+XBNQ=; b=or1b3MlG1vEnSOB+vb4TFIkGT7JwnkFFWpeTPxVUFxI
        fG3+FJZSBSkZnC1AoBdI43t+aDAj/8PF7tJIe8o7JjAMYT4ihFoG2lEZDoyVHZLC
        hs8m5957dHlJz6osqmOvvOCB7d3MF7mIeRw02JPe0xJvyNQmPf1r6ieaErykWAzY
        odmXfflpt6C18RbwHg9CUC9/QyH65YiDxl+p7KV6KUMtQPkDEIT1+MSEJKaqShJw
        k5cguGUSnVgxoaAHt7Wv5eNKuAm0DQJbMVv0pOvFgXFIsLUiGB4dZPHJgYyDwK0j
        ALgvwQHlRaC3jfRZZgYjF+YiZf960hL7moH7itkhpVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sCQ/5Q
        HRHtcOSYu1YRNa/QPa+mZ+TmQSrDiitU+XBNQ=; b=T71ORZalKvuurq9HlhLdL/
        oNEkfvzGASA2qFHkEmv916eE7sGLON44WHZ0FUpTLVz7C2Ob/B+RoXHCReKloAp3
        AqItIzy0/+FT/ZJm2zXXP8rpzzhDIhX6uxB66s3hUd5M4nTSvu0SbrzWFQEvZRLB
        z+s/Y05Gn9kp3raEzhKSDFqDidBapbqW4DvHaTFtcxc0tt4n+jd8JEZ81rS0Dg/y
        dd/Q6ow4k65zko/8TtO34XESnOFWqvI2btFT2FbtYtqnYy6LNACR7mypg7oQV7K/
        f0npgZkBQYRNSNjQV+jaon0mVvDMsfO/kEQwM4MwAbf1rcZMgNYnl1Dtzr4dlh1Q
        ==
X-ME-Sender: <xms:ftxAYH14NVzBXY6Apdk1_B9SprykaoMNWeME2PNjBVBASGaWoAQq1Q>
    <xme:ftxAYGActi5Vup5Je5PTXreKNr5otC_NXFMq4ULmlevDkIqCCZBdzNtYQgeh6mQ_f
    BcbAf4tMZPtbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:ftxAYExKrYrRWezo-Vc1quROEFNtC4plLCWBWwa7gFlTjEJZYCN5lw>
    <xmx:ftxAYEnXQ-QOB1lOJCoM1iiTonvq4pQjNtbDr86TfQynbSW2VUvAjA>
    <xmx:ftxAYJFJmfiHJnEyaTBxyc_6ialJzKoqNp8T0J3haKEwgn51nN4hZw>
    <xmx:gNxAYCRJqosFNT3ufzURfCfVJVm_m4OSEaq6a6k96N0hap7pjhiyeA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA3161080054;
        Thu,  4 Mar 2021 08:11:26 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:11:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [PATCH 4.9 1/7] futex: Cleanup variable names for
 futex_top_waiter()
Message-ID: <YEDcez2630AlrWbJ@kroah.com>
References: <YD0kv9H996Tkhg2o@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD0kv9H996Tkhg2o@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 06:30:39PM +0100, Ben Hutchings wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 499f5aca2cdd5e958b27e2655e7e7f82524f46b1 upstream.
> 
> futex_top_waiter() returns the top-waiter on the pi_mutex. Assinging
> this to a variable 'match' totally obscures the code.
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
> Link: http://lkml.kernel.org/r/20170322104151.554710645@infradead.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [bwh: Backported to 4.9: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  kernel/futex.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)

All now queued up, thanks.

greg k-h
