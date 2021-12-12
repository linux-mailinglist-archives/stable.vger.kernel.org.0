Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1210F471A80
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhLLNzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:55:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43205 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhLLNzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:55:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A3305C0118;
        Sun, 12 Dec 2021 08:55:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 12 Dec 2021 08:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=DU5SXriTNRyS71l2bxO2m+nfg0d
        UpC1LU1HuaivfHlQ=; b=FJbUlQnjlXMPLDuiUPofv+v99/CAdmIIhstdQfXtgRz
        cXqrFfvpiZ0JlTihyZ/PNa9RDQdH7/CXffOfjeTMdZYB7s9RFy0CbAN7CQ3Ag4Cn
        +CEwWG7dp6Qj+xDWheAbxWYLv2btS8G0DRFKTx/25yVzuMypPXrL2MzFEwFm0wjJ
        RJ7BHLztu9yo0URpPgQnzJypGFqvAGcnyCwR6csf12fG54WUd4q0BbeR2vLq7UMT
        4VvdYE0Q34n/SjGORhSMEnUez9+klqoUwy+K8xgZQsm7HAX/4TMeY6cmFYNHQDyT
        p9PVvKXRF6asanmIoiJUqiur2EZLmR6ll7fS0JdZTjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DU5SXr
        iTNRyS71l2bxO2m+nfg0dUpC1LU1HuaivfHlQ=; b=a2px8q7dbHR3zIhEBq1qyw
        KaTRzZ/j+ZayQjx/oZxMlhGTuQQIn314780fZmBa6C40qtXUvBpNSJLIAyGwojQX
        d72ro0Polr2+Vb9hgqcUmikYmty7Do1lp31v3gnAhyDBb06rLc6PXPQUEEbIogFD
        P/9x1VcKwhgZl8d9CDf5/9cew8J4W+9tSpBcOlko5q4HiHcfe8xEUaERgfawnGXF
        /tO+l8Nlk1Hr0SZ6n6/9veMFw1z8WxQzrPMkLSMJVYbetKx5C9r3RWOY37922lIJ
        tht8y0U1yOcdkLkt4KSl3PqTBOfFkZJPvrDNPW2sQtXiQJ7QkHHmu2wSq2H+NU0A
        ==
X-ME-Sender: <xms:NP-1YeVs1Vp8CvyV87GVKiSMg3yJO54EjPKlyoTJ64D7hqERARAUmQ>
    <xme:NP-1Yak3x60lk1jb3Ua2_88xPEBamRp_13ycU2FeLIBEtcwoeRWxOt5czjtKpvpun
    ZEtuqp4oZcN7g>
X-ME-Received: <xmr:NP-1YSbhAM9RIXtXsciWLn7OfUH36n9KZkJOEsSp0o4hjCBnR7LzTrLqCs1BU4mr8XusrqAbJo8XetFPjSmPcuASRDmuSLGM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeeigdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:NP-1YVVtk7U__F8WLxLMBJoGw5i6CKEfIoVuitpIVf-M1SthEa95NA>
    <xmx:NP-1YYmvn4DEDy2jUqUWQFWt5BQNdsmjdWguEGRXkOHxEP3BdU4kXg>
    <xmx:NP-1Yadv5Vzl0f_QTHeHYrwj3T1q_-Hgk0b91-h6HGEadjiWSVdHGg>
    <xmx:NP-1YZBnbL4MyyFpm8ddAtim9I5Wl6wlFcl6ENwTgRNwOfzMMdCBXg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Dec 2021 08:54:59 -0500 (EST)
Date:   Sun, 12 Dec 2021 14:54:45 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 0/5] aio poll fixes for 5.10
Message-ID: <YbX/JVz768WuoiXd@kroah.com>
References: <20211210234805.39861-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210234805.39861-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 03:48:00PM -0800, Eric Biggers wrote:
> Backport the aio poll fixes to 5.10.  This resolves a conflict in
> aio_poll_wake() in patch 4.  It's a "trivial" conflict, but I'm sending
> this to make sure it doesn't get dropped.
> 
> Eric Biggers (5):
>   wait: add wake_up_pollfree()
>   binder: use wake_up_pollfree()
>   signalfd: use wake_up_pollfree()
>   aio: keep poll requests on waitqueue until completed
>   aio: fix use-after-free due to missing POLLFREE handling
> 
>  drivers/android/binder.c        |  21 ++--
>  fs/aio.c                        | 184 ++++++++++++++++++++++++++------
>  fs/signalfd.c                   |  12 +--
>  include/linux/wait.h            |  26 +++++
>  include/uapi/asm-generic/poll.h |   2 +-
>  kernel/sched/wait.c             |   7 ++
>  6 files changed, 195 insertions(+), 57 deletions(-)
> 
> -- 
> 2.34.1
> 

Thanks for all of the backports, much appreciated and now queued up.

greg k-h
