Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF7D2D7835
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 15:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406259AbgLKOsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 09:48:09 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50485 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406329AbgLKOrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 09:47:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 639DC5801CB;
        Fri, 11 Dec 2020 09:46:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 11 Dec 2020 09:46:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=+Am/okroNzJr1TmU7haAv6uyZZI
        Q6jWmqnrSti6GXho=; b=Rmzl45noxIYEjFtsgOkZQmwHKHn3tIfMedDbmqeBxij
        NKFPx9nyuEMFD1SOkZZEiltRmZioluy0zCtTAO/kivENkAv782RrkBUxIg/rvZPI
        UnYvfuxcLXglqg6+F5feTsWMgR11JZWo+uBoJ3zknGpuwBNH6mG0/jYVuvX+3LL3
        35KQ2Imf5StXYTeBXK9y+FZV2BK/8ApRCFfup+RrVL+TvR5OmaX/vmmJMxFBbGCQ
        6zXUv6uhKMvFWjWPgOuj0Nj3p8fl2stnEKHRM3vjrOVE0K9j8SB8jojdBhvNzQhe
        rl0Kl6lvTSAIXM9UUkh7zk26qTGasI46o88QL2BgGmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+Am/ok
        roNzJr1TmU7haAv6uyZZIQ6jWmqnrSti6GXho=; b=OClxJ5zI0Kc6sUzw2FFl0o
        n2mc8LIOe9QRBJWVfS6e5krsJwizD0dtzxBJBMwdJJzgHohngFR9VqDmDht4kliQ
        iCQ6TbXKzZ64N+FPx75VZ5dOG1S8KWy7N22qfqYimgJTFbbfRpbxxVgQZawzPcnd
        b9DtxHAvrAZNUwoxwKtUFAywW76ky1DdxfTKzE+O+HNh5eM2+EmrXMQzOD21rHU9
        0Fo6Z4OpuR8Lezl/bbaeOrdkfLuf1rTDfaPGSWl6DyT+AGv9TP0QyE/VQKo1jR7R
        w6sFSo0dhmLnpvbuaC4Kpt3wEkQ5GGUvTltn7caxE0u3gAs7UerzdQWCpjcMjp5Q
        ==
X-ME-Sender: <xms:PobTX_ELpSGjATysjlZnFEAG1P-yJRZJa3sds_SrcY3XApc15RLcLQ>
    <xme:PobTX8W3IuQH87ezyvIqJ_V4dQLXGxKOPM4vtz_moXBquNSzhDDElNbdYNnR7FM8m
    zNBaFNpooQwOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PobTXxKV34px7PpLEdB5UrtiIpCtRRiRTKaHDxyRhwUL8rU6jB8Ugg>
    <xmx:PobTX9EQnE7IyPk1rUO0Ek_-oCPP8DM9UiTNmQr5Cg3OykiAodGuhQ>
    <xmx:PobTX1WzfqpP211WLZ9t87e8I7Y4g01NbWqG9KeJTEI5hwaeu4pkUA>
    <xmx:QobTXwPPxU-Tr1Kt4vjiPki-wZoCNdlOUoqNfGA1YUXNhfC-O4Sw2w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7278E240062;
        Fri, 11 Dec 2020 09:46:22 -0500 (EST)
Date:   Fri, 11 Dec 2020 15:47:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Solar Designer <solar@openwall.com>, Eddy_Wu@trendmicro.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] kprobes: Remove NMI context check
Message-ID: <X9OGh2QRZQrX/gM9@kroah.com>
References: <160761425763.3585575.15837172081484340228.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160761425763.3585575.15837172081484340228.stgit@devnote2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 12:30:58AM +0900, Masami Hiramatsu wrote:
> commit e03b4a084ea6b0a18b0e874baec439e69090c168 upstream.

Both patches now queued up, thanks.

greg k-h
