Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3CD20784A
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404812AbgFXQDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 12:03:41 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35695 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404749AbgFXQD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 12:03:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id C478C5805AB;
        Wed, 24 Jun 2020 12:03:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 24 Jun 2020 12:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=TE2/e9FpO75wG6kqeeVhy+Ld0ru
        0iGhAExHCNmnHBis=; b=VEYS+lzHIBd4K6Z+E7htDhS/pGNShyYjG6uGMr9DNO2
        K/f7Vv4qZ98SBolL/kpWohOg5tOnLx5v57TbqpIpiccJTOK0bVFcWU/anuId4wqh
        5HMH10fMfe54j2sLkDLZdxv9m1Am8Eg7N5p+jT8wSJy5Q8N7E0VMzMgxHQVqcxnE
        MbXT6KveM8hjVnrP+zKNCBka2aHuFEWVHKy8A1gHK5p7IBPk6dsSHio7+xt9Nski
        jCpqO30GKl5d7y9PmCc/vK2Cff3Hp6MmqzKad4sBLtitW2tIN2ljpzGUbm6c4img
        Z1acHReOOsAnVMTArh8Gch6ni1P18sDHcenCTgMfg1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TE2/e9
        FpO75wG6kqeeVhy+Ld0ru0iGhAExHCNmnHBis=; b=JrtWcRMkVFlj01KYKlXQ8b
        b9KIqG5tA+3nAgMhwtrm9jZkJDVh9j7DQVYvzjCRvjO9p4a2O6qMZxvDrf8X/kjc
        AW55yreGCtIswby7D/mbcbBucZChFoVNH0oGd1W2APeBPK2pC7ljhY7WfcTOHT82
        pZNOPd/EdD4NtwVCeIgcCpDz3GYX8WczbHevSOTHzoWQS23yh/d6lTT1ClmCYaIJ
        vG8jl/ylknCH8r/MYFqLVUg2GH/uEBdEqXJpTmAx4/AEV07c1KH2EPHVrQIyl5M+
        fjWay30aa2tkpj5m8ohQimyL7I5eNUVN0OrC4IZKPYvOFdK+cdlSPg94EuZvsu3Q
        ==
X-ME-Sender: <xms:TXnzXjlECZTW4ODrs_poojQ1DYw-fologPd04jSc6w40_bkIiXpi4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TXnzXm1ev_WQ-QVkwTqHS6wdKdc5ukBwweQHwy8rOiB4u-ditdGmLA>
    <xmx:TXnzXpp6LRvvMoCfOXdPGhBmLqTWoaRJXUky9kW1xarRJ_4RoBXMHA>
    <xmx:TXnzXrn7XkVJoPVnZls4QB4G1QLxtIS8hVgABCsEm_vSb_QE4zbg2A>
    <xmx:TXnzXrx8_ue5qv2roYlYk0ogjWr5CZGYd-Vdpu2bW4P8n5qP_ZycTg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 951EB3280059;
        Wed, 24 Jun 2020 12:03:24 -0400 (EDT)
Date:   Wed, 24 Jun 2020 18:03:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
Message-ID: <20200624160322.GA2096759@kroah.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
 <20200623191334.GA279616@kroah.com>
 <99a35736-6539-4a83-b0f0-74a8cf28d85d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99a35736-6539-4a83-b0f0-74a8cf28d85d@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 08:41:06AM -0700, Florian Fainelli wrote:
> 
> 
> On 6/23/2020 12:13 PM, Greg KH wrote:
> > On Fri, Jun 05, 2020 at 09:24:57AM -0700, Florian Fainelli wrote:
> >> Hi all,
> >>
> >> This long patch series was motivated by backporting Jaedon's changes
> >> which add a proper ioctl compatibility layer for 32-bit applications
> >> running on 64-bit kernels. We have a number of Android TV-based products
> >> currently running on the 4.9 kernel and this was broken for them.
> >>
> >> Thanks to Robert McConnell for identifying and providing the patches in
> >> their initial format.
> >>
> >> In order for Jaedon's patches to apply cleanly a number of changes were
> >> applied to support those changes. If you deem the patch series too big
> >> please let me know.
> > 
> > Now queued up,t hanks.
> 
> Thanks a lot, I did not get an email about "[PATCH stable 4.9 02/21]
> media: dvb_frontend: initialize variable s with FE_NONE instead of 0"
> being applied, not that it is a very important change,

That should be there, I merged it before I did the whole long series and
realised I should just automate it, sorry about that.

thanks,

greg k-h
