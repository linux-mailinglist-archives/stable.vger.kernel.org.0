Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464542CA863
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgLAQj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:39:27 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51079 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLAQj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 11:39:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5695C5C014B;
        Tue,  1 Dec 2020 11:38:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 01 Dec 2020 11:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=n
        EY3X9T6N/e2U3MmEV4r18xwjapHZrtvQOUhEcxULZc=; b=0uxXsSFJ56BR8a5kB
        wb22Ce96UrrWe0rdRgr2YnrFbJv4SFwryfRaTWswh1BOJVsEeYBlMdOeix72Vs4A
        FhcuCXHXKiyrLA4Vc/kT9C6fWHWns9+RrYo2vj0QiqHjPemkWNn+tfm5v3VavY+m
        SwYuLpxQxQg1AgZpCAb5nsQZ5H0TrTiz6ksKIEyeTwzB6Zne6KCxUaHgL/97Rovg
        iJzS5tQLgGfXeb6aT0tVQwquhKlDop9JlF1nGGW0qe6JEUqZJA2bXzluzDsg/711
        yO94EsnIe1K0nmh/qGNd5JDSOK4z1/9VJA5yqvSROA+AGD6u2t8Kc8+7XCG70j0y
        894Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=nEY3X9T6N/e2U3MmEV4r18xwjapHZrtvQOUhEcxUL
        Zc=; b=VDmfc10zwviF0LWqro5j4VOxbEDkKkH/BhZo300dfpqzB8//kp2kopYhw
        lnCkTpDW+x0iUyxfZQqhwnrxU7X9PeXUHIkKVhUoaKdqWPI2Qa6DAyhnTrYviAJQ
        wLBfqqyP/r0zkmaesujHVTZOQifylTdeMMvunxm/Zeu6zP70FNaygtd9eHdZ56to
        g2ijw2K9Do9gqqYA5/4hmiQGwBMFnNJX+ueAiOBPD9qvHLu1YOaugxnm371w6Ocd
        DMcqrw7ydb6xlREO0VY/DVhOE6XRHhbrhpIKyT15DFHrP9LgLGAkHR4SI01M/ePU
        +A8YMLUfNy5cgiboqSHziM1M57CVg==
X-ME-Sender: <xms:kHHGX2JcOqRip6Wqx0O3UsKuANdJMCQzCc4rroEgKrHqdW6iWaT53Q>
    <xme:kHHGX-J9J8r1obvTc5CwaZCNsrgE1aPzdb6tn_XHdb2_HWqacE67CewJBbillvGCR
    oa8yumgcEOhtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeivddgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kHHGX2v9oY3QOI4H_3oSMDhtOIQ7t8cDXRDlKa2yf6x0D6_DAJiUqw>
    <xmx:kHHGX7Z0LoXnZoVpDJX1bvPmTX8OPYyFH7htq35vIkKA58XkNYnDZw>
    <xmx:kHHGX9b5rhnVuL1WminRtI25c9729oU764cXkgI6a785-farE2cvzw>
    <xmx:kXHGX8krc7_FHSUEvl6De7aI4hm-hlbuqw017RvzbEoByuijQx1N_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B2FF1080057;
        Tue,  1 Dec 2020 11:38:40 -0500 (EST)
Date:   Tue, 1 Dec 2020 17:39:53 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Sebastian Sjoholm <sebastian.sjoholm@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: fix Quectel BG96 matching
Message-ID: <X8Zx2TvfmsqQ7KNB@kroah.com>
References: <20201201100318.37843-1-bjorn@mork.no>
 <X8YYdVk7LQ+VcpPf@localhost>
 <87tut5bzd5.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tut5bzd5.fsf@miraculix.mork.no>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 11:21:42AM +0100, Bjørn Mork wrote:
> Johan Hovold <johan@kernel.org> writes:
> 
> > On Tue, Dec 01, 2020 at 11:03:18AM +0100, Bjørn Mork wrote:
> >> This is a partial revert of commit 2bb70f0a4b23 ("USB: serial:
> >> option: support dynamic Quectel USB compositions")
> >> 
> >> The Quectel BG96 is different from most other modern Quectel modems,
> >> having serial functions with 3 endpoints using ff/ff/ff and ff/fe/ff
> >> class/subclass/protocol. Including it in the change to accommodate
> >> dynamic function mapping was incorrect.
> >> 
> >> Revert to interface number matching for the BG96, assuming static
> >> layout of the RMNET function on interface 4. This restores support
> >> for the serial functions on interfaces 2 and 3.
> >> 
> >> Full lsusb output for the BG96:
> >
> >> Cc: Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
> >> Cc: linux-stable@vger.kernel.org
> >> Fixes: 2bb70f0a4b23 ("USB: serial: option: support dynamic Quectel USB compositions")
> >> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> >
> > Thanks, Bjørn. Now applied.
> 
> Thanks. But I see that I managed to type the stable address wrong.
> Sorry.  Hope you can get that fixed somehow.

No worries, people type it wrong all the time, my regex would have
caught it when it hits Linus's tree :)

