Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E67D377D8E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhEJIA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:00:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45089 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJIA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:00:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EC9F45C015C;
        Mon, 10 May 2021 03:59:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 03:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=COun/+zNE3VckKfb7H79zzDotzC
        cy3ZnMr98TRk5Ux4=; b=aGBIc19VC07U2W1ST5VSXE71PxFZAwzlt4yZeRwtv+O
        Xz+TOiKOK58W92+kl6mlQIdrtyPNoTw09cVR/UhNdcni3s6DI5XGgOoILhZAWM3x
        ZNAdzKHbQhD05daEFytfeFkqJJ8eNkBiOpqN22q25VcclLFeLZFwx+5nzHGY5+wW
        Ahe9cIpCnRZIdMeBDzNtqHC74p5TC+LshfxDId/V0G5uhjT77bBYbtsLaXvjByPU
        gJ4SbvOVP/ttfOaYHcqM55G4l0V56uF2BgSYIk7XA8DaLSoK3MQXpUOM7dR2onSa
        Sm7R7wKlG1dKvsD3APn8avoXRdoGEafcCGLIYGi0kfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=COun/+
        zNE3VckKfb7H79zzDotzCcy3ZnMr98TRk5Ux4=; b=nCUEafwz+ZY1G26FX9sjtu
        A+nWb3wNbTnVY65qFWneH7AMree0LSR6fYWZ0PMeLn6ffWulh5IdCP09h73+KqkW
        6YBlc5qcK2T5p4Z+oxqEZjjw/tH5zutUiSBzjPjd7gTYTtlX3LgIjgatiuqV6oCd
        VBYvbPSn5uHBGEZzjF+91KhrMS7ob4ZSdq3dYW8Z6P252QCr4mYIHlRkhijuT+sw
        G1SRcr4cqMOJAbVmyAbP09BJ2/nwUOedQsidAuD4UTFu0sZHbKF8ageogIcbsKlO
        AlQqZ+qteDYYz3j6jgmJ6IuBfmUURPfJeiITtlfGrDIcFa+9SW6U4yW7aCD4g2Ow
        ==
X-ME-Sender: <xms:-OeYYBCexk9V5TogZeNhe-SUmPiavKcCdNiZ4girdu3kuixYNp92DQ>
    <xme:-OeYYPjISUh1W4NmRm9hf9HTksD13RNNGE6UD6vcnvHcfxxwSzrFfMTyP3xkBN8gs
    lBj-5_DElJhvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:-OeYYMm5-V214rNgugiGylmzzdwJB2uASgO0ZPBMEIuTM6AliUXPMQ>
    <xmx:-OeYYLwcbjiKEneuVe2iaTpGhDIazYwfHuueSJzWaigfzbezsaaq2g>
    <xmx:-OeYYGToRrbL8ucDM2ZogZv_jZhYLNUxcKtLHFq974WRdCkbiRJ8Ig>
    <xmx:-OeYYEeDDfZbvkoU-KLx8N7ph74tHqHhW2p94Z3neq0t2Z8YHEivlw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:59:51 -0400 (EDT)
Date:   Mon, 10 May 2021 09:59:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "s390/pci: expose UID uniqueness guarantee" has been added
 to the 5.12-stable tree
Message-ID: <YJjn9VlQm0a/u1vp@kroah.com>
References: <20210508032523.30E2D61400@mail.kernel.org>
 <57af9bf26f6cb7f33a2f81bab1a0b8254c98d159.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57af9bf26f6cb7f33a2f81bab1a0b8254c98d159.camel@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 09:42:46AM +0200, Niklas Schnelle wrote:
> On Fri, 2021-05-07 at 23:25 -0400, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     s390/pci: expose UID uniqueness guarantee
> > 
> > to the 5.12-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      s390-pci-expose-uid-uniqueness-guarantee.patch
> > and it can be found in the queue-5.12 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > 
> > commit 7b9825aa0891087c5c91be0fb75431919e2027e3
> > Author: Niklas Schnelle <schnelle@linux.ibm.com>
> > Date:   Wed Feb 24 11:29:36 2021 +0100
> > 
> >     s390/pci: expose UID uniqueness guarantee
> >     
> >     [ Upstream commit 408f2c9c15682fc21b645fdec1f726492e235c4b ]
> >     
> >     On s390 each PCI device has a user-defined ID (UID) exposed under
> >     /sys/bus/pci/devices/<dev>/uid. This ID was designed to serve as the PCI
> >     device's primary index and to match the device within Linux to the
> >     device configured in the hypervisor. To serve as a primary identifier
> >     the UID must be unique within the Linux instance, this is guaranteed by
> >     the platform if and only if the UID Uniqueness Checking flag is set
> >     within the CLP List PCI Functions response.
> >     
> >     While the UID has been exposed to userspace since commit ac4995b9d570
> >     ("s390/pci: add some new arch specific pci attributes") whether or not
> >     the platform guarantees its uniqueness for the lifetime of the Linux
> >     instance while defined is not visible from userspace. Remedy this by
> >     exposing this as a per device attribute at
> >     
> >     /sys/bus/pci/devices/<dev>/uid_is_unique
> >     
> >     Keeping this a per device attribute allows for maximum flexibility if we
> >     ever end up with some devices not having a UID or not enjoying the
> >     guaranteed uniqueness.
> >     
> >     Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> >     Reviewed-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
> >     Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > 
> 
> Hi Sasha,
> 
> I think we should not backport this patch to the stable kernels either
> 5.12, 5.11 nor 5.10.
> 
> The reason is that I'd like this staty together with commit
> 81bbf03905aa ("s390/pci: expose a PCI device's UID as its index") since
> this then allows to reason that if uid_is_unique is 1 that implies that
> the index attribute must exist. On the other hand backporting the other
> patch too  would create new network interface names. I reckon that
> there would be some value for the uid_is_unique attribute alone but I
> think it's not worth having more possible scenarios.

Good point, now dropped from everywhere, thanks.

greg k-h
