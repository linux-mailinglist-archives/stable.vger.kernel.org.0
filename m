Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445DB14DCC5
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgA3O1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:27:39 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45415 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727139AbgA3O1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:27:39 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 1AF4F46B;
        Thu, 30 Jan 2020 09:27:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:27:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TUlawlgTzSpWq0b/d5uMRU4UHNv
        MoXG4k8rumQ7y4nQ=; b=ANWYYMcTm9CdmwokO6s+mB5Uqb4qTkCYGNxO6uUZOtF
        Dw0yuuPmINUkwOtwT4VB2nnyeJ4dDw1no2mz119yKckhaihRlApcmQx6H6Rt7tzc
        hecjkheWs7NzXSzcTbYqldMQODgCQVixQrgFRaDwVoHKcLh648yBDlvp/RIQ62Xn
        8cmz9sVIyw8PzFVrLiINSeMwrS+cpRFIWNWgssbN3GYukxl50fdm2jYX0KiyWrGc
        WwP6KE5yr2rP/2A5wnFEpiacaueXkrOTNsTY49bVhhBFG6pHSg3Hvyx9L5lZtFSg
        h8IyiVxLhxBwgxgRsa5wFrYn7KF2sbqOcoZe+kIA4/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TUlawl
        gTzSpWq0b/d5uMRU4UHNvMoXG4k8rumQ7y4nQ=; b=x1NEv0k8GlSFzWy+U9f76Y
        suyasDkyfUiTHgx1+YS7WG5gs7jVjYsUHLKeAD/bNWNc/KAKdCQUFz8q8yCav6/V
        oKi+hSwEu7AlAujIX+ZfrXsbNR5KuFPnGzrp3OT9m8O2ZMLoxYBL3l7WjFZYAlTE
        qSo9C9clj2CFGqb1jAqDh6n3bHD1LbUfXHzF3ayyuAsIP4kfhE2WcPTpN+PsgMoU
        73rxmYtzHN9h2HhLQPVFbi7VMRDRDfCmv3RR96vIszSL2PJsy+SKYafx1dul/t57
        Z4l0ye0IZoFI86CoPHhhnpv+1W7FHBEmE6ay34++UaptgWM7daFm5DdyYPlJdvgw
        ==
X-ME-Sender: <xms:2ecyXoI6wgxNj_Lt2kov8jhv1v65TgbtUDua11Zyu1ROhacGUGJ5BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekgedrvdeguddrudelkedrud
    ekudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2ecyXkQa9LSrpopBdXtKJugqfbbbTZrenzFIHf6760-9izGKBU34ZQ>
    <xmx:2ecyXk267fdL7ZJAaQdVqC_ni3QWV5o38CcZU1ynom1NtaQSFE4Fpw>
    <xmx:2ecyXqB0Q_TWaJrvh1QkPuOFJLG2d209yd8DRkivcvp8KjxtjyrYQA>
    <xmx:2ecyXuHesRBVYCcfTWtN7_iuYha7lJi9SeHM3v5taE6NbezrDPtJwQ>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5FED3060A08;
        Thu, 30 Jan 2020 09:27:36 -0500 (EST)
Date:   Thu, 30 Jan 2020 15:27:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     Stable <stable@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Subject: Re: [4.19.y] 32-bit overflow in __blkdev_issue_discard()
Message-ID: <20200130142735.GA963927@kroah.com>
References: <ad8d7c2d-9bbe-6d2e-db20-d208b5563c09@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad8d7c2d-9bbe-6d2e-db20-d208b5563c09@yandex-team.ru>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 03:10:42PM +0300, Konstantin Khlebnikov wrote:
> Please consider including into 4.19 upstream commits
> 
> ba5d73851e71847ba7f7f4c27a1a6e1f5ab91c79
> ("block: cleanup __blkdev_issue_discard()")
> 
> and
> 
> 4800bf7bc8c725e955fcbc6191cc872f43f506d3
> ("block: fix 32 bit overflow in __blkdev_issue_discard()")

THis patch does not apply to the 4.19 tree :(

> Overflow of unsigned long "req_sects" (fixed in second patch)
> actually exist here much longer.
> 
> And 4.19 commit 744889b7cbb56a64f957e65ade7cb65fe3f35714
> ("block: don't deal with discard limit in blkdev_issue_discard()")
> make it worse by replacing
> 
> req_sects = min_t(sector_t, nr_sects, q->limits.max_discard_sectors);
> 
> with
> 
> unsigned int req_sects = nr_sects;
> 
> 
> because now discard length isn't cut by max_discard_sectors it easily overflows.
> As a result BLKDISCARD fails unexpectedly:
> 
> ioctl(3, BLKDISCARD, [0, 0x20000000000])  = -1 EOPNOTSUPP (Operation not supported)

I don't understand.  Can you provide backported and working patches for
the 4.19.y series so that I can apply them that way to show exactly what
you have changed here?

thanks,

greg k-h
