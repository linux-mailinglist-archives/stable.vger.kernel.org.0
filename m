Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630479A3E8
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfHVXh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:37:26 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:56129 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbfHVXhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:37:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 243A547C;
        Thu, 22 Aug 2019 19:37:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 22 Aug 2019 19:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=k
        V6VTtSTYRYPv3CE5R7G8K9FlaRZaZR360NSNauSTn4=; b=KYdGVAgLqklFVddvE
        pfpnB5E85+YKFvWgyC4faCutvJj/rvhbBXxg0siE1H9Afh01KepHEnZ3hCl/hO6i
        X5MM1+OZvC9fiKXPUkuLKVN9SM7MBLRITH6nWZCq/Oiyix7ZIastKMflDVoOiZfU
        uI8es/rnj6Th4Rqz6/UVt8xSLRMwNyNQFAGVxuw29OaZ5bqVkkFWd4V/IQddqKOx
        aEqTMJWfbbemstLGkSSSmcikXi6Ir9Nnj8L2X06laRKMzKqhUQ5Kk0qof8micty0
        S+A8kRqAi/2iyfTzOr6FYocfWt8kJGpX3qHa8A7jdflfOwQ4yWDwYk4arsiCHfPH
        bP/5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=kV6VTtSTYRYPv3CE5R7G8K9FlaRZaZR360NSNauST
        n4=; b=pocvKiFuHDqWiAieBOxlh2InFHmXz58OTyx3sY6W7IcDs3a0k8D9vgY2f
        ilAKDNJiopdeOJAcJaImzoa8+cnSEfi28iIdTiCRGUuhQ9WpLy8UdaACgwhcbEti
        ezVeGImUjzhICbdOWvmzQhCuX/MIPDjyJfoNVYnUfIKCdKnOZRkZ1CHQFAJ1Ol4r
        PTRC2Zol84dLQNVdNbfX54gfO43QxdvFwro+oi9Bu0Xc71LnizhvT14kmp1kisHK
        64/cQb8TqecrGZrpRoyPDUiVm0EdwibVZFEZqYU6kvB0gt/VdKMPYPvznpfMwnb6
        UhgOtTjBkfb2B2uUFd7KSu7uNXb2Q==
X-ME-Sender: <xms:LydfXbx9wbWI8WLTdhnZ9_bRhfy2YhKb19A_k9i795HXReJF_91hIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegjedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhprghmkfhpqdhouhhtucdlhedttddmnecujfgurhepfffhvffukfhfgggtugfgjggf
    sehtkeertddtreejnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrd
    gtohhmqeenucffohhmrghinheptghkihdqphhrohhjvggtthdrohhrghdpkhgvrhhnvghl
    rdhorhhgnecukfhppedukeegrddukeekrdefiedrvdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:LydfXXhmzswfTqgRoEClCpShwuX2cWbiMkod8ATqmT21PN1il0NZJQ>
    <xmx:LydfXQVePOwlx_jn89fAu9MmAHth356ZybAcXcjwHhT4mKdBleMWuw>
    <xmx:LydfXZ2Px-PGEbf9zDWKsxJut5bAYTox3j6JKW4lTNOVIOL67J8iDQ>
    <xmx:LydfXTwAGvHu6jl7efPVnSUI0k5vRJGy5MJeqhrkwkkVbawO9uau6zqUAIc>
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 130EA8005C;
        Thu, 22 Aug 2019 19:37:18 -0400 (EDT)
Date:   Thu, 22 Aug 2019 16:37:17 -0700
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190822233717.GA24034@kroah.com>
References: <cki.A52B1C532D.YEFB2VN58T@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.A52B1C532D.YEFB2VN58T@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 06:48:50PM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: aad39e30fb9e - Linux 5.2.9
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/116984
> 
> 
> 
> One or more kernel tests failed:
> 
>   aarch64:
>     ❌ LTP lite
>     ❌ Loopdev Sanity

Odd, what suddenly broke?  No new patches had been added to the queue
since Tuesday, except I removed a single patch.  Removing a patch
shouldn't break anything, right?

thanks,

greg k-h
