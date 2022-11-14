Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229B56278F1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 10:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiKNJYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 04:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbiKNJYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 04:24:18 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F2A17422
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 01:24:15 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7BDE85C0101;
        Mon, 14 Nov 2022 04:24:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Nov 2022 04:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1668417854; x=1668504254; bh=IlQ+ZeoMfv
        teNZ5QEvXRNhOiV6BqtfefJJfSHt1de4M=; b=gUltFiaCZOapayIHVyciso+6cZ
        fRowHrquZ3SRMKD5CtRBXhNZiW1LTcdD5RFnKeY5MqLcahzrM9ZtqgFe43gBsSWW
        wzV1xdOo5CwtP8sgIE7Rvj1/kbcW1d2vv75FYLwEWXR1oCAJNHvARYSFt9st+ouM
        r/ttbtEWrxz7i6Mq2nhUic6xgOrCHkGtG1TNVPlQCSYRDHGA4p5HKI2+ivCeMFnb
        ddduebOQllYFcvW4y19PgAG6hRoKCAGIgX26fNqCFKMxtu/CSAnEfIWSTtVAZuDk
        tZ3bD1vOPXJOFdD3tcNgqMHVoV+S70bBxTM5XlxNs2YckaUkUhAmsSfMAT8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668417854; x=1668504254; bh=IlQ+ZeoMfvteNZ5QEvXRNhOiV6Bq
        tfefJJfSHt1de4M=; b=pF46vnsaciVSfNhG1A8aV2bHXz+oe5NruhII+QcPD2oO
        2stH1+BkdmW8oL0PWD9EYhGM7ghtj63Nb/ITGpZpAAShc8Mk18XTn4KzHye8E6+Q
        ZCzH6z/CP2zWkkZLf1lNWjZhZ2quResoLJ3EhxV90JNOhdmTIVymL0lsoDbvmlYj
        s8iMExC5AAwCFyubnUuFdnlZ4aFkP9JFOouLnxEavbj5ACaVH3N0E4NVuyIYD+G1
        dY3wbhN0k9bGaiD0LTlZnAbkQZbcDBLKa2c/pt4l5rhxURjoCH0cQ1CLO31hdTUm
        BEa63ld7lUINEBMDDwjjxO4orfQkFG5H7u62QvIaJg==
X-ME-Sender: <xms:PglyY9FJ_OlNBnr_PApQi5tJzxGBD3sfRWS3c776SKydWhUhxcz5nQ>
    <xme:PglyYyVQX91aD2Btp4lr9dy75QKVVkfaemtCHBjTe3RKlBtiaac9tHGTgUGw4kipC
    eqsngy5f4rv1w>
X-ME-Received: <xmr:PglyY_K1EtMSzKYblyZUTJpUu-gInVU293AIvML00kmuTt51e_TYXS0QUytMkvgk8R3pqx6Rsd9ShdKMdLpvf3pwUMHI9I1d>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgedugddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleeite
    evieefteelfeehveegvdetveehgffhvdejffdvleevhfffgeffffejlefgnecuffhomhgr
    ihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PglyYzFQaopp65IXCwbGkU1jm6ON3WcLzGlYjkWhY5ESDh6aFEjfWw>
    <xmx:PglyYzXvvxpzOV6IvMHOCiapEQwChm3Lezu3teW5rKS_dy_hj0m73w>
    <xmx:PglyY-MTZdAQlWCx9F2EPE0eOZJNJA5OBbVcZSUlPZy2F0qAKEgqqQ>
    <xmx:PglyYwjOw-JqW4-SByxPjhR97bvCZw3zFN692BnHT587LHvmdnWqHQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Nov 2022 04:24:13 -0500 (EST)
Date:   Mon, 14 Nov 2022 10:24:11 +0100
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Another fix for DRM Buddy regression
Message-ID: <Y3IJO315aROIBlSI@kroah.com>
References: <MN0PR12MB610140563FB372EB9AE0D046E2009@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB610140563FB372EB9AE0D046E2009@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 11, 2022 at 06:46:52PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> One more fix was just merged for the DRM buddy regression from 5.19.  
> This was merged before it got confirmed successful by some of the reporters, so it didn't
> get the stable tag added directly.
> 
> e0b26b948246 ("drm/amdgpu: Fix the lpfn checking condition in drm buddy")
> 
> Can you please take it to 6.0.y?  Here are some other tags you can add to it when committed.
> 
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
> Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")

Now queued up, thanks.

greg k-h
