Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E1D318D56
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 15:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhBKOZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 09:25:11 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34113 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232230AbhBKOXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 09:23:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6F7F458025B;
        Thu, 11 Feb 2021 09:22:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Feb 2021 09:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=JFZ7YHgz567pwZ8pXcY1GfLrs+i
        XNGVtsKz/WPRFyC0=; b=TIwh7WsXN5fvHUYtKkxii95O8Gi53miNjj/fZYC/OSx
        BUqnbZ2s0ZYznMooKgyc5zBVVPEoiwWtJ3cdHzITdGwciP2NI5cOGeM7qJ0COUBB
        vJhwemcPUzIwnQZxE3niWALnj3r5eHIulTPVgcqVXRwf/V7gZzlK+Z3xLD4VfdWA
        ZpnPmC8DfAwnRkoAcZbEwxzatyStENoEyy22TeUt4W8/fNHStFWVtTjcn+0TP3h9
        GilEgpiC642ztWVBz0+UG+m67XdLfWe/zsXQOF6F6tiS22aKNiZBTjN2F5MmyzCo
        Bg2QvtfBdKrGBJkpn1h2PS82uP4Q2U0R9Yw5LuI0S2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JFZ7YH
        gz567pwZ8pXcY1GfLrs+iXNGVtsKz/WPRFyC0=; b=SpFZRk0RUeJ6vEPgMgN37v
        iLtu6caBnun6Eqe944hDMeIHV1gh89oljqjswdmQvJFkyRSsybfoMFwNKoaDILcw
        amMlHRjAdaXbrThL/9lGFAcBCo3o31RDZ+gDg2u3pe6WX38djvE3Q0mCZ64BODXS
        Ad9KHS/kgl76e/X+asdiN6PuETOXVOFLv2lhCYCFk8CJ9rm3r8ABys0rtxJ89jWz
        n+u0ItocHdY4YFek77H+FIfolDnqEbBW3h6QDo0/iMjEVWxeTPOpEtjWAHYO0XJH
        22WsILHk0RWPWoHblEwQicVCPfMLYqPJbxHzcmUx4/GD5zGSBP4poREnXs1hEPng
        ==
X-ME-Sender: <xms:lj0lYHT_u8Hbem32h2Bcxpyf_ZDIF82rc751TrgsARKa7Ai8WCInCQ>
    <xme:lj0lYIwYdMMaGnAf2EYmFjq0apBmikU2oSKCQ93fC4uoJEZDYXzUszarKzRDwCKcq
    UdyKC1UkqFL0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheelgdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lj0lYM2T7Iaupj8WSt4-CQInLRocDa6wkolFfiuXgS1WFqcopkPHXQ>
    <xmx:lj0lYHCIZEvvvqwJQdYzXPguvVUe7OpgyXJ5bUOPoH1OwI4Mo_ViKA>
    <xmx:lj0lYAh85o8v08Pcutcob5NeiZALgbqlj5xo4ZhIQHptkfwmTirsXA>
    <xmx:mD0lYPoQFZfxCRseZq-itfOSs-TUvNoMdbc9vloDbuEpHvMlhzYR0Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 746FA108005F;
        Thu, 11 Feb 2021 09:22:14 -0500 (EST)
Date:   Thu, 11 Feb 2021 15:22:08 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, zhengyejian@foxmail.com,
        bigeasy@linutronix.de, bristot@redhat.com,
        Darren Hart <dvhart@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, jdesfossez@efficios.com,
        juri.lelli@arm.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, Sasha Levin <sashal@kernel.org>,
        xlpang@redhat.com
Subject: Re: [PATCH 4.9 0/3] Follow-up patch series to update Futex
Message-ID: <YCU9kBNvlj1Jiyya@kroah.com>
References: <20210211092700.11772-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211092700.11772-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 09:26:57AM +0000, Lee Jones wrote:
> A potential coding issue was:
> 
>  Reported-by: Zheng Yejian <zhengyejian@foxmail.com>
> 
> This set should solve it.

Now queued up, thanks.

greg k-h
