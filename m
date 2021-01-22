Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B4300466
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 14:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbhAVNlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 08:41:10 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34825 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727975AbhAVNlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 08:41:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 812631AD4;
        Fri, 22 Jan 2021 08:39:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 08:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=1UZKtFsCspoiQaWn2zzM21QUXU7
        Xi+n7y3Sxw4QPU9Y=; b=3+/pwfWbC+2XpDGZXN4trqQXmBwAqsqKqLWeQ2BAczd
        i0eFsJyMKE/BKgkrIe78sKhlwQN0pbiskyPqqOY2xcraf7BgVe0HBdDkDZuK+M76
        /Rqnj9AYx6ztJZbVJt3yWxswdoLE5wdWHb6rFA0VESxzkxTU3pENhygag3K7TTk/
        943MaUJ+ho+lyVy/bzQMOJlkAhGhMLsmHi8VZEiUV57r/aZMJObWirfEjdupbShe
        8fn9oLOK6qrWQzvyLYkV8Af2bxzhhd//Me8nXUw7n0kGbGdOGeqUYtukA6OIa4Va
        JrkSXNo6qt3x7F2teyc9FQjKw72KzqBylP1FmHnXQVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1UZKtF
        sCspoiQaWn2zzM21QUXU7Xi+n7y3Sxw4QPU9Y=; b=CLM3VMuuB+KzB2Lnogq93D
        zjAA/TdPC8NVKkeN7YsJeAFlfDPVbr+YVFhc12oUjWveJNRHwnkERQl2jsydJ9Vy
        ZIFcsH7Zg5UCfrk3Lp+xVW8X76wGZH3WbvfFpoYIz73PkayJc0YJh0nGkbnC4j+r
        OeV8YZqO6BRF+qUMBIZr2FyB4tP+VDPyA3h31GsuuDqhmCsuEBqExOL3F37FMSM8
        cP0siPnF1RUM3+9KukGF/wpoeUKAmS8mXisSEfAHWGzuGrNmgDDN2dNxhE6QX3wW
        5Ex3+aH8bny2/dCTRx9VKLtKF9wXUPhttOFFBBRUhNwWuu0WpekRQDdM+1T8iq/w
        ==
X-ME-Sender: <xms:rtUKYNKqEOG5hMo0DFV1tXSIq79HcpNjTKYijLgUjkF4ijsrRVqTdA>
    <xme:rtUKYJKDH6uUNZYP3Cdhd-j6dKTVu9TH_4sIM0SvwmlXDtKkCA-AeJPVhW92HW0Ul
    b-zVWHnN9xxag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:rtUKYFuJmAoLbcfTxYc-LxBDcY9LPoAeurJYijhO6pxOAKDkTjEjoQ>
    <xmx:rtUKYOapIV1An-w7GQV6uF_TE-1Pgktr22pXVrVAH-t8Z1kkk2cQ9A>
    <xmx:rtUKYEa_RTahFMJaaCvhknv5mYoHcEsb9A64x5EhmLaXt5GmwdBvTw>
    <xmx:r9UKYNBWbaIpPYxgdkFRot43fSmwoEgT-dwu2bqSK2ExnH-wr6C90A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94C9C240062;
        Fri, 22 Jan 2021 08:39:58 -0500 (EST)
Date:   Fri, 22 Jan 2021 14:39:57 +0100
From:   Greg KH <greg@kroah.com>
To:     "Alex G." <mr.nuke.me@gmail.com>
Cc:     stable@vger.kernel.org, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] drm/panel: otm8009a: allow using non-continuous dsi clock
Message-ID: <YArVrTKtT9zSsDlt@kroah.com>
References: <e1d4b851-061c-4959-7333-28b6e57f91df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d4b851-061c-4959-7333-28b6e57f91df@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 03:34:11PM -0600, Alex G. wrote:
> Hi,
> 
> Please consider applying the following commit to v5.10:
> 
> 880ee3b7615e ("drm/panel: otm8009a: allow using non-continuous dsi clock")
> 
> A related patch introduced in v5.10 has accidentally broken the display on
> stm32mp DK2 boards. This commit resolves the issue.
> 
> Fixes: c6d94e37bdbb ("drm/bridge/synopsys: dsi: add support for
> non-continuous HS clock")

Now queued up, thanks.

greg k-h
