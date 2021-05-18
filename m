Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400E538716E
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 07:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhERFuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 01:50:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45607 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230328AbhERFuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 01:50:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 252145C019B;
        Tue, 18 May 2021 01:49:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 18 May 2021 01:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=m7L31pXv8sUiqNZeuzfEwawxBqG
        rTSV4u+sf5gf1YNE=; b=e+QkxxAfFRil7lwcA+jGvJDUxriEc7qIQ1FAoGh19p6
        FZ/OnISXvnggXoe2ghkpSQsCrJjMcvSjTSlUiDnpAGVZf0jiPvQWd4ZbL5CJyydh
        hETeHHqwtrvQeE8siu5fp1HSBeweF2+s5YIOjoXJ9akXeGWGgsN8r8Uz046G9gVF
        Z/LAH8+qYJYHSda31VcOjU+dxomWzr6UaRXxn73VK360sbl+w286y9FNqBpppDDV
        uNgIIKJn2i19bqxCGB9UIOd7xcGVJ+gCsEokj7MvxWWIqvCAVrBwB/ZExB+SU4CE
        Pl6yLmOOTI5yH7OnPjX+KRyNKv2plzPZHejql37TWPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m7L31p
        Xv8sUiqNZeuzfEwawxBqGrTSV4u+sf5gf1YNE=; b=bN9fBnTbzdl9BIktvZh/H7
        I5SqxymyxOUe3UaM8IltZCZ1nv1Ld63xhWlaLdTijde9WayGmdZSkl6IEsDt73M8
        imhatS89crLqLzI01NoIsLgryQAPSikSWDGVXk8kBFPbOw9+lWu1/zeg6KxzkFWl
        qTU0uoxr0rdaOqrwJb7mh0DRiBIGl7FuQJCPJqUtmIGD6DBK9bkFDQ2Pz92EiHvL
        zY1Cj0Y643KltOVllMFB/P+LoAEvdf7KfymrZ0o2yAWMx13lPsIi5HOpQDJ0wftF
        vqJncRc+KgekzE+4Ekaiocf2pz52GKB6KaXtd7fJuzwWzLdPYVxOnBBJlJnJDm4Q
        ==
X-ME-Sender: <xms:S1WjYF6Vznf13AjBoubz8w-w9JRQq5ClNQkxfo88FTSV191JdZrxiQ>
    <xme:S1WjYC4pxhu7o4Y-j06Bbk72IiBnx94KDSCws2F6Dq1u-rKmSB4iRNWVrBk1UUNDO
    Hwbf-N71l4Yag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiiedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepueelledtheekleethfeludduvdfhffeuvdffudevgeehke
    egieffveehgeeftefgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S1WjYMc0J64VQ1UarF-ymOHRXhG8zfs9cJj47xxl0ROugB_2bPI6Jg>
    <xmx:S1WjYOKuc94RU1seFUgW2HFvHBXm7jxG1yte2OB-q1v45sJiZkS4Og>
    <xmx:S1WjYJJG_BaXWRpjOTL_Bh42DDDSx0EwPH_s2Hr2kKbTqaiiOpg55w>
    <xmx:TFWjYHiKQz2gyBv0B3s1fEMzCWJ4nBjoPZbAyPYxOzy3eA3mNbjtFg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 01:48:59 -0400 (EDT)
Date:   Tue, 18 May 2021 07:48:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <YKNVRUWNpN7mNTI3@kroah.com>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
 <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de>
 <1621251685@msgid.manchmal.in-ulm.de>
 <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com>
 <1621254246@msgid.manchmal.in-ulm.de>
 <CA+res+QRm3VyJSjMaKLYm=KY5+T5nX+6-QhOgrgBcP+d2Ganag@mail.gmail.com>
 <YKJ5ysGAuI32Jpn6@kroah.com>
 <1621290515@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621290515@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 12:30:15AM +0200, Christoph Biedl wrote:
> Greg KH wrote...
> 
> > On Mon, May 17, 2021 at 02:45:01PM +0200, Jack Wang wrote:
> 
> > > So it's caused by this commit[1], and it should be fixed by latest
> > > 5.10.38-rc1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/log/?h=linux-5.10.y
> > > [1]https://lore.kernel.org/stable/20210515132855.4bn7ve2ozvdhpnj4@nabokov.fritz.box/
> > 
> > Hopefully the "real" 5.10.38-rc1 release that is out now should fix
> > this.  If not, please let us know.
> 
> Good news: Fixed with that "real" 5.10.38-rc1.

Wonderful!  Thanks for testing and letting us know.

greg k-h
