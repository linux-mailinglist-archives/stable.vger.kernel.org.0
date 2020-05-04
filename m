Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423DB1C364B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 11:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEDJ6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 05:58:36 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55609 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728003AbgEDJ6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 05:58:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 341E65E3;
        Mon,  4 May 2020 05:58:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 05:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=llJwF5RXjAJ50M5WNfOLWzPmdbE
        a7VjH1UwXJhRIvaU=; b=MrNu1maxn7oY3N84dFOqo9koKmc/KSMbkQgYdlnVd13
        HquzIIq0aF3GFFLjMrMp4TNB+/jv3T8PObBvKkyOdq+unl+m2x7kqJvbzBAlOTjS
        Xgwrf3vJ2OEkvm71mxn/JK1ZgzFr+rxsXqL4DjmOVrVpvglh43YjEFgRu57xSWYq
        Gsg97mu/BuYya1nrcB9R1m8Xw5holvhwbOc0ndVmcV8CW85C1tz0LRI4kBmb42DF
        C4RTanS4DO5DzOqkJ1961GpzTRS+qTkPQNhxAC9I2rutydtutj5i/MupIyL7sgk8
        04uZeJstjTdLxw72FLH8gxExqk/5/VDfIPjbCUz8sXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=llJwF5
        RXjAJ50M5WNfOLWzPmdbEa7VjH1UwXJhRIvaU=; b=WdhrnaVbDT7eETk2pdtG+B
        83k7n7BQf32p1YVnTD8rGjNscfA8zGrvZHUrKcYQdMQUaaIj/pETR7+WVnq63XGG
        UlsG5mobD8FZPmM21Qlv93nWtUjCy7ivf9BqJZbLV18g1YYlDcBDH+v/c30Qh76a
        0Jmdlki9/sRQebVUGCnpMCTGCFNJDJ9N3qBFqJcQ3+rLcYUQV0BlOZOhwmyzXNyy
        AJceJyw/HMzclq74ryFA4gqVfEB0ZcCqGoDr5K3qjX6Xuye7cAjy836z6lZAr8yw
        ajYxXxzxLqOgEIMzHYETz08TaCToGeDUIIxawNxTDxMEJZ1DTwBG53r0jjIO8dUA
        ==
X-ME-Sender: <xms:SuevXpNfEHNZYX4G9NcZFNzM48O0It40351U3h9MfccS4LWVBefy7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:SuevXi2qh2Q3mXvYjouU3KdzA43thIlSGFMNlF75nHj2fZ6XyipYDw>
    <xmx:SuevXgl2Njtedkel8PKKbq25lwqbjeFY5ZEFCflTEr1oDHj3iwW0DA>
    <xmx:SuevXhWCKUgsdgxyAYKb-nDImxqNy5rnNXkZAfhLG2hxdg90bgBAbA>
    <xmx:SuevXhiIWiwVh1IIKPXMpDqzvIuehHFua7KpzoNwZxfZFuppRGsY7g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 541F63065FFD;
        Mon,  4 May 2020 05:58:34 -0400 (EDT)
Date:   Mon, 4 May 2020 11:58:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Borges de Freitas <miguelborgesdefreitas@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@armlinux.org.uk
Subject: Re: [Patch include request] ARM: dts: imx6qdl-sr-som-ti: indicate
 powering off wifi is safe
Message-ID: <20200504095832.GA1277837@kroah.com>
References: <CAC4G8N75VkqDug9AmhvMQnXr8bOvC9cu_jUwZVUKwpvWr6pO5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC4G8N75VkqDug9AmhvMQnXr8bOvC9cu_jUwZVUKwpvWr6pO5A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 09:23:49PM +0100, Miguel Borges de Freitas wrote:
> Dear all,
> 
> This is a request to backport b7dc7205b2ae6b6c9d9cfc3e47d6f08da8647b10
> (Arm: dts:  imx6qdl-sr-som-ti: indicate powering off wifi is safe),
> already in Linus tree
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm/boot/dts/imx6qdl-sr-som-ti.dtsi?h=v5.7-rc3&id=b7dc7205b2ae6b6c9d9cfc3e47d6f08da8647b10)
> to LTS kernel 5.4 and to stable 5.6.8.
> 
> Reasoning:
> 
> Changes to the wlcore driver during Kernel 5.x development, made the
> Cubox-i with the IMX SOM v1.5 (which includes.a TI Wilink 8 wifi
> chipset) not power the wireless interface on boot leaving it
> completely unusable. This happens since at least kernel 5.3 (older one
> I tested) and affects the current stable and LTS latest kernels. The
> linked commit, already in linux mainline, restores the wifi
> functionality.
> 
> Thanks in advance,

Now queued up, thanks.

greg k-h
