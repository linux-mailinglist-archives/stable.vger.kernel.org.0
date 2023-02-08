Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8A68FA68
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 23:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjBHWrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 17:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBHWrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 17:47:17 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B759C244AD
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 14:47:16 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F0125C01D8;
        Wed,  8 Feb 2023 17:47:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 08 Feb 2023 17:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1675896436; x=
        1675982836; bh=AUlCs+PpiysqDxJNwm7vquCmItSGxqt3BresXMX/e9M=; b=Z
        5uhmLS8Bki36tl7LZeGAtRZF2WDLCoeTsCmQeDmSjNxTA0ZI0ySVA9sW2LDwiNL4
        /5mpoYAU+cYUk1mPgMPJiYlG6bEPmBua4D596Cw+6Tq1TBXAtqfbnnPCQ/GlATey
        TuwrLD58yX6GZCLYsb33MVFupxcy/janfCb0vw/DSfqjtTMhKN2Ew2z+oQBP7j5H
        yNx0a0DrQ/4+kBSUmttp1AKAKF/1CkhFu8lGaFtG3cVOZDzh4Va+7VZ2oqjJUYOG
        kb0XpMpS7OlFsZ7aDUd/ALxww5fYY53tQNJCSUxrIPjm4BKxHPZV/FwDCWGjOkr9
        hnrzD/GJIvtKds49R7ZsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1675896436; x=
        1675982836; bh=AUlCs+PpiysqDxJNwm7vquCmItSGxqt3BresXMX/e9M=; b=W
        Ya8jaGe6bLkolJPJE7q3pmG0DMyf3wuR/J7Mrg8+Cw/7j2U3EOtCnXcYmdcjkc5l
        WeA3PSgnCtXvS18bx8QOI1eLoJRJn8wauiFL9+v7blBAz14pAfGnGZBXeurlxMHI
        8D0WYdfYkTQsAe4AqGVjW2QlHo+Fb1o8Y8AVd7OBSBBUKKlbmo4lLo3TcxJxDnrV
        qmch6LLtyMawfND0oF3cGSY5uzAAzrrAiroea9nxYvGXUE25f9hU372I6M8Kmzof
        TfAz37jGg3GcXCocMiFPAkIouwZhyqtrHdL3NyEy10mjdwvnh9Cze1PvTbSxnOjZ
        ODq+uEvOYYXfRqGB6CjZQ==
X-ME-Sender: <xms:cybkY51WY5mS3cxRQP1GK_WK_JHqnOBdYUIvVWH6-Xw9C4B5vgfFyQ>
    <xme:cybkYwELz9WyrLZwFuH_qtQhz3kFJ_EygSBnTNNSrBcqXxuwCYDwaMi_fBEd9MiLF
    rAsEgVKoSCEh6J3sHk>
X-ME-Received: <xmr:cybkY57tVgdpP3AJmZcQwjY2_lzpLCaoWMjRfHn2JGg7o91BLwhLDCriz5gX7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomhepfdgm
    fdforggriicuofhomhgsrghsrgifrghlrgculdggofifrghrvgdmfdcuoehmrggriihmse
    hfrghsthhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhepteffhfegvddvgfeutdet
    heffjeelhffgudefudeujedvveehveeuhfethfdtjeffnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrgiimhesfhgrshhtmhgrihhlrdgt
    ohhm
X-ME-Proxy: <xmx:dCbkY22MCpBylly_UdZQ_s9DYRkHh4HLDEVR3VfiLZPGjlcXqUzfIQ>
    <xmx:dCbkY8F8ZwXmWChpv8HBey4TcPPinAAzEWdxuOcn8Jq2YyjkX6XR_w>
    <xmx:dCbkY38g-CcRin9At6BcB09yuiOgiVuEVWbDKALXgCG07Drtow7OHg>
    <xmx:dCbkY4hKRmsn8TEQveZoCnkmy4bs4WkgbqPzMZsdldMYG8hvZ15tBg>
Feedback-ID: i1b1946fb:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Feb 2023 17:47:14 -0500 (EST)
Message-ID: <0bf2717e-767a-2179-60d1-0a4ad006053c@fastmail.com>
Date:   Wed, 8 Feb 2023 14:47:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] drm/vmwgfx: Stop accessing buffer objects which failed
 init
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org, banackm@vmware.com,
        mombasawalam@vmware.com
References: <20230208180050.2093426-1-zack@kde.org>
From:   "\"Maaz Mombasawala (VMware)" <maazm@fastmail.com>
In-Reply-To: <20230208180050.2093426-1-zack@kde.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        FROM_ADDR_WS,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/23 10:00, Zack Rusin wrote:
> From: Zack Rusin <zackr@vmware.com>
> 
> ttm_bo_init_reserved on failure puts the buffer object back which
> causes it to be deleted, but kfree was still being called on the same
> buffer in vmw_bo_create leading to a double free.
> 
> After the double free the vmw_gem_object_create_with_handle was
> setting the gem function objects before checking the return status
> of vmw_bo_create leading to null pointer access.
> 
> Fix the entire path by relaying on ttm_bo_init_reserved to delete the
> buffer objects on failure and making sure the return status is checked
> before setting the gem function objects on the buffer object.
> 
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
> Cc: <stable@vger.kernel.org> # v5.17+
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_bo.c  | 4 +++-
>  drivers/gpu/drm/vmwgfx/vmwgfx_gem.c | 4 ++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> index 63486802c8fd..43ffa5c7acbd 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
> @@ -431,13 +431,15 @@ int vmw_bo_create(struct vmw_private *vmw,
>  		return -ENOMEM;
>  	}
>  
> +	/*
> +	 * vmw_bo_init will delete the *p_bo object if it fails
> +	 */
>  	ret = vmw_bo_init(vmw, *p_bo, params, vmw_bo_free);
>  	if (unlikely(ret != 0))
>  		goto out_error;
>  
>  	return ret;
>  out_error:
> -	kfree(*p_bo);
>  	*p_bo = NULL;
>  	return ret;
>  }
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> index f042e22b8b59..51bd1f8c5cc4 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> @@ -127,11 +127,11 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
>  	};
>  
>  	ret = vmw_bo_create(dev_priv, &params, p_vbo);
> -
> -	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
>  	if (ret != 0)
>  		goto out_no_bo;
>  
> +	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
> +
>  	ret = drm_gem_handle_create(filp, &(*p_vbo)->tbo.base, handle);
>  	/* drop reference from allocate - handle holds it now */
>  	drm_gem_object_put(&(*p_vbo)->tbo.base);

LGTM!

Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>

-- 
Maaz Mombasawala (VMware) <maazm@fastmail.com>

