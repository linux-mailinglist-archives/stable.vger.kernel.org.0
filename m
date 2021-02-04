Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2210230F601
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhBDPR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 10:17:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47639 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237216AbhBDPQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 10:16:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E847F5C019F;
        Thu,  4 Feb 2021 10:15:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 04 Feb 2021 10:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=+p3wHuTAcbO2AfQiy9ouwRWdQDc
        SdaVHqwFGP5tcAr0=; b=dxJ1+Ls+TVOERLzkCP3z1GO2OihocuXKiyXOyhjA04N
        jHdrhb/jD2nCNQ1feXSndHQkvMBTDDEAk8X+A36M6c+YGFzGS2YPXANhfjKx8flZ
        nhEG3ed79MHmo4UcG9dawSTRqhWa4YQUIVfjT0f059IsjhNFfOusKBkjxmYNmvd3
        nE4y3fXtRFMHclZvl1wE6ALoe4K2xx2vJukM1wqGzBIkuwinOVOrTaK3vaZAOOyE
        wLZP+ug6a567RnyChPwE6YiTKoChRnDNk+iMla01oe8Th4LABZoPe9hCcJFOWS/7
        vx7ih51dx3I+t7AMUOQ3rcVrz8imyNeiDrrDvLhtytw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+p3wHu
        TAcbO2AfQiy9ouwRWdQDcSdaVHqwFGP5tcAr0=; b=azk5bN8ogE9RPf4yCGQCfv
        8jTGObRF4nPn/PdQWAke5c2srZeHG1+FVygw9Gfa/Rq/ZqjBfEP5qhmHjfNHvQHH
        0oYGgrUFbAU7XL9nVvDyDQ7Mt+QaZ21zqqpCrTy+sQABBghQPVjL272ToSKDn7/M
        J9uO5F2ph21AhRQHUOJmx7nZd0mtG+n3VDnH9VbksMvipDh1BsXwwpQeM4LZxven
        89jpOjjCOZL9KxW2ZOTBeXNOzZfzuEfZhLxLHcTQmTcOI3A5j10V0vSBEPlnQ5sS
        AcmPoZMpZF5JboTyde2wtKZG4viVBDbI+Ac4ONFeWlM/Diq+URhssCQ4ZcAkX7+g
        ==
X-ME-Sender: <xms:og8cYB9NsVg1Czt7i4L3G4EJjrAzhSPqXPV1JmK97cMOnBbVQnjqBg>
    <xme:og8cYFvMUVHqRxdR89QMoJSBGCO5UwOS99aZcf1tlELN7ubGHY8qkTk16RcsHV9qN
    f4g0uNlCGgxyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeeggdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:og8cYPAcsmLEFN3NT3NfFUooXe3r9RZrk2rles-U1DAZ5LVco0wVMw>
    <xmx:og8cYFde-R1CaJCCTFtAoonO-1U_tb7urkidgwXKWgXTw_RozvZieQ>
    <xmx:og8cYGMZZ3SmGILekS54x16L2-zRtQFPAN03HTuHv9_kyWIPuO-b4g>
    <xmx:ow8cYFcjA_W3IshelJM_ftCxazd3p6Ow4qIUcgXkLaUrhjY34HEVTg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A54E024005A;
        Thu,  4 Feb 2021 10:15:46 -0500 (EST)
Date:   Thu, 4 Feb 2021 16:15:44 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, bigeasy@linutronix.de, bristot@redhat.com,
        Darren Hart <dvhart@infradead.org>, jdesfossez@efficios.com,
        juri.lelli@arm.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, xlpang@redhat.com
Subject: Re: [PATCH 4.9 00/10] [Set 2] Futex back-port
Message-ID: <YBwPoPxKoLKcmVL0@kroah.com>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 01:45:29PM +0000, Lee Jones wrote:
> This set required 4 additional patches to avoid errors.
> 
> Peter Zijlstra (4):
>   futex,rt_mutex: Provide futex specific rt_mutex API
>   futex: Remove rt_mutex_deadlock_account_*()
>   futex: Rework inconsistent rt_mutex/futex_q state
>   futex: Avoid violating the 10th rule of futex
> 
> Thomas Gleixner (6):
>   futex: Replace pointless printk in fixup_owner()
>   futex: Provide and use pi_state_update_owner()
>   rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
>   futex: Use pi_state_update_owner() in put_pi_state()
>   futex: Simplify fixup_pi_state_owner()
>   futex: Handle faults correctly for PI futexes

Thanks for these, all now queued up!

greg k-h
