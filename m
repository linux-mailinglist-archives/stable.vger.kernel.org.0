Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1E3E233E
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 08:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhHFG3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 02:29:00 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45143 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhHFG3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 02:29:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7F7A6580B73;
        Fri,  6 Aug 2021 02:28:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 06 Aug 2021 02:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=eWVlY49TeLxeXcwOp6RoCArUbxW
        pC9ZgtJzQ3VYEJu8=; b=VKvPK9QLfcxaD53WyA4abxkXFYGC2lbJ9Sp3NVV75jH
        HxY4YZp8zdAnhfYBgyGO8Hc7CHqrLoFyeb7U9KS9midrtgXn6ubeddqJfNCsIcUD
        QgOMGWOyK0mfY55wYMl59jb4CTnWqKI4pJ6bDiSd3te8lOG1vDK0bP7Z7N+A5hqQ
        QzxcH7bLizVOJA8G84krha94crfM8IeFvsEoe0tIikxupEPnvteHMMtG5G8ci2bp
        59n8sDDaBxFISNAl13yjRUvc1ljYboeux1zjI7pzs2bRPXgq4ckecz0DzZUJPUgv
        ZleVORvq5/110wAzHVh9+hHfrsZDUxPBTz6Hrdho53Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eWVlY4
        9TeLxeXcwOp6RoCArUbxWpC9ZgtJzQ3VYEJu8=; b=ANlIL+aE+oSIEyyaz/PfzR
        4b8jxfX6peebx5ePhv/6TZpECcibgNjHncllgtanibeCYfJj1LUGRwmNhhqyXkJ1
        KTOdRADhzdvWfOGMdFHWMvn0WIqddg4gSzIZG+H45V6gKZiGjgBnsjbPJGqANC0q
        kcxj0Kkdhe6Ui2Q/m14fQ5XwXFZZV9Yv4ilu+tHcam8G1SSJiN2ogq+Zjse3MdYA
        Q1oJTEbQnMgjeK6A8y87MQKYPy4jWOSUrhclgzxfIiDDE/lHzwZSAqkpURShXOgK
        p4gS7SUdpa0ueFE8YuM5uHEOdfyrWx13rJJGo8eZzWIhUjWPnkfzUAhN4uAVEFIA
        ==
X-ME-Sender: <xms:mtYMYVp6y_ieYX6y4ebnfhcTn9KWN4XRWnUL4ILCKCF3QfIYGFXFFQ>
    <xme:mtYMYXoQft32LmSDFR_XR5cRUWG735DEJTEJSOzLcB68Rjy1tnCkye_FH-iJDxgDM
    DtvirlWIJczeQ>
X-ME-Received: <xmr:mtYMYSP4UoVbL_Z856fJu5b56K6Lj3rOvMTN8sf666kno8Rz8u8NAUDokDOnPG4Nq_NqF1yuKNPno2t8M9amA7W3BSomwfAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjedtgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mtYMYQ6Faq5UrKAc2pI9rf8uBbSquuHpMmLx2kDWGV9VHJnEN82unA>
    <xmx:mtYMYU7_EACPS6gCwy-j4Co20eP1vnkb3U0la8GY6HuXoXSpmXnnlg>
    <xmx:mtYMYYhka83FFa4WxHKy_uafoKKtJxtYr4AQHhRd9l9g0VKw6acSmg>
    <xmx:nNYMYTQaWkg8Hz0jlC9zShaC4hHb1NY5v9j1XN9i5rVV8r7VQHi4Wg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Aug 2021 02:28:42 -0400 (EDT)
Date:   Fri, 6 Aug 2021 08:28:39 +0200
From:   Greg KH <greg@kroah.com>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Michael Marley <michael@michaelmarley.com>
Subject: Re: Faulty commit "watchdog: iTCO_wdt: Account for rebooting on
 second timeout"
Message-ID: <YQzWl9GeD6OgxzWA@kroah.com>
References: <20210803165108.4154cd52@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803165108.4154cd52@endymion>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 04:51:08PM +0200, Jean Delvare wrote:
> Hi all,
> 
> Commit cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on
> second timeout") causes a regression on several systems. Symptoms are:
> system reboots automatically after a short period of time if watchdog
> is enabled (by systemd for example). This has been reported in bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=213809
> 
> Unfortunately this commit was backported to all stable kernel branches
> (4.14, 4.19, 5.4, 5.10, 5.12 and 5.13). I'm not sure why that is the
> case, BTW, as there is no Fixes tag and no Cc to stable@vger either.
> And the fix is not trivial, has apparently not seen enough testing,
> and addresses a problem that has a known and simple workaround. IMHO it
> should never have been accepted as a stable patch in the first place.
> Especially when the previous attempt to fix this issue already ended
> with a regression and a revert.
> 
> Anyway... After a glance at the patch, I see what looks like a nice
> thinko:
> 
> +	if (p->smi_res &&
> +	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
> 
> The author most certainly meant inl(SMI_EN(p)) (the register's value)
> and not SMI_EN(p) (the register's address).

Let me go revert this from the stable trees now, thanks for the report.

greg k-h
