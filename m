Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F706D451B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjDCNBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjDCNBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:01:37 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E061D846
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:01:32 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D624E5C015E;
        Mon,  3 Apr 2023 09:01:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 03 Apr 2023 09:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680526888; x=1680613288; bh=Ml
        XtwIWcOmyl6yxX1H76LZIEZW9N6q13L2ji8h4Ntxg=; b=g4H2aVwqPm4isPrie6
        j0/fR/b5oOR0d6LelMGrg67K6HjpPflK5RRmLuX3vMKY2YqkpQBedA4wevvdY/A5
        CSRsq09vTs/xZRb2Q5Ohsw0v2PINQE+j+gF7VGd6SULAUMYApZfWijp7g+CxUwkc
        0OLzGQ2Lo0T31/XIpS3sT2OkqHgEwWqtr+Feo0L8Q24xcUliOq1clG4vFvV7yga4
        uEQpAlbjVPNIgbuYAPA9CBCuYDz1Dlkctc6SGM6WwxOiknn7Kj2WZCiO7U99OELV
        upyZ8xoC0FLicD5j5MWqmjnqSUu/goAB5jFM1v3/BaFbUAqKen3A866xQIpsLNT5
        9pMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680526888; x=1680613288; bh=MlXtwIWcOmyl6
        yxX1H76LZIEZW9N6q13L2ji8h4Ntxg=; b=eR79kWWKlAKBO5U2AU25muZyxhit2
        hE0gABt4PoWWyVX0f3YCwiwAy1KCgVGUMEIXy5IGDRsZPsQwV0VDvARF9pDn9ECI
        FWp7rFZYtHKq+kvKUeghtWA8u5TRjPFSIKEYRwhiwb+7TFkwZ00H7Rtjz3uPTL4b
        yF1Ax5eAOZ/2eDDF20b3hv8BbXcwGruf22TuCwH37LWF3G6FQPG9hHUUd7fcwUvA
        L84x8wfXfdyxc1Vfaz/VZKwQ+B26anP680ITtMc47c8x4kjWX/sfVuvOdGjS6TKp
        bYVhD0WoSoQsrb81p21lXBRU5dW/+EgO8k0qRfv4f/ch7affJOjN6Ue8w==
X-ME-Sender: <xms:J84qZE8KLV7ABIuRiWMBy0eGuHC0qUw0d3sSw0ZlTN6qgqMJVwJAiA>
    <xme:J84qZMt5OtvxOXW35iMjvAa04VpfUXors47l5m5XhX0tH2vOw6qIIzfTG4-ijTKdW
    6jQcWfnQPm4IQ>
X-ME-Received: <xmr:J84qZKCV1im1yZ77AaiwsC1JC64s5jEaGwo618GEEfCeaYvt-hx_B1VtiG0xEyZ_8mbWHKcYX2PVXVWtdZo1CHADJXkUkFOtS8vLoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeijedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KM4qZEfhLo_X7UTjMumE35hxkexJTEp8wpO6huSTk9eUdRuIOQNFVg>
    <xmx:KM4qZJN5E5FhlRNwNgDMRIIGQ4n3vIXd506WflaXnG9-0aftrh8yrQ>
    <xmx:KM4qZOlx71J9mKMTjnU7zHyXyZaPzpR1cBi-pFmaFNHhm09e3CHC5Q>
    <xmx:KM4qZCgm1lAySQlITEEr2A-QyVnQhQKHKl8e7lwP9qs8oi0bFDbnrw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Apr 2023 09:01:27 -0400 (EDT)
Date:   Mon, 3 Apr 2023 15:01:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 4.14.y] s390/uaccess: add missing earlyclobber
 annotations to __clear_user()
Message-ID: <2023040317-quote-backrest-2c53@gregkh>
References: <2023040339-copartner-curliness-0c67@gregkh>
 <20230403094336.1325934-1-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403094336.1325934-1-hca@linux.ibm.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 11:43:36AM +0200, Heiko Carstens wrote:
> commit 89aba4c26fae4e459f755a18912845c348ee48f3 upstream.
> 
> Add missing earlyclobber annotation to size, to, and tmp2 operands of the
> __clear_user() inline assembly since they are modified or written to before
> the last usage of all input operands. This can lead to incorrect register
> allocation for the inline assembly.
> 
> Fixes: 6c2a9e6df604 ("[S390] Use alternative user-copy operations for new hardware.")
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Link: https://lore.kernel.org/all/20230321122514.1743889-3-mark.rutland@arm.com/
> Cc: stable@vger.kernel.org
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/lib/uaccess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
> index 802903c50de1..b11ebcb3d33b 100644
> --- a/arch/s390/lib/uaccess.c
> +++ b/arch/s390/lib/uaccess.c
> @@ -272,7 +272,7 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
>  		"4: slgr  %0,%0\n"
>  		"5:\n"
>  		EX_TABLE(0b,2b) EX_TABLE(3b,5b)
> -		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
> +		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
>  		: "a" (empty_zero_page), "d" (reg0) : "cc", "memory");
>  	return size;
>  }
> -- 
> 2.37.2
> 

All now queued up, thanks!

greg k-h
