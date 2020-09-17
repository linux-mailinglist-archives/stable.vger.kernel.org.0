Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C7626E5C1
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 21:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgIQT4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 15:56:15 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37187 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727766AbgIQOqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 10:46:15 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 10:46:14 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D53365C009F;
        Thu, 17 Sep 2020 10:35:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 17 Sep 2020 10:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=hb25I+1RjUrzjlK+Zw0h0v0Up2c
        NKGwohiAm3Y1zn/s=; b=pVOPpEXhhP2uoZYBe+EJ0JYOsuU+p927D2JmmA0anxY
        VjRyVTiL1bv0qpgkHavk7nISW/cmxzJ6tNvs+XdAvjKbQH4Uj3MdSm5e/iAUwre+
        0hFYFR7eld9j77zMdMJbp5RWgg2H5ZMfwJIdVrRQjmYYEo1EF8cfvY+bE+LXoDbg
        UX5MTU8gLeCE2sTfkCClbkcacmcT5lDa0wYXxbDe/HJOI0z3jwsVfaCRv4/5++pe
        atuM/qxCAs2K8APyyFMIdTgLGbVqjf0ONfLV0iyoj22Q8K3qK+6fdoQPJ6gYsM0J
        LmQx7POj3oK95ssCQw1EYAZAmwY9lZlx1f9umoxh7Kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hb25I+
        1RjUrzjlK+Zw0h0v0Up2cNKGwohiAm3Y1zn/s=; b=hp9h2EIxPblo2bSZuXqbjI
        ykbS2X0lxI/X2sBiMluqMRzJtOx+FQGDSpdrpKYzh0wWWAOerVGExQ7AQSMZQilI
        Zhz5X9JR1xbZLOKVYiU153eWpysM/Im/vZqeJq1b5IfJLSfLy2H5Ra7jtYhMC55L
        VNzMUvr8fwCYXuZa1z3KCR4tvjeHxcGDTfWd5axKEiNkFZ/dIq4i9MclETPhE/jx
        gBaUmJ4F4lHmGwAZ/iRAI0x57uigCmN/ApBxpUh6BV0NsaJvBDKnf+hQaMYAlnSr
        +gAMwzYtlKOSI8VVbagM1pQa1OQY98hc9EpoBHXhq6YP5d45EXLM+vf3VNbquvZA
        ==
X-ME-Sender: <xms:R3RjX8MB7gVS2xDoBknyz7VK5JoaHDFvALcxroXLcL9J9z_zm4g9Gg>
    <xme:R3RjXy8Opl1qRPbOXWR4E852mjPz09bHueSi0zj2xrwhJ2HJuYsJ30GsNCn3FDTWs
    SzcExE4yy_HVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdeggdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepieeluefhtd
    ehiefgheegheegleehvdfgffeljeevveeuieekffdukeffkeffueefnecuffhomhgrihhn
    pehoshhuohhslhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:R3RjXzScJt2Hq1ClqJbk1CSLuFE3fvTqioF4--Dy06r-FuZKboZOHQ>
    <xmx:R3RjX0ummjbqFkAy12xpVYj1kkX6k5lnl3wpzYh4c3V-QZek2PXfSg>
    <xmx:R3RjX0f0p8RHLxukP4dS9GG16_SgnEqWS6c2bauI0M3XWJNFIY2CKg>
    <xmx:R3RjX1qjbM43RC0w0aWdrWSNMA0BjxLnNWXsLqVzn5ox0LYKTUTI4g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F25C03064688;
        Thu, 17 Sep 2020 10:35:50 -0400 (EDT)
Date:   Thu, 17 Sep 2020 16:36:19 +0200
From:   Greg KH <greg@kroah.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: e1000e: Add support for Comet Lake
Message-ID: <20200917143619.GH3941575@kroah.com>
References: <d1bd83b89a9f0b4354a56a83053adcc779fe1223.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1bd83b89a9f0b4354a56a83053adcc779fe1223.camel@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 05:30:40PM +0000, Nguyen, Anthony L wrote:
> Please consider applying commit 914ee9c436cb ("e1000e: Add support for
> Comet Lake"), which adds device id support, to 5.4.y as this additional
> support can be useful to users [1].
> 
> [1] 
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20200914/021359.html

Now queued up, thanks.

greg k-h
