Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D427F195260
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 08:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgC0Hy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 03:54:58 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:56877 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgC0Hy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 03:54:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 96A9B836;
        Fri, 27 Mar 2020 03:54:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 27 Mar 2020 03:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=Y
        HOho/3oIK6hoFBqknB1AMyX3kZ/D3bJKiKPIPNsG/I=; b=Ru/tnAROPb6DeBkeD
        24FAilPSH7Bm0R/sKsx4Pw8OAtmPmbEeEqXsoN8C41jd4XMGMRmdqu388VUT3e8m
        avQTAWnlkFIm825CpGe9A9ANy+5SA4Q6M5fJaHyh1pBI5rLhD1qyFMJS9sWcp88m
        STU83p5ZUO71/wdXzZvuObyJSxFe1eo/bC74XtDngVDsrglnSIKfVWcJtbT4J24t
        U0AdGN9oiZnJNV7zh2p5xcDw+xBu59NolsKgPW+A6XHxNkmKZoiPOL4G+4hvbvXN
        lrpjXs8/xy0owf1PdAEy5+YwhQZUpUXo4wCF4CkGu3G8mJ3hGluE8u4OOjwyukZ7
        Jdrrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=YHOho/3oIK6hoFBqknB1AMyX3kZ/D3bJKiKPIPNsG
        /I=; b=14e7COQ53M5Ke60J6V/UOA1MNsaIoSwt84melW2+6jv/H2wBKEhMKSxuz
        kKi7mbM9mOIZcXgTAqb6uLRm1fv+zUwnCPux5CYTQEJedYH2MoKZv5nDPsHnid7G
        zMUt6yFoEuSWgM4I7zUN8gfMOdF1uKjw32bIKMFNvekiu6dXRKo0mrtxsZWtZ6Gr
        qnj3o2N3/uAH/IONQy5JlvadT4pfgSlmbu1H4TtbUXFC6VA8bq1c8uXYP0m+LA6n
        4xdckx1tR6KWu98CH1C884RBDYYUhRYPhEKN1LHSynLGJTJtWaVokJSXVlygXW1K
        6/TWNjkZE1vpszI4MCl5mkzQ+SCcg==
X-ME-Sender: <xms:T7F9XobOZ1rytgjRclcmIRq8U7Kml8QPOiCU5IW47Hknpn0kxa-Hmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T7F9XjNwf_0cwabzgC2pEizIk4ykryJ3mnUkVwAX902PEmRs1bHPJA>
    <xmx:T7F9XlgfR6TpRB8Hp7pQ01xG4KwX_K8Tlasb95I89xmASWdYNSNhOw>
    <xmx:T7F9XvPAmXS8J8sXIyADOolrg2BLXVaCSCVaMR9eNxdWMLUb9dvjgw>
    <xmx:ULF9XqWtR45tHyqiBpjCBHGsOujU35wRD4lVtE6jIUZL8U5p_0EaLw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DB2A3280063;
        Fri, 27 Mar 2020 03:54:54 -0400 (EDT)
Date:   Fri, 27 Mar 2020 08:54:53 +0100
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Voegtle <tv@lio96.de>, stable@vger.kernel.org,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        LinFeng <linfeng23@huawei.com>
Subject: Re: proposing 7df003c85218b5f for v5.5.y, v5.4.y, 4.19.y, v4.14.y,
 v4.9.y
Message-ID: <20200327075453.GA1627266@kroah.com>
References: <alpine.LSU.2.21.2003261831320.11753@er-systems.de>
 <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 07:04:15PM +0100, Paolo Bonzini wrote:
> On 26/03/20 18:43, Thomas Voegtle wrote:
> > 
> > Hello,
> > 
> > the following one line commit
> > 
> > commit 7df003c85218b5f5b10a7f6418208f31e813f38f
> > Author: Zhuang Yanying <ann.zhuangyanying@huawei.com>
> > Date:   Sat Oct 12 11:37:31 2019 +0800
> > 
> >     KVM: fix overflow of zero page refcount with ksm running
> > 
> > 
> > applies cleanly to v5.5.y, v5.4.y, 4.19.y, v4.14.y and v4.9.y.
> > 
> > I actually ran into that bug on 4.9.y
> > 
> > Thanks in advance,
> > 
> >  Thomas
> > 
> > 
> > 
> 
> Yes, indeed.  It's not a trivial backport though, so I prefer to do it
> manually.  I can help with that, or with reviews if Yanying already has
> patches ready.

Backports would be great, I'll wait for them before applying them.

thanks,

greg k-h
