Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2B91BC7
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 06:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfHSESo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 00:18:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50913 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbfHSESo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 00:18:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4480921CFD;
        Mon, 19 Aug 2019 00:18:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 19 Aug 2019 00:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=3
        NxNxboZi1dfIdQqxAbOEbn4zJzRNwd0Snbrqn0TNzs=; b=d6i3nvlynz6QGt9mJ
        nT9/QChVjg0GG02zdFNDtYz1lp+RtSPT8lFFnitNpM6XYRiRMHm6/AS5n2N/kqIs
        CUhOPDpxJF0QzDVOSV81JSoL0jdzORJ11xiqvkQN9d9jJY+gYA7vpkQ6GRFZyvSC
        t9fwfdeKOlgt4Nh1xQu1H7u4AaqUqkZWZ2NbG76hGoTZAJFi3kbPAPGDi8IRUvHQ
        3AVxKbdB5dfynimB49hVqe036BUljtBFhXiYy+rzuTjpmtn1mYENSL3iK2RhepqB
        ENDC33SDCCYENdN0cuGwRCsZJYt7wAQqJcrv1cmD8d591Yupdxu7joBvwUXDz/xZ
        Og4Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=3NxNxboZi1dfIdQqxAbOEbn4zJzRNwd0Snbrqn0TN
        zs=; b=sqv43yPvwlV9c0gNGTySfzgQ6h3CDunCKsMhbOHy6lXlfse12HNPKUWwN
        PD0FHFwSQmAdAw6t4JWVXwdusKO0WsLzxcJ0pa3uaTm2o0ZjxXxemY09fYANLIbQ
        Pb4txYWY+2sYOpntBFfM9gLt2A8gm08/H673F3OvHcQXfXo55LSmcUgkJU288VLh
        TJjWdBt3Y02kdfwxC5t5ARB+PST64HX88xdRSEl9joSm2Te/KajAyp7MNjm/I+vE
        hfhoApFm1FhzyOxSHhECfedLRGzxwEOoOlj5Pnf5UfKUIoN6oJBmTTqaNY273baQ
        cVOs+/Q1ycPZcvtwGPKbCgZwvk2/Q==
X-ME-Sender: <xms:IiNaXcMSYvCkVPdwHUI6NBbh_rGA7rsW35zlfPMb2glW8ZlAOUNaFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefkedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinheptghkihdqph
    hrohhjvggtthdrohhrghdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledr
    uddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmne
    cuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:IiNaXefBc39yfTrBTKrptKhk0GVmh06AzP4Bg6egT-aLLG3UQ4hsww>
    <xmx:IiNaXZtDFN0fTxF6GFOkWSP7QElD6FOQU5nLJsPqXnyPcI1XiY6v0w>
    <xmx:IiNaXfnHV0jj01wQiLmwcu-1fmE6aGR1pEPHZojrJUfWQTzx8kGGvA>
    <xmx:IyNaXbYxduP9H1CuhWE6IenSxWyzW2GaY3pHcajYJzWHilCHSFdfuQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B58E80060;
        Mon, 19 Aug 2019 00:18:42 -0400 (EDT)
Date:   Mon, 19 Aug 2019 06:18:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.10-rc1-61d06c6.cki (stable)
Message-ID: <20190819041840.GB24625@kroah.com>
References: <cki.8FD44CAC8D.KLM2TF66J1@redhat.com>
 <20190818184900.GE2791@kroah.com>
 <843a068f-9a67-f3a0-cef6-a51f29616705@applied-asynchrony.com>
 <38430602-3b5e-5217-aeae-13fcd82a9c1f@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38430602-3b5e-5217-aeae-13fcd82a9c1f@applied-asynchrony.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 11:57:05PM +0200, Holger Hoffstätte wrote:
> On 8/18/19 10:38 PM, Holger Hoffstätte wrote:
> > On 8/18/19 8:49 PM, Greg KH wrote:
> > > On Sun, Aug 18, 2019 at 02:31:22PM -0400, CKI Project wrote:
> > > > 
> > > > Hello,
> > > > 
> > > > We ran automated tests on a recent commit from this kernel tree:
> > > > 
> > > >         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > >              Commit: 61d06c60569f - Linux 5.2.10-rc1
> > > > 
> > > > The results of these automated tests are provided below.
> > > > 
> > > >      Overall result: FAILED (see details below)
> > > >               Merge: OK
> > > >             Compile: OK
> > > >               Tests: FAILED
> > > > 
> > > > All kernel binaries, config files, and logs are available for download here:
> > > > 
> > > >    https://artifacts.cki-project.org/pipelines/108998
> > > > 
> > > > 
> > > > 
> > > > One or more kernel tests failed:
> > > > 
> > > >    aarch64:
> > > >      ❌ Boot test
> > > >      ❌ Boot test
> > > > 
> > > >    ppc64le:
> > > >      ❌ Boot test
> > > >      ❌ Boot test
> > > > 
> > > >    x86_64:
> > > >      ❌ Boot test
> > > >      ❌ Boot test
> > > > 
> > > 
> > > Are these all real?
> > > 
> > 
> > Hi Greg,
> > 
> > the current 5.2-queue also fails to boot for me when applied to 5.2.9,
> > so this is not a false positive. I had a handful of the queued patches in my
> > own tree and know which ones work in 5.2.9, but the new ones for -mm look
> > like they could cause problems. I'll try a few things..
> 
> The culprit is "exit-make-setting-exit_state-consistent.patch", which was
> successfully added everywhere. This explains why KCI is consistently sad
> everywhere, too. :)
> 
> Removing that patch from the queue results in a working kernel (with the
> version updated by me):
> 
> $cat /proc/version
> Linux version 5.2.10 (root@ragnarok) (gcc version 9.2.0 (Gentoo 9.2.0 p1)) #1 SMP Sun Aug 18 23:50:50 CEST 2019

Thanks for this, looks like kernelci and Linaro's testing are all
failing as well, so this isn't isolated.

Sasha, the above commit relies on commit b191d6491be6 ("pidfd: fix a
poll race when setting exit_state") which is in 5.3-rc, so I'll drop it
from everywhere now...

thanks,

greg k-h
