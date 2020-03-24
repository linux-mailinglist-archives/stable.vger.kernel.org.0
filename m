Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990DB1905A7
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 07:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgCXGWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 02:22:22 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40479 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbgCXGWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 02:22:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 800F92D2;
        Tue, 24 Mar 2020 02:22:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Mar 2020 02:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=W
        Yea4OlgdnJnO5JNoMbXByYLZmfJ9FcXAWPvkLDjIEc=; b=V/Ow6sBNonVayKjHx
        Ihl18DjdWp2kQviuMHza0FeCFFCxm68wevoDDofwyZvgEplkO1IUbVWn6BtRvvgW
        y7J/qdyWRs7pE14AOHbMvtkUNuzS/UOBo8F2P6WwB8/Sym85oSmNNjEaiQFbhUzK
        002mKioSegxAh8kTA3MEufZN44Q7lMLmLlOg/YQV1oYTCvsqylk+2dY2NwwIF/Bf
        zNPs3Dh1XmChPOrdXoVIFbx+j4YsIAKKsB+H2BbyOXdsc4tJPyYZUCaOzZ/NmVvo
        SZK98TfKkh81pQbsOpGzaMjMY8Fr3UmWQ/zW6YlMeVGURuSr1GNXU3uvEzkIjdP7
        lnyUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=WYea4OlgdnJnO5JNoMbXByYLZmfJ9FcXAWPvkLDjI
        Ec=; b=jk006znmQfxtfwca00iWfXDIRmO4tKg9lm7nDG2t+C9pHkkHofiMSBmCv
        b4rBOyDGPckE3lu1w98gALdSve2pDPwG7ryB5UZb5CMdr/XNv23eNnRtf+3GXIwM
        miqA+wSFLCct0amDkp6biAyWrb5rdWZ8hqZ5ku1I1l3n9OVLlW9d+RoLhNdF33p4
        6YfE7sYl48Et41motw+YrIocQV5AMRzRJai9YEMl88zxlNQbexijK/0tpLZlyh7B
        akTMR/M2OsYUCgKWvTHfWl7IUQ4ebBphm9CeVFnfJWsROJr6c4+czQ6JQvAT5c2u
        n3bP9+9hreEERGCPC7dhgQWKRewfg==
X-ME-Sender: <xms:Gad5XuF67ZA-HC9MwfMbG6200QrFAogQFf-AO34LH0u9z7mi6QlMwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegledgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrdekiedrkeelrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvg
    hgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Gad5XuF5lU3vz3sdc5e2rYAjgFgcPzQ12DgDSqmV5fXZrVDZvX-yJQ>
    <xmx:Gad5XqXD4z3GF5ptmqMFcvx2Sbq6VVvRATKi8KUf6zTNL9ZTcJKa5A>
    <xmx:Gad5XskgoG_0TwfBvWWxgWdS91jKCK3eJn214JS2ONlQTpAk3q_-1Q>
    <xmx:Gqd5XkoggtKpVfiiXreNrlM--qVDeWjXTKdLteB544M2tz-1cs1cuQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A11A33280060;
        Tue, 24 Mar 2020 02:22:17 -0400 (EDT)
Date:   Tue, 24 Mar 2020 07:22:13 +0100
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.5.12-rc1-8b841eb.cki (stable)
Message-ID: <20200324062213.GA1961100@kroah.com>
References: <cki.936A32626F.M0L95JS69X@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.936A32626F.M0L95JS69X@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 05:42:38AM -0000, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 8b841eb697e1 - Linux 5.5.12-rc1
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: PANICKED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/23/502039
> 
> One or more kernel tests failed:
> 
>     ppc64le:
>      💥 xfstests - ext4
> 
>     aarch64:
>      ❌ LTP
> 
>     x86_64:
>      💥 xfstests - ext4

Ok, it's time I start just blacklisting this report again, it's not
being helpful in any way :(

Remember, if something starts breaking, I need some way to find out what
caused it to break...

greg k-h
