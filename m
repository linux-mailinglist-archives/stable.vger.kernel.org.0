Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14EFD1049
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbfJINhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 09:37:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45757 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731183AbfJINhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 09:37:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5713A220A3;
        Wed,  9 Oct 2019 09:36:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 09 Oct 2019 09:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=gnm5/K6BRLhl7sZoyC43VeoPAfO
        sZBL7QWezS01zOds=; b=Gm27DKQONrTQtBnT66x0EunKtcGf+tYiYGfKpR6tkL5
        AvrIvxDUboP+C9ik4QPOCkT7iN2jQZk20uX/ulRKMykmAbqTM5i9hUzI0Z5Z2iVZ
        tuIVeKv3qy6Q0axtWo43kbHTOXuq4WtDqasS91mEVWaVfyJ/untTaHZ4xsfy+zlj
        veccRMjbJ34xtI/vkWy/biy1ZM92TjEprEhDmHUjhFqfI1iZI1Oc0haRfwNeqidE
        Bgu7P52ysUqIL09xb/32UHsyXHk34kWvaR15tAo0wenGezYYG/m+yw06wAx6Uugn
        qXxyscLjKN7BizIEhzFAarz0+aZsMhVZAsqT1SZr/Eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gnm5/K
        6BRLhl7sZoyC43VeoPAfOsZBL7QWezS01zOds=; b=cOsv+pemqGCDJRZs/5uZcj
        9eE8Zq4rJeSOPjnNB4AlvCwqQnTwkOYot+oJ42bJGuvufsuCkoRLm9V9NVu2S0mG
        HeFAM1mP+jlN9H5/JvCrYHFHYl3ag3vW5LfujHQI/GxEG9NyiEAjt6INSuN4VDZI
        2uwOstIyNo2jFXYEun8u4tDyreFhtgvv6IS5oCN648BohIm7TYZBBLCxmp/9twe7
        eVpIg2m+6YNpDgtrYjRi4xk7vUbc3M7P7qAsdS1+M5sPXWBENjJon+Sxm+w+xCTE
        ioOPELn8/Ut333v7rvyf0QMWZOEiWMhgd8zNZ4Mua8HJe+ZOthf+JqCXcUgs7JuA
        ==
X-ME-Sender: <xms:euKdXSX5tqWfegw0GURgQNV6xG8vY4EJplFT8NeAxtO_v9HaNaEG4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedugdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:euKdXdpNREWBgaWAu0Wj3wRB84-E7mIMi-JUfdRY4kBwJ69_2Vp8Rw>
    <xmx:euKdXcm_i0BfW2QyWvBj5Lj8oshbzX3r0GWaLwiDjYht-gAnyGsv8A>
    <xmx:euKdXV1cBJqZ2bISU28Pf9CYqTs3nA-0cflnithf_J1v_J3EBeLChQ>
    <xmx:e-KdXT6DlCgnHuBQTqsfLvowvDy6iHGMOg9n-ODet_VmTpxmCVinlQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB255D6005B;
        Wed,  9 Oct 2019 09:36:58 -0400 (EDT)
Date:   Wed, 9 Oct 2019 15:36:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4, 4.9, 4.14, 4.19] nl80211: validate beacon head
Message-ID: <20191009133656.GA58233@kroah.com>
References: <1570603265-@changeid>
 <20191009094310.GA3945119@kroah.com>
 <fd0c407c9507ba22741af5a9360ddba79971af29.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd0c407c9507ba22741af5a9360ddba79971af29.camel@sipsolutions.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 11:44:03AM +0200, Johannes Berg wrote:
> On Wed, 2019-10-09 at 11:43 +0200, Greg KH wrote:
> > 
> > > +	for_each_element(elem, data, len) {
> > > +		/* nothing */
> > > +	}
> > 
> > for_each_element() is not in 4.4, 4.9, 4.14, or 4.19, so this breaks the
> > build :(
> 
> Oh, right. I had previously also said:
> 
> You also need to cherry-pick
> 0f3b07f027f8 ("cfg80211: add and use strongly typed element iteration macros")
> 7388afe09143 ("cfg80211: Use const more consistently in for_each_element macros")
> 
> as dependencies - the latter doesn't apply cleanly as it has a change
> that doesn't apply, but that part of the change isn't necessary.

Ok, that worked, thanks.  Well, almost worked, I had to do a bit more
effort for 4.4.y, but all looks good now.

thanks,

greg k-h
