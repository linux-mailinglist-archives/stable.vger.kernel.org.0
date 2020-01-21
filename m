Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC3F144080
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAUP3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 10:29:07 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49233 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727508AbgAUP3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 10:29:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A8CF4683;
        Tue, 21 Jan 2020 10:29:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 21 Jan 2020 10:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=+/0f47UqYUDDzNHgiHrSNjUlgtv
        aeiDXvmGXKPpKjRk=; b=bYMFftfoQGWMwkGpoyljg0PHYiZ1r6mSEhHrF8YDhbI
        N+cP8hdSA8hrGPYfxPw0ETzZtj4czAvBywrJ+tu/cq2tV+e1jGZ8oTOACOPjXG/5
        A3iKFXngfbG/RULZy1+2q9HpAF60iWZQH3EbLRU66yuSARx2Rs2HU5rl3mxOWhzp
        8xUJdExLk5Ndo85mWx/j0wKKWtk+zkPb7jkEDI1zCY4/E+kL1VhHzN2Er8x1umL0
        k5OkALrIXead9Hvw+91UODAdpiezEP/nto5T6YJVwsU0dsG3ng8lSUfrN+tlRp6M
        8a92utG1g+tAmyoJ/ZaTz9QDKhQnjBqOdzytYgKcr4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+/0f47
        UqYUDDzNHgiHrSNjUlgtvaeiDXvmGXKPpKjRk=; b=bkBhkJBhs7knQQliTWl+xZ
        Jt7bSmRvgtQ4XGrPevpWffunb9zk9GturMNaXTzx5BXX/b6lHfG6/SDe3OfeQ0nO
        uQRLOkmvjHayK8f2z05ZFNZZTJBdJzu6dQizTKWLNMSJzrl3mfaJ3eYOOQ9863ru
        ofj4PfsqNDhe/3eX3kpSuHPnFJeRQ6iMeCdu9msH/em1jKVjQhvQw8oPVAC1the9
        yflqEzdVXlkYUsJQMw5g3TUhN9gUW5wmc89Oxl8pAP0vGU70Ea9cQzkcjUUPk4nE
        sb+GUxerjBrMWrMebye22Op6jbCdpHcuwym+bqrFwRrsfHwWfuukOeziZJKykcag
        ==
X-ME-Sender: <xms:whgnXis9CtNWWx3QirYYlUtgOicR9T568Y2WSd9JjH8G7NkFEuO_1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudekgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:whgnXq-StiJQRyPsqliYvY7JQGu4hKjq8GHaOnT_lMibWRUjmMmapw>
    <xmx:whgnXmRV65C1CM1KFmglEkVIPnKnHdI-D6euQjKgix1draPoTbY1VA>
    <xmx:whgnXgDQFWG9vbdsPfrcam1EExSK2HuitOByul86vUB1aJq9WcKc1g>
    <xmx:whgnXjXx7JFAep6QqB04XMdX-uEK1baSwiN8I0r9nuebqNyAuSMZcQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA76B328005A;
        Tue, 21 Jan 2020 10:29:05 -0500 (EST)
Date:   Tue, 21 Jan 2020 16:29:03 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200121152903.GA586917@kroah.com>
References: <20200120.204420.1680420390021164400.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120.204420.1680420390021164400.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 20, 2020 at 08:44:20PM +0100, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.4
> -stable, respectively.
> 
> Thank you!

All now queued up, thanks!

greg k-h

