Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902C92E9558
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbhADMzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:55:37 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55753 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbhADMzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:55:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 63BCF15D8;
        Mon,  4 Jan 2021 07:54:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 04 Jan 2021 07:54:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=KhhpB57NCBwpsFegDp/KnPnpp7y
        0kN/0LqejfDPizYU=; b=BstwvCO45AX5wufflWvrmbBT66O2gIu3of5PillHp+B
        olanTnFeqtBX3bvOPUCHGQvtvj/At1/6yUrKqSCK2gpucasA8FklB5ryawame91E
        Jh72PBICEfwhoZTtbT7HuHZL9lCXqhh3rXkwzxjL3EnJt/7oP9bttVLLTirsFtw/
        4gcwOtslgVHC4DPzkQg765oQR2lU3SRWMmFLPYJc0TeV2JMzLDXT93dq0GsYBtTJ
        wOhJfwvIwf1wmwGuLSyUpdS4z0G/zPvkRDOv0CoTprcvinyT7IJZ5hFmS0hr165Q
        qN3cNKBfX/EMB0Cfqwn/aM6n/yADHB5TXXZv+L5cPLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KhhpB5
        7NCBwpsFegDp/KnPnpp7y0kN/0LqejfDPizYU=; b=CXuNXhggS1+G2FAMsx5FRf
        4gHh15OrQKgdFn36edFhpWruQtxNiSioWgTifqBzrVPGtlip0xqkmCxPTvPG/WNn
        jpczDrIsaftrAygtsXDf13zDwulrn3QD5sSE4fz8h4wEAK6DNut4ZF0LaK843cdH
        K8Q33ls4PqcZ/+9weNBGZSzfnMU4qG3fe/glwRMGw5yJh2mG2fAi7yNCio2ikMVM
        pi4D8VxVukDA8N/oc8x6rYe0coCmvR587gZ5U9xSzCZfrU5v2wlxsAaqvODb2tBV
        j1O2CYD/Ao7kyqvJ2XdDEhxAMcCoj5KMbcjzaXMyPdcVM0l99K1dQZ2AG4Nxfo+Q
        ==
X-ME-Sender: <xms:GRDzX580XrG7L4y-te7UOtjGkJaliwTBj2cYmDRXCb5_ucPi2ZmZdQ>
    <xme:GRDzX9td7dS8jiCbdZaS3Cq3DAILp2lD49PttWSztc8KBOSO_Vck6SrSjSkn_BA76
    tQPUDWTRaBysg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeffedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:GRDzX3AQqFJnXnrmC3UjRFjIZUebCpPjHsyxfCVzG8hdg38jzJ4huA>
    <xmx:GRDzX9cLd7y1ywko0vtHERMDOFLTUy1-vqwH6Cu01fEQON-gmpiuSQ>
    <xmx:GRDzX-P4ysuU4f9wvyZecIZa5tJWiashaEH-gBL8PU-5hI4k17JzYA>
    <xmx:GxDzX3YfWQgP05R12ZNthlYzoH27bd8WdxCnhjN2JOAxXv4b-RImRg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 786DC24005B;
        Mon,  4 Jan 2021 07:54:49 -0500 (EST)
Date:   Mon, 4 Jan 2021 13:56:16 +0100
From:   Greg KH <greg@kroah.com>
To:     Santosh Sivaraj <santosh@fossix.org>
Cc:     stable@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v3 0/6] Memory corruption may occur due to incorrent tlb
 flush
Message-ID: <X/MQcIep4k15cHe4@kroah.com>
References: <20200312132740.225241-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312132740.225241-1-santosh@fossix.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 06:57:34PM +0530, Santosh Sivaraj wrote:
> The TLB flush optimisation (a46cc7a90f: powerpc/mm/radix: Improve TLB/PWC
> flushes) may result in random memory corruption. Any concurrent page-table walk
> could end up with a Use-after-Free. Even on UP this might give issues, since
> mmu_gather is preemptible these days. An interrupt or preempted task accessing
> user pages might stumble into the free page if the hardware caches page
> directories.
> 
> The series is a backport of the fix sent by Peter [1].
> 
> The first three patches are dependencies for the last patch (avoid potential
> double flush). If the performance impact due to double flush is considered
> trivial then the first three patches and last patch may be dropped.
> 
> This is only for v4.19 stable.
> 
> [1] https://patchwork.kernel.org/cover/11284843/

Sorry for the delay, now queued up, let's see what the test-builders say
about it...

thanks,

greg k-h
