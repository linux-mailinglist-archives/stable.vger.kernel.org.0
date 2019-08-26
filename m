Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3919C8F5
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 08:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfHZGKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 02:10:25 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:32927 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729303AbfHZGKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 02:10:25 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8EFF7305;
        Mon, 26 Aug 2019 02:10:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 02:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=tzTY97xHrbLWJGenhOBbYuRd29p
        dIE9dwtl03jKpHYQ=; b=Wd88EIBdXEWiIqbHbDz0mZJ2C6rh7kLDWfMWrvRqq/7
        dNrmBRhfEN+bSUNcuAiQ9C89OKDSh2y7IexZndv8hAXiV/J07MuVefVLskPWM9BF
        YQ323BYJmO1CDd5/HASTGU6SnYY4/9J3HfUCaJTXdwuLOBVkXv4JPz9r3xI+Nppu
        caq0cBZ5dlC56+ItcFMUV3hQyxkRZA1KpdLWlzpfTDiv3lz+yaJAjo8WMuGbn1y9
        bmNiyMUOJUaJqU1vOqObSqKSG37vePXEGcOYSYvYmhhunZbOxZ5SdNvBw2rTNhT1
        0EBFDvKEEPF2iMS2SiD/+kZVszDpj+rnMsOyTnEo9QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tzTY97
        xHrbLWJGenhOBbYuRd29pdIE9dwtl03jKpHYQ=; b=OlnlOwIse0pIFJUX85+8nm
        yusOHRTG8prjJAivkdvxIZJg+FmpZ2sE07MNUW830ShElC5Js+ScEiC1UunVcYhm
        UoixP9PDfvFiQiwQuwcs8gpX8yO1Y0yxl6LUqBC+qHho8WUHsmflvv4i+IElX0sA
        UKDiSFJHV080EMXr9Eo1loNZNKU67P2cYtH4bSa2ZfAhYoj7PsoE1gzRdQXMgb8V
        GOshGCagy9dEIxllD+mM4+yUaDSithmjQW390nEZR737q/ULMXG0xvtKrN4D5e2d
        5LtPH+HF6/H63Gam393JzuGHXh+NCTTMwVZor/sJuZp3mmZgRtlH4KHF/WBr/1kg
        ==
X-ME-Sender: <xms:zndjXd-yIVwVWtJG9ferpXwSG2EoLDZZ2Lx3heMRQAhCabR7MR3bhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehfedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepuggrrhhinh
    hgfhhirhgvsggrlhhlrdhnvghtpdhkvghrnhgvlhdrohhrghdpfihikhhiphgvughirgdr
    ohhrghdpkhgvrhhnvgdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:zndjXS8IQn5soYMZyOdsC5PF2eQZ48IYQA1UXckWrbD2PInvdNXmNQ>
    <xmx:zndjXcxalQmw-GW414XMNga42bnFBfg4thKySJrcRXsT3upMae2kkw>
    <xmx:zndjXa5JuDCC4OPIbYW6-7KDkzzEIqJCln8MSEc1_Jw3PpAUpBMe6Q>
    <xmx:z3djXbxw3F_yj9Vp0LTK-OLfPl82b9-J4aEAxXN-bGHVC2-G3q9Z7w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0592D8005B;
        Mon, 26 Aug 2019 02:10:21 -0400 (EDT)
Date:   Mon, 26 Aug 2019 08:10:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     Paul Bolle <pebolle@tiscali.nl>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: Linux 5.2.10
Message-ID: <20190826061019.GB3688@kroah.com>
References: <20190825144703.6518-1-sashal@kernel.org>
 <dd3a1ec7d03888dade78db1e4c45ec1347c0815b.camel@tiscali.nl>
 <20190826043401.GC26547@kroah.com>
 <20190826054156.GB31983@Gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826054156.GB31983@Gentoo>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
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

On Mon, Aug 26, 2019 at 11:11:58AM +0530, Bhaskar Chowdhury wrote:
> Not sure,kerne.org not reflecting the latest number...probably timing
> difference ....looping Kai in this mail ..

I do not know what you are referring to here.

The front page of kernel.org shows 5.2.10 to me.  I will work today on
adding Sasha and Ben's gpg signatures to the
https://www.kernel.org/category/signatures.html page so that people can
verify them.

thanks,

greg k-h
