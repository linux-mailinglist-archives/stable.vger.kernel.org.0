Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EFC1D71CA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 09:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgERH10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 03:27:26 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48209 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgERH1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 03:27:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1ADDB5D7F;
        Mon, 18 May 2020 03:27:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 03:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=WJXvjDve5mEkKZ0I6T2/VmzLncC
        /OzA1t3Xk0zcb8iA=; b=BvEgbGblcwflKDHANGylbBeWQ3s9eROdA+jupVgz+a3
        FuGFkjl5+NlVmTMn1Ovnh+S5D6X6ddTv/kJa9S9GCNVW1tE+iBFBEBxhd8OAF3hi
        yJvrGS6W8XqTSOiAA1KcCH5IAZ++NllkOqfGM51FIW69eiLqJ/dXTkyJIJxnmKcV
        YpcbZj4WPai0J8Y9A2FAwrCpPt6HP7HnSA/r2f41gKCN0Xs7bBK4JOIdBM9U/BdJ
        NeJ38jkiJwSzqLwK/Mh2T2CR5xNVoqlbGaPbdp0fBggZSzbNgVpm/e7/uUetn9gz
        jj6RKj1o1M9anAXR55N5Us682x3uK9TQpwnFSt78dhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WJXvjD
        ve5mEkKZ0I6T2/VmzLncC/OzA1t3Xk0zcb8iA=; b=zOu/FuBHyASLd2rQkDW25L
        p18CcPpRz8/MsnY+i/ODCVA82tczK0eKq6PQGIqJDltUV5tjaVID7E7STaJGqI2D
        jUcPkykjuvmOI5sViyvOEbWMCq2ocfmIgTzRYvHayIfCU8h6HrnD1YssqbPwUPzf
        k/VNy9MYJcQE+wxybQy3cRbFF09ehZxgoHLn/YnEu8d98I8UKGbAqhNCgdk/2KhT
        gzOmBQaZU4JJAtr2YtGJEEVaLfc0jY2MYe/KfJYyD0bxEonNp50W2JjfGgY6nZfa
        W7BwAvWb29tHhvolDCWJMFvKshHW5vV8opILkrkaIFyMUtXgC2j5QtTHaoYd7OAw
        ==
X-ME-Sender: <xms:3DjCXl0kGURlcrjtkvzerJs9W4iwWG3Cv-SoekJyKxB3nmMnIqSzlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtgedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3DjCXsElEgn0cZZTXyQEo7DViJrRIXYGM_ahm88nDrIIBLeGdt_utg>
    <xmx:3DjCXl7R8U2SWnepryi24ZB08dVgy42OiyymEF2xYP0y3VgPXBH5Kw>
    <xmx:3DjCXi0FnD3cc4Vb7KK8W4r4THCBO71MBdAC6Zz3jNT5EHHyGQCQOQ>
    <xmx:3DjCXsTdlPW9WAwgnIS-4TJRdrCpsrp8EYSoku53ESM863-5QzfhBQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 509693280065;
        Mon, 18 May 2020 03:27:24 -0400 (EDT)
Date:   Mon, 18 May 2020 09:27:20 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 0/4] backport request for use-after-free
 blk_mq_queue_tag_busy_iter
Message-ID: <20200518072720.GA3010296@kroah.com>
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
 <20200415130017.244979-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415130017.244979-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 02:00:13PM +0100, Giuliano Procida wrote:
> v2: Updated commit messages following feedback from gregkh.
> 
> Here are the patches for linux-4.4.y.
> 
> There are 2 further patches over those for linux-4.9.y and the
> differences after back-porting are non-trivial.
> 
> The code complies without warnings. However, I have no suitable
> hardware or virtual machine to test this on.

Sorry for the delay, now queued up.

greg k-h
