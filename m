Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEF9C46FB
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 07:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJBFcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 01:32:09 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54887 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbfJBFcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 01:32:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9CAE44A8;
        Wed,  2 Oct 2019 01:32:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 02 Oct 2019 01:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=2ae/lnHSgT/krjDtV4hDIFs2kdL
        Gh9JksUk23N47I8M=; b=DzSdpJcq2ErRfG1wezit5v3+Akl1Y9znso634I0MErJ
        PMZKtTtLUgvfsMfoGlKiCIHKAOuI422drJzeoy4WL5adklBdZDg/N2kZpAvH/7QU
        iawk5EvJAXYv0500mgiZGC79elCRRNS9aAbMAi0uZ37cnUR1IJw8cJYrzmF5saOT
        nb7jUxNlNwYywufhiPFyMb/UPWMC5wpf/QoO4EqrJYHSSVLlu5D3HNSTOp3miEM2
        ktTf9t4RUKJUfoUV3QoCMp88aVRf7IyUsehQ1Kzr6vO4UTKcG+oVDrPxUWSnTCRy
        JnpcbWg8gLwg2+exgVHR7aOLz2p5qkOtoWLNgGrJzDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2ae/ln
        HSgT/krjDtV4hDIFs2kdLGh9JksUk23N47I8M=; b=yyGauRQ70+bV340+G0CcWP
        waTHGhU7J5vaRddC0Xt0LyE0a8akCDzwbYYYZQ/qqinnydgErb+NshFS/BczirXS
        zpk25WIZk5sAEpcHYQvxQbJrnu+sJShv69DdwHJJnswyFsWzzXndbUhTpXhFyuOF
        xWnrNpPj7FHrfClkL+sW3ndb5wjorypF73x+kMcwesHfkMPA2KFCPM3JLl7Dx7d5
        8M/EYCLfyhtN1hg0TN0bvtp87O5DLuHKF8SWRULpO3mLmD2WCZMVstyWES1odVUM
        zxViR/8TnsME37q3OEUI+3EoZflTO4xrG4qQXc7oynYOVPyECgs7KFqk0Nl93NZA
        ==
X-ME-Sender: <xms:VjaUXetVCkvUR-0bcac3m6lJyQsvHz83MUQFa-RoUYH96ka676ZWfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeehgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:VjaUXUY1dHcHaWb7Mvt5_VshJYXO9h4hYr0Ekr2rw0uErOYPdJypUA>
    <xmx:VjaUXaGYjPO-iQVSN6cItUpfPZf7htUs4_8Vu2_YkOKabbxsFInuOg>
    <xmx:VjaUXXps6wM3lSwvF7x06FU5tBiRyZujtVK4Rc5jdRcEWRpjtFKSoA>
    <xmx:VzaUXZ5c1TCBqQ4Xhu8sw9rgcA6643yDyQpZec7xY_e4Jbk_-l6H5A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2172D6005E;
        Wed,  2 Oct 2019 01:32:06 -0400 (EDT)
Date:   Wed, 2 Oct 2019 07:32:02 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.4.0-rc1-643b3a0.cki (stable-next)
Message-ID: <20191002053202.GA1450924@kroah.com>
References: <cki.7E7289C905.6I9MGQOO2V@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.7E7289C905.6I9MGQOO2V@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 12:27:24AM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
>             Commit: 643b3a097f86 - selftests: pidfd: Fix undefined reference to pthread_create()

That is 5.4-rc1?

Why are you sending those results to the stable list?

confused,

greg k-h
