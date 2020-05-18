Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7403A1D7D92
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgERP5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 11:57:06 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54321 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgERP5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 11:57:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1200D5C0138;
        Mon, 18 May 2020 11:57:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 11:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=v
        m0x5tLetfUdDVd4EKUgDBTp+RkCn/SvycrCaVd2+VM=; b=pcCA1vs4t/Ua20k4r
        VM/aW44H+WMTekYBhzRnFqAstdHb9x5/rV0qt6ekx9wky9hGQYn+I+U8/NeZFlq9
        qmvVsaNHbRij2iGM9TfreFsqI/6kK90gxa5rww8cORy3GiAgJNQ/XVc8Dgk4NZQT
        HMiRRqqhHo64uEZH+4zVu0/LsbBkB75LZhELfdBKxcL/0o7h2BObVFN5fe7YJKCB
        rXf1ETOypTjPUsADH8dz8DIDyQKgF94jNlp7nWMcFEASYGonPZCxLXrlPbxmjFC5
        hTlBPnkLVf+7jXZVouthzE90c65zgFY7aLnpLKL88ba/u9NZhlACNHWM0yAmECsK
        nXePg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=vm0x5tLetfUdDVd4EKUgDBTp+RkCn/SvycrCaVd2+
        VM=; b=ongzkHr7ClK6IMC8SnYsKRxBdPNKGBTwcvOnxOJU6DJ4MoYQh0A7uyYfh
        3BJicqZE7xfPEM6q9wp8OO1mO6U7fpgpKZizD49sbcUN8eDuzlKVjmPYu2zhqhVp
        QooS0BKjyBD38/sPBGoPr6mKmFzMow7Of0xM8Jeae8heMoEdIpX7mFfWyvRzZUxh
        48YXKoUY3ZIliSIJ/OYS2E80UUR6kmZW3qWYlQX9sUGpvgjradL6D45WOmBg4TFO
        j0ugb30gBnBwYUWXT+XExKmsDXz4Pjbb1Qf/xAB2AInGp3lCsk9ksD6ibwWP/Adh
        MbZ14TNnykezIi8x2bKl4lhck0Rrw==
X-ME-Sender: <xms:ULDCXoksoiNW1nnZtKowcfpKK9fyoWS2DH3t43yQRK7Uu6fAPtrmMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuue
    dvhfetveefgfefgfejffeutedvteduhfffkeejvdeuffehgeejvefgleevnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ULDCXn0oUgSok6NrzItpOlrTGKUEyWwn885ksPzgoSSeuAk34Rypcw>
    <xmx:ULDCXmrj91cvtLczoLXrwBafDBJkNMfMEHaJtVGHKYMWrgUjLAOUpw>
    <xmx:ULDCXkl8eAEHnsXmFBnOT0jdo5isYRhpcMLgtoDPbLD-rvXYG5vRrw>
    <xmx:UbDCXvgNkoLsiUtHr7nj8-X23yDa8bf7yRI98hu4raO91ZrKrZSWjA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7335B30663FC;
        Mon, 18 May 2020 11:57:04 -0400 (EDT)
Date:   Mon, 18 May 2020 17:57:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.6.13-d8e36b7.cki?(stable-queue)
Message-ID: <20200518155702.GA2030093@kroah.com>
References: <cki.F4DFA21C5D.24XICWV69E@redhat.com>
 <1063175897.23455623.1589816519233.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1063175897.23455623.1589816519233.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 11:41:59AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Monday, May 18, 2020 5:39:09 PM
> > Subject: ❌ FAIL: Test report for kernel 5.6.13-d8e36b7.cki	(stable-queue)
> > 
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: d8e36b7ce54e - Makefile: disallow data races on gcc-10 as
> >             well
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/05/18/570957
> > 
> 
> Hi,
> 
> I believe this is introduced by the following patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.6&id=de3f4548c1083d5ccb2afe1946fa8dd396001eeb

Yes, just caught and fixed on my end, sorry abou tthat.  5.14 and 4.19
also are failing to build, will fix that up in a bit...

greg k-h
