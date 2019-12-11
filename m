Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA5811A655
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 09:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfLKI4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 03:56:35 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48135 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbfLKI4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 03:56:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C6F91200CF;
        Wed, 11 Dec 2019 03:56:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 03:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=tNxPJDhRaUb9dxTuxKKQkUK1mjn
        pjlZYUVO9jg8ADY0=; b=ZLWQK9pL7wfYAE5JPlBJUNuSf9XBgOE1K7v7hu6wBAR
        PrlvEwaj5wKN/UUNn9YKxstS2mPWcKBLwsJIG+7fQXR1M0mjV5w2Tq7jDZUO6dKl
        lvabhwcMPBkSMvWdlwOepdFuJu7p6nv1Av2BrCpWn5TrcVpXh9SRP6uKhdF2Dbmc
        hTjlcmyvXNUquW0gJ3m+ZmnmsBbu4Pg35z6V7TgoxU/1XrHBDZ0AufwOxthSnAht
        eCfBvDmdRkYzgI1GMR+xQZqsS7x7Re6Dx3W9to5WN6ZPqsR5y66XhcYtSxjTNjnf
        OPSNGPMguEXL+bPvTQFQYdlF68V9opnmYtQwyydIFUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tNxPJD
        hRaUb9dxTuxKKQkUK1mjnpjlZYUVO9jg8ADY0=; b=YRO5PV6s3h0ai7eCOu7WMF
        uadF9G8zXSvMJQOHirTb7/rx8JwVQOK5HGUXFkdI2BIYj1dureCwai1DzWbgEOpn
        kD/r/STZsRWAnXN5bgkixAmThhe9QskHQ3stvTmLtR54QbO+/V4Enwq6j6ypVmNK
        P/qJ2o52VcjDyE/2E8BFE4L0KcoBUQ53NeWU7qRAMSMgCtPATYveDsxfGgByTA9l
        bSByPLB7KJk5VSbWfHUMF8cq/iqfifbxFyq3qPtQDWgbh4imZqofbzCjP1ElAi1h
        wDC0gH/xv8DtAKT/H2kk7v98IbMFRVCVlYVDCD8j7JhM2mqceRIvcfypPAtxzYgw
        ==
X-ME-Sender: <xms:Qq_wXR3p3wEFnJW3ZvvFxl9WflMhORWB_-m9t6f6JtyeO3IVHLhXEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehrvgguhhgrth
    drtghomhdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfr
    rghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:Qq_wXRJF8V3eWHMs1JFFIpjHZbJ1HQINSV2MzZ-yK4fYOx1_Dwn6SA>
    <xmx:Qq_wXa_xzBAv5yxc0sPPOh6_nZsEdBsYfyXgC6aWbDU3LmtkJhQUuQ>
    <xmx:Qq_wXamgnPg5k3ib0n2p5j77BwyPlQcnSgVcsEg8Yz0k2FbbFykVCA>
    <xmx:Qq_wXQU5bEseDK2jIh-z5E_AW_Uhl4eyWDFC7cCTqjzXAhCmQGkoHw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 452E78005B;
        Wed, 11 Dec 2019 03:56:34 -0500 (EST)
Date:   Wed, 11 Dec 2019 09:56:32 +0100
From:   Greg KH <greg@kroah.com>
To:     Laura Abbott <labbott@redhat.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Requests for stable inclusion
Message-ID: <20191211085632.GC500800@kroah.com>
References: <54f071b9-ab38-156d-dc3e-6a6b3959ccf0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54f071b9-ab38-156d-dc3e-6a6b3959ccf0@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 10:17:08AM -0500, Laura Abbott wrote:
> Hi,
> 
> Can you please queue up the following patches for stable 5.4
> 
> cba22d86e0a1 bdev: Refresh bdev size for disks without partitioning
> 731dc4868311 bdev: Factor out bdev revalidation into a common helper
> 
> These fix the issue reported in
> https://bugzilla.kernel.org/show_bug.cgi?id=194965#c46 and
> https://bugzilla.redhat.com/show_bug.cgi?id=1781762
> They apply cleanly to 5.4.
> 

Now queued up, thanks.

greg k-h
