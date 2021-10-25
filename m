Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B368D439095
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhJYHvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:51:46 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34893 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhJYHvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 03:51:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D2EA25C0174;
        Mon, 25 Oct 2021 03:49:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 Oct 2021 03:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=kdLwoTB8i3G/ZvdoG/COo/Jt5C/
        YuqEPOfkB3SWTpUI=; b=mNjEjw8qGlwLPntihdb6Ox0wUjQz/FPDjzFUAdTwlGi
        sVoFrvNK0/swo2d7wfoWfehyiPtyB+B75dx4C7zJE74CCZ+530aKozbxGnzkBmm7
        yO7QhNHoJkX0BIUDxJvy/APIqrkHGxt41uT3ig54FsOZYpqzz67sY3MOxUxzlowW
        8xT3QDu7zD8cfCkvtKFHgwymwDZujSfwF40FxGS4XA+m15G9jedmFnfv8CKsz+ZN
        VeKY6scxxSZfXFOxcYahJ+ImmAw2L1EpbN9GxC3jP1YV9peRzMrjsRne1yczENuF
        U22cyW+FKco+vQFzMFN/NiTAEe+n7sZHJ8WdDlI2IIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kdLwoT
        B8i3G/ZvdoG/COo/Jt5C/YuqEPOfkB3SWTpUI=; b=iY/v+ChvBPaae+NW8vqe4X
        ME2Yi6LZwkVZYtnhd/MRXbQj/fHT57+RpV/dOjSJfVrIbjXFlPV3ItvhKhMw22St
        62HT2i4Td3b5/o3nl5yzuwB0hb4tUZ2vqbPcJWW3ulkvfSto6Apt2lFRFdYEQv6H
        P51BFZ02g7v2z4NMXvMoyf1UOW91nWruqMmqizvKaJhc7sIkAtf2Yn38UQWFSKfa
        YV/CrsvY8XH49xAmcd5JcX0RkWxg6vNUTa2P5mKhBFXHQY2EAwNMA9WgQyQPm52I
        kkpK3cA/BhQCkZtZPklGW8eVouZxktFypyreQy2w1VBaT418psxrVenpUc2mJjcA
        ==
X-ME-Sender: <xms:gWF2YU4EkQ0lj3_ng7eSZPkiKmo5s8E-M7moATpl0pr2W9K4Tlar-g>
    <xme:gWF2YV4Fe_Q6E-itaJOnE-YeUCH_1ZB2Rezr0fDRetrAk_tw4Ja2k3duoj1IcP7nK
    ZywdGZwHHkp8w>
X-ME-Received: <xmr:gWF2YTcVPA1B2wJFMjcPX950PmUsdAEACmAIzTyqn7FHUIGmugwRIF-Y29NdMENl-RSBwwlYqfpNIVkDdCwil8c7zQDZjOUo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:gWF2YZLeOyOBtvXdJCSItlZkNnC0Cieet8-3_PPzYVhWjTTxmAEUJw>
    <xmx:gWF2YYK0UNHV-FT0UgpxxgjY1_BUtWuvcN-x9dITuo9LwL1IrqGorg>
    <xmx:gWF2YaxDSEY7zu28UaQRXICc2Eq9rT9fuO3UBGUeAD-6uyMVH8NtJA>
    <xmx:gWF2YfUPGa2Ao47c43dKls1VRuuzxnMnC1rGEKm2va0PkR1B-ZzLtA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Oct 2021 03:49:21 -0400 (EDT)
Date:   Mon, 25 Oct 2021 09:49:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.14 2/2] s390/pci: fix zpci_zdev_put() on reserve
Message-ID: <YXZhf5c0iFleZfqs@kroah.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
 <20211021141341.344756-3-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021141341.344756-3-schnelle@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 21, 2021 at 04:13:41PM +0200, Niklas Schnelle wrote:
> commit a46044a92add6a400f4dada7b943b30221f7cc80 upstream.
> 
> Since commit 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> the reference count of a zpci_dev is incremented between
> pcibios_add_device() and pcibios_release_device() which was supposed to
> prevent the zpci_dev from being freed while the common PCI code has
> access to it. It was missed however that the handling of zPCI
> availability events assumed that once zpci_zdev_put() was called no
> later availability event would still see the device. With the previously
> mentioned commit however this assumption no longer holds and we must
> make sure that we only drop the initial long-lived reference the zPCI
> subsystem holds exactly once.
> 
> Do so by introducing a zpci_device_reserved() function that handles when
> a device is reserved. Here we make sure the zpci_dev will not be
> considered for further events by removing it from the zpci_list.
> 
> This also means that the device actually stays in the
> ZPCI_FN_STATE_RESERVED state between the time we know it has been
> reserved and the final reference going away. We thus need to consider it
> a real state instead of just a conceptual state after the removal. The
> final cleanup of PCI resources, removal from zbus, and destruction of
> the IOMMU stays in zpci_release_device() to make sure holders of the
> reference do see valid data until the release.
> 
> Fixes: 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

This is also needed for 5.10.y, can you please provide a working
backport for that tree too?

thanks,

greg k-h
