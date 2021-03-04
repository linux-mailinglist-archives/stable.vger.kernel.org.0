Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE932D496
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241494AbhCDNvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:51:15 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46849 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241597AbhCDNvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:51:01 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 152EF1434;
        Thu,  4 Mar 2021 08:49:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 04 Mar 2021 08:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=6cQZ873v7AbTfsWamdQwEC0EwcY
        A4zd+ouupYsm63p8=; b=iZMv3wt2Gx4P57OApxtufdqa4zfrOJxjLTRSzdFZY1B
        XiyHrAk/8sRPUl+PQfEo3ivaLPgEfr5Wcev+uE6uROBfGKRgUDB3qD7wGAnCvr7w
        gm0jVjiC6RamEBFhVEQtOjo9riwXaVvHndkAEhDP2HjzwuTDtJxFlyRLw2OSwarf
        vRGEhtpsI/m+1qw/wspzzFemf0XLlICwPVKv0lbznCtYlg73ednSTPoWlGuF8QPe
        52Q1wFxMauIrj1oXuHKB/i8tu7jO89u+uXa5pVCmjrV693AFt4Il9IV/0+wKQCPj
        SY1WSmrmsWwdBG6zBL6mhJXsehE4/rnXPRgVNGU+eeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6cQZ87
        3v7AbTfsWamdQwEC0EwcYA4zd+ouupYsm63p8=; b=qpWK6my0EZQlmy5++QCZyv
        DjImLTDncSWJVPVqeh7gbBwDtSLfMtX0H3pfnPxdv6x3lEnV+ImFW9mdtfbPfV28
        KOLDsWWtEQZnbL0ScpUWFjgKkXL8pBwoITtHU3Wt/mpiXiGE85H/VH32A+YzRPV+
        vHjbnOMaOYJ6bthtk2ATC9wxllxbnjkd/lEDPQe98uMfjdVf1ZFMcAqrtX6fdpCS
        ZdKM6D3mEE2A2LxxCW3Q9qnLMVOUDN4VsvgUGbnLSlD3S/2NNrZh6Hj3qdhhu8aX
        9XwArCB6BjsI4z83P27XvBLUNM4PwUUYdehWLHZgofiTb2vlsp+SlTVYDx/UNR4Q
        ==
X-ME-Sender: <xms:g-VAYLOk6KPeYqFQWDPU460tIAtgxmzUtVLXgZP6O6bSz1-z2dLLIQ>
    <xme:g-VAYFIN1qw6umOgjOEHuUoHrVgMXSTmRLD9Xle4wfFn2RNe6mpjCQ9TYekW5q6zE
    oCuU0JoEXpbfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:g-VAYM_C5AfBTo_-lP7psXhbMUjEepzQbGmIIn9ociQV5x5DgVcUPw>
    <xmx:g-VAYJElksTgyv8T1eIiuteXOOD0WhIfiqYs0U1sYs_H3YFDRwRUrQ>
    <xmx:g-VAYP6BVJLWJg5aVTI0fb7i_pvXonSmF7UpJPOt708u9agJ_3AR_A>
    <xmx:g-VAYBy15dhl8IPSm3uaf4WHYeaLNLml4xbUZIPoZj5d7fAPukT08Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23CE51080057;
        Thu,  4 Mar 2021 08:49:55 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:49:53 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [stable 4.9-4.19] Fix arm64 build regression in xen-netback
Message-ID: <YEDlgYsJPWZIZlq2@kroah.com>
References: <YD1G1zQT/H+CUwXF@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD1G1zQT/H+CUwXF@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 08:56:07PM +0100, Ben Hutchings wrote:
> The arm64 implementations of some atomic operations had incorrect
> assembly constraints.  Depending on the compiler version and
> options, this can result in a build failure for some parameter
> values:
> 
> /tmp/ccDOb5nB.s: Assembler messages:
> /tmp/ccDOb5nB.s:2214: Error: immediate out of range at operand 3 -- `bic w1,w0,5'
> 
> This has specifically been seen when building a 4.9 stable kernel with
> gcc 6.3.0, since commit 23025393dbeb "xen/netback: use lateeoi irq
> binding" was applied.  I can also reproduce it with 4.14.
> 
> I cannot reproduce it with 4.19, but the same fixes are applicable and
> the issue presumably could occur when using different compiler
> options.
> 
> I haven't done anything about the 4.4 branch since it does not have
> that xen-netback fix and it has significantly different definitions
> for arm64 atomic ops.
> 
> I've attached a mailbox of patches for each of the 4.9, 4.14, and 4.19
> branches.

All now queued up, thanks.

greg k-h
