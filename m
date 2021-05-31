Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D10395521
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 07:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhEaFw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 01:52:26 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:44741 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhEaFw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 01:52:26 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 600BE12AA;
        Mon, 31 May 2021 01:50:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 31 May 2021 01:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=lWcs2qTRorJqQWXwm3bg063UJS2
        ScsXhxsOZBMFwDHw=; b=Kb1kImAL4quY5QabD8G9MizMLF0OE8EIznco4oqAoC2
        KPlbZHxAac3xb0My+2krGELq/9vSrtVlDvSOUh6pabrqzsoScQwe+g876+8riv1V
        zpyf7MxD4up22kkp4YfNng12iGqaOwSZwmAxSvBPKXHmMBGQwmfvFhmg0z/kFN6S
        y6bMHpr8MhZhVCdnkP0bvHWKrcSafKPZqA7NdfXrWYLWXPW25NljKuNUb5Pf4/rP
        cmnjETMzrsPHRfuyfSFlZuyke0S82YkJsHNEjOpmQ1IveEBv9w706vovNPeywdaG
        AuMKSQblqP5VBqKGwz7VJJ0pNdZkd9QaJe22FfmBh0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lWcs2q
        TRorJqQWXwm3bg063UJS2ScsXhxsOZBMFwDHw=; b=DjKlygQVQNg7wy6L7rcWiX
        yzUAeh252NP2iqTyW5Xn8F/4762rhr5sninB5ft89Xmpuh44hB2Ia2BOUOt7aUVx
        K5JiIoW6sXUvIByg6TKKuK6TpdbusgnegT/kf9pochQyUk4oANygigygefXt/mBN
        lzEVIEu2ZT8A3VEm6ybU7MOsluUSJHQAk8l9IjjgSsAMiza6x27lHY7cOnhU0scn
        lVifro4QuXHSEuys/E/hCNezZ7m5QkUHiqjeXZ+IC92i0axAAIFb9hrSzJyF2oDj
        ajRcxAVVRcTCahs8wkRROf6QyUATjhpx5Wu5gG3M0hy46+BVyE0fYXVDg8rUA2vQ
        ==
X-ME-Sender: <xms:NHm0YHOVzEglZ-3Lu2iDC6GRlfSnYZDoTVpjo2g8_7Y0GIyUA3jEKg>
    <xme:NHm0YB8QW5VavC2wq5NbdvbOpC6qGvvTAMgpC1Qz4ict9Yb4usJVhWP5O_ATnNNGO
    -mTPALloPIg-w>
X-ME-Received: <xmr:NHm0YGQPNh6rjwiPnA2cJNYA5xQMcWVZIB7_HSh4X6iVj0I5czZEsBP6qQLJvg0kBJZ5FFrRIr9eCfrXKne2BsCcl4e6TnKc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelvddgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NHm0YLvR65sO5SOwC9S-oIUlFlEI0F9xISiSAivLPpIiB8CbfgLQsg>
    <xmx:NHm0YPcSfgDMqJzPbIM7U7jQ4UorwqyZ5hoKVwp100sEgDYkcTAFQA>
    <xmx:NHm0YH2ZUqk8g42LpaVHLnfFJkEheBga_pBLIFYDnlk10aZnbuZrdw>
    <xmx:NHm0YN0nZWiruU3griH-ciYcTrZgZJI5idsIYyKLz56Ud-IU0balnYeP8v8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 May 2021 01:50:44 -0400 (EDT)
Date:   Mon, 31 May 2021 07:50:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] tpm: Replace WARN_ONCE() with dev_err_once() in
 tpm_tis_status()
Message-ID: <YLR5MSiVpv52FcZe@kroah.com>
References: <20210531053427.118552-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531053427.118552-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 08:34:27AM +0300, Jarkko Sakkinen wrote:
> Do not torn down the system when getting invalid status from a TPM chip.
> This can happen when panic-on-warn is used.
> 
> In addition, print out the value of TPM_STS.x instead of "invalid
> status". In order to get the earlier benefits for forensics, also call
> dump_stack().
> 
> Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
> Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
> Cc: stable@vger.kernel.org
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> 
> v2:
> Dump also stack only once.

Huh?

> 
>  drivers/char/tpm/tpm_tis_core.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 55b9d3965ae1..ce410f19eff2 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -188,21 +188,33 @@ static int request_locality(struct tpm_chip *chip, int l)
>  static u8 tpm_tis_status(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	int rc;
> +	static unsigned long klog_once;
>  	u8 status;
> +	int rc;
>  
>  	rc = tpm_tis_read8(priv, TPM_STS(priv->locality), &status);
>  	if (rc < 0)
>  		return 0;
>  
>  	if (unlikely((status & TPM_STS_READ_ZERO) != 0)) {
> -		/*
> -		 * If this trips, the chances are the read is
> -		 * returning 0xff because the locality hasn't been
> -		 * acquired.  Usually because tpm_try_get_ops() hasn't
> -		 * been called before doing a TPM operation.
> -		 */
> -		WARN_ONCE(1, "TPM returned invalid status\n");
> +		if  (!test_and_set_bit(BIT(0), &klog_once)) {

Odd whitespace...

Anyway, why?  Isn't this what the ratelimit stuff should give you?  How
badly is this being tripped so much so that you need to only do this
once per entire system and not per-device?

thanks,

greg k-h
