Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5D53C9D44
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbhGOKxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:53:03 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56941 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241715AbhGOKxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 06:53:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E57F5C0276;
        Thu, 15 Jul 2021 06:50:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 15 Jul 2021 06:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VXXNnZWQeRfhZDJT3wISjtqUs8k
        n/PPDTkCsEYUw/r4=; b=B7/EVaMmWM7rmxPGoTT1FdG5VUrQ4y1QneKcktN4B4r
        i6xrDQPdDSst75iSft3zmHFl3u6EkrmPk0ONhE+kk4s7fN8ieB/Zl6IBnMuZYNJX
        bJ6aY7tSE3JQnAayeVRkz0NCC6uv6G2u1oZH94DGnfZmXk48aT9Je1lwGjDLoiQC
        msjny78vDHNOQiwZGWubdssHe2xjUpy6wTbgpGgpbkYwH/QNfibqwnP0AOaNL6Wq
        A7kHa3VT2vvppVLqPOzjv1PA+fGWlmxlKNaWplW/uTTzQoEgBAI2hRmbGgQG1I2e
        1fFwg6Ksp6YVPuR6W0hljLeLo5CBEVEMV+5hOzpXXlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VXXNnZ
        WQeRfhZDJT3wISjtqUs8kn/PPDTkCsEYUw/r4=; b=lqrHlMPnOaJwCu0hEcWxGi
        ZTzvC9SVZa0bRzNN8494ESu2L5WBl4SNvz+jkDXqbeCasWeMsPBwAemttfWOB+zS
        LdE/GMW3ItidNCk3OVuK9Etd+/8eCwgbLns6WGYLvGGVyLzrD5ytpwVV1QKS92oa
        g6GbxPetmWGxK7/MQPlAzbmXoZwq01mJHA0tmNhdbhpnOHsx+80GuoNEhHDJVvGe
        /UhUutzPKyq65gkDUtRMGYEGRrRe0qHsa7mg9UGxda3U+xH4S0wFoVq9+oFJFzes
        /qbp1fOcknOO7cBPElEO5W4hHtQBk5JUqZC1gM9mFJ+NgIjf4ugrv+xpod5XoWTw
        ==
X-ME-Sender: <xms:4RLwYPJ9jCxNlcaLvhqh1tUwJH79vsvIMTDJ3fEWhVzE6m9gJyC92A>
    <xme:4RLwYDIoB3AQJCFKK5q6JOwUvLE5Q_AH5G8vKaT2Xl72S6APRRM4icTiUm_iHedlb
    hTj2T3EzJOyIA>
X-ME-Received: <xmr:4RLwYHthoYKEYR2d11wvY7hb_29HDd8AQhm-p-6BPQ4LMa5os2ia1o3y2xqLcA40Qb3xa0NY-FTzNE9CUGp55W7gyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:4RLwYIZvkmiSWcpWOn9oWHuM2XwYhLte52TRhquyax2wIPcoR0rt8Q>
    <xmx:4RLwYGakV1bgMoyFhwAZppVsrGt4CLQJRVtseNSb9qiCpbMJLaSyNw>
    <xmx:4RLwYMA_8wMX2W9M4M8SnsHjLSpLQOPMnsJq6V1tcIcQ5mw1LqiEFA>
    <xmx:4hLwYNUHAjNtekyUf8VBl9RLcLdWZ2gcC5GKpUCFj_5ZeiJbBVWCyA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jul 2021 06:50:09 -0400 (EDT)
Date:   Thu, 15 Jul 2021 12:50:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 5.4/4.19/4.14] fscrypt: don't ignore minor_hash when hash
 is 0
Message-ID: <YPAS3GbIhMKKjRWT@kroah.com>
References: <20210712152717.6480-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712152717.6480-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 10:27:17AM -0500, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 77f30bfcfcf484da7208affd6a9e63406420bf91 upstream.
> [Please apply to 5.4-stable, 4.19-stable, and 4.14-stable.]

Now queued up.  Do we also need this for 4.9?

thanks,

greg k-h
