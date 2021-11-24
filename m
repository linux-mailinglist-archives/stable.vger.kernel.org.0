Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC8D45B56C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 08:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbhKXHhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 02:37:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59413 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234291AbhKXHhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 02:37:05 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DA395C0099;
        Wed, 24 Nov 2021 02:33:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 24 Nov 2021 02:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ZlqFarHAXijg9pmi5CNDixjvKeH
        xGYNcISljKKu2PdE=; b=SUdCYeOYrZnIzGrnaYAbDXBM0pURP7nSl/mS/lEDqAZ
        6vLjoQbWLDKMqECDdc4LWd7qKaucxlN3KsvhX6hIWBaMhNNwzLyuupUjRse+bGjX
        IM1RYEQi9/Ns+G0jS2wYc9eJnMsB+wsAfE+t4ZaVRFLukgKpStF6a7rEQf6MJEZ3
        AxIlFhbcn+Q9aF3SjdzcdTo8p+9t9weJ1I8FjR2VGN+lkaQAHPe9x7Nm/AZIjOgM
        YQMtlWoizX4z6LctpGIi0tnvRsYv50prqq8+6YuVtSyU5oQnpdA3TcPF0+2diGHe
        5TMtNyitt0kiMgNi+mECoAgwH5idMJR6B2zCy24Soqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZlqFar
        HAXijg9pmi5CNDixjvKeHxGYNcISljKKu2PdE=; b=Ri1yMkHdkeG/GfUrvGJqzW
        XJajV9O/MdsFlxYIDRDHSEMhOKGv8glFwWANoMCcPoAGB+qBjnEo9Zlf2gBI1GpJ
        hE0J8iBqLkM5gKKpIU724G6Dlz5nRN+bC/4hDZX1plXSO9w+bdN6O+gA96W43wb5
        vxSWRs0F+lw9tewsHXLJVk8fEaCtvfUGvK3OjDC8+Oy4lk66nYaJMSLyBvZg0rN3
        YOse8oCeB6+6yIHHKlB7fowXKMiC4cwd9pngoYpYTK+EctK5fWbaUhClvIMQ2mCc
        xsl+6pXNygcP2X4Y7NDKEnspxWsEAX1ghEAVZa0KhbP1LBkWfQrMbmFOyxKoNgnQ
        ==
X-ME-Sender: <xms:4-qdYSDf0aftvUUAU1LFe6jOEtUvErDJsrWDCXZkSQcxE_i2HD9RHw>
    <xme:4-qdYcjcSLxNX-Lr-zqakVICekjPVAkdBXcA6nZhhuHHBG7Kokag42DfLWRISnaRT
    eARvmvDjBCzCA>
X-ME-Received: <xmr:4-qdYVkJIpFfl41bHWVIdD3Lo0fSMnMiiG7K-geij1toxRDJcj9xr6QYkt3CqBoq2AKIjpuNmy2Ne2lFOR_EUirGjfdaor5l>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeejgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnheplefhueelvdffjeeffffgudejteehgeekhfefvdeiueduff
    eftdefheegfeeutedunecuffhomhgrihhnpehusghunhhtuhdrtghomhenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:4-qdYQxd03DRZSXpyH0dmCTOR3Dkd-AevfiYpUPGS6bLaVwtnWkOug>
    <xmx:4-qdYXQq61pUrmmloKcrHmn8rMoRXlULbJgQSn-OqNiR4EegB36Eeg>
    <xmx:4-qdYbbnGzptW6MF1cdstsJce83uXWrjjhLvo18FwuA6TOkf-8CdTA>
    <xmx:4-qdYVOJlsrqR3gjOMc8-7XUNEmP2TQ5-usS7ZV0f9HCysSN27kiKg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Nov 2021 02:33:54 -0500 (EST)
Date:   Wed, 24 Nov 2021 08:33:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Stefan Dietrich <roots@gmx.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
Message-ID: <YZ3q4OKhU2EPPttE@kroah.com>
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 08:28:39AM +0100, Stefan Dietrich wrote:
> Summary: When attempting to rise or shut down a NIC manually or via
> network-manager under 5.15, the machine reboots or freezes.
> 
> Occurs with: 5.15.4-051504-generic and earlier 5.15 mainline (
> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.4/) as well as
> liquorix flavours.
> Does not occur with: 5.14 and 5.13 (both with various flavours)

Can you use 'git bisect' between 5.14 and 5.15 to find the problem
commit?

thanks,

greg k-h
