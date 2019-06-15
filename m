Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4147154
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfFOQym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 12:54:42 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:57777 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfFOQym (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 12:54:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D328241E;
        Sat, 15 Jun 2019 12:54:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 12:54:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=fEt2SSahijpOpKAmD9/yDcLh1cm
        rNj10niyxH2l7WHg=; b=QT7fdUxK7s1Fp0v1OgG7m8U24zX7xbsgf4GIhg1yxEl
        024bVf43ILNDJmPD98PZsigObKlQZjt9tXRb+eZWfJhmpQw3O/L8z65BKYtA6dN1
        RA1hrxNt49wX2oUnYoclL81yzWTxZzvJjqORNcioqpcJE+SIDZNgJkjspz6CQOz6
        H2qzXY75o5li1Bxwl/v7cIeaM62ihrElcaj/wuFgXbvzU3sB1FWjzroIFfBF8YtG
        ggcIiQ/laX/R7ZGp4/sMIdorp6EWcNUcCSBBQuhEm0V8qEgUCWj3/YL9jH+7mTyf
        fQ3LxBv7BmdVmNK59IIbF6Fd57GiLMdmU9FUKKfKUqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fEt2SS
        ahijpOpKAmD9/yDcLh1cmrNj10niyxH2l7WHg=; b=viMCS9xKh63Q5iSAJ+P9CN
        hdnKZh/u+7Xs92aOcETskz5Ars3OyjL2m4x3HPaBnVnyQEeJ7p+RjVLOavY1678T
        29Z1WRc4GpW8nspvZw+x3GU+PBRRf1nPf8coyoFybUFkgoPSZNLVNygWQFVpW9GD
        Zm9qsbZecwDoowQ9LLmri3RzblFduLny9BT9HyBcUXmnh6dYApJPR7FCgA6svbIt
        X0oZ1kzTUmNIvL5/lIbkBOU/cjL8hVtvSe19BmwDLTYXRIbZqzFR/WzLbcw+U6zy
        DhJjKu+twMRSIUpdUTNdOzasJ71Zrmmn7IoZirGYiPFfyWixM0rac+rIKTjxuZRw
        ==
X-ME-Sender: <xms:0CIFXU86swNtekH1G7Krk9RHfgq7dVtoV5P6zzSORthnsPgGjdOd9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:0CIFXQ_Dq31PHf7DO4EBXBVG1_m5oYVLkBswVKFLvGtph1qUCgmZ-g>
    <xmx:0CIFXVB04GgqhzyzUQ9PAS0n0kLAC1fnXhbW05BmHHWPXQKGzS0JtQ>
    <xmx:0CIFXYxv0PgFyUMQNjNmAuuI9bb5LwY2lysDGk0phokENhqi7anPoQ>
    <xmx:0CIFXQKzYStxXcrY5_sz6TEq0axW3zScHjFPho7pxAfaDAnKXve9RQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A34988005B;
        Sat, 15 Jun 2019 12:54:39 -0400 (EDT)
Date:   Sat, 15 Jun 2019 18:54:37 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190615165437.GA2030@kroah.com>
References: <cki.9519046E3A.WEI3BPT8RX@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.9519046E3A.WEI3BPT8RX@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 15, 2019 at 12:38:00PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 7e1bdd68ffee - Linux 5.1.10
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
> 

Thanks for this, your builds are faster than mine :)

Should now be fixed...

greg k-h
