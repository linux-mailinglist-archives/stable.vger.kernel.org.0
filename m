Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE01D2A2EA2
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKBPws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:52:48 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49857 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgKBPws (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 10:52:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 63243116E;
        Mon,  2 Nov 2020 10:52:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 02 Nov 2020 10:52:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=yVWVblK9OUYQdIbr65U7yPOCV/G
        SdGTrt+oEyCZWSMg=; b=yVG3ffUSyzeTkOf9bUeygenwOVMxuQu/7RAEYYnsm2z
        1N74wAOm6S+jycIjNT7FKDT3gnUZZ+04Wi81jOOCswP4Um/cscXMm4uOLrk5Gu28
        ybBtcvM92qsMSrwtlmSNpYOQHBySn+fPq8GguGpumPZ9FzE8RWnX19jOq6dHjR01
        8jCoQ/Y4VrEgk1KX5D50aaykKXZ8qM+3N8ulNNd3Ak0YCVmy9ylAd9ivVuOjLhS1
        ek2OFp7kUZc7uBXpVWUvOl+aY88dKCYcgNW9pKwzsEmw8+3HOpCHAtet2DSgsxL7
        MG1PPb5xRd0peYadIxzHmIXT52hu4kWbDPuyLcqzmfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yVWVbl
        K9OUYQdIbr65U7yPOCV/GSdGTrt+oEyCZWSMg=; b=UPaJn9mLRNvukySxPdXmwh
        nWMnc+CFkEmNIVKCmDFtf+rQ6lFz8HTczh8Td0rOirhGgPPk0ZWl0LtbBckMbYjf
        2tj5WiTPqJx9D2AToLBMwypnN6J8huDn/sEq5XZfk2Zz7Wd9QNyxsIJWFLFgR8Fu
        6DA2WrYr8YS7UensLyNgxRXxFksVONrUyqoSJYr5vrizzq12HqVxmoCXs5BIbOtF
        qWRPwTMs+Su7WpTlXcj0rAjs2eY7OdZrVYcUtSxOhe0y29XiCnCYA8LMO5aEmEgl
        7XtfKhbqXIJdtwT9XZ87OOI5JIYFsXKr8TcAUE/0txEGfWCeWJ3WqXHlmfqDGjXA
        ==
X-ME-Sender: <xms:TiugX7iIabbX774shlNaJqe9YGJ79mt6TNKtEJVBabnFCYbf6lZB-g>
    <xme:TiugX4CiWl3sMmG2Pn5yp0gMFnPybVfFR9nhiAmm5EYgFKMDQHr8q-eY8sgJlfMMd
    x5zDvGOUNASoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TiugX7GI9vLvVbWc6PAfccgItYy7-udPvQQyzNO41Vnaz6BZhpjaNA>
    <xmx:TiugX4Sl1rd6sU6Zpi7t8qBM4tGJB8cQIs7KgzDlrC2K8sZ4O4badw>
    <xmx:TiugX4zVDGmf3JtWgwO3RiCum3gY4pSpVkFn9-i8YU9T9qQy0lVVFQ>
    <xmx:TyugX1ul4L_iXgKPDhFiNwbhQZE-7AltdE0irZahIflJ1W9y7VDj5w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 895F93064610;
        Mon,  2 Nov 2020 10:52:46 -0500 (EST)
Date:   Mon, 2 Nov 2020 16:53:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 12/14] xen/events: use a common cpu hotplug hook for
 event channels
Message-ID: <20201102155342.GA1492224@kroah.com>
References: <20201102121722.10940-1-jgross@suse.com>
 <20201102121722.10940-13-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102121722.10940-13-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 01:17:20PM +0100, Juergen Gross wrote:
> Today only fifo event channels have a cpu hotplug callback. In order
> to prepare for more percpu (de)init work move that callback into
> events_base.c and add percpu_init() and percpu_deinit() hooks to
> struct evtchn_ops.
> 
> This is part of XSA-332.
> 
> This is upstream commit 7beb290caa2adb0a399e735a1e175db9aae0523a
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
> Reviewed-by: Wei Liu <wl@xen.org>xen/events: use a common cpu hotplug hook for event
>  channels
> 
> Today only fifo event channels have a cpu hotplug callback. In order
> to prepare for more percpu (de)init work move that callback into
> events_base.c and add percpu_init() and percpu_deinit() hooks to
> struct evtchn_ops.
> 
> This is part of XSA-332.
> 
> This is upstream commit 7beb290caa2adb0a399e735a1e175db9aae0523a
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
> Reviewed-by: Wei Liu <wl@xen.org>
> ---
>  drivers/xen/events/events_base.c     | 25 +++++++++++++++++
>  drivers/xen/events/events_fifo.c     | 40 +++++++++++++---------------
>  drivers/xen/events/events_internal.h |  3 +++
>  3 files changed, 47 insertions(+), 21 deletions(-)

Duplicated changelog text?  I'll edit it...
