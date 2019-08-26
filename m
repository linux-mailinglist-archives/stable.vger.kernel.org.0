Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258A79C86E
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 06:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHZEeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 00:34:06 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42773 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbfHZEeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 00:34:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 931422F0;
        Mon, 26 Aug 2019 00:34:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 00:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=i+YJVaoCdNp985rRk2d+jlhfmVC
        mqssOEbRx507HeRk=; b=BbUYK5lQnu4JfkUP6IwuSnsuY/foEIDAOrf5eUP7EjV
        Ta6Uf/44n/22C+a+iyGO8qzaO0SFtQa3gbucc2RqMoVF6y7OlXyFTYDYhyteFzTq
        CAgg4gGyQO2I4o1AIOd+sMQxH6+4yzm1xbiWO8sN4I8V6tOa73twFSnaa+44x8Bx
        ari/19eCllHHrqMwWzOuAcLwb7bRvhuJYCLrH0P2f8zK3raYLrFrb0siMx2tHSb3
        LkWpmZzO+o0fAk7xsT9GN+CU8mzVe78wNzBjIErtnR74dC+sV2TVNBO8TwLqJT4y
        J6q0kWf4nTCR9bz1VlscLuYsn5+zqYBBMIeiXQsar0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=i+YJVa
        oCdNp985rRk2d+jlhfmVCmqssOEbRx507HeRk=; b=SqCgFehCMG/PCtKLoyaFFt
        QeYclyCXN3blkj9VBeX+WB3x3Do2uY4mAn8SmfWTvSOpEP7IS08J1k1ahSN0t1qG
        E+Bv+QP47fPijCMV90uAwg4++UbEFTLVuMiTSeJqtvnkONUpaqaLdY7yKkgjNe6U
        N6HpU8SrIGZBjULSGW9fdD+PQYSWz989iTi56lPkeK2QyPPsN8sdnkIz1PVoqy2w
        lvkPixQuhUj3bh/8rvaSqv+kjldeIScT1/ny+VByaibOUbtz0fpnMeocDmG48ip6
        1PUHpwKV7/E1v0c7ejzkz8pDBwGo3coqqgNMbliK+k4wb6lZ9pfYSehs1uKeQbvw
        ==
X-ME-Sender: <xms:O2FjXc-cn7UQkSKC7-3M3MCW-wFGAkUeDx5kjNzl15IIBypX1fFYtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehfedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:O2FjXY-z0G35_x80tYhWXAhtvd8Ef1DFCH6nJB8sbXYgOQIKQsdqfg>
    <xmx:O2FjXdDarY4wmZB0sBMD1KSjIVbBj16OhqsIJoVKy96vW09uzFTeQQ>
    <xmx:O2FjXQwUXBlhp4a7gkRIc0kcNkKpaaRwL2YUT20R-cgX86E-31ceQQ>
    <xmx:PGFjXW3CWNExABMzfTvcQvuRHG8jDF1eBEHf8-dZFc8nNLktafjY3g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E2E6D60063;
        Mon, 26 Aug 2019 00:34:03 -0400 (EDT)
Date:   Mon, 26 Aug 2019 06:34:01 +0200
From:   Greg KH <greg@kroah.com>
To:     Paul Bolle <pebolle@tiscali.nl>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz,
        lwn@lwn.net
Subject: Re: Linux 5.2.10
Message-ID: <20190826043401.GC26547@kroah.com>
References: <20190825144703.6518-1-sashal@kernel.org>
 <dd3a1ec7d03888dade78db1e4c45ec1347c0815b.camel@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd3a1ec7d03888dade78db1e4c45ec1347c0815b.camel@tiscali.nl>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 25, 2019 at 07:33:36PM +0200, Paul Bolle wrote:
> Sasha,
> 
> Sasha Levin schreef op zo 25-08-2019 om 10:47 [-0400]:
> > I'm announcing the release of the 5.2.10 kernel.
> > 
> > All users of the 5.2 kernel series must upgrade.
> > 
> > The updated 5.2.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.2.y
> > and can be browsed at the normal kernel.org git web browser:
> >         https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> v5.2.10 was tagged by sashal@kernel.org but signed by 
> alexander.levin@verizon.com. Perhaps you could use one of gpg2's many options
> to add an
>     aka "Sasha Levin <sashal@kernel.org>"
> 
> line to that key. (I assume "--recv-key" then would have found your key.)

It's on that key already, have you refreshed your version of it?

thanks,

greg k-h
