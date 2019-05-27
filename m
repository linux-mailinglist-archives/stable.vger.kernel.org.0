Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1231E2B73D
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 16:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfE0OFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 10:05:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57217 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbfE0OFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 10:05:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BE3F02221D;
        Mon, 27 May 2019 10:05:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 May 2019 10:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=qYtSkNJTTq6ZG8R+2xAxwwgmx7V
        o7um741pIGFRqeJw=; b=DNUmr5tgYCLyoPFVp3as0MLpL4wTQuKXI6TW9RHxid9
        7Jlr3qcyxBsfxNLRug8xY5hN+36V1se/QipuSL1Dyc661h3XxiUOdarWQE6A6e7O
        ni0VucccLEmO0FCBwy1M/hNNFcFyqjHC4hnoI53lqpWu6MIaO0rAxuGMQNZwrHk6
        gnscITKVP2j7EIZ5Tvj4d0LghlBqH8gHKxziqoDOCo/9b7iF+sr/VogGqsvY9oDo
        Rlfodu/SPgKadPOmIm7fcHvcdBdwZWYPVsLfXTLhsoEpIrIJdQZ93hN6EpA3UfVs
        GbroFmmb7qFN7frIPGuM6/Y4zAueJ2w+QSVhzBerKRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qYtSkN
        JTTq6ZG8R+2xAxwwgmx7Vo7um741pIGFRqeJw=; b=puH3S1UIrwedCDcSnheDmt
        74ohwcDjJBW00UU8++6pki03wKO9CDS066Jwwmuxk952xS75vOC5yoc9QSp+ceNv
        oarF1n9BPbCYqkXNeKGr35XS6OhrnkXE8xai/OLC1rIwzr3dSghusav5qwkwO1Vl
        UAb5NFXzoa4Z4o+CS1j5N/f9jVTyBAY4X1+v0pcxM19mlP3zNEvIE+KCjUz+IV4K
        ebNdX1JSmE+XeH5k65efmZ9eHMYAXqVvPbXVIjRp/YmZ1yQpZRfYAnRt1E3+QW4v
        C47cDaVSDiAIQ1uv5wNS0RTIsXT8o2k7s0PRLsbtk2D67mOxCPIjOQCxGPBGHWfw
        ==
X-ME-Sender: <xms:t-7rXN1Ui-Eq2hT6YAjeVqdYJcDI9plg-5Jo1QkGjmHaNJDDK5Cd8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:t-7rXGhqlkwJVNhGlaMIuddfXilXfEhEUWqcCLfwnD_ccjpVu1Bcyg>
    <xmx:t-7rXOGDKSdF9ua2EwVbho9RYGgZwmrpLHMhnTrJtptJYjDTvJHX2Q>
    <xmx:t-7rXCX-yznJ7hPsHRUKcvIZMBFwxm3Jd1qvPsQHJ-UPKGrPUIz2tA>
    <xmx:t-7rXIp4xGEYAaUuCyP6leylFDiz7K-mj29HXCXWrJYH25iLFfozNg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC78980063;
        Mon, 27 May 2019 10:05:42 -0400 (EDT)
Date:   Mon, 27 May 2019 16:05:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
Message-ID: <20190527140540.GB7659@kroah.com>
References: <1558651664-25756-1-git-send-email-pshilov@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558651664-25756-1-git-send-email-pshilov@microsoft.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 03:47:44PM -0700, Pavel Shilovsky wrote:
> From: Ronnie Sahlberg <lsahlber@redhat.com>
> 
> Commit d69cb728e70c ("cifs: fix credits leak for SMB1 oplock breaks").
> 
> For SMB1 oplock breaks we would grab one credit while sending the PDU
> but we would never relese the credit back since we will never receive a
> response to this from the server. Eventuallt this would lead to a hang
> once all credits are leaked.
> 
> Fix this by defining a new flag CIFS_NO_SRV_RSP which indicates that there
> is no server response to this command and thus we need to add any credits
> back immediately after sending the PDU.
> 
> CC: Stable <stable@vger.kernel.org> #v5.0+
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifsglob.h  |  1 +
>  fs/cifs/cifssmb.c   |  2 +-
>  fs/cifs/transport.c | 10 +++++-----
>  3 files changed, 7 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
