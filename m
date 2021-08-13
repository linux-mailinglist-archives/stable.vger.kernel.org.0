Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7133EB56E
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhHMM0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:26:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34829 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhHMM0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 08:26:34 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 9FB345C010D;
        Fri, 13 Aug 2021 08:26:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 13 Aug 2021 08:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=O0lENVBH+WntImBlijDZKATpdAC
        IiNeSXStEESHrN30=; b=Mc0Xfv+8Q6hr0aQiMjQaDAb+UhbQbsgTyRYHMUZPpcT
        ZgCd+XeEOJuLugNsugVv/nqPwB2DDMhiCElDiauqHjrAytruDBAVZpAUed8uQU7y
        IJ5BsnwPQypG+qw4vNb+olLa9YxBcKM6tN8fNeWLJiUj9IEyByEV02aipdmJESZ4
        N6Y0TYN16GnqlXoMFv1uRqedXeVUz3D0dGgqIE16oZy8JJ0aU/5FQqtycjDfoGnK
        78/HBG43SjMzjBzRaQNU9O8X0lUJpEUs0xfdwgzdLIAUX8AKazf0EPjhC5YfBdao
        jAc4P+cMqtTqMe6zDd7jUD4BnrRNmmtD9dU6lH+uMWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O0lENV
        BH+WntImBlijDZKATpdACIiNeSXStEESHrN30=; b=ee8+d9Mjek15jqzP6hyf4p
        B6EHtGxHSzylYZz/S7ngMW557BnTIHZgaNkzMifCPkllMdh3VSjvIjmOQQwlWbMx
        vYG94tCWVm+sKi5SqHxuR/sd4vajyekODPQHMHobaaJ/GQzLGvPDxL6MDbKg/A6m
        40mwJCDRYIzPZjXnDEDBhuR4wCh8DO2DhGICBMe05mQHD21Dw9o7knufybNtkmV6
        xGaAwqGE2n0W14v88U1FMH7J91msDt5ITP/gLIr3HVUqUUmDNjaOT1nkcgZ8drEY
        ySe0sn13D/Qj2EZeEXH7QsHxoKn/InLA0x7D9U4VnNg3ns1uOmPgqFQ3KRoOD6uQ
        ==
X-ME-Sender: <xms:3mQWYWNEozgrjv__eCdn7_B21NICRut9KnkcBwTpyW769scdCDShZg>
    <xme:3mQWYU8sL_pN5R-gx9hDMxLkLrdutaIotq0LK1dA8RIGA2H1jFUx8hjjaJRN3zeQj
    llIcrC5Bf4iVQ>
X-ME-Received: <xmr:3mQWYdQvGTpEb3uCzAJyAu8G5QwqrtYuRYGpBQYcdIjKfLdw1oftIkmMgqD1WJmxeeNbO3EuILGgFyFbK1_RzO0Qys8NI1nY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3mQWYWtBBZIzTYC2PHW8sbzD5KAyXLipUekFgXnkSsC-p_S36lE6gg>
    <xmx:3mQWYefA6jm5k3dJ0q_xMSkhWH0fXhgwoUGZQ990NkZUwSB8cHb_Ag>
    <xmx:3mQWYa1IHjpxjQOz4vV-vsc3xaQeroKhDj94H75kKCz51rqCVB08bw>
    <xmx:3mQWYVy1g1ZuFg0PeJMUik7IAu1iVB92__Wx7KMx_W3q3xuJ393jjg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 08:26:05 -0400 (EDT)
Date:   Fri, 13 Aug 2021 14:26:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH stable-5.4.y 0/3] btrfs: backport hang fixes due to
 commit c53e9653605d
Message-ID: <YRZk20TQpSiGiis7@kroah.com>
References: <cover.1628854236.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628854236.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 08:12:22PM +0800, Anand Jain wrote:
> Further to the commit c53e9653605d (btrfs: qgroup: try to flush qgroup 
> space when we get -EDQUOT) there are three fixes as below.
> 
> 6f23277a49e6 btrfs: qgroup: don't commit transaction when we already hold the handle
> 4d14c5cde5c2 btrfs: don't flush from btrfs_delayed_inode_reserve_metadata
> f9baa501b4fd btrfs: fix deadlock when cloning inline extents and using qgroups
> 
> Commits 6f23277a49e6 and 4d14c5cde5c2 above are straightforward and are
> part of this series.
> 
> However, commit f9baa501b4fd above is more complicated to backport.
> Furthermore, the bug mentioned in the commit f9baa501b4fd might not
> trigger on 5.4.y as its related commit 05a5a7621ce66c ("Btrfs: implement
> full reflink support for inline extents") is not backported to 5.4.y.

Queued up, thanks.

greg k-h
