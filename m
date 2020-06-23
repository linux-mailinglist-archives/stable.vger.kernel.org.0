Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC38205B87
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 21:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733220AbgFWTNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 15:13:38 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:35071 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733236AbgFWTNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 15:13:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id C4289906;
        Tue, 23 Jun 2020 15:13:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 15:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=7WMvAPN1ErXgthiWUva+PTQ5T73
        /EhOOW6dGIyc3zc0=; b=B+xXS5EBQWZ76VL502N0Tw1rr59TAS+8Pq1CRN/ND1g
        9mi/Bj3aIMd9/8Z0lXlIW13VHlyNycJXaI+NnLZgeAPZ1dtuK+FL9rAasVMz5yzj
        b3UDgAoF1CfpbwJa1kTLjuSmrN2mKF4aJhTvLtg4LONgwbz5MwRM74ZWGh3YBNE0
        oEomJNl1PnVg3e1jouf9fcYDMOiONa8F3GJ2UsEQRzq8TYJvV64vP+fEviCCOwoV
        Goe3ONO0sURn5YPfJdlW/quT7f31cXx75HAxqTk6Uz0KyVx5nlMfGXUX1IZfhKHC
        Hz8uQ2hey7urtJcHOhT/CeX81xdemir2Qm6N6mkuOqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7WMvAP
        N1ErXgthiWUva+PTQ5T73/EhOOW6dGIyc3zc0=; b=dXCLzDdCuwNGc5oLIfOe5L
        wTIxnmKazr6VdstsTaz3hwOkHGeSMwlx2q3oknJL/FU7LcsrYnK4yy1OmNW/LESh
        4n9N8vOKP/DIUVa48fgeFVm6Hoj57yAJruueXw6Mdazc79XtPFoXEyPaJh8B9mWM
        kS1EN/wdxPQYsSCWc7lC+j3HN9VBqMqn1dl0nKUhj+QvWbbVQ45MlATPwK1B2ixj
        ETVWDshVsgLRGKGNlwSfs5NrhzlK3D+mtoiZh7CLyZjtSnMIcbwBBmoEc0GN2vdj
        RSyVPh91Pe6AC5alHDvLdEECasb1vmKqnhxOr2CHjiHaKYhM9XnXsdgXlnq5OtaQ
        ==
X-ME-Sender: <xms:XlTyXk-P6sWMr2Vi07X27DG6YL52VZnVlmT_fZ5wtczUclsPFZs2Ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XlTyXssaaugpPbLXOIRp270vhFlvbqRa8cz2rWuRJXoPz9G6NYl9PQ>
    <xmx:XlTyXqAixP3WzEqLYjaZXMWcZi_uCoI1eUN7pV2lkxqzqm59jRvlcQ>
    <xmx:XlTyXkfqATS3k_-vThGx3EGgS6FZwaRiZzTfd3PiD66Vgdkh52J78g>
    <xmx:X1TyXqGrtznON9bqGqlBXzR_2sIOg8ycDEX1jqn43Wv7SI4mvRRE0zk6ax4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20A203280063;
        Tue, 23 Jun 2020 15:13:34 -0400 (EDT)
Date:   Tue, 23 Jun 2020 21:13:34 +0200
From:   Greg KH <greg@kroah.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
Message-ID: <20200623191334.GA279616@kroah.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 09:24:57AM -0700, Florian Fainelli wrote:
> Hi all,
> 
> This long patch series was motivated by backporting Jaedon's changes
> which add a proper ioctl compatibility layer for 32-bit applications
> running on 64-bit kernels. We have a number of Android TV-based products
> currently running on the 4.9 kernel and this was broken for them.
> 
> Thanks to Robert McConnell for identifying and providing the patches in
> their initial format.
> 
> In order for Jaedon's patches to apply cleanly a number of changes were
> applied to support those changes. If you deem the patch series too big
> please let me know.

Now queued up,t hanks.

greg k-h
