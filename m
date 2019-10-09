Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB06D0B16
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfJIJ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:27:06 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54045 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729747AbfJIJ1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:27:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 485B3520;
        Wed,  9 Oct 2019 05:27:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 09 Oct 2019 05:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=SU9uF8IClSvEO6f2AACsW6k3zkd
        /WItSqIelcQgWmJc=; b=IxBwvnR7dlnFRaqZyDEHEYMR7cA2MARwEDma9Hit0tB
        Sc46MWOOj5DlEJrPU6DRlIPxr/GTLBRTQygN76OYyyMWgDTyoMJCZoMcqh6SuCCJ
        1pAXlRsUtCWPBneQ8lqCKANIOz5XbFmKG7GmnDBHiNui1kePaIvfkUQn7i4Xt+sw
        jHQLQmMFexhurpvWxkBdHIPueMCjQt8pubzC0P9WLRcW99GztpB6QWDUVxrqe7Wa
        /9nz+pHNf0bbmyvLkII9vmLu8XwC2buZH3yWTqDDK6ZYi2LWQ0xty2LlGJ1BmhtP
        A7LvIcDS7Ka+w155n1ypXTDx3KMX3k3o7/mOQSTMJdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SU9uF8
        IClSvEO6f2AACsW6k3zkd/WItSqIelcQgWmJc=; b=Hku/QXSc/xe8gg0frCKPv9
        /9g2NFDP/H9gFdajyQTCJAKs94TadrdFFR/GLC1jbxmgfRAzi4rVe56lEgU8l0pt
        K4dSPFuQ6yaWJSBSBXwhooImTKzfdrV2vdMcAcUPul+uYmagLXEqyMHhCB4X3eyI
        AOk8Xhm7Hb5fobWXBVOkQWlsUsRDpioJpys+VPOnDwEkAQFoHWvPP5iDYChRw9h3
        du7kwTsiqwGdzeeLQZIyv+zFGVXlVR1JvMsartmtaE44E1OuJp+oEDTtFWIFxoMY
        5Znw+yMTGoHi5wKlG/VHTimq8gGi3cIC5Cm4+G82yYmPe7yK6SElB4URRT3sdX7g
        ==
X-ME-Sender: <xms:6KedXUzkk6FLOGZe17s5Lc4ERH6Ss1lAsvlrOdNbMYJnTtvmkz9Ghg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6KedXbnA_V2ODD9HonmdWk_X3aWMKm6qCwwzFYKaH24BZB4DQNifeQ>
    <xmx:6KedXSIzTw-8kxPfXN7YlHBLIGKFOgvYrjH6SVSXIkKJw0z50R35Yw>
    <xmx:6KedXVv7OFryIXz6Py_5rR0nMG6hxj5gcBoZPjyW7PgRUTrvMdSTVw>
    <xmx:6KedXZwWMWoUP9twqAhISY15MCmFRvQ0noNTD1dm6s2XeprvKo6-Ww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B348D6005B;
        Wed,  9 Oct 2019 05:27:04 -0400 (EDT)
Date:   Wed, 9 Oct 2019 11:27:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.4, 4.9, 4.14, 4.19] nl80211: validate beacon head
Message-ID: <20191009092702.GA3901624@kroah.com>
References: <1570603265-@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570603265-@changeid>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 08:41:09AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Commit 8a3347aa110c76a7f87771999aed491d1d8779a8 upstream.

I don't see that commit in Linus's tree :(

Is this f88eb7c0d002 ("nl80211: validate beacon head")?

thanks,

greg k-h
