Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE942BFCA
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 08:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfE1G6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 02:58:38 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55827 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfE1G6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 02:58:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8B686371;
        Tue, 28 May 2019 02:58:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 28 May 2019 02:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Untf67SLMeBn/dqegU/ruZ59KBJ
        XN/BOcpL2kpxD+gA=; b=jUKYoVVGZHskHNtxpNzeASntys+BYYXvIv4tlFrEZwN
        1dJ3xHq3DeFcA8bqr6VvMSOB0TO/42dECwVAhrSzHCN/uRFvNswy5N2wR6bPEstR
        IhstAHF64M5NcmiZQK2PIU1nMz70lqzOhuxMBc3V1pZL+vhQFl3kJChQkfrvlrns
        3yhDfqE6pjp4r8O1II4/Vh6xdcf7Zt4fRgEDePbHzIXEh917e+U7tQeOfPhNlwr3
        N/W4ovLf//FrNLtED+a4qICrf9tCP4IpGGsOczFpyqd0yMejrs45rUeqZYBsmX82
        AtZe0B62h4ghBNabQQBVy3P0yywpKEbunlQ86wYR8Uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Untf67
        SLMeBn/dqegU/ruZ59KBJXN/BOcpL2kpxD+gA=; b=vV4clusKreIKFhpWvACDcx
        7vK55WVqXk+p7UJVZXIdTpmgEzbrULg2n0dhIjzlpDfFXLyndrefOWEaxSpUJLwQ
        WCmj/YHawVUQrljy2/v+H6864I9DDGNIWnKbtyTdLxCNE7tTtGUBWuJDQG6Lh6aB
        w4W/RQc/1XJ5bUh5lFVho6mBMDbZRmfO6GGEO8Uow/DssgOLqkAmGaxMPptQ8ISX
        6KROIWLOzBNzzQXiowyKeBjKF+7Ff5LyuNtdB1JhGVvpVj64k/kGYFPlNKGVAcmc
        EgFfhrQ/lBMbVG2SoHpW4O/5qAN58AENE62LqauqBCGaF55p+RclGFZU2St2BoMA
        ==
X-ME-Sender: <xms:HNzsXCZy8OSavmoWlCFvA0eXQk80s5WTefoU10M840Ze107U0N_keg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvgedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesth
    dtredttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecukfhppeejjedrvdeguddrvddvledrvdefvdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HNzsXCwnt0MaCIz9cW738x0jXc2dPf4z8kDM-vMS7obBem-1DoDvMQ>
    <xmx:HNzsXGdGL2ns9_rumsKyyy1dHlDhZlf0FVINQZoxls_5MIesXMV6xA>
    <xmx:HNzsXP5F0ARWscoG2g6R_r11fqhB6_vQ0pJqqfwat6wFjVBRFTMCCw>
    <xmx:HdzsXOZgXEf9Y3F7nfrKXJNFcj8DhnbuRNQL-Aq8mpUxXdNy3SJs_Q>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EE1880059;
        Tue, 28 May 2019 02:58:36 -0400 (EDT)
Date:   Tue, 28 May 2019 08:58:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build/test failures in v4.4.y.queue
Message-ID: <20190528065829.GE2623@kroah.com>
References: <9f66f53a-331c-ddef-9f66-3855b2d1bc49@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f66f53a-331c-ddef-9f66-3855b2d1bc49@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 04:44:37PM -0700, Guenter Roeck wrote:
> parisc, parisc64:
> 
> Build reference: v4.4.180-76-gb17fdeda327c
> gcc version: hppa-linux-gcc (GCC) 8.3.0
> 
> Configuration file workarounds:
>     "s/# CONFIG_MLONGCALLS is not set/CONFIG_MLONGCALLS=y/"
> 
> Building parisc:defconfig ... failed
> --------------
> Error log:
> /opt/buildbot/slave/stable-queue-4.4/build/arch/parisc/lib/fixup.S: Assembler messages:
> /opt/buildbot/slave/stable-queue-4.4/build/arch/parisc/lib/fixup.S:62: Error: Unrecognized .LEVEL argument
> 
> The problem affects all tested configurations.

Thanks, I've now dropped the parisc patch that should have caused this
issue.

greg k-h
