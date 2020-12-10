Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D212D5705
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 10:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388545AbgLJJX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 04:23:28 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35017 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732324AbgLJJXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 04:23:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E09D27BC;
        Thu, 10 Dec 2020 04:22:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 10 Dec 2020 04:22:16 -0500
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
        BRVgNBZXJUpDZOGOQfOjRSNiGbqNk2pJT3YNw=; b=CKgjqRFVwhvY5TKmLrb6bO
        C2U7o/SJSvKmhg//sYb+NlScuCI2A6+G1PqgydaGvjjfMCM6/ZtaHfcTbB1vVEYS
        KC4yWvM4uwMNvafUJyOVbn60FQlFbkmO2oj+8w/P34yeE6cfuoGP9U0BZB0Un1P6
        MMHOZgFmHWkxtJAuvYNMs7Lp2hvSOPsCNyCNOL5lVtp3vJJzpO9XuIFA3HJZ9O1B
        UV8FWchJcLKpL7N4ASLjy+u+b6zGNHyzIAulNW0ajuLEkfm/OLypGf7kx3kcfMkF
        FV1VlW8/W60SFoKEUF4ALMw/nn23qrT4EUm1HfyUjUKRxXS2s45Zz42JJUseEuPA
        ==
X-ME-Sender: <xms:x-jRX-TLMHePEwG4CvQz6MQrlQbAIu8xJIB44fmM-Ta8sfKugWSXxQ>
    <xme:x-jRXzzEG42IsQ9OMWLD0qBhiVK3vo_8JRNvxrfkTxCRolYdYd6GhDsbzQpoE8kyU
    Y426GiaLfLNWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudektddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:x-jRX73N0O2wIJdj4eNoWCWcrW4LlE8ROeZ0VEu_n9XT2kHwvHZcXQ>
    <xmx:x-jRX6DT3q-WVNaXyEOChJeKyPs6C_PtRW7cg10Lb8MDUuEi2FUixw>
    <xmx:x-jRX3ifxSc65-zXnkijhzQDQbLG3XPZLGWxgMUSVfKrwbE2YBOuQA>
    <xmx:x-jRX6sjqC_TECvLg0yMKJ0KEcMFI-xwGUcLoxgXCkbY899hz6L0yA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02C0F108005B;
        Thu, 10 Dec 2020 04:22:14 -0500 (EST)
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
