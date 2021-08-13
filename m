Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B038F3EB2B6
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238856AbhHMIj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:39:26 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59973 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhHMIj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 04:39:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 901C1320093D;
        Fri, 13 Aug 2021 04:38:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 13 Aug 2021 04:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=FwpYTJeWczzk92WbeGwsGqT0n98
        uSC0n4iLI8iyzRhY=; b=NjtP0qlr2q3UY80ZNSCNIyoL415MnkNssm47laQPG21
        mmgw87+uRVkpaJ1OQXFsdJEyQQPe8jWNIBD1uMy7mnKIJHZb6F0EJeNDikNyvJST
        4eTQyyQPmq/HmaBiOku861SzyohZEYE9Q9i9JpudcKgpwFXBwqiX3LazVY0R9huC
        2dbZKrCPbvGgyv79DaSiCHoI2EJeSy2CgT0A0ZWLCxJqnLak67A2CZ/1Y8+LoYsV
        NyiWC46AZUAn1og4CnyYmRCN11b3KY1r64sgi88Ln3RIx2RyeBYZlfuWlg8vcoYj
        3q8nIPZi8e3YDP2U95IvzS1Y+hT8WhS+a8P225Nw6iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FwpYTJ
        eWczzk92WbeGwsGqT0n98uSC0n4iLI8iyzRhY=; b=vaKdUS4USCID9qMUgytbOk
        AKt1R2ar+bw6hYxcKX7+Gx+U4m7yIcvFGpR1CAtRHYkN3syJNW8OaRUEW452Eyvj
        0iwQBPDFJPqTLi6qHnGA0vPHQzRXcaRcd6Rya0yP/FiOXnBoNHWDFH/wtc9enH+R
        fvX4YxpBzqWUhWkjfUQD+zSpeQjBj34ONRgYLJJwmh5HuJnft4N3lK82vgF00y4h
        S1UUjeBtfTWVz3PMelTNbOVYRdQlpe8mlqjGPZlrXJc9WsBFc+n8s8iVSiMea/3i
        8OmEWohBGaVi7AFnTtH5SD7NNCN8MDHsfgQ4ASHBM36JQNCNyXK5FCmEOdI3cszw
        ==
X-ME-Sender: <xms:oi8WYWNGnUKLtiE1VNefuyqetReeLlkDLl8LVb0COgw5lA2RqgWB8Q>
    <xme:oi8WYU8Gbq_UCsxhPi4cMnrhyEB729WSaXuAcoqkMLugmLSRUFulXgHHwhoHC93eX
    0MxmxWJqLZNpg>
X-ME-Received: <xmr:oi8WYdQBuNViHjXFtsha1JfIvHULjyldSCQvF_44MEhfmeGwY4o-OL3ofu0310d9dBjKX8KdA3GRYZjN9DPAvl7VoQlq_hB4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:oi8WYWurUB0WHwoHdUGfNG_VyKKGxX65ErMQmgbwG_ordoByk8y9nw>
    <xmx:oi8WYefiQgIbINFsKhgFw3Ynx0gRGj6WE4ZWQGw3zsQ9pDwKhYwcyg>
    <xmx:oi8WYa3CMA47dnmt84t3Z5ZvxFoFV4RqHEkAGJcM601EVZqI8p2GMg>
    <xmx:oy8WYd4IFwgaxXDYwMvK7PzrxKkrvY__NsSZ_fiUfwMPIFMeOTrTrQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 04:38:58 -0400 (EDT)
Date:   Fri, 13 Aug 2021 10:38:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 4.19 0/4] bpf: backport fixes for CVE-2021-33624
Message-ID: <YRYvn51P2Or6deXs@kroah.com>
References: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 12, 2021 at 08:00:33PM +0300, Ovidiu Panait wrote:
> NOTE: the fixes were manually adjusted to apply to 4.19, so copying bpf@ to see
> if there are any concerns.
> 
> With this patchseries all bpf verifier selftests pass:
> root@intel-x86-64:~# ./test_verifier
> ...
> #657/u pass modified ctx pointer to helper, 2 OK
> #657/p pass modified ctx pointer to helper, 2 OK
> #658/p pass modified ctx pointer to helper, 3 OK
> #659/p mov64 src == dst OK
> #660/p mov64 src != dst OK
> #661/u calls: ctx read at start of subprog OK
> #661/p calls: ctx read at start of subprog OK
> Summary: 925 PASSED, 0 SKIPPED, 0 FAILED
> 
> Daniel Borkmann (4):
>   bpf: Inherit expanded/patched seen count from old aux data
>   bpf: Do not mark insn as seen under speculative path verification
>   bpf: Fix leakage under speculation on mispredicted branches
>   bpf, selftests: Adjust few selftest outcomes wrt unreachable code

All now queued up, thanks!

greg k-h
