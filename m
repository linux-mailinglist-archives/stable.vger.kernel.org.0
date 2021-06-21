Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F6E3AEC49
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFUP1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:27:55 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44025 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230061AbhFUP1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 11:27:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id C305B580862;
        Mon, 21 Jun 2021 11:25:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 21 Jun 2021 11:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VChZ2B4kvGp9lzShOwiPyBmcM3t
        XR4PDIa6DizYyQhQ=; b=VjUtR840o9xUV5nixjHbmUw98DpqNaGJd/zGoDecD5g
        +I39ye4HB6+Dab0hyTxWqFo+1xMPDyWFnMEFdDiFYRx2pHmfESs9oz8662rj3SHz
        qWjFslgPm+8iFZGMeoP8br04s9U81HJNmki9ONOm3gQFLbtWPmh4+LC3pGvK1sVw
        YdBdbWEEUmt4Tlpd+xVKPr5mtIE2WyKek/bsXj+yxV23RbTTVTd5mm4pn4Fz4k+V
        +J7cwsfc7EbaoYzqGX3rfu/DBes6nES7reU2S+4d8vLKS6qBv7KbQFwyEOqoN6iN
        SAy6dOPgp4EKSYrn4yMa73hWhvRFsT5rticdqGJ6brg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VChZ2B
        4kvGp9lzShOwiPyBmcM3tXR4PDIa6DizYyQhQ=; b=OPpgeB8sdRp9gNmj+fwFqS
        anby1YSRIqj5vJA0S7b8ujxpQXUyBW3G2E5oshmD61BkVshoyh7x/tJnNpl3vvbW
        I6by7brWQxRZ2J4aUpO+iQ6B43OkZAXf7bDJ7e+4mzYOHnF138itPj+1q4Rh/7Da
        H2W6WM/A4BAMqYIDuHMkmkbn6YuaDSQjMNn8bm5Gu8Kzuaa9sUTEp3a7rDxKK+N8
        mtEGTcxlLEMqJSQO6jx6hij8WTYeWdsHitDjqV6YO/UgVbAVc66pnpKrIJAXL8Ax
        bP5aG71Pys+TwYo4WSHytc+rQ4u1ZBcxb3sdrX0meVaL5W2JqMhY2WpMJ0bb3SXA
        ==
X-ME-Sender: <xms:cK_QYKFEx9Zkd-hNTdPtVtibyEj-mrmEAvt983asMrpb0tKq7dumeg>
    <xme:cK_QYLX64qQ9wPDBsuFf7jJmYXgKacLJfBCWAUFGlvnoXawwDO44Y-J6XrQctG5rx
    TRDzZyegxKX7A>
X-ME-Received: <xmr:cK_QYEK1Hy5suqU4mG5XeVQsm2nzSDcAtv0T1Pyi9OQ-yBprXoJhoWckYoTO-WN32Edm6IjMwZXpJGfyS-gUcSCzPQSJsMA1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeefteehte
    eugeekfeejfffhfeffhfevveeijefgveehgeefffejveeutdevffeujeenucffohhmrghi
    nhepshihiihkrghllhgvrhdrrghpphhsphhothdrtghomhdpkhgvrhhnvghlrdhorhhgpd
    dvfeejrdhimhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cK_QYEHlFLodsXvpMye0NUN5pcRvTM3EZFlD64VY2zNE-teXQNv1tw>
    <xmx:cK_QYAXHDfM3JNhfR4C2fCDKxFU9SpwuPddtsX4hOc7M-v2e1N4hlw>
    <xmx:cK_QYHPXLi3rvj9YroE0vxvJ5dgYGZRLuNCKM7rRoyl7RKjgdXH6og>
    <xmx:ca_QYMkbMcYSzVSATI1wthqNEv5XgutRp9I70d-k18MrwqBSFNqVMQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 11:25:35 -0400 (EDT)
Date:   Mon, 21 Jun 2021 17:25:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, kernel@pengutronix.de,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-stable <stable@vger.kernel.org>,
        syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>,
        syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier
Message-ID: <YNCvbZp5LDwUvyjZ@kroah.com>
References: <1624271916195215@kroah.com>
 <20210621112451.2882032-1-mkl@pengutronix.de>
 <20210621112820.5gemmaw56bipx45j@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621112820.5gemmaw56bipx45j@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 01:28:20PM +0200, Marc Kleine-Budde wrote:
> On 21.06.2021 13:24:51, Marc Kleine-Budde wrote:
> > From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> > 
> > commit 8d0caedb759683041d9db82069937525999ada53 upstream
> > 
> > syzbot is reporting hung task at register_netdevice_notifier() [1] and
> > unregister_netdevice_notifier() [2], for cleanup_net() might perform
> > time consuming operations while CAN driver's raw/bcm/isotp modules are
> > calling {register,unregister}_netdevice_notifier() on each socket.
> > 
> > Change raw/bcm/isotp modules to call register_netdevice_notifier() from
> > module's __init function and call unregister_netdevice_notifier() from
> > module's __exit function, as with gw/j1939 modules are doing.
> > 
> > Link: https://syzkaller.appspot.com/bug?id=391b9498827788b3cc6830226d4ff5be87107c30 [1]
> > Link: https://syzkaller.appspot.com/bug?id=1724d278c83ca6e6df100a2e320c10d991cf2bce [2]
> > Link: https://lore.kernel.org/r/54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-love.sakura.ne.jp
> > Cc: linux-stable <stable@vger.kernel.org>
> > Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
> > Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>
> > Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> > Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
> > Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > [mkl: ported to v4.19.195]
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > ---
> > Hello Greg,
> > 
> > this is a backport of
> > 
> > | 8d0caedb7596 can: bcm/raw/isotp: use per module netdevice notifier
> > 
> > to v4.19.195. Please apply.
> 
> This also applies to v4.14.237.
> 
> I'm working on a v4.9 version.

All now applied, thanks!

greg k-h
