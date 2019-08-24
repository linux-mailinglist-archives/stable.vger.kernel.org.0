Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAB29BAE9
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 04:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfHXCic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 22:38:32 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48705 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfHXCic (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 22:38:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id E857246C5;
        Fri, 23 Aug 2019 22:38:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 23 Aug 2019 22:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=uwo5KC6cm7RwrFdHorEZcbCanbJ
        1Veh3/B8otgcZu4s=; b=ou5uENMjrJS43V17e1R/ele998tAPPEx8KBaa5M7Zec
        8qdkE4/iak5DuLaMKsMfnrsYCeQ0hX5IpUfxoIEfQLMclQdS9wIITEFoHx6mNeBd
        q49dbb2vUjigJnih4zedCL+k2MP/p7GyBbiC2DbUnhwtqGp1NzfRj4TmFIjmI5ya
        9Giga/ZmE+PMKRKNialDqXCr5KWcitg23x2ZVPQ2nEQW+n+OFazyPnwp69vi1pCS
        D2/h4A98vaYmJTtOXo/xWUD/7iqfDGcROuQBh8HQ4DJpNcvH0qOSJdPnp2QUPb9p
        0/jLcBf7EddhQlEQgdLJDobhj6YiMYzc8UqqL9wU0/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uwo5KC
        6cm7RwrFdHorEZcbCanbJ1Veh3/B8otgcZu4s=; b=L9at2VRZ2lTHgtJBXoBpEQ
        qNchxgB05BMyBBWxZNEjHdEytMqASE0G5m9G02liIYPMF1KuBxJJbP6hJa41nb8u
        6l3Mzz73wEoAluriPH0CgSley0HlsP94KxBlduZ3snRybEv3/PxIdUtx+mBTQJ8u
        Bl5+vRKN9DganC5x/ZMeYLkC5niEhchkqBZOhzF7Te5aRSZrPKEpkI4biMfvO6Jd
        dXt22MCnZ3Dm96Q2FPWEkbRl3uBi1J8OdGkPVXPN/IykIIgrLyMgfCkLWlxKw4b2
        QM7gBTaIVZ/9Ga8E8fDRQAD1bYT1FLyIJvvdXdBM/OUbeY7po3lJPii9tJw9REww
        ==
X-ME-Sender: <xms:JqNgXXTUVoXBa7H3AVc31lQROQtD8bdd19WjqvFb4zf7yKhL3HGDpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegledgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhprghmkfhpqdhouhhtucdlhedttddmnecujfgurhepfffhvffukfhfgggtuggjfges
    thdtredttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtg
    homheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepieehrdduudegrdel
    tddrudelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
    enucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:JqNgXSHfJi19z9xm4CA2g33LKwwVQqPS6Uc6_VVaNc_vkdkJafIvUg>
    <xmx:JqNgXU0QQsBuC9IO3378tUI3LCJNPqTXuH1OobM7xcMoOy_ryqqgWg>
    <xmx:JqNgXQt-0UeDrg0cNPurNCeo-l54NIHkblURt9HJKbgZcm8EIicMVw>
    <xmx:JqNgXfWsv-rPNVxhXg7ih0HA4CxN_M5L9JReA5X5Em8lhBMUAK5HnA>
Received: from localhost (65-114-90-19.dia.static.qwest.net [65.114.90.19])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8B918005B;
        Fri, 23 Aug 2019 22:38:29 -0400 (EDT)
Date:   Fri, 23 Aug 2019 19:38:29 -0700
From:   Greg KH <greg@kroah.com>
To:     shuah <shuah@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190824023829.GE9862@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
 <00216731-a088-7d47-eafb-70409f876bda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00216731-a088-7d47-eafb-70409f876bda@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 12:41:03PM -0600, shuah wrote:
> On 8/22/19 11:05 AM, Sasha Levin wrote:
> > 
> > This is the start of the stable review cycle for the 5.2.10 release.
> > There are 135 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
> 
> I am seeing "Sorry I can't find your kernels". Is this posted?

Ah, Sasha didn't generate the patch but it was still listed here, oops.
He copied my format and we didn't notice this, sorry about that.

As the thread shows, we didn't generate this file this time to see what
would happen.  If your test process requires it, we can generate it as I
don't want to break it.

thanks,

greg k-h
