Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993544556DD
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbhKRIX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:23:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49127 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235672AbhKRIXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:23:55 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C27F15C0076;
        Thu, 18 Nov 2021 03:20:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 Nov 2021 03:20:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=2BwFqhkEaqb0wwO4i3eJ2chfvHV
        2OQLt6WAJ9OSUwcM=; b=sRu3Wu+Pe/QilkPNIeqJywkZ0pgKkDxpsObRV8dGTj/
        cZyCcpFjAWgqckvCz5bumyFEhmuRee/ZuK48yvNuY0tbYoiMBJTR194vdaFrEq12
        KUs4X5+BckD4enucuQVV7NGSFP37v9WR/p3B/+ok6ZifV/kNuTY4by8dMRRDKGqH
        3eJif2aDZMH4BVer28qUuBmk3iMAjHgjto5P+flsYoo0L0A9avrFtPmM3GSyKEFd
        jm+cDyTsm+a9s5D9IM7ZmsjMSw1WOKZOXxQJR4jz1KmlpSQLGTmI7+PKDMx6vq84
        9mLCCpCC4UWKyBlraL8h1eurOlDF7/octK0VgsWnMpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2BwFqh
        kEaqb0wwO4i3eJ2chfvHV2OQLt6WAJ9OSUwcM=; b=YqIbYrvW2PnsnJp78GJYDT
        x0oQ9Ma/wPvNMgtT5L3Ok2DE83ZsLxWBJHohERKLWLrZU2l1eE7kyOG8bEWPaukr
        26IRyIokwStya8kXaAK4PDoW0nIuIIo3DLGEGch8JYXDcIRBVWD7nqDGEhTmLsaN
        6qxRAPJ1lM43LoeiEZAa5gZ2qRtmsYeBJER6sgZEiOVCzkXwgbbXC60ZyS+kkWQR
        QjKrore07F7oGAGWWtuXaHzHq8ETEmQ4YcMtykugkgidQnqG2HQWK4uQoO4xyk78
        Een/i5QkNTE4rlAFjvWl9w9K/4A7mu3hMbBj/ntq+wEL3rTWu/O/A1XPhCxxh7WA
        ==
X-ME-Sender: <xms:5wyWYdEsRCODQ_e6zCEQVW3VOrxWgYlvsQvk96TfPFJfLOtjuPvlPw>
    <xme:5wyWYSX37BqcM9FJSAKdWW_cNsSSrN-0-rkj212-lR0UnlurCRkyfjPzL-eXdhWI7
    LGBBla_M-JyoQ>
X-ME-Received: <xmr:5wyWYfLQbECc3GOBYynmmtesPKwK8576FGLsOJNAGDvaVXdRCd7hB939CTEzlNhECc9b5ghJXU4Wz9-SiMFhYZKSr31Mv4JR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeehgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:5wyWYTHPCfJsJBfSpMyS7Wrwndt0LJVd3Tie9vM32UnaRiLWK3ww9w>
    <xmx:5wyWYTUCw5l9x1sM7NKngzeevvAbztl-qi8APRd7VFQPMgD2Qv98kg>
    <xmx:5wyWYeMqxispHEMcVgkGKTuNyj7RdV_tyfi6b-WlWdT9oyr6ydx1FQ>
    <xmx:5wyWYQhB9umU4l-rNihvQMn3rH2BjPOOMl-v_Ucx2MdtS2Ro0q9GRA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Nov 2021 03:20:54 -0500 (EST)
Date:   Thu, 18 Nov 2021 09:20:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] ext4: fix lazy initialization next schedule time
 computation in more granular unit
Message-ID: <YZYM5DRi+yztvfbX@kroah.com>
References: <20211115214212.GA18940@amazon.com>
 <YZVDshkxnSxnIdfq@kroah.com>
 <20211117232036.GA14594@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117232036.GA14594@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 11:20:36PM +0000, Shaoying Xu wrote:
> Thank you! Can the patch also be added to kernel 4.19 and 4.14 please? 

Now queued up, thanks.

greg k-h
