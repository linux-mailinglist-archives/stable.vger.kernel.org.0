Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13828FD85
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 07:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732552AbgJPFAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 01:00:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34221 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732247AbgJPFAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 01:00:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CC34C5C0187;
        Fri, 16 Oct 2020 01:00:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 16 Oct 2020 01:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=jPyRaaFmLMsYWJzz0T+aFFNdX5Y
        W2kW/0wcD3tJqv+I=; b=YlNjRZbSJkd+vvcni+ti3pls8BkHrDA2uQhQ8EdtqLe
        KiYTv0UAb1pGLySOLIb+njk5muRhbeQLbJEwxIsLZCtvoaDXn98Gw9Sm+exI/HNg
        xg32qu/UjeWLyy6ZdGB/T/ws4VkXgZ43un7AjaN6ZnVVhjpfkT7/FRloL4m535/6
        G0OxOpON0+sh+TyLbNNnALqHvwxhI687caAEXNpjg2FyPSYvh/KkygGxb//1+vaM
        JTsAThVr6qVfuQ1dQR8f8wMO85O+YVfaEu8vuUh+5R/IU6dwnCAXdbFXfZSqgpUX
        JTJhGV6B50NIYreoJipzAHF0QTWyelubeb1Wyv7S9og==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jPyRaa
        FmLMsYWJzz0T+aFFNdX5YW2kW/0wcD3tJqv+I=; b=r056eFQfEkdUbmiJs6suH3
        ZRIG6zr2h9DjdJowKHoux96rZY9gaAkhDg2hw5xQhJEvHyHgCWpseP19xBPBdAF6
        b9e8pwjOo10kJOjoKWH9F2HDE0PxNIU4HZ9fUf0VuuEguv6kpiW04lOgDPWAhwNF
        eu2e0nkhtami5u+Syv/5BzpFEydJICb2kLw0Lt8HPB7MiUChCfdUf+gLEp0No4Dj
        b/IOkXuzb9z16H9ENxb0NJyqupXftwkSVDIG9R6dObve/qJ+49bl3f9iJQJeztYp
        4b5bVllcjRMFRX4AbURG0bOAJgPsjW9YsIqRoz5WixG9v0Te50PXT9QK3KuWNj3A
        ==
X-ME-Sender: <xms:9yiJX0K81ZqJTjX2qqh3RGHIeAZPeSw7tY_VG3RszPqHrfGo51HmVA>
    <xme:9yiJX0KQ8gS1BxAsccWfNJM6F4Q82FDJ3wb71PppvHrCiZtCSQ7fhZkU8c1gQt_ji
    AgnKKnK_h_Bxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieeggdeltdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:9yiJX0sQGznGZVejEe0FhExt1GNuj_xJetmDI3GcNXbCaumlCYz9mw>
    <xmx:9yiJXxa-MPXAXeDuzfo4WHC19BGkr32QjhQ2d0FW-ScYA6dsFuesLw>
    <xmx:9yiJX7Z3FL06eCw4nI0-5RIXi2loGHsC-nMOQREZLTwqzPc7kLXm6g>
    <xmx:9yiJX6V91bvGdHQNYSd5yjO9P-TkSKpPKD1Zq8-OF9-Q64JgOIMu6Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD37A3280059;
        Fri, 16 Oct 2020 01:00:38 -0400 (EDT)
Date:   Fri, 16 Oct 2020 07:00:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Daniel Burgener <dburgener@linux.microsoft.com>
Cc:     stable@vger.kernel.org, stephen.smalley.work@gmail.com,
        paul@paul-moore.com, selinux@vger.kernel.org, jmorris@namei.org,
        sashal@kernel.org
Subject: Re: [PATCH v5.4 0/3] Update SELinuxfs out of tree and then swapover
Message-ID: <20201016050036.GB461792@kroah.com>
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 03:29:53PM -0400, Daniel Burgener wrote:
> This is a backport for stable of my series to fix a race condition in
> selinuxfs during policy load:
> 
> selinux: Create function for selinuxfs directory cleanup
> https://lore.kernel.org/selinux/20200819195935.1720168-2-dburgener@linux.microsoft.com/
> 
> selinux: Refactor selinuxfs directory populating functions
> https://lore.kernel.org/selinux/20200819195935.1720168-3-dburgener@linux.microsoft.com/
> 
> selinux: Standardize string literal usage for selinuxfs directory names
> https://lore.kernel.org/selinux/20200819195935.1720168-4-dburgener@linux.microsoft.com/
> 
> selinux: Create new booleans and class dirs out of tree
> https://lore.kernel.org/selinux/20200819195935.1720168-5-dburgener@linux.microsoft.com/
> 
> Several changes were necessary to backport.  They are detailed in the
> commit message for the third commit in the series.  I also dropped the
> original third commit from this because it was only a style change.

As Sasha said, we want to take the original commits as much as possible
to reduce the delta.  It is ok to take style changes if other patches
depend on them, because every time we do something that is not upstream,
we create bugs.

So can you redo this series, and backport the original commits, and
provide the ids for them as well?

thanks,

greg k-h
