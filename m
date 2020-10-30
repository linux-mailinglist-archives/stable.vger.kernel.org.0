Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551362A0335
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 11:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgJ3Krs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 06:47:48 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43275 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgJ3Krp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 06:47:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 68699DC4;
        Fri, 30 Oct 2020 06:47:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 30 Oct 2020 06:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=d
        reWqn1C6oyy9WYNPasIYL1TsiHmeKDgek8Y92LJVqY=; b=AjT9HbPP7yQ9dcAc3
        6oVXokGG8zlE9AuegBPbJN5bYkv1Mwqu8Ca3eUFa14JEhfUZWP72aU5AFyQbkJVI
        bzOBwAF8yLpQAaYKCGFMArmVwCzUl9bXibG0IPDptjMexJHEgeSXJvk7klglir6X
        9YplL5Ik367W1jYIkozmY/BDkxaW+DdS+U7/4x2OgneDigqXjsw2oCKCQj1EHmUn
        4UMmzTNLjQB5WMv1iDGksFFCbSbz+N6xVnSaavpc/VnLMii1oG9efPk9+cemP0US
        yz/YsnnAYnupWTjCLO1L+Ed3n2fWUqLPxhPfEx8kzId9oZf1ng2CgaoNNYouRi9m
        V7heA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=dreWqn1C6oyy9WYNPasIYL1TsiHmeKDgek8Y92LJV
        qY=; b=jLrtJWMLHo9eLqazfiYacp6g7jIiq/PT94+5XaQhIfEZxtO4rhe0M5YMH
        E9mSHutVlQ5pab0D6PBBa3StWpmDYrMJk8Ad7GcCFjTR3epyum6BR8J5OAxfsUtT
        guIVdC84v1XjMxlWXLg5rmoyIKx5C0Ml6WMAyYL2e28kvH5QOUNhS7R1zS1j5m1z
        5DM3NcEpGJHPmruLItw2xOWjExYgNq4uLtTOAzuss18ax+kumkOCAewU5H88PGWN
        CLvk8qAUwCEsM4HDx2+UwFmm+NzqjdQHz+S3g1lMOWuFTXXNQvdgWZ944ZbRYPwI
        GqO3qDPZM3sJPlRHNXJNpwkAty/iA==
X-ME-Sender: <xms:T--bX9ceQcv29UpxDLOKNDzCeMHdK1Fr-1-JbAvf5T_JIiM7fEd8rg>
    <xme:T--bX7NnmTQJ08Mgquog7LKFkkiS-f71cLS8ZF_W7SwPnYXZr5FxsjBxxiatpW-Uu
    AIIroiXTXucTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleehgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeefveduge
    fgieeltefftddvieeuleelgeefjefhfeettdfhgeetfedutefgiefftdenucffohhmrghi
    nhepfihikhhiphgvughirgdrohhrghdpuggrrhhinhhgfhhirhgvsggrlhhlrdhnvghtpd
    hkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:T--bX2hR4AKiSu6JxmUfWYDwpYnH6p03t1f5_zIuZVosJS92HMwObA>
    <xmx:T--bX2-FaUNhySKAA9adqJrxNHSfS2CjT444uL_xMFgxrP9ktxx7Bg>
    <xmx:T--bX5tOZwIerdIZg1DJBhiupD0CgSg47BOvC1cb9pckW9KJPfn9Rw>
    <xmx:UO-bX3UrfBUZKadGh-meMuyUmtc7iNWLuLq4Hh69_Ykv5fdDOAhwFw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6875A328005D;
        Fri, 30 Oct 2020 06:47:43 -0400 (EDT)
Date:   Fri, 30 Oct 2020 11:48:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Chris Ye <linzhao.ye@gmail.com>
Cc:     Chris Ye <lzye@google.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
Message-ID: <20201030104831.GD2395528@kroah.com>
References: <20201028235113.660272-1-lzye@google.com>
 <20201029054147.GB3039992@kroah.com>
 <CAFFudd+7DrJ+vYZ5wQ58mei6VMkMPGCpS1d7DwZMrzM-FVKzqQ@mail.gmail.com>
 <20201029191413.GB986195@kroah.com>
 <8975d128-e47f-c97c-fbd9-6045de67f34a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8975d128-e47f-c97c-fbd9-6045de67f34a@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Oct 29, 2020 at 01:04:06PM -0700, Chris Ye wrote:
> Hi Greg,
> 
> Yes, I can see them on https://lore.kernel.org/linux-input/ now.
> 
> But I didn't put [PATCH v1] in subject,  should I sent them again with
> version?

It should be v2 at the least, right?  And please read the documentation
for how to do that properly.

thanks,

greg k-h
