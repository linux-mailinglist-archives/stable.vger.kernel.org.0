Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0641E81A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 08:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfEOGC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 02:02:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38823 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbfEOGC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 02:02:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 80BF723D05;
        Wed, 15 May 2019 02:02:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 15 May 2019 02:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=bJQD2G08DfuRL0ihv4KiyUPmn5e
        3OKe07XFguPByLE4=; b=uJ8bSmruC8NW5wTgS9baYxUDNaCouBIkIdz2oqUq7J6
        U8lc3mCv1/uRX7tan+gKrMCmyMKnXsLUQ+O8sSaZ9PvARPQcVfmB2wYoZetirX6Q
        Z7SaWMnAegfhdCmQ4LrTT6q6p/qN3msP9YKo6emcTV2bJgEJQHxnBq+hRBEsC4mZ
        IS/TKVp8LnrXWn27/uPLlFKxxey0tvDpRIEh+XnzjgfIoOzFepT8opjEP73YJT+I
        a1aIKmzRQkqYpKpxfxanXvJ4q/LEUSQhnApc37QVRn1wBl7eRQGB7hh087HEvT2u
        rOEkQ4UkpqS/UKIC6BiZ9fajV8mrFXjJourc9mkxA+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bJQD2G
        08DfuRL0ihv4KiyUPmn5e3OKe07XFguPByLE4=; b=2yYogtHToEwMIOpZSYu/or
        KgeCA+7xyh9fXt+8/SrmIzWUkgQgwXd1m7f99f8ZRP0M50jrvo6e7elERbJhhIfZ
        MJUPtJVxVubV8GG1nIviTaOJsftaNA7bEngDTXGcKq/1TI1Rzy/UlWsS4lRIjoOp
        C5Mi2RtPHPKW/5eYrOvCEwyrznruQ5X+Kop0JFuxCKELURxdn90nG0Nh/Cy9WtNP
        71l7HfHChlBdPAm/R1onqkJBuOk4IZJqqE1kUVJmPKcNHbFabw6z1E+OYww/X8vT
        kXzRI7TK+x/UDhTcrvaBytYrDQsBpqU2hjPFBpaBR4o7antiH6q7RxOFnDzZbsxQ
        ==
X-ME-Sender: <xms:kKvbXMvM0HQfv1Yxoj3jASlT9c9E4VVKqdvzfe_9JDQT1ZyLTkg7Pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleejgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:kavbXNuJLsscIlkehOGhFEtTxfQ_aPOEYCWZVy5Xfie1KrwkbD27MQ>
    <xmx:kavbXCxhOhQYevV46dycjomZfsnBPF6SBXIEGnT8ZtDwnHGF0x6RQw>
    <xmx:kavbXDjxt9vH2Gc_Kl_TtO-VA0kWjohq176c2S774L6o5jA_y4WRQQ>
    <xmx:kavbXP6YGE6dd1wUyIDukXgxUxhydsk-jm3Xdzr9xEhtVgbqM3ClKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5FDD61037C;
        Wed, 15 May 2019 02:02:56 -0400 (EDT)
Date:   Wed, 15 May 2019 08:02:54 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190515060254.GA3512@kroah.com>
References: <20190514.125849.1258431573897075138.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514.125849.1258431573897075138.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 12:58:49PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.0 and v5.1
> -stable, respectively.
> 
> Thank you.


All now queued up, thanks!

greg k-h
