Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AC3735CC
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 09:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhEEHpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 03:45:31 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44155 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231738AbhEEHpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 03:45:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0D6A616A9;
        Wed,  5 May 2021 03:44:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 05 May 2021 03:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=NIJRvX73HAM9U/xkGlUE0U5q5XT
        djlZGyFP5AM6s+YM=; b=UKYjwy1BfO8tP9+q5gakvqX6/ldVS9lkyjGmbmiy3Cy
        cswJGDroB/GoNIUwyljpaks33+uLZRBOOcQFyIPMymernLx9KPImzS6DWe50RLup
        BzBqk1tFdl7/b5fzELbxOm9T8BOkZ8pnXYfyzkUEZFKZJurbITYTy5XJAlAfnVrQ
        fc+ZYtpD1xjcAo7Xa/B4s6ABq1Wl18L+AW4RcFQkk5ZlCGW7kg/EDkYRrEtlPhCr
        V0H3rEs7Duv39s20ftNJV7clFo48rsSXY72/m+G5f/+SI9dol3OzqXzRtnwpEV4p
        kNFYDRjDDm+qDqIZn2JnwQU2ynvMviiSvFx9mr0w3cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NIJRvX
        73HAM9U/xkGlUE0U5q5XTdjlZGyFP5AM6s+YM=; b=Uxn+urrA1leyBPtFfHxpR5
        3kQIHOVZBZ8ulFxNOq2GQvAfSnQ00tTarEVT06BAniJ3q787fOOzNlV4gT+pqwNa
        9wxwsIWkMYFBGcb0MRn14hyFlGlT7qwcs8ydCCbdf8AaH8ejkJZIjMDpfJjyqNgb
        qQpWDw9xdHoPWjMS/SSE973yaarkA6f6lKqk4rgwRhb6m/wmWmFDLXC3rICLE/iG
        Yipl2u/MO0EwmVaQvnTNz2pREa580eYMHu4a2hUDmnEyzgcaOeWmAhVULZDrQ3Lz
        Wr52CqAfAbp5b14TDEPhR4xCZpJIN1NB5xD5iim0j7NhfaVmeQu8N/bkjVX/uRIA
        ==
X-ME-Sender: <xms:4UySYMcbxh8fl3bRMaarkdpQ-nqKlwxe7bjfpQQkv-sjzAlS2ioz9g>
    <xme:4UySYOO5uPne7HdKSUG3RLSV5w5yiT3TAbrc1a4NgHbvqSR6SnFwjyFgrCUp_7hIU
    jZePnPxVmxSdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveehgf
    ejiedtffefhfdvgeelieegjeegieffkeeiffejfeelhfeigeethfdujeeunecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:4UySYNhvTXlJjhE6ckRjEpk8jZ-Igaei7DOWmXUPaGp1P0NB3S2RLQ>
    <xmx:4UySYB8beOg5KlUf-Sf9tvKVoJQhIglurnn8YwHlUIHO0sDa1rwq6A>
    <xmx:4UySYIsqWQJ2lO_WdtRd-gtYpgskTNnv8YT1LW1YZzpYy0ZU-chyFQ>
    <xmx:4UySYN-CoCb8XoGpUZwh0BUq5dt0RzRwXvr9heEIlT8dn1cw1_f9sA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:44:32 -0400 (EDT)
Date:   Wed, 5 May 2021 09:44:15 +0200
From:   Greg KH <greg@kroah.com>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Subject: Re: [PATCH v2 5.10 0/9] preserve DMA offsets when using swiotlb
Message-ID: <YJJMzzADYcapNsMq@kroah.com>
References: <20210429173315.1252465-1-jxgao@google.com>
 <YJJH8Jy8VjFmR2AL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJJH8Jy8VjFmR2AL@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 09:23:28AM +0200, Greg KH wrote:
> On Thu, Apr 29, 2021 at 05:33:06PM +0000, Jianxiong Gao wrote:
> > We observed several NVMe failures when running with SWIOTLB. The root
> > cause of the issue is that when data is mapped via SWIOTLB, the address
> > offset is not preserved. Several device drivers including the NVMe
> > driver relies on this offset to function correctly.
> > 
> > Even though we discovered the error when running using AMD SEV, we have
> > reproduced the same error in Rhel 8 without SEV. By adding swiotlb=force
> > option to the boot command line parameter, NVMe funcionality is
> > impacted. For example formatting a disk into xfs format returns an
> > error.
> > 
> > 
> > ----
> > Changes in v2:
> > Rebased patches to 5.10.33
> 
> It looks like if I were to take these now, we need to also have a
> version for 5.11.y because you can not upgrade from an older kernel and
> have a "regression" like this, right?
> 
> 5.11.y will still be alive for at least a week or so, let me see if your
> backports work there or not...

Ok, looks like it worked, now queued up.

greg k-h
