Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81814321B80
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 16:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhBVPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 10:33:01 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50283 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231340AbhBVPcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 10:32:39 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id E5816235;
        Mon, 22 Feb 2021 10:31:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 22 Feb 2021 10:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=kpjfjIQXb12eNYyAjjrjeos1q8U
        zd/mrMfnV3zzJGbQ=; b=iEN3easIeaxIkcQPJc0Ttbqp8hALXzwfFSY07oxmTgT
        AlG7JQvfcwtaF5svPwi1gAeGSWdcOGIBvIV/qxZ3l9ljcnea9LDjhgMIs8P8UZs5
        R1WeoGDVKhnQENvncwynOPArfAOVSwysrZ7VkdkksmgkFkswBblm1dQOgXPs1GQn
        V5jYE/WABHmZKaAFfL/Tszl5+nZYj5RdzcNJxdOGCIkNBmIzrIHJboZJlAFprh3H
        hODAMO/Cz94nEsjf90ByceiW5FHFy3+eeGbCNVs/DJo6Swik0mJDsT3ueQtveFvf
        8t0h3rsxTD+cPoSsETz91J4V2rYChccert1Y0ZIW95A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kpjfjI
        QXb12eNYyAjjrjeos1q8Uzd/mrMfnV3zzJGbQ=; b=h2TCz1gPcg2tN04tA8pCE9
        GHjgl9mNUpyOJ2h4O/YxNZs+GSo/13IDuYuccxcXJxGnx4U50DvBWYqCrZnH5e2f
        yeLg48A9r5SFl1FTTURq6ZPg7rG7skv99Fb1y3c9TZa2YTtH0cSr9geM6lDK1UXb
        znDI2hwu1umyf7YDR8qGpULzeug+NZ+pn/82vkUtesQ0RYUwbJPLBWM9Qdayx0Hm
        LAU7Fl0mdvfWALAnl0tIr13YPL7BItIX3SXhqJ8aJbsx3fz1ozvhKDD8yzMCVndZ
        14wfiJ8mZx0ZI2HA9hhnmjdEke0j90yKuGhHGouYNJPFX2WG14Ip84pVpesYEXeA
        ==
X-ME-Sender: <xms:Ts4zYIjiCsz8209Dv44crzlM-8KouOXAAImdLJ7RcVnA-t0wgvSr5g>
    <xme:Ts4zYPuguIeW0J4VvQrhGdVrzoJvh_kVowcmhhoYVFL2a2Ni31lYlgvUD5OdZNqKT
    OXoK3ZW6s83ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeefgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:Ts4zYDAiqApjG_oL281V8hAZ1qMA_63vGnN-w5-xlHODATrvaNoD9A>
    <xmx:Ts4zYJ517AYZciy7OIgbd_Ww7RXFXrRmTWVSb7ue7z_NobmCI3T58Q>
    <xmx:Ts4zYGfO8tRDe9DmpzLAQJL84vGjm3iLnv_KMsyXTHxjO-iNQAKK-w>
    <xmx:T84zYL9ajllrG5m3g--cCHgu95bM0UhIBussfmZcIMYmFEdmZZzmGw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B2DF108006D;
        Mon, 22 Feb 2021 10:31:26 -0500 (EST)
Date:   Mon, 22 Feb 2021 13:39:12 +0100
From:   Greg KH <greg@kroah.com>
To:     David Sterba <dsterba@suse.com>
Cc:     stable@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Wang Yugui <wangyugui@e16-tech.com>
Subject: Re: [PATCH] btrfs: fix backport of 2175bf57dc952 in 5.4.95
Message-ID: <YDOl8Ptkjgx/gOK9@kroah.com>
References: <20210222121639.30086-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121639.30086-1-dsterba@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:16:39PM +0100, David Sterba wrote:
> From: David Sterba <dsterba@suse.cz>
> 
> There's a mistake in backport of upstream commit 2175bf57dc95 ("btrfs:
> fix possible free space tree corruption with online conversion") as
> 5.4.95 commit e1ae9aab8029.
> 
> The enum value BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED has been added to the
> wrong enum set, colliding with value of BTRFS_FS_QUOTA_ENABLE. This
> could cause problems during the tree conversion, where the quotas
> wouldn't be set up properly but the related code executed anyway due to
> the bit set.
> 
> Link: https://lore.kernel.org/linux-btrfs/20210219111741.95DD.409509F4@e16-tech.com
> Reported-by: Wang Yugui <wangyugui@e16-tech.com>
> CC: stable@vger.kernel.org # 5.4.95+
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> This is same fix that went to 5.10.x, with refreshed diff so it applies
> cleanly on 5.4.x and with updated references.

Now queued up, thanks.

greg k-h
