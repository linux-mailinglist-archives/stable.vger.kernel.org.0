Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EADEB79EC
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388618AbfISM5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:57:30 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48801 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727980AbfISM5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 08:57:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DA5517DA;
        Thu, 19 Sep 2019 08:57:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Sep 2019 08:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=aowFOdl/EIeeZ3NERaVX5NgpdBb
        Ykhs8Nff7kjX3pi8=; b=n8W0ZTxy5ATryeRQGltugwlLK3EIT3iJ63wQP1fhnLY
        qFeCWatSDogfugg+iBIqeCMn7FuyDM0YC9DJOaB0TRQ8RvHWj8kpiHTFu4/9PyAe
        n4axv/QPamoChUVCubbjr8+PnyBHNuWIAqNnveT99i3d52Gg9hIB1NtwgltQLGGN
        f4FgFpEasoWdPrFz+doji6QfPKAYcvef/n6uBtVXPk+yiU48sbBQmdiin+gotKLs
        hbi2NZQCcuAKIDfSRSMkgaTYgASBISlYxuy4oTwolgj3yLWQbKb48d/XVZU8DqV4
        bWRZRl7KsxKbt5m6fC6wILOfpGOrcJt+wXqiGMFQ9/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aowFOd
        l/EIeeZ3NERaVX5NgpdBbYkhs8Nff7kjX3pi8=; b=mG0XmvkKBy+ptMyw6cu32P
        3OrGBWwQVJA+L95CqGk+Sf8tXd/tFDMpYJDCb1eHbfP66BSMXPQ6R5Pr5rl1ql+M
        2hqDIJU37jhL1NizY/d/Im2tOISiuHrSyIuD3m9FCyIcDcq42g6E9F3wymyImBJt
        1B+C+viE1DldI9N7flCsArdglSD5fpnw5uhrr7lbSp9hwv4zmEPAimk6xXYxadgQ
        sKHIgVsln+AB69js0L7cpGftxbfOMGKbDQ8oYzXkP6yXfPemlYPA/rFU+Vv33ogr
        K4BYEmShnkiuRbsKDPiDajUAtk0HR+GZKaNN4b21uPchuoEtKF71DR7acWVDTIOw
        ==
X-ME-Sender: <xms:LnuDXQGT8A8tgtcw9ugp8eR7hIYe2QRDaFSePHuyKS6vov8QxMPzTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LnuDXeRzr5gJZLkyt6_aW2EYhwfB0oGv7JcZ6QsXSdcbDPDNzQqfTQ>
    <xmx:LnuDXU5z_Dfr_3JIJw234Bc9RP6lXt8urAjtAn7spSdDWADEgAjNRA>
    <xmx:LnuDXczxQkDfgS8LdW5vIcBzU_GGIw-STCf0PDQGwF8TgVxc-fnjGw>
    <xmx:OHuDXdVs3UMF9L0hDNu9OaMw80NvVP7YpkADWHS5D1HFEXTppy5Bcg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2DE98005B;
        Thu, 19 Sep 2019 08:57:17 -0400 (EDT)
Date:   Thu, 19 Sep 2019 14:57:16 +0200
From:   Greg KH <greg@kroah.com>
To:     minyard@acm.org
Cc:     stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] x86/boot: Add missing bootparam that breaks boot on some
 platforms
Message-ID: <20190919125716.GA3431951@kroah.com>
References: <20190919121646.22472-1-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919121646.22472-1-minyard@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 07:16:46AM -0500, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
> 
> Change
> 
>   a90118c445cc x86/boot: Save fields explicitly, zero out everything else
> 
> modified the way boot parameters were saved on x86.  When this was
> backported, e820_table didn't exists, and that change was dropped.
> Unfortunately, e820_table did exist, it was just named e820_map
> in this kernel version.
> 
> This was breaking booting on a Supermicro Super Server/A2SDi-2C-HLN4F
> with a Denverton CPU.  Adding e820_map to the saved boot params table
> fixes the issue.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x, 4.4.x
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
> I checked the stable mailing lists and didn't see any discussion of
> this, I hope it's not a dup, but some systems will be broken without
> this.
> 
> I wasn't sure how to add a "Fixes:" field in a situation like this.

No problem this works, now queued up.

thanks,

greg k-h
