Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F20D519D35D
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbgDCJRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 05:17:30 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52671 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727774AbgDCJR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 05:17:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 43B5C6CF;
        Fri,  3 Apr 2020 05:17:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 03 Apr 2020 05:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=u01C7zFZyUWlNzAl8KZgCW07i07
        te7eX/Qn9RGPmwyg=; b=eXa1ttSW7nvAI8ly93AVznWSxcZRlzZ7rFiu23xfYiI
        /JQCQ10Xk9RnXhyZJkDgafDcLxd0gdOfZCQavEM/1xWf4yLc5I4C/vDtpytbMBBo
        IfnAA8NJVqIStZzjzwcJJfDZne656Gwh2ws0JGzl5XbAVzwu/jk9+Su+sq78nURz
        JSfcfa6ErnGjkRbvKJ47Q9MNYTttO0mu8xpllDx5gwahDw0qmp8nJ698QDViTG6H
        6A7ot0aQFzNG0uZfrxqQPxil5nbviz5eiYdnHzNVGjL49ATmJJZ4BN88JoMzhq6X
        mENtz6NLFORXrfc/u4z0x/XO8BbvXeEyw2Xa6HWeuww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=u01C7z
        FZyUWlNzAl8KZgCW07i07te7eX/Qn9RGPmwyg=; b=XN7sxF0E/8Ku3VR9QgEhLu
        ar9x+d2/x/LZmw2fxqp6JEM9otOVn6xmvglGAWkPzKK3w2OvoBiwoJ1AZ3zfEC33
        T8OQyZJO4jVCkLWuJ7UlV2vIG5uB+Jz30zo05ZnKw0r2Cd3qEYlnx1IvdbNqqoVh
        Jjaz684X57n+PtoKdsBubQ24CDuDTT9t7798lSc5e43wlV0u266z1OzuqdBt+pfY
        CWI5SwKlgEYjJmzPCKAJLmzFeGz0spzm3tmcsBr3vezAONH8jRm9XifTJVNIMxX/
        mzPuVPad3rbzWDszvoYvxwoPIYSg79jz+WtQjzmzlVCqBfy2sBFvf1NSri660L6g
        ==
X-ME-Sender: <xms:KP-GXvd0Bh17DWrQJUtDcXPCzlt2vpeAmQRiCXf2eklr1jguZSiGbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KP-GXjdvcTgldv3KIqCck4Hh_aMkHwyBwytkyzdqoDVYqZuNHH0OYA>
    <xmx:KP-GXlpFew6RcFXAjmfsotxZzdpjWFBLbCRz-voEFxVYXabfpw0B8g>
    <xmx:KP-GXjyuofBJJI1LNQCApJRFTqok09jqBoVj1ogA2OX6DNN5gh7JVg>
    <xmx:KP-GXvKr2-NlmqElNqlHGo-hrSAXBquXXWedTYv3iS1gJDwk50BQmA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 546D23280063;
        Fri,  3 Apr 2020 05:17:28 -0400 (EDT)
Date:   Fri, 3 Apr 2020 11:17:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Torsten Duwe <duwe@lst.de>
Cc:     stable@vger.kernel.org
Subject: Re: drm/bridge: analogix-anx6345: Avoid duplicate -supply suffix
Message-ID: <20200403091726.GC3740897@kroah.com>
References: <20200402161557.GA15916@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402161557.GA15916@lst.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 06:15:57PM +0200, Torsten Duwe wrote:
> Sorry, I forgot the "fixes:" in commit 
> 
> 6726ca1a2d531f5a6efc1f785b15606ce837c4dc
> 
> I was hoping DRM maintainers would pick it up before it hit mainline,
> but it hasn't happened.
> 
> Please apply to 5.6.x
> 
> The driver is new in 5.6 and this fix is merged for 5.7 already.
> 
> Sorry for the inconvenience,

Now queued up,t hanks.
greg k-h
