Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97152C33E9
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 14:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732428AbfJAMLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 08:11:44 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38735 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbfJAMLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 08:11:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9D00259C;
        Tue,  1 Oct 2019 08:11:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 08:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=XtuBm0192lhG7hi45n9D7uzxRhq
        rxQ1fyKMCdr40/hQ=; b=BRRmeqMSr6cJDaEVMx7gD+IPkqzCYb4ZApJcGwsmMuk
        1qA9REFmAJfxo0OEScu+iMLauy6ZxF0HApQQJ2ayyEKvJtLI6mOgKkCwBZmwwdxC
        905F2jQrdZKM9+fZ0hzwxBu8bNj1CwR4TG+HDntAtYUUXkdmhGTqX590EnnywfLt
        rM2P26zJP33YzCOj0SqwLRtSBiY7AMSS+NprM8CVQrBV+U1MP2u1sUNXRUe0qp8w
        YqnpyTdhvA1UVJlKA/xpCD2TJSiyWnBx7Wbf1mg1+vzfRQrpyP6eo0rNJw8Ux8LM
        xGvWMkRpwUil8vNcNGYG1qe41z9JngLpEINrvFOH0ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XtuBm0
        192lhG7hi45n9D7uzxRhqrxQ1fyKMCdr40/hQ=; b=m4F53Vc1YIbEFIjvQyVpOe
        V7ZyIRLT+ZC8j/zJwhxsXQZ0gdf3XuCuwH4UYN4WnX8Ba8B48S31RFHGP7OREm5o
        LAk6KLO8iHtg+bJicee3e7jCAdJj6mv1thinm99aJsxbJME/q8MDQ/P15/deo3MS
        7wMojTYzuL/v38+jZAfRLDCcHHj1+uv4p/ulsoTFWZHURBsD/fkvd8pWY//KgUIZ
        MEzCUVn9CNEDjVf4Baonh0M0XkTbg5nwY6OiINX7klomVuYGNpQppdKKNrs03gT1
        ngFbqVJykQ7Cbhf5EAvpzEffvHhIU74sVx/1/2JBLQPL8raerju2C24BcLE/3cHg
        ==
X-ME-Sender: <xms:fkKTXZTW63qWgcL4JHKFrAJ5gj7OvOku2nzAB-ruQvuAGZb8HIChrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesthdtre
    dttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:fkKTXTPITZUD_3ffvAXxwrr44Gjp7oQEYiDMaCf7Us1kT4NA323yKw>
    <xmx:fkKTXel_450NoxN4yR9nWeqmc91ZKPiD3w8cPiyhSdmZZbvUhYVkWA>
    <xmx:fkKTXdabJu4XZDZ7HGo2ENjRW9cXYN5ZGzFm8aK4HxcfY6PKGXiXtg>
    <xmx:fkKTXZpUHexZ3gh5H2bQYQjAzMzx-ZOuAqTIeww0B9TKjkxGgdhKIg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC19BD60066;
        Tue,  1 Oct 2019 08:11:41 -0400 (EDT)
Date:   Tue, 1 Oct 2019 14:11:37 +0200
From:   Greg KH <greg@kroah.com>
To:     netman3d <netman3d@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: iwlwifi regression patch for stable kernel 5.3.x
Message-ID: <20191001121137.GB2951658@kroah.com>
References: <CAEtwUJ8t6TfVXaEkEiGwUS=CQz6SQSijX8aPC+bxpTwWO7YXtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEtwUJ8t6TfVXaEkEiGwUS=CQz6SQSijX8aPC+bxpTwWO7YXtg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 12:11:00PM +0200, netman3d wrote:
> Hi,
> 
> the following patch to fix a regression in the iwlwifi modul is
> currently not in the pipeline for the stable kernel 5.3.x?
> 
> https://patchwork.kernel.org/patch/11158395/
> 
> Checked Kernel:
> 5.3.1
> 
> Card:
> 03:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
> 
> Current Firmware:
> iwlwifi-8000C-36.ucode release/core33::77d01142

Give me a chance, that patch just showed up in a released kernel a few
hours ago.  I had to wait until that happened before I can put it in a
stable kernel release.  So give me a week or so please.

thanks,

greg k-h
