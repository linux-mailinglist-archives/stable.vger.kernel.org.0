Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF61F50D0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfKHQP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:15:29 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42047 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbfKHQP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 11:15:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2FF4B21EBC;
        Fri,  8 Nov 2019 11:15:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 08 Nov 2019 11:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=rXerACSGVzIB31baLJCc/F95zv5
        Ph0AO9GOIVfBEt9g=; b=rDGnegvXbeV/qwdSPmFxCxHe10zRM1Hh8HoEkwbGS4R
        ubsRwaZ+KhYaHFPxWEI7lfdpIJGABil3UfoYN3Q3z9Lgsfc0ImBWsHJFW8ErCkVh
        cR3lKteTnhSe35MAXBJzzLkzeflC8ghWpGx0oqDOccRxplLiiBXZ6cU02s17FI7b
        k3GUKxX++K4DOkRqibpH8F1RVWuKhpLZWuYbWPrz7kc2bPBFL4mG8ifKzYRk+yYJ
        fdhabO3NRcFRuIQNUY67WucnBBoK4mkd3XJ/h4DU0G9qPFRrrrCIUaeovPOiowyp
        54Duu+GHXk5/UvwlX/wPn0idRa/t2lgwGsY0Wa3jyXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rXerAC
        SGVzIB31baLJCc/F95zv5Ph0AO9GOIVfBEt9g=; b=R6z7XKPChb1U6LDMcKYouK
        WaSObrzD+5xt9fPfRYtph924kLBOedPsjzbQYSUfh/mdC1pU6c/hACISFuyVnqMQ
        PZorFnfsggn65I1Wdu/Axf6IF9VqxWeufutyROnqmY0AM0eby9GWoA+zk2VRX/qN
        lwmFka9kZgCM4Dj2cp8/M8jSgkfAgd9BOwfB1eMtmt/si8YdFzrJkzv98YkqRhUI
        wdYPYmvbQdOR3UBGj37m8rr+8p+XQ+9ZnU6tl/Ko16qPbuEgoXh/jbi+b+qZj6we
        79LRxBnt/PLFwe5lnGoO6wjMTPwuPvUOIi61CsGoySp4jfcVoiFOsb0gSpNuox7g
        ==
X-ME-Sender: <xms:n5TFXVE5Ky8U-zi358skzABCHn_3P-bQXdDDTBCMKupbzl4zmvz36A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:n5TFXcrD9KuVwGHqmFIv3xj9_NEfIUNYzZrcwsG86LwfWh2CzXmmxw>
    <xmx:n5TFXV4AAvbpI6S5sKnlrFZjH-fY14dcp5zpIz7QHBT_h4_Wnz-ciQ>
    <xmx:n5TFXVQIZm_wpk0PfxnNuBlp7AA5BYS6F9lcOpAo5tks8lxLIZSc9A>
    <xmx:oJTFXZ-1xNy7aN7MkQuww825Q3qib7ox0g4CEhP6X60ANTEWk238bw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 683C980059;
        Fri,  8 Nov 2019 11:15:27 -0500 (EST)
Date:   Fri, 8 Nov 2019 17:15:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Fix retry mid list corruption on reconnects
Message-ID: <20191108161525.GE761587@kroah.com>
References: <20191106181635.25327-1-pshilov@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106181635.25327-1-pshilov@microsoft.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 10:16:35AM -0800, Pavel Shilovsky wrote:
> Commit abe57073d08c1 ("CIFS: Fix retry mid list corruption on reconnects") upstream.
> 
> When the client hits reconnect it iterates over the mid
> pending queue marking entries for retry and moving them
> to a temporary list to issue callbacks later without holding
> GlobalMid_Lock. In the same time there is no guarantee that
> mids can't be removed from the temporary list or even
> freed completely by another thread. It may cause a temporary
> list corruption:
> 
> [  430.454897] list_del corruption. prev->next should be ffff98d3a8f316c0, but was 2e885cb266355469
> [  430.464668] ------------[ cut here ]------------
> [  430.466569] kernel BUG at lib/list_debug.c:51!
> [  430.468476] invalid opcode: 0000 [#1] SMP PTI
> [  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted 5.4.0-rc3+ #19
> [  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
> ...
> [  430.510426] Call Trace:
> [  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
> [  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
> [  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
> [  430.517452]  ? try_to_wake_up+0x212/0x650
> [  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
> [  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
> [  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
> [  430.525116]  kthread+0xfb/0x130
> [  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
> [  430.528514]  ? kthread_park+0x90/0x90
> [  430.530019]  ret_from_fork+0x35/0x40
> 
> Fix this by obtaining extra references for mids being retried
> and marking them as MID_DELETED which indicates that such a mid
> has been dequeued from the pending list.
> 
> Also move mid cleanup logic from DeleteMidQEntry to
> _cifs_mid_q_entry_release which is called when the last reference
> to a particular mid is put. This allows to avoid any use-after-free
> of response buffers.
> 
> The patch needs to be backported to stable kernels. A stable tag
> is not mentioned below because the patch doesn't apply cleanly
> to any actively maintained stable kernel.
> 
> Cc: Stable <stable@vger.kernel.org> # 5.3.x
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Reviewed-and-tested-by: David Wysochanski <dwysocha@redhat.com>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/connect.c   | 10 +++++++++-
>  fs/cifs/transport.c | 42 +++++++++++++++++++++++-------------------
>  2 files changed, 32 insertions(+), 20 deletions(-)

Now queued up, thanks.

greg k-h
