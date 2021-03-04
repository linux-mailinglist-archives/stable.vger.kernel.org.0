Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9505A32D5CF
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhCDPCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:02:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35561 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232931AbhCDPCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:02:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 214B25C00AC;
        Thu,  4 Mar 2021 10:01:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Mar 2021 10:01:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=mHZZN8K/EPgTBzm8XmQW9ZbvdTK
        GSPyQQB9K7Tso7hk=; b=oHxuICK2Vp0EylGGURy5j+mYUuDB3qs8CH97GYLQNtI
        g2dyZyUZlv/6tRKkTfoUa0PK4xETfh99vNIZPdMpxwTsY9C2UAcy1Zd6K7bYz14l
        uGqdNvM8ON8jrK8epcD9Mmg0qxmJktH6VBZcky5cROcERw5Is2/xhWa/ZDBiHjQ8
        BVBQOLh9ncGuZl4xZM5XKM/rp3aqAWc1Yke2/4SpN5I90Cy7IpPAzS10X4dI0gVM
        hwvIqFZ3IX9ZZo1fSyI5nKY8xbfpA0hfiyPlyrmBWj25H+VEakyb1uoohFvmFURK
        iYIMBQEoHuYq7L4EeLMbybknaJ9bAeZ9CSSd1vRhpsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mHZZN8
        K/EPgTBzm8XmQW9ZbvdTKGSPyQQB9K7Tso7hk=; b=FIp1+esrBe0flTIh0eSjYh
        pUQxhkT/UAHWOnvACH4MxQGlBxCbxQNbANZBL/F1AELk0JgTxBXY1yQJGqbzrJBn
        VVXyMCdmxeoQO6kQbvn4dIe3EM4zPB5dl6BfLs9T1lx9Dp8wFDFAS8sMXIIKrALT
        cqTfMa4/5dIfz279QGyjZx80QxWEZeKDNDKKWb2loOP6NLr8PxhtcVtDvrBPwxF5
        4WrTzm0Vr6K7VWSEy04bCYhzp0FpN5BzMYLDLwQsTNrvo1At8rJ5/l/B06XBZXvO
        rZMblSF1YV1PN6Wjvwlw/cdsXG+fX1kG51Y4Q+i6TuI7cyHBNAJ2AtB/wXBZnYrA
        ==
X-ME-Sender: <xms:RfZAYHWvdeGB1qfgCR3--OoGn4ANK1fcNUiyZoMNzEwzDdQ_gACJPw>
    <xme:RfZAYGFyCFZGXNNP14GLdU0rgy0oQjPfN1iN8t5L-aWJHrwfFVC4xsFWIibs8GOke
    AUvFdG0A5xgJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RfZAYBbksWC0wSCiYVZX-ToQ2QuJBYCRRT6KkB7znm7gTJeR0NcIag>
    <xmx:RfZAYFEtnGQMdeXGcnZV2fGY5sIdBjAIIGz98H9LWMNvYKBxHEXSfw>
    <xmx:RfZAYH30z6WAqXjvKq8jfBSkQGtmjPDZutpzF3U5ndk71D587v_Qsw>
    <xmx:R_ZAYP_Qq_UpRZLTElFttdrP0iuZwuo1pMYXa4XkBHWM-Q6RXJpW-A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4001E1080068;
        Thu,  4 Mar 2021 10:01:25 -0500 (EST)
Date:   Thu, 4 Mar 2021 16:01:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 5.4.y] MIPS: Drop 32-bit asm string functions
Message-ID: <YED2Q2Kl6Kf/BKf1@kroah.com>
References: <20210304144814.14131-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304144814.14131-1-fw@strlen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 03:48:14PM +0100, Florian Westphal wrote:
> From: Paul Burton <paul.burton@mips.com>
> 
> commit 3c0be5849259b729580c23549330973a2dd513a2 upstream.

Thanks, now queued up.

greg k-h
