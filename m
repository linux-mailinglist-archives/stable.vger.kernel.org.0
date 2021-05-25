Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DDD39005F
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhEYLzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:55:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56453 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhEYLzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 07:55:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id ADDB95C016A;
        Tue, 25 May 2021 07:53:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 25 May 2021 07:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=mpo4TL18KQrZtoHaJmKu4cwp1WP
        8toI29cOIp2W3nRc=; b=n5IAeuj/CWcpADQVB+VOHrR4QooWdbUufC4m+Nwe7/N
        AV86VO2APJEQ1WdErssJpw04z5RmNsEBlBx+33NUHqeqp8V9vA0lV6/Tw+cAwrnw
        x9igNsRebrvLDqD1avG6vkFKp4RbZYTfbgxlKGN7CnS3Dbj3yjXKTiJrPmIR4yDn
        Vphpb3D4jojOxUEH7M8XdF9rjA7UDSQ0ra7Npky/C8X028Kss6/DR+fNNk+itxwz
        lkzhFIZKXlt9atSwAC1Ln4OY5xZVeA29zedP+nbAmm1lkTwQxEuFBl3yAZ+DQ5Wf
        8jZ6fyxWhhPVdQt3lO8zEzBkV9cpoTvvusoNSg6BHtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mpo4TL
        18KQrZtoHaJmKu4cwp1WP8toI29cOIp2W3nRc=; b=Ha5DS1ZEXmiuImO4MbcAZ/
        Jd1pfSHtZdpRMLdoAkWZyHMXJihJBZ177o40woL5EAb/i+Bl3OesgRz9io+qnV0/
        VcdmG6TbZ7sbf3NILK9HUFGK0fxUdai+YovDO/GUC5M1hYwfjYSIllQzHSZ1NsfZ
        +mJVMb+f8KvjA3MpddQx2Vd4LwIZmk+hcLZGSWKH+x8GjWeMd/mjlZEFn6GHZpJc
        iTIaMDMJvCzL9a/KbBCLHfvje1nFKywIHpMQJC1RHBEe1HmgeEWPXaRR+856xzFe
        LwdZNNfSsFAcV6pKajekku/f8+UnCY+sAEIbQpHXPINT8b/gdEs9/sbYrz2DIpPg
        ==
X-ME-Sender: <xms:UOWsYBQkeC3qGUop7iFSeHQ1zJ9VXdh-N4tROvp9TCs2-rxlDJsmWg>
    <xme:UOWsYKxw9y6GVoZhibKu5rd9RkZVW6PkaUWPrKsEV6ZAQV_I3mjvGwY6FQgXD_Yj2
    BA-nCbW0FigJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekuddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UOWsYG3ZhUyIbKMMlVo1rJaCxsjwpEoxco4wsMfcxGRs8bqQlEQBnA>
    <xmx:UOWsYJDttBGB5ZYXY9kr9B-lKAtokLm9mlX-04eat5RHCMNnVGeGlw>
    <xmx:UOWsYKhKfDQYiR6wJyrnI9S0i8WFP7j7r0Cv0GOL6lvFSwFqGt6-rg>
    <xmx:UOWsYMbpvdUYPNW4gkBAwgcvaPt3EC7tJTbviVTYhOzNuEKkWfyMdg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 25 May 2021 07:53:51 -0400 (EDT)
Date:   Tue, 25 May 2021 13:53:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN()
 in find_asymmetric_key()
Message-ID: <YKzlTR1AzUigShtZ@kroah.com>
References: <20210525113628.2682248-1-andrew.zaborowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525113628.2682248-1-andrew.zaborowski@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 01:36:27PM +0200, Andrew Zaborowski wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> BUG_ON() should not be used in the kernel code, unless there are
> exceptional reasons to do so. Replace BUG_ON() with WARN() and
> return.
> 
> Cc: stable@vger.kernel.org
> Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> No changes from original submission by Jarkko.
> 
>  crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> index ad8af3d70ac..a00bed3e04d 100644
> --- a/crypto/asymmetric_keys/asymmetric_type.c
> +++ b/crypto/asymmetric_keys/asymmetric_type.c
> @@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
>  	char *req, *p;
>  	int len;
>  
> -	BUG_ON(!id_0 && !id_1);
> +	if (!id_0 && !id_1) {
> +		WARN(1, "All ID's are NULL\n");

You still just rebooted a machine (panic-on-warn is commonly set).

Please just handle this properly, print an error message with dev_err()
or pr_err() and move on, don't crash things.

thanks,

greg k-h
