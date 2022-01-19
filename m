Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61449399E
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 12:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354207AbiASLhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 06:37:09 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:49157 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354053AbiASLhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 06:37:09 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B7D38320209A;
        Wed, 19 Jan 2022 06:37:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Jan 2022 06:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=DnpHo9kV5iFIix8/11LT71z0m5R
        x/e2zWpnL0RXxbrM=; b=Y9NsHS3giYQJda7t9QV2p4Dz0tMmdNLlytkY0RBzDCx
        R2YLv0itq3MjH3qCOYvWPMGKZ1BamaxsI5Y+s0bl0qbvwA98SCiiDpf8PvtjSwlm
        gNdWjDRghKI4+QbspRVdLVibUrNIs/E49c/3YEFFoBqCdYlv3cMd/XDU/3hOu3sx
        kHdC8oC058jZ+dSmAYYzLAmNbxlPc/NmxM+d9xG68eRXHke/weWL9kjQ//pEStjt
        zs+/eGxBCSXpm8rZ/Orp1WwllWxFUAfsKOxn1BueM+bTmd+Yd4ED9iVY5SHKVMTv
        3ItHmxyUXFv9R5WbEIJG8EaZzMyJfqb/i2YVk54m8iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DnpHo9
        kV5iFIix8/11LT71z0m5Rx/e2zWpnL0RXxbrM=; b=DmL1OSKLmcyossmO2ZN0og
        9MfWPvUTmWLRXH8MLzN9E5aJ/YFCG0Ywb5o5y0+mlDSsQOAQz9FyoQ+1urmA7BFK
        mIua+9XErJjaFh7QWbnicaTIIeOvCIHeI01VwAOUS6EM7sBUhhAqc1eJnnzrJdIJ
        4pUJ0GV1kRkQq0MDOpbj1ziwf2GwwFnO3tXRtM2ASg73gddiSkfhAi5K3P1V3iXI
        FS7oC3nj7IMw6PWZiRDm8dzojBdbAXWjQ/8MYd933q3vLENWIKjUAY9oQ/W2JGIY
        fi0P7hCfWc3Qu/f5Dp9egjtKhPQvkTyGR9ZWAgPyu1nK3z1hckznqjYzhvDB8wsQ
        ==
X-ME-Sender: <xms:5PfnYV3WVkbctw-XYt6WsQJd5OfG7Fx8XzsN8elhwUxApUwRZ1y_rg>
    <xme:5PfnYcHvQoOpfN-Zvi5mSh4y-G8oNfHT47zc8irzdf4mF3hA0sBdoouTwJeaa7eAD
    sB6dbErIgoR4g>
X-ME-Received: <xmr:5PfnYV7TM2JENC0hFNqzOYYe_79g154RbA0He7JcEBl5wlr3cWMV_NkGUsNTVrtOnfspv6awbklNYEfXxTVwA92IZqZTGjc3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudehgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepjeehheetve
    eiffeutdfhleekkeefleevgfdufeehtdejgeejhfdvffeggfdugeefnecuffhomhgrihhn
    pehshiiikhgrlhhlvghrrdgrphhpshhpohhtrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5PfnYS3fggMZdEUkbEllsGF488N1eGFZ7qcHZahVsjRrvo7jqa3fZQ>
    <xmx:5PfnYYE4-xI5Fx8FSqpAtkiwsmk9lrjk19BrlCjeKRcH26hjLbqBQw>
    <xmx:5PfnYT-RjT_CKsafzZ_CG6Zjv14U6VJVHH6SwC909VmRao0xH6pCDQ>
    <xmx:5PfnYdR06oB7h2NxgmjoNpEm678rmWwW7jv-HXaZk7_MfmpxkW5UrQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Jan 2022 06:37:07 -0500 (EST)
Date:   Wed, 19 Jan 2022 12:37:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 1/2] Bluetooth: schedule SCO timeouts with
 delayed_work
Message-ID: <Yef34tC/MAMc2ozn@kroah.com>
References: <20220118163240.2892168-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118163240.2892168-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 06:32:39PM +0200, Ovidiu Panait wrote:
> From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> 
> commit ba316be1b6a00db7126ed9a39f9bee434a508043 upstream.
> 
> struct sock.sk_timer should be used as a sock cleanup timer. However,
> SCO uses it to implement sock timeouts.
> 
> This causes issues because struct sock.sk_timer's callback is run in
> an IRQ context, and the timer callback function sco_sock_timeout takes
> a spin lock on the socket. However, other functions such as
> sco_conn_del and sco_conn_ready take the spin lock with interrupts
> enabled.
> 
> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
> lead to deadlocks as reported by Syzbot [1]:
>        CPU0
>        ----
>   lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>   <Interrupt>
>     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
> 
> To fix this, we use delayed work to implement SCO sock timouts
> instead. This allows us to avoid taking the spin lock on the socket in
> an IRQ context, and corrects the misuse of struct sock.sk_timer.
> 
> As a note, cancel_delayed_work is used instead of
> cancel_delayed_work_sync in sco_sock_set_timer and
> sco_sock_clear_timer to avoid a deadlock. In the future, the call to
> bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
> synchronize with other functions using lock_sock. However, since
> sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
> the locked socket (in sco_connect and __sco_sock_close),
> cancel_delayed_work_sync might cause them to sleep until an
> sco_sock_timeout that has started finishes running. But
> sco_sock_timeout would also sleep until it can grab the lock_sock.
> 
> Using cancel_delayed_work is fine because sco_sock_timeout does not
> change from run to run, hence there is no functional difference
> between:
> 1. waiting for a timeout to finish running before scheduling another
> timeout
> 2. scheduling another timeout while a timeout is running.
> 
> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> [OP: adjusted context for 4.14]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> Note: these 2 fixes are part of CVE-2021-3640 patchset and are already present
> in 4.14+ stable branches. For this backport, small contextual adjustments
> were done to account for the old setup_timer() API usage.

Both now queued up, thanks.

greg k-h
