Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C1123548
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLQSwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:52:55 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32907 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfLQSwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:52:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EEB9321EA0;
        Tue, 17 Dec 2019 13:52:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 17 Dec 2019 13:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=Z
        nNrkjW8IniNHg0L9hPLeTQoGfjn80wDfO1+ofBRRVU=; b=e6qvkPXEz/ZgLQq5r
        LNXz6jVLR/pZUO6ibx/XygVIcEm8kCfYGe1GTFIVwlN+hN5Hgni5fa8pSlLQI9DS
        d8kkwsJqkyNpHO2UMxk+toiYzdBeR7X2WagUq0DXnAWnZBn96Tw0qXN8LDQe/0zI
        cpr8ffKjqEEblD/ZL2jrBr+AOSZt97s0s3h2DNi+MsCm+43IiSFLFQLiN99jFd69
        v7XmUcNnafikoOMpM0j9f6V9f6T5lR3Qpi1iMpRgwZUgYxaL02aYr38c+8irTYcO
        2iNw/mqYePRLJmAG0jEEr+fvjSUuT+4yg/055N0TvMOCF12Jc6pNAxVCXBpspAOk
        r6TrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=ZnNrkjW8IniNHg0L9hPLeTQoGfjn80wDfO1+ofBRR
        VU=; b=rD6RVPr8xHwcRglqe7jlxv394T3Xq7bO/VhVbuHCIisuZuei1EKQ0QMbp
        rCpE2tw2M8Uf4vhDKIp7P38DMjWKBEgn4CFkruDX5yd/OmTFq7gJh36edY2iSJhq
        WvCCmbjqoRslAmRGbvlfRNTScFGmk88OgIZ9VdatBcJrCp/MUCast5bv30cap1MB
        YRwvD/kkSLxQX1ssG9BySg3h7Vt3ocoyoObT6jlExYMqr1qHNUy9HwpDWDA1Urlm
        K1S+HFBpI0UFNfOHNJiCPovMNKCb9NptlFlg4Xa45ZER1U+e8i3ICSDbZG/kZglm
        smC0rDiWXEyJdK4NJgRbEpgPMvUYQ==
X-ME-Sender: <xms:BST5XcQcX_Qj1kW-z-OZ9miVPW111rZ6s1LdRzv4dlnZOkGmkbwZ1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtjedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjgesth
    ekredttddtjeenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:BST5XXUzS-hDfknO1AJ1AoSM8Ae6s7WP_Pb2eo9pfIPyzGOpsaDYng>
    <xmx:BST5XQR1y-x-Mwf-vTcVxyM8B43AYy0q0RXbMnhAEM5TaER_Ohtu7Q>
    <xmx:BST5XRk_Jz1v-0dBy4vrG4pRg_UjBbJGJgNHWWBp7qzdudm30HvUbQ>
    <xmx:BST5XQxvi6ILuEQAyzhq7zx5D0Gieu5uw87Dqr2hH6y88QZopPo8Sw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83D8030600D4;
        Tue, 17 Dec 2019 13:52:53 -0500 (EST)
Date:   Tue, 17 Dec 2019 19:52:50 +0100
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: 4.4.y/4.9.y stable queue build failures
Message-ID: <20191217185250.GB3867407@kroah.com>
References: <20191217182309.GA29679@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191217182309.GA29679@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 10:23:09AM -0800, Guenter Roeck wrote:
> Just in case this hasn't been reported already.
> 
> arch/powerpc/kernel/asm-offsets.c:30:0:
> arch/powerpc/kernel/asm-offsets.c: In function ‘main’:
> arch/powerpc/kernel/asm-offsets.c:401:37: error: expected specifier-qualifier-list before ‘vdso_data’
> 
> This affects all powerpc builds in v4.4.y / v4.9.y stable queues.

Ah, I see the issue, thanks, will go fix that up now.

greg k-h
