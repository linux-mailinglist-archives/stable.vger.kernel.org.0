Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9459C284
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiHVPVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiHVPU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 11:20:59 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04543D5BE
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:14:21 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 8432132009AC;
        Mon, 22 Aug 2022 11:13:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Aug 2022 11:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1661181238; x=1661267638; bh=nYDLPMBAmn
        rwESJu+Kjdnz+fMIpyn54d9JD2b8IjK1A=; b=zERnwObPTD1D7bArm5UglQJi8z
        rC1zQyh8hJVkFrExnybrAfV/nz2tDNj4L4J0qv0hKS7fUUdcdXYgpXM2GE9fEdgC
        AQVNQsr+Xf3yiYEmEO8rf44q00Vl2+eL4/5aD1cWJ/1kkSmJ0aK01euAOJ31Y2mB
        6Zsp4NSqI1n1issIHQ2zWXcycAnBsdOwCe7CgQnsnG2qU7VluN9F4/ECizohqED+
        ae7pQecmNsct+cMuTWpXv0vICUPET99IfQOG8GulW9qEgagVs/YL5x4GpJ3TSJ1i
        KNmPe2P1071apVNeyft2l6QVk+1qhVSk2aH3yO7fq1V1hus9zt27uyxZeJNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661181238; x=1661267638; bh=nYDLPMBAmnrwESJu+Kjdnz+fMIpy
        n54d9JD2b8IjK1A=; b=AjQGX1uNk0u5or0Tpylla6RORwysAkGH+iODPJiOyK2V
        3fdeB9wMAc7qoXejfV2KTdxUds4zPflWf42LU0fQSoIYtIrUU+LE7dIZenTEJNiV
        kPJ9OD/bbwWqYOBdKH9K/ZoSAp91sdrAzeTxsTRVHTcAAl1n2snUGgKEFgbpM/YA
        bDHeXFOuAWl74YubcRaEInewgpvKnJq1WTT7l4Rht63Q6wstCOkMV3OnPRPODskt
        O7VHwmOT8i3fzbGZ0z9alIdCQlK0e6s4xIuQvC7gGkzeRKhZ3Hy6W/1XYVBoMNqI
        D8Gdxnk7fCxQprxnmqCpRNnWxfV2MD3KiFs4Z6cW+g==
X-ME-Sender: <xms:NZ0DY7zmVbiP_eZJFLw_UVuHKdeuFU3pdM0tUGEIJ7W7XULqXOGviQ>
    <xme:NZ0DYzRCJq-AYRWdOigT-hiw00zdlEc1OPEDwOGkA4DFn_A22MrobC35OPyUS8JO1
    0UTytt9alGiAw>
X-ME-Received: <xmr:NZ0DY1VAFQpmcKN7K4kRAIL6OR0pMkg0eEVDvg8trjQPnUBllDMQp7MRveN0lmRO345EctbfFvg_OyKV-CshKNhdtaa4kp8d>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:NZ0DY1guGKwQtO5Cg4wKUOaHxihO2jePfjM4iUiT2rY5_zGwXYBU2w>
    <xmx:NZ0DY9CPUkVGFLMR91qUkg4l0XXoa0sRBMMTyJIgDsPAk0QHedTL6A>
    <xmx:NZ0DY-K3Aia94IEAshnccONdgUXgevi0FhfpT5yUvzvTHwxNN4D_eg>
    <xmx:Np0DY1bdd7Yks4UEf8uZvynjC5We-CQRXMYNYtnHkQdHBGPgAX8JHg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 11:13:57 -0400 (EDT)
Date:   Mon, 22 Aug 2022 17:13:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
Message-ID: <YwOdMf8m7yhhX8k2@kroah.com>
References: <20220822150253.3924012-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822150253.3924012-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 05:02:53PM +0200, Jens Wiklander wrote:
> commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> 
> With special lengths supplied by user space, tee_shm_register() has
> an integer overflow when calculating the number of pages covered by a
> supplied user space memory region.
> 
> This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> 
> Fix this by adding an an explicit call to access_ok() in
> tee_ioctl_shm_register() to catch an invalid user space address early.
> 
> Fixes: 033ddf12bcf5 ("tee: add register user memory")
> Cc: stable@vger.kernel.org # 4.19
> Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [JW: backport to stable-4.19 + update commit message]
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>  drivers/tee/tee_core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index d42fc2ae8592..e568cb4b2ffc 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -175,6 +175,10 @@ tee_ioctl_shm_register(struct tee_context *ctx,
>  	if (data.flags)
>  		return -EINVAL;
>  
> +	if (!access_ok(VERIFY_WRITE, (void __user *)(unsigned long)data.addr,
> +		       data.length))
> +		return -EFAULT;
> +
>  	shm = tee_shm_register(ctx, data.addr, data.length,
>  			       TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
>  	if (IS_ERR(shm))
> -- 
> 2.31.1
> 

Now queued up, thanks.

greg k-h
