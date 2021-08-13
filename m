Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70433EB44F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhHMK5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:57:05 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:51881 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhHMK5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:57:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 8988F2B0135D;
        Fri, 13 Aug 2021 06:56:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 13 Aug 2021 06:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=j
        NqzVPfTTcLpE2tfgAuOOpZdMfBcnbYjJTS/Ns3TE1s=; b=VsOQ2vhG1DoOMhonB
        GaArYAmlC7w1LcozG1XeT6D5YX4T3wcuvZFLWtuQJVDUBj2b4ZYGzNFyMS8aSrQt
        AzeNd7//b6fTH3TmTNbsxvLynhkab5s+dB6MFbo/DHk9Ciq7GeAkupH0nzvcDws7
        a8zgfnSSWPktIPQYSt9nw74ZdBo56z8BKv1slxse4GmWdlecwL8yeEo54ImkV4l+
        tdapYYNGa/6f8p1bfKlmzzeQ/cD7omJsG1LRZvIT4lPe5JrmyFADQMFXHBNMXQh9
        ufrKA169Ry+KGxJ8vyNrqrjjR3HECYWbVVH8hiFzBlPVS24XH+vUXzsF1sU28SRt
        AdV5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=jNqzVPfTTcLpE2tfgAuOOpZdMfBcnbYjJTS/Ns3TE
        1s=; b=OcUuoKlBJwao42ts2nP6M3Dc8BK+b3xiQmmA4cg4EALOlqqrw3nSFahaJ
        s6afEl3Zow9+xziV8aQ9LBbci2LdgRxLei+r4BWHud+vlTa2f2+nxARA6akoEdCZ
        hwpj8T/HjJxyADfLPGDLs7UYUsFVGHw1SHJXhs8WoK/IHSOO5iSzaCunlmlKdzmV
        LH3gwTta8okZgzpTtGD2cyMDdgk7Okod+4e3dv2HWKVXYRL8a/o5oqYIeHZ1GQCe
        Hbh++FE67UHVQNEe7m3+hvLjcj39FOhYDlQzmfWtzjlADLM2P2D9DN3OjBaxSHCG
        l2Z7v8LZIkVhQqpRHFgVO0dQCesWw==
X-ME-Sender: <xms:408WYY1zOJO4sIoegssYINYvuHFBfLZo_X43yI-yGpijnGat-e7UmQ>
    <xme:408WYTH9y3qd5-GhnVpoByppAMvFD_SJhY1XHugFwmMVZwogxqdUx-lX2B-65omvQ
    M8omwJ5FxpRmw>
X-ME-Received: <xmr:408WYQ4s4WzrEmF17atNhPpac45XMPrKftsPmqEZYgL8F6o1A2Gx4JHOirn19QB3hK8OriyAKlLOnbrgGrSaNQlv5rt0MmG9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuheekhe
    elffefieduteefkeejffdvueehjeejffehledugfetkedvleekudduvdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:408WYR3CP68MzM7ggkOqZBGZhmb6m8c4gPehZmyh-35Hewex7X9tFg>
    <xmx:408WYbF4izvEotlfL4nYjGexAxDz0y1O3n04WdHm3pu09oyBB6gqjA>
    <xmx:408WYa8F5Orn9YaGXWzevlPpbd-OwBfWfo_Ie9fX1ZwQ4F0q3tEvCw>
    <xmx:5E8WYYcxNNNKZNayzYwd6IFDuaoSF1_VsUbDNW9qsPC1sm8g7mAS2m2Uvk8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 06:56:35 -0400 (EDT)
Date:   Fri, 13 Aug 2021 12:56:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
Message-ID: <YRZP4Jh0FNHrma5/@kroah.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
 <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
 <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
 <b49529b9-3f1c-be5f-f95a-dadceae057ec@oracle.com>
 <6f45f8c6-03df-b2e0-cfda-85fd0b41212a@suse.com>
 <26649302-ce62-798d-4a9c-6a46ab1e25ec@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26649302-ce62-798d-4a9c-6a46ab1e25ec@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 06:41:53PM +0800, Anand Jain wrote:
> 
> 
> On 13/08/2021 18:39, Qu Wenruo wrote:
> > 
> > 
> > On 2021/8/13 下午6:30, Anand Jain wrote:
> > > 
> > > 
> > > On 13/08/2021 18:26, Qu Wenruo wrote:
> > > > 
> > > > 
> > > > On 2021/8/13 下午5:55, Anand Jain wrote:
> > > > > From: Qu Wenruo <wqu@suse.com>
> > > > > 
> > > > > commit c53e9653605dbf708f5be02902de51831be4b009 upstream
> > > > 
> > > > This lacks certain upstream fixes for it:
> > > > 
> > > > f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
> > > > cloning inline extents and using qgroups
> > > > 
> > > > 4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
> > > > btrfs_delayed_inode_reserve_metadata
> > > > 
> > > > 6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
> > > > transaction when we already hold the handle
> > > > 
> > > > All these fixes are to ensure we don't try to flush in context where we
> > > > shouldn't.
> > > > 
> > > > Without them, it can hit various deadlock.
> > > > 
> > > 
> > > Qu,
> > > 
> > >     Thanks for taking a look. I will send it in v2.
> > 
> > I guess you only need to add the missing fixes?
> 
>   Yeah, maybe it's better to send it as a new set.

So should I drop the existing patches and wait for a whole new series,
or will you send these as an additional set?

And at least one of the above commits needs to go to the 5.10.y tree, I
did not check them all...

thanks,

greg k-h
