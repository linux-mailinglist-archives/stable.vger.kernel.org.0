Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13671425947
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 19:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhJGRXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 13:23:00 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45023 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241854AbhJGRW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 13:22:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id C3183580C3A;
        Thu,  7 Oct 2021 13:21:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 07 Oct 2021 13:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=h7pyFg0sSpr620NIFMlnMBLz7O2
        8NNLY6C3BYJkRlzM=; b=qYJgEB9Z3FusN9qQ4486/MtuYbddQ4cVwwJZv682UxO
        yfL+MRDvB4hzUQpRJ/ra3g5lz15+LB134+LaBQJc2g6ojLIJZucFdTzIEKtylQPG
        A4TMURpAGKUkTUynH8fsJl8KxANER0w+4J2livhL96GrRo4vF3u0DL32dyiLkLuW
        C1FBd4wBTCCar40O3Z6oQtcRUIPTc+UDnS92YFiwHPK4IoG+5eNbBIT/oMkS0zdY
        D3LB8kks9psYhuCWJmN4NNhXIi/ByILjCzp4CwozzUoyaqbqEc43EA8PLVvHQa1e
        WB8WXgcvK6+9DYsDeO8Srl4uTTWZl0ak9RwaDCMeTRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=h7pyFg
        0sSpr620NIFMlnMBLz7O28NNLY6C3BYJkRlzM=; b=G3T8xhPsAGPc20IT76m04I
        E2NGb7guT3s0qUkM9s6mYD5fcloPNvS3R8qC+yi5vkaQU+LY0j3PGN/t348rzvFf
        ufOV/xniJ3/bi+qYVMa1S39Y7Cyt+uTTiP1FvTaJk1RoiCVsckuzZmPWvv8tFqFB
        AY5CuhOIyu0AcNPMlgs5j2PRIt2M0vWB9quQG7gFq6XNAvbo8VrYv0JWA9On2ogl
        sWU9XOwZo+P6MplxKXrSoZRJgTONvc4TatWMi5Bqc5t2gj90GXgDer9Nj144GyyO
        0c8dl0K5bFINFAGtcASlNWIT8jdCopeFQgondnl3N4KWgdVUqMw8bniys/UkPU0Q
        ==
X-ME-Sender: <xms:fixfYe-fBHqIyVMN2MD8IY0I-QKjQx3Ye2Nh8Pe7XcHkE564ZyTxjw>
    <xme:fixfYevu8hU1ozCzaWASww7VXZkGYsdEDfaxVV4JG5ovgDzkJUxdxgp62tg9xTmGP
    lnDv5nWXN_8gQ>
X-ME-Received: <xmr:fixfYUA0G50JH1tugIkHSqddZGqs0l_YGiDyt9RV58mfk_o91d0p8eKfuqVkb-cPxMQQvbiILp_oCyJJ_sb1RdKmUdsswa0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelkedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:fixfYWcrakWal2eHYKWNurbChY96YsrqlSBbCpcWxj075lwR9yoa_A>
    <xmx:fixfYTPJaoJXUqSL5WRcjHk5HQrgNHZv2FuysRJzvYAskZ9O4IwVPw>
    <xmx:fixfYQkZJq4ajvidFM4CJE27fu2cUHzxTiI-lNj5WS4LIl0gUO2GNw>
    <xmx:fixfYXkdPY5BuCeNT_GEyOMzit66wc1mUr6LJO-dDhyWBPdGNxQsOQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 7 Oct 2021 13:21:02 -0400 (EDT)
Date:   Thu, 7 Oct 2021 19:20:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 4.9] af_unix: fix races in sk_peer_pid and
 sk_peer_cred accesses
Message-ID: <YV8sezluT/RPT/Cs@kroah.com>
References: <20211007170536.2587403-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007170536.2587403-1-jannh@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 07:05:36PM +0200, Jann Horn wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 35306eb23814444bd4021f8a1c3047d3cb0c8b2b ]
> 
> Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
> are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.
> 
> In order to fix this issue, this patch adds a new spinlock that needs
> to be used whenever these fields are read or written.
> 
> Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
> reading sk->sk_peer_pid which makes no sense, as this field
> is only possibly set by AF_UNIX sockets.
> We will have to clean this in a separate patch.
> This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
> or implementing what was truly expected.
> 
> Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jann Horn <jannh@google.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [backport note: 4.4 and 4.9 don't have SO_PEERGROUPS, only SO_PEERCRED]
> [backport note: got rid of sk_get_peer_cred(), no users in 4.4/4.9]
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  include/net/sock.h |  2 ++
>  net/core/sock.c    | 12 +++++++++---
>  net/unix/af_unix.c | 34 ++++++++++++++++++++++++++++------
>  3 files changed, 39 insertions(+), 9 deletions(-)

Thanks, both now queued up.

greg k-h
