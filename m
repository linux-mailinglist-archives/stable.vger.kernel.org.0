Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C032C66BF
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgK0NWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:22:53 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50953 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729888AbgK0NWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 08:22:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 11F685C00ED;
        Fri, 27 Nov 2020 08:22:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Nov 2020 08:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=38/wbfCKXTkC5LG04Smdt4//3XS
        DcNSerBfnYChVnqk=; b=A3RucOtO4sfSGAUx8aw1p7nKrHNOxMH7C8353ibvzzk
        IqulggrIQkRE8iDVxFAFnwjOjgg7mMi7GTf0fVMmarE/tOon69N+5QCxfhDiWlDR
        zStrayoisgxXhDiKzr54pdmJqXxJ1n8DLRXVsWioMbTWggPk47sbdUa5tqcNV825
        QOOMjt0IVAbH+I6bMoKdkbHUJPRTvZtS+2+4bR65tJAAFTT1RYbbfaXeLoNJY9Gl
        1PZGffggoVa+dPmRvUAszb784Z1z3YdESxBkzkfeGe7inu60Cm7DfghMQa6ZBVfo
        9Tw+vtrAxILFI70IfrE7dMxzbWuUj46s0jLH0fdwYIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=38/wbf
        CKXTkC5LG04Smdt4//3XSDcNSerBfnYChVnqk=; b=Mks2GYvxs5dd/960MLWXxZ
        /TspEnhB6/8ioZsH7iCNFWBczpUkdeFRpNJuKpwFwKZj0RshbtSJqVwzHskoZ4CH
        oSUUVa0Q8d97mVt28Fo5GkktKkfosufs6v28/DtYsmTpk17BNl7szsMggLJwrAlg
        75hvJlmpjP3Ui/fXvpaHY1X9sYx2gjpf/TRQYS1I6BqbopPVEjCl9WJZ+Tf7zxt8
        o2tkdCrZ442pPbGnxBezvnEZf2Thp42HIAfa7I2ToU8HofvbaC5uew3J8S4gzT5M
        DUcKc4BNls9hRe7PeATEWZcwSbo/tiEzoRbHW1pXX0djyKaG765FGih/N6HXYwBw
        ==
X-ME-Sender: <xms:q_3AXy3VwWhXvCHM5Wk-O_FD2B_GEKzVez7Z4AYc449tParRFAqauQ>
    <xme:q_3AX1FOgJNq3nrVvqz-OkO_mqjXlgW7S8qN7_2k3o_LUOw9k1ZGoqOV8ycp2UtDc
    poh3syShAQuaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekvddrvddujedrvddtrddukeehnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhho
    rghhrdgtohhm
X-ME-Proxy: <xmx:q_3AX652CnxMu_IK8F_JOV_wZBE9ak8U3AqwJu3fqKQ2p9DObJ7kBA>
    <xmx:q_3AXz1IYMiYVIKwc1dcGszwi2KnAk1hPNd0kbYBgqC0BOUtaGr6Lw>
    <xmx:q_3AX1FUZYy7J2vAIfE9ystGNCKWL7fHi-cq5-zH7AUbRPgg3allKQ>
    <xmx:rP3AXzM-bxDuoD6qNL2bJz2P68I_1uhzTq_XMmOavy0BzwNKYTzhqQ>
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E2E23064AB0;
        Fri, 27 Nov 2020 08:22:51 -0500 (EST)
Date:   Fri, 27 Nov 2020 14:22:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     stable <stable@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: stable backport of "wireless: Use linux/stddef.h instead of
 stddef.h"
Message-ID: <X8D9qRSZ+g9nLjf0@kroah.com>
References: <f1958cd2-bd9e-5141-8aa2-f8729dd76719@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1958cd2-bd9e-5141-8aa2-f8729dd76719@hauke-m.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 12:04:00AM +0100, Hauke Mehrtens wrote:
> Hi,
> 
> Please backport "wireless: Use linux/stddef.h instead of stddef.h" to kernel
> 4.14, 4.19 and 5.4.
> This is upstream commit id 1b9ae0c92925ac40489be526d67d0010d0724ce0
> https://git.kernel.org/linus/1b9ae0c92925ac40489be526d67d0010d0724ce0
> 
> commit 1b9ae0c92925ac40489be526d67d0010d0724ce0
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Thu May 21 22:14:22 2020 +0200
> 
>     wireless: Use linux/stddef.h instead of stddef.h
> 
> This patch fixes a build problem in broken build environments which was
> introduced with 6989310f5d43 ("wireless: Use offsetof instead of custom
> macro.") which was backported to the listed kernel versions.
> 
> When the include path is fully correct you should not hit this problem, but
> I got it because of some bug in by build system and also someone else
> reported a similar problem to me and requested this backport.

Now queued up, thanks.

greg k-h
