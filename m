Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633872C3F4D
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 12:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgKYLsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 06:48:43 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47201 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgKYLsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 06:48:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 9775EC8F;
        Wed, 25 Nov 2020 06:48:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 25 Nov 2020 06:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eDDmbS7x/P+kfvFMPpO+nwfcN+O
        q7iMUJdzmcknX/RY=; b=lPhdItbFMltSgeQ7VsdzUCA4hhjOIZlos8ZmYJJgor0
        7Ts/oqQarHGginK5r00GwMuvb9E86lhHzg7upqP/fxWNCi4m6TOgDxJvOAuFD2rt
        YUTKmdUAvehdvlLmX6qg9/FnG8dNxbSA2bO6zvf1iBpjmUu0ubps+eCzJ9eHxm6y
        B9RvZN/Jis1ypcZ3pKNufyHHqN4Li9jh9Q55xeZ6jkvPLSuvG1VTemp3rbLqFtqu
        WJ+arp2CfmeABU/3oTC6F2R0ZZayEkxyItA2WwLFCory8eYchxt38Pp8/e3x6i8y
        KDKQoFcWf96XV2vTXBkgyZ2prmvf6Z2jHhlv4Wm7OYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eDDmbS
        7x/P+kfvFMPpO+nwfcN+Oq7iMUJdzmcknX/RY=; b=jta7XShbC5k613LaKcVD7i
        CEsZnYhRh/jZc8PiZwwO6vwoHyfiYpbx0NpN4SwNZY32qR12MT3tsIGfR7S5p+Y8
        wnKlLUk3blPSurGnK+DwUWto3S43TGtZwT0r0vmycrBXJLTROWc94Q5mjyc3ODrp
        6GRE4mcjq9VC85WStLSYXoNuu7Ec9A+Z8nNxL73pDr2GoQa6ox3D8XwMe0/RwLRn
        GCC2+TMTLC0a5UEHpq8nXTiSBFQpkXhoQjtmm4SXC6dfjMtEqwICBHaMh7IlDQnS
        +tEsoRzi9zNSqmV/pMCDU1gmYqOAuZuA4JOxN/RYmbghj5LAhcU2MTMG9O1xt63w
        ==
X-ME-Sender: <xms:mUS-X5POyzJpxv6E8SjDGKbjd7v6PayqGvrlGjav3zNnv3gedrgWQw>
    <xme:mUS-X78i2e0zAWbXIgtdKTRU0KfRWLqfIaaBCJD0h2JFXToPyf0wSdXjg-gvRn5ZX
    3grd10Sgnwyrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkedv
    rddvudejrddvtddrudekheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mUS-X4S9H_xgZt3pNWZNSUZ44blSZLP16u-PFqrWOIqGOkfTBQnqQg>
    <xmx:mUS-X1u1W1BPv-ryI-HlJcJ5af3QCylk-_L1pmzENCvXF-kCGnhEjA>
    <xmx:mUS-Xxe-I_LKf_oGBwmUC_pvjGTeYuiBlCilGnUA-NvF-K-ClHjgYw>
    <xmx:mkS-X3pO8ZtmOVz5O1xqPyXJ2kWdQAcewJIduh-UrntMI3Qq174twA>
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93A8A3064AA6;
        Wed, 25 Nov 2020 06:48:41 -0500 (EST)
Date:   Wed, 25 Nov 2020 12:48:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     stable@vger.kernel.org
Subject: Re: perf: Apply e9a6882f267a to v4.9 stable (fix for null-pointer
 dereference)
Message-ID: <X75El25Mf0FJcjLR@kroah.com>
References: <4431770.U1WXKbcAmY@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4431770.U1WXKbcAmY@ada>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 11:01:39AM +0100, Alexander Dahl wrote:
> Hei hei,
> 
> please apply e9a6882f267a8105461066e3ea6b4b6b9be1b807 ("perf event: Check 
> ref_reloc_sym before using it") to the v4.9 stable tree and maybe to later LTS 
> trees (v4.14, v4.19) as well. 
> 
> That change is in mainline since v5.4-rc1 and it's a fix for a possible null 
> pointer dereference in the tool 'perf', so it is a fix for a user space tool 
> coming with the kernel tree actually.
> 
> I am directly affeted by this, calling 'perf record' on an at91 based device 
> (armv5te, sam9g20 soc) running PREEMPT RT kernel 4.9.220-rt143 results in a 
> segfault here.  I debugged this with gdb and tracked it down to the exact 
> pointer being NULL, which is checked now in that above mentioned changeset.
> 
> I could cleanly apply that changeset to my local tree and the segfault is not 
> triggered anymore, I can use perf on that platform now.
> 
> I only tested this on the above mentioned v4.9 based kernel version.

Now queued up, thanks.

greg k-h
