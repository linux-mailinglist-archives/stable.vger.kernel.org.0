Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABB51858D
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 08:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfEIGvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 02:51:22 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42563 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbfEIGvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 02:51:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9939C258FC;
        Thu,  9 May 2019 02:51:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 09 May 2019 02:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=PxvDPZHfQlOElUqMXGHm8QPbHGC
        fmVb2QgzQf3V8ohg=; b=FrS4YpVSDMoY+qW0Uos39pLj9t6O1XLd622dzFPNLkA
        rwfFAQdUxfW7sA2ODqjJkZhuypLFte7H1nAwAcM/Am1VYGFQRmYb5P1RTG/idxaf
        IJUfKdiwEygnVIwWOja/wO9BxEkDf4TqbCYZJHYDDUIC7laKiu+e4CZUX2oK4XDq
        iflyV/kVBaGZnmoDY7YCw54iL9VD51NlaUCrY2m46uGYWwv3IyK4YJGcjSRblZ5r
        svc4pN90rGcPkUNmgTmpGWpaeGueXO/MdhuyIxJUh6bwm9gAtTLJo+XKjT0YKSU3
        Hr9mJeMIL2eFPVVG0TNDhg11BrzSA8jgArkqMPlPz9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PxvDPZ
        HfQlOElUqMXGHm8QPbHGCfmVb2QgzQf3V8ohg=; b=FCN7xyfpoXTUJDfqLOE88T
        Jpb6PC3s1FUCEq9BsekytfmKBw1SX5aPVMvJWxx04SnGXMQK408SCvzqTslyKYr6
        jptE12ZeoKLT46WRj2FOUmbA6P6b4/P9ZQ9k843Z2ZQtxSNsKE85t8vYsCMT67H2
        fxfMwpGTcfwGijCOEzR9eaHokrEtZJZeEJnz9yW/YuO5oBpfTDjdwtaHWfIDbe3h
        81MsitSZYBNd3F8c5aWQwnNMVPWgdCfo9EU7TVSc7eDXwK5HzbIlD6h+g62vKRj5
        69/gf+tE720hNvUI7AUS0oRfEjUJdrNMumkwfgO5zTz4VER20A7THUwM50Bbpr/g
        ==
X-ME-Sender: <xms:6c3TXDw4GzY9n_9XFhSz8D8ua59XE3UgXVJAMm_5ed2PnETyHrwaDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:6c3TXElJWkFqgWyzNI_2eWLWoyNduoTr9TMBeNi1-1rr5fjVNWbspQ>
    <xmx:6c3TXEmZCjW8lBKTD_pjSRsgUG_7J3slrTL0koOMISCsRuUupgzXeA>
    <xmx:6c3TXOz4tkdhC5ibsIku3Naw-dob3lAbw3yaHQY2rP5kM2qqYwNXLA>
    <xmx:6c3TXPvkt6Bs6GplsxLqbCcR3jxC5RLFUYhmYJRdCLJAY3DJ_sHi5A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A531F8005B;
        Thu,  9 May 2019 02:51:20 -0400 (EDT)
Date:   Thu, 9 May 2019 08:51:18 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Test report for kernel
 4.19.41-rc1-721c545.cki (stable)
Message-ID: <20190509065118.GB3255@kroah.com>
References: <cki.D9C3C37075.4ZHPVBFDGL@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.D9C3C37075.4ZHPVBFDGL@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 06:40:44PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: f897c76a347c - Linux 4.19.41-rc1

Here you are testing the linux-stable-rc.git tree, not the
linux-stable.git tree, like you do for the 5.0 queue.

Any reason why?

thanks,

greg k-h
