Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0184932A37
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfFCIAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:00:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42689 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfFCIAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 04:00:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 993CB2208C;
        Mon,  3 Jun 2019 04:00:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Jun 2019 04:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=q
        daAgJ9fNvUmysHIjCTXJpXixNuqYmRyjOfd7GNfc2M=; b=nuudXgCxTteabkqM+
        /LHWKDbcH5m6Fv3KtkTb5JEVaDomOO04Mq2xrKd5dAwOLgxNczmDXepPPSkMZP9W
        Es0HyGTMQyjvaJksZbhv4iR3BrOGjslkg26VQaoyLpMmFXRVy6rCzQKozKDWXZ3+
        RVwiMBFksD3Oy+tSDLmx4UqbyXxvbsdNcCDS1Brfqx2acW/91vwGOGd/VqiEiCYW
        q7Yk+dYc8F5lTrTsm1yB4L/4s0atBxfNyd+r5P5pTd6MOlKAzqFq5mlNsbXcmfJz
        KaCQEqI5e2iIQhr3PS3U0ujDXWwA3DrETjLqUQaP4ZjpIymBSqEUIFG2XniUYgBt
        RK16w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=qdaAgJ9fNvUmysHIjCTXJpXixNuqYmRyjOfd7GNfc
        2M=; b=JH4MFZXfU0MVLUrYvbtHtpW/GGWXHQCNiNnngg3wSSEdsd+AvHIP01/nz
        Y9DOyBKnwKIx/1S5p1UMYZ0lfc3uLEkF6+q2N/lE7Wsa4TJ3h9XTWn1i8tcvcQ4c
        MOyZWwzAXIFswvCuPd9Q/UUHWfGDUi5RKxQ43FKNkU+uTIj4vmauir4Px1t9VyLh
        1rTu+ZBI3Wzj9xip9hxusJlD9jvoiQ2+gQx4s5I15K0Mkjg6Hpi3umzk9sCpZlHS
        i96QeilpTyrY8ntuD/kQKXM9360jn9gnLmElHDsg+RuHvVZseNij84iyCy5gcazQ
        0VCm838oOSmf75ra7qJ3uLzT2p16g==
X-ME-Sender: <xms:sdP0XOH3f0iliZfCjhYddenAqprOGjQjiotneKRfiP9kYvZfvnv9kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefiedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjfgesthekredttderudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:sdP0XAklciS6gRNVUtDytsc93_KVsgPJfHqRgRE-z9mrQqwB8WiOYw>
    <xmx:sdP0XFM4Pp9Rq87Po4vvR9pHecf-6DG7BD-a2tejMTO6aPbl_y1ejg>
    <xmx:sdP0XLGPwG0ljHLDc0KIVI1z0ol96v9yLxY7ejRXxEssB7v818BRPg>
    <xmx:sdP0XJaNdTck15kubQyXLB61LvpWyjkUT4WyU4rl-1kxy5AY5rXDxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A017D380086;
        Mon,  3 Jun 2019 04:00:48 -0400 (EDT)
Date:   Mon, 3 Jun 2019 10:00:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Prarit Bhargava <prarit@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable <stable@vger.kernel.org>
Subject: Re: [stable] xen/pciback: Don't disable PCI_COMMAND on PCI device
 reset.
Message-ID: <20190603080036.GF7814@kroah.com>
References: <1559229415.24330.2.camel@codethink.co.uk>
 <0e6ebb5c-ff43-6d65-bcba-6ac5e60aa472@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e6ebb5c-ff43-6d65-bcba-6ac5e60aa472@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 07:02:34PM -0700, Konrad Rzeszutek Wilk wrote:
> On 5/30/19 8:16 AM, Ben Hutchings wrote:
> > I'm looking at CVE-2015-8553 which is fixed by:
> > 
> > commit 7681f31ec9cdacab4fd10570be924f2cef6669ba
> > Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Date:   Wed Feb 13 18:21:31 2019 -0500
> > 
> >      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.
> > 
> > I'm aware that this change is incompatible with qemu < 2.5, but that's
> > now quite old.  Do you think it makes sense to apply this change to
> > some stable branches?
> > 
> > Ben.
> > 
> 
> Hey Ben,
> 
> <shrugs> My opinion is to drop it, but if Juergen thinks it makes sense to
> backport I am not going to argue.

Ok, I've queued this up now, thanks.

greg k-h
