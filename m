Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DCC3E3DD8
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 03:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhHIB7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 21:59:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56127 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231459AbhHIB7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 21:59:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 52D6C5C010D;
        Sun,  8 Aug 2021 21:59:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 08 Aug 2021 21:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OylQU9
        vb93bEc/qD54BoqNyoSqL9L9zi1LBegBb5SC4=; b=onQH3F3G6O/fyvoN8JBbFb
        /TH/8f1xTMnAqHKCVzKrizgo6kEiiyqj+UERZrq6DHux4E9AQE7S3mO2pt4LbnzX
        WsnB5nB9Xg9OO2qt/cEVEKocfPj+HgkbvNLqiAPcag+i6ElL+jkNJs1jn0bCdb5S
        vaeApFnXm4idihpqc6oC863We3yN9zg6cpHfclHfMrS2FdsOruOHl3Yw35t/6GFH
        jfdUPzWe7h4VCFKx6IV6HEYCwLb0G5FT2PrTZnnGOn4cgn1mZN9I/x7+uMeMx7tk
        9LhEC9EglC4e0LtsWj293vO09bUoD3dCcx/Ll8psGstVJjVve25bok1cw/n7rUWw
        ==
X-ME-Sender: <xms:-YsQYaif_8F4BPrLVNrPMvuabgYV_YHdn_KKAWiw9tqmkm9ZaC5NhQ>
    <xme:-YsQYbAGHmpIXDDrFF2c1Tp8RZEfgDcGG9vSl7180__u3yPkFnETC96FxS-TVUGgk
    zhnzMXMzcs6ihRddcE>
X-ME-Received: <xmr:-YsQYSFRa-pRjhNsNVgDuEQkbFex26fJgcUsiIeUN30aJblHGi4eWF4S4YxYHgWb8rBsyY8uoYVH61o5QZ9zpxLrYktcVf0ULoU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeeigdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeekgeejkeffhfefgeelieffueethfeludduhfdtteduvddthedtteeftdevfefh
    jeenucffohhmrghinhepudegqdhrtgdurdhishenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdho
    rhhg
X-ME-Proxy: <xmx:-YsQYTSd5OdThR58l1aB7eTiLWQnIEg20VATmXtwvjY3zsHtZTMTXw>
    <xmx:-YsQYXxrx2F3DoTAcXerqBN-k_XGiB7hcOTmyMxCBavUW31MOvjuNA>
    <xmx:-YsQYR7IsOtutOVOXAvnYFCqWD7BEXQ29aco0FB878OiGwBmrZKIbA>
    <xmx:-osQYS_sLcD5hF6GQo4MgWbjVdgJIf8LNarRFDq9UB6wGUcuWA-SDw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Aug 2021 21:59:19 -0400 (EDT)
Date:   Mon, 9 Aug 2021 11:59:11 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Mikael Pettersson <mikpelinux@gmail.com>
cc:     Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k@lists.linux-m68k.org, stable@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on
 m68k/aranym
In-Reply-To: <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
Message-ID: <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org>
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com> <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org> <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 8 Aug 2021, Mikael Pettersson wrote:

> On Sun, Aug 8, 2021 at 1:20 AM Finn Thain <fthain@linux-m68k.org> wrote:
> >
> > On Sat, 7 Aug 2021, Mikael Pettersson wrote:
> >
> > > I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> > > 5.10.47 to 5.10.56, and the new kernel failed to boot:
> > >
> > > ARAnyM 1.1.0
> > > Using config file: 'aranym1.headless.config'
> > > Could not open joystick 0
> > > ARAnyM RTC Timer: /dev/rtc: Permission denied
> > > ARAnyM LILO: Error loading ramdisk 'root.bin'
> > > Blitter tried to read byte from register ff8a00 at 0077ee
> > >
> > > At this point it kept running, but produced no output to the console,
> > > and would never get to the point of starting user-space. Attaching gdb
> > > to aranym showed nothing interesting, i.e. it seemed to be executing
> > > normally.
> > >
> > > A git bisect identified the following commit between 5.10.52 and
> > > 5.10.53 as the culprit:
> > > # first bad commit: [9e1cf2d1ed37c934c9935f2c0b2f8b15d9355654]
> > > mm/userfaultfd: fix uffd-wp special cases for fork()
> > >
> >
> > That commit appeared in mainline between v5.13 and v5.14-rc1. Is mainline
> > also affected? e.g. v5.14-rc4.
> 
> 5.14-rc4 boots fine. I suspect the commit has some dependency that
> hasn't been backported to 5.10 stable.
> 

On mainline, 9e1cf2d1ed3 is known as commit 8f34f1eac382 ("mm/userfaultfd: 
fix uffd-wp special cases for fork()").

There are differences between the two commits that may be relevant. I 
don't know.

If you checkout 8f34f1eac382 and if that works, it would indicate either 
missing dependencies in -stable, or those differences are important.

OTOH, if 8f34f1eac382 fails in the same way as linux-5.10.y, it would 
indicate that -stable is missing a fix that's present in v5.14-rc4.
