Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB54F2D5702
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 10:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbgLJJXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 04:23:25 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40169 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388545AbgLJJXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 04:23:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id DB7B777B;
        Thu, 10 Dec 2020 04:22:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 10 Dec 2020 04:22:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=1ZAlIqBRVgNBZXJUpDZOGOQfOjR
        SNiGbqNk2pJT3YNw=; b=Isaz5TMNcW44OShJrlhd6WuizUfUOC1KUEJqkzdW+9w
        Ymgkf8Fao9zHi9H5ZjSq+0Ir0OXWOa+ftU8sWhtx539/LJQuqnSSW7jwGojSQEtb
        Rtypr6x8JsgoXCYc6aQ7E24gcFKf8++RVjZ4aBM2qB9+6xr+fSyTaV6GMBAMUv5S
        IAwuunuiEtrEYtylTJ+Fr7nB+KpYuCuIPbYc/jmMkwdT/tCkWqSYDQ7SfRWSF8+b
        pNzNTgH6SIbJImurxwcuhpoXzlQ+GOIdqx+K4i/5Z/dSIrJKE+1cTszTsqyJQrfK
        ln8Mdfm3D8Og0mfhmBtBhei7eeZn7LcFfvGuH1yZKWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1ZAlIq
        BRVgNBZXJUpDZOGOQfOjRSNiGbqNk2pJT3YNw=; b=L0Kp4CJbjuAtWOcWhvSnYN
        ic2wWt4LS0Zdvx5u7Mj5G0vhKOlozpwkAEjzTjx8+0xnp+Zd50lWJSw6Mfb1/Wsa
        JbBMM1opn77/Lcw4dTJLRWqoKN39s81jASWd29RqEgSv3NpsBk7Bu/A/c/5bsXl0
        k6aIb+Rf0862xfZPnf6K7Hqu4m1MHMEERkUg/j+bJ//n1kwvWejmqJBqdNCIyRpV
        D2ECQjKR4RD6Jt5+V46hORb93L89TS/XIoppeiFUPS+zvfirk5aOnGT0yKuKSzxj
        igCL4UUP5lE9ehIdh7Fg6Vc4uhLwwN+L4MQGDQweRBACSoC0RMFTSvwiDx2fa7Cw
        ==
X-ME-Sender: <xms:yejRX8hgQTT3yw7fKx0lLtKmvZeB1QevqqS_YCNF30_KUiLaPQP31w>
    <xme:yejRX1ABIO3RcY3KkypN1dayQxDnweW562tIu2OFHGXrD3DceGWjUaT17z4cXLrew
    Oy83_j54yjPig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudektddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yejRX0HH7kTuoWhhEG66jRug6W9Z-QuOhq_8P5hLsvuHr1LkERE2jA>
    <xmx:yejRX9SofjNJSMOdhVzQlPauPvTyB8NOLttY5zd7WKoKNdBsAnz-wg>
    <xmx:yejRX5weUHBUm_8lGDyCN5lCx5JqTFabxVcMyEzZYGmWVVQ3Fr4OqQ>
    <xmx:yejRX0_jrUp98FYrM1s10tMyP--7z9K9Lz5vxrSULesqRxbM1TzYQw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 281BA24005C;
        Thu, 10 Dec 2020 04:22:17 -0500 (EST)
Date:   Thu, 10 Dec 2020 10:04:22 +0100
From:   Greg KH <greg@kroah.com>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com,
        lenb@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ACPI / PNP: check the string length of pnp device id
 in matching_id
Message-ID: <X9HklmczekRvwKTE@kroah.com>
References: <20201210012539.5747-1-hui.wang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210012539.5747-1-hui.wang@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 09:25:39AM +0800, Hui Wang wrote:
> Recently we met a touchscreen problem on some Thinkpad machines, the
> touchscreen driver (i2c-hid) is not loaded and the touchscreen can't
> work.
> 
> An i2c ACPI device with the name WACF2200 is defined in the BIOS, with
> the current ACPI PNP matching rule, this device will be regarded as
> a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
> this PNP device is attached to the acpi device as the 1st
> physical_node, this will make the i2c bus match fail when i2c bus
> calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
> driver.
> 
> An ACPI PNP device's id has fixed format and its string length equals
> 7, after adding this check in the matching_id, the touchscreen could
> work.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>  drivers/acpi/acpi_pnp.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> index 4ed755a963aa..5ce711b9b070 100644
> --- a/drivers/acpi/acpi_pnp.c
> +++ b/drivers/acpi/acpi_pnp.c
> @@ -319,6 +319,10 @@ static bool matching_id(const char *idstr, const char *list_id)
>  {
>  	int i;
>  
> +	/* a pnp device id has CCCdddd format (C character, d digit), strlen should be 7 */
> +	if (strlen(idstr) != 7)
> +		return false;

Shouldn't you verify that the format is correct as well?

thanks,

greg k-h
