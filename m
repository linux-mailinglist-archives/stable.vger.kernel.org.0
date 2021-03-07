Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D31533026B
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhCGPC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:02:29 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50383 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231965AbhCGPB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 10:01:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 30BDC5C0054;
        Sun,  7 Mar 2021 10:01:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 10:01:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=UG7zA5wVrhtWj0nT3iBcc9xsDYV
        G0j6Lhyxatunzl5s=; b=CgzkuEhlAM/dMbfTMzRYlOel28AT8fmuntunqVmXNQy
        hhnw6VY/C9hrBkqOoKrEs19SNHY+e3EgE5xkuYwXQmlDwFHX1r5IZZRlQkTQJHM2
        5er3z/kgQEk2e/G5/05hBefgNa0RjQiJ2yJ8HOruP78Rb+kQJt9z9LyrlK+Olw0i
        8gfCFqFPhXiUWT+q06N7Zh1w05UXvGxNUy1jiRF9Z6GjU7AVCerCJvVOd8fhmeoM
        qoTOtOuC9mMtsCuVI3PXs7Du15mzKAr9eGO+X4zdcZs7Eh2uVWbPQMa90fi2TTzA
        PRWW4ZsInqIsiFYTE/N6D1d3Q2O9c/ZQhNQGVlSaGLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UG7zA5
        wVrhtWj0nT3iBcc9xsDYVG0j6Lhyxatunzl5s=; b=h0+QCHCUqIMk2HefdCmYsE
        cGi0ZUkEX+dUl4TaHn7Lm+R1BmbGSky8FkjFRcR9v4uTOiCy+eT871aYpexN1S0F
        G3rQY6KqZu8WCKsru9oBeCRyiBsk/1QEnoPM96fuJSGKgnCeSS7KzmvDnxPTMgMR
        V9fx938NYQx53ZB+EIO5WCfnLI8ZHA0VHKktRVFco9Uy/JOyfA+vAwHJYbNsHP2w
        gcLqbM7pjgbNWE0OyGoVNjMcsOqDuVx8pr/jJcLZBqiDDO1IwmAHL7rswq2m5KwN
        5SImgIqnnyZ3LMUzJWr7g1MCjbevIrj1tZhW0MOlowro24I/SIMcKNvAeov6+3hw
        ==
X-ME-Sender: <xms:4upEYObk7ra8YsBDkcE6k1ow7C80XgLJyt9XO_rWZap3y5ckt25-5w>
    <xme:4upEYBY2XEUXf6v6-hvTupa035MyLtVWkGKo9V1MV_Gye7dKS-vdybMxYUpHJd1SZ
    qb4VU15jKTJ_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4upEYI8jg0gzmYBq9J2hJfT_D9hud_ktGxXYoAaT3yG_gzKu7LkaPg>
    <xmx:4upEYAoKgMAlMvGUm_TlggUo5OGmWURG0X2nrc8qCfl9yFbFQvScNQ>
    <xmx:4upEYJoGBSk_tYOqAEGXoTvGnvtwZfrH73FgAX-ROMrKHYbBMX-UHA>
    <xmx:5OpEYKltSFXY_oUhJkFiUveRwNTr2_Cgv_MurfnCUjfDo_eR1nlLHg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AAC81080066;
        Sun,  7 Mar 2021 10:01:54 -0500 (EST)
Date:   Sun, 7 Mar 2021 16:01:50 +0100
From:   Greg KH <greg@kroah.com>
To:     Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
Cc:     tim@majoroak.me.uk, Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH] arm64: ptrace: Fix seccomp of traced syscall -1
 (NO_SYSCALL)
Message-ID: <YETq3rUG9rekD1bX@kroah.com>
References: <20210301131000.avqjoi4vousakiq2@bogus>
 <20210305191205.2239589-1-T.E.Baldwin99@members.leeds.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305191205.2239589-1-T.E.Baldwin99@members.leeds.ac.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 07:12:05PM +0000, Timothy E Baldwin wrote:
> commit df84fe94708985cdfb78a83148322bcd0a699472 upstream.

Thanks for the backport, now queued up.

greg k-h
