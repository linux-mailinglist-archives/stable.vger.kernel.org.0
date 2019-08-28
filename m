Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE768A0815
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 19:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfH1RFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 13:05:51 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56049 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbfH1RFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 13:05:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 682455DD;
        Wed, 28 Aug 2019 13:05:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 28 Aug 2019 13:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=St94MHN5UV1RXYwkQ8jFmrNTF9L
        FaXFtqhsHG7B3yIk=; b=QKS3F1l4/yfRlYJu7cJda2XaOFJ0Ru7f8T0ZtS7nPGK
        E3Fqymi/m6R8NxGtRmkt1bAqnt4YzgjPgJqrjW/hO9i7KPdsp8syAT01t3uMwqL2
        2OfpS+jhyTw5BcW783bZx6eVn7lvUJcn/q4o2eEcbQrpo7BfHHeSDLwsMpcf9c0P
        J8GRoPV7Znoj6F/YfsrpLYfY+f20Wyihp56yfJqJaWtUVAR5bSGVms4mdxDOUvA3
        AEJbqQQi6ta6ZGm+nHKFLipHd62Dr1SrNTRWf3LDziQ0xjGzygEX4tL0y5WdRezr
        LlljtGW0KQF1Jy9EXkXDv6Cx/ci6FrAwWXoz9EM/oOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=St94MH
        N5UV1RXYwkQ8jFmrNTF9LFaXFtqhsHG7B3yIk=; b=VOdXUCyUTDVeEUqpNC9CWA
        3saR+N6pNvM/sm27TGpq3oTIVOGYK0VULnLKII7m/xGx0pSoyyEYAVo+H5d7OTNB
        rb3jZDhS1rYjQfMU+oPlQipzOYLtMn/HDTXB6Get5y5nMEI8AX6eVkr+EBnB0rB8
        CX/Rcwts8TPVnXag/mUAJ9J+I7edOJMU+L5GsiKw9SJB8sKT1co3xKG2QywDzyOi
        dWEx/G4TB+9VRMc2ABJgVUFHqdwwEafQSumV3G+kJlZ2EcCOQewvPhexXn90GKSP
        hsU9Ctn7w/vfsqMIT86UEcXPDWuxc3cbXU8D2JdUHaERvhvPpmjEUfSHeeYz1RbA
        ==
X-ME-Sender: <xms:bLRmXQDu8hPepStpYa_6EmT5zjQm9chhz0uBhfLYC4XPDpzZjnMdbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesth
    dtredttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:bLRmXemq8QkzM7TamVi1vd3XCpXNck_mVBmIkziU57bU95-o7V7Dyw>
    <xmx:bLRmXQRqfyunFfgIZMoKIOfzbQcJRTnotElBz0TBTPzrB-6l4DO9AA>
    <xmx:bLRmXdHpWFNjWabQkyr_Tn0VpEJuWdCD-pUPesgvXNSd_ytLhHyb0Q>
    <xmx:bbRmXZ9ZxoHqI4c-7odHqZWiVDAP-2H1HoS9t7QPtIQXFFBEAlXk6g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77A10D6005F;
        Wed, 28 Aug 2019 13:05:48 -0400 (EDT)
Date:   Wed, 28 Aug 2019 19:05:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Konstantin Ryabitsev <mricon@kernel.org>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        StableKernel <stable@vger.kernel.org>,
        LinuxKernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel version no NOT reflecting on kernel.org
Message-ID: <20190828170547.GA11688@kroah.com>
References: <20190828135750.GA5841@Gentoo>
 <20190828151353.GA9673@kroah.com>
 <20190828160156.GB26001@chatter.i7.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828160156.GB26001@chatter.i7.local>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 12:01:56PM -0400, Konstantin Ryabitsev wrote:
> On Wed, Aug 28, 2019 at 05:13:53PM +0200, Greg KH wrote:
> > On Wed, Aug 28, 2019 at 07:27:53PM +0530, Bhaskar Chowdhury wrote:
> > > Am I the only one, who is not seeing it getting reflected on
> > > kernel.org???
> > > 
> > > Well, I have tried it 2 different browsers.....cleared caches several
> > > times(heck) .....3 different devices .....and importantly 3 different
> > > networks.
> > > 
> > > Wondering!
> > 
> > Adding Konstantin.
> > 
> > I think there's a way to see which cdn mirror you are hitting when you
> > ask for "www.kernel.org".  Konstantin, any hints as to see if maybe one
> > of the mirrors is out of sync?
> 
> Looks like the Singapore mirror was feeling out-of-sorts. It'll start
> feeling better shortly.

Great, thanks for looking into this!

greg k-h
