Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F95B1A799F
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 13:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439324AbgDNLfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 07:35:03 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:58191 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439311AbgDNLfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 07:35:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 30D03838;
        Tue, 14 Apr 2020 07:34:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 07:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=CajYkw12Wg26QGl9v1uChV7VMYo
        edWz1DqxKqGkHlpw=; b=FH6PtdqMwU14ZKPrF33MbxkqctFFryBJGzzvj95BUpe
        60l+jk0D6A1rxbtvPA8Eq0W0zx+bG/pfcYprWifGoziUfI8Hn4qNttj9oMjZYaqT
        S3M4XYTFJGVBtrWSOCVlJf8P7jPiKWvTtCoKxWLWGpAb0IpPX5c4nG8VmukRgV/6
        CdfZ180GLbkOQuFpkWjIb0BFmkDAdBib5bqYF4ZUo5EUCf5lJpZeVJHL12zFz70x
        9FIRdgpRt/b6bvBj8Fxt4sI2fcwZVFIIm21IQEcA9oouhWPXIYhPEu5k41/P7j7T
        ouNDMnCrWMMvzyzsC14VhrnntmRTERKOVfWuIXahJqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CajYkw
        12Wg26QGl9v1uChV7VMYoedWz1DqxKqGkHlpw=; b=S8Q6ivvUgSaO+nMq3R6Dl2
        3nSITdNS3zomVNfAp4O9/v5f4BpCSbbrMWiZz98tixo8eD3ONWgfglaRphzLsw7Z
        bLq/P9rw17/wb0STS88lXFSJ7fhkoW5DNM3jzuIs/cTSFRVxCN/oVqIk2KfUvGYU
        b+0N7cd+90igD3wLoJIxRKqDvOGSkRvOifL/U1feP4NUJlwmz4MgGEdz4D5TyylD
        jk/2PqQzXPTMS/pBKQCiKXGuQszVtWzXgO3nnjmH1FeK/gU4SfnQrs4WvpB2HvlW
        ZVZQSHVzhvIgfgT17NP1cGhOAsQcq/rbCj9/gXJa/jKot4wUXaPOEe2oG/YesiSQ
        ==
X-ME-Sender: <xms:4Z-VXh-PdX2WqsZ8yAbd0-R87PkvKeM1Rcqx5_rwdsPnmFbnaQfitA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4Z-VXp9mMqo3_of_rInwq6hClROxYZWkNO2DNEOrt7mVoyX6dRwM_Q>
    <xmx:4Z-VXil_jT5nJ_nag5hO6iWrUcH13qgJXvA_RGhjX7eVDLpgEjPDYA>
    <xmx:4Z-VXkkLduKnVCSNaLVcHJWs4ctxAKWwP6YZY3UezTuqiFuK0i-rhA>
    <xmx:4Z-VXp6AD3ZT9dK2zej-xVWSeLMJMhjMKSX6oiKhsRM_ej4NmHYckg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 503C33060062;
        Tue, 14 Apr 2020 07:34:57 -0400 (EDT)
Date:   Tue, 14 Apr 2020 13:34:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.18+] nvme: Treat discovery subsystems as unique
 subsystems
Message-ID: <20200414113456.GA441876@kroah.com>
References: <20200413081349.16278-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413081349.16278-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 01:13:49AM -0700, Sagi Grimberg wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> [ Upstream commit c26aa572027d438de9cc311aaebcbe972f698c24 ]
> 
> Current code matches subnqn and collapses all controllers to the
> same subnqn to a single subsystem structure. This is good for
> recognizing multiple controllers for the same subsystem. But with
> the well-known discovery subnqn, the subsystems aren't truly the
> same subsystem. As such, subsystem specific rules, such as no
> overlap of controller id, do not apply. With today's behavior, the
> check for overlap of controller id can fail, preventing the new
> discovery controller from being created.
> 
> When searching for like subsystem nqn, exclude the discovery nqn
> from matching. This will result in each discovery controller being
> attached to a unique subsystem structure.
> 
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/nvme/host/core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index fad04282148d..0545eb97d838 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2374,6 +2374,17 @@ static struct nvme_subsystem *__nvme_find_get_subsystem(const char *subsysnqn)
>  
>  	lockdep_assert_held(&nvme_subsystems_lock);
>  
> +	/*
> +	 * Fail matches for discovery subsystems. This results
> +	 * in each discovery controller bound to a unique subsystem.
> +	 * This avoids issues with validating controller values
> +	 * that can only be true when there is a single unique subsystem.
> +	 * There may be multiple and completely independent entities
> +	 * that provide discovery controllers.
> +	 */
> +	if (!strcmp(subsysnqn, NVME_DISC_SUBSYS_NAME))
> +		return NULL;
> +
>  	list_for_each_entry(subsys, &nvme_subsystems, entry) {
>  		if (strcmp(subsys->subnqn, subsysnqn))
>  			continue;
> -- 
> 2.20.1
> 

Now queued up, thanks.

greg k-h
