Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01672B79ED
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfISM5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:57:39 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60843 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727980AbfISM5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 08:57:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EDEF87A4;
        Thu, 19 Sep 2019 08:57:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Sep 2019 08:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ZPK6yJNRxhT1AEgABy3qr2ptLi+
        WzTLdFgfadcu/8QY=; b=RLkK6lacYbRyieHQvkilgCMbcaNivIg/KReocE7/ifa
        LJyb5aMKi5Snwt1yI0GuNQ/LOgc1C7hiFUEUjAAbdLxFwZvKSj2RyUqfxxpTeJVw
        Oxf3aUGum0ZdIyGnmjOm1ST8e4QeySoJ1+1gGHxQK7IBMx/eR4H9JU3WHQv7xE3Z
        P3gJYaC4FyK1obeyWA/DpIckfmq9SE16uFi1sRGgUIw+rGeqtUl4nDimnqdW/91/
        KtkbLw8FmudvrSAYzYpvbFCWlNN+0p7VnlDx0lCq8RmR/cg5040v1CSURjHTY9rx
        oDulIMP4wUDlLPIyvilzX/mzYv2uZPOXdA39HrC0Czg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZPK6yJ
        NRxhT1AEgABy3qr2ptLi+WzTLdFgfadcu/8QY=; b=uywEfcRDhkdGxFl1+MxgZN
        WlvRQ19ERW5wgrpB0B5MbKudSZ8fr/J5aDvZuYo+KlwYKTHha3ZvCat71e3OIlgp
        wKEbH2YhpTI5/if0jvbZnSabTjUv+MsuV+Yfn3/3xjW3TY8FESrTx7kgn84NxwVc
        PUAxD4rZInDmXvL2EfWQduI4FqJkq47hIy+ycvYzcDpKnnySs8VNSQPaUp8SrMyJ
        6mpmmTWYihpGJ86vyZueWik+IFSHii4qTCKNuIeVf9N01z1Fg0+YghBCYrFIFnaK
        Gs12xc7TCEu8t2m0HhXCV8H33QyNj8SObuwO5l9OAn0+LbQKXU6j+WbcrlDbbXzA
        ==
X-ME-Sender: <xms:QXuDXSF_RoQl_QIPdB-h_aKDolRCXsPZHPlZ7msDbvUZ3a-Py8nnEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:QXuDXfOZjG_n4VahHg5ZKtGgUiRQw437J7lZVkH0myZPlAZiFjtF0A>
    <xmx:QXuDXZL5_Eby1KFyu3pT8Xj4MwKZvWAONp7mckUfR4MHOdx4NoZeJw>
    <xmx:QXuDXQ_auO0Eb1eDqFT2zf8UeMBw1p0FgpnLiBpzB7DBUjE2pFeBMw>
    <xmx:QXuDXYe0U7taq6nkKET_7CkqgPQd9dyO4q0YyXSow0ilznPh4jyMBA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1523B80059;
        Thu, 19 Sep 2019 08:57:36 -0400 (EDT)
Date:   Thu, 19 Sep 2019 14:57:36 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190919125736.GB3431951@kroah.com>
References: <cki.BCC66CB54E.K2A3YXEFWC@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.BCC66CB54E.K2A3YXEFWC@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 08:42:43AM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 1e2ba4a74fa7 - Linux 5.2.16
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED

My fault, should be fixed soon...
