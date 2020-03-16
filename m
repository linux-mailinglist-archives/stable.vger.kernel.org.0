Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17F186C01
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgCPN1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:27:22 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:40887 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731234AbgCPN1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:27:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id F10EF896;
        Mon, 16 Mar 2020 09:27:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 09:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=LWbAkvWvTOa4/NhzgKx+d5FE+oD
        7OtLXsqLGPhJiiBo=; b=RNhy5s9hBOf+/dxtzvUA7WepZsu5TRLSceu4tUk8yup
        3hZOrfebsDZAd4yoSCqNqxG8uNH0L3N05CMwEc98CBHY/hFaEIo7xzqRr+nl8XHT
        aIUE+/s02MueQ7uELkKkNCQ0M6W1SW9Xd1vnReNlWBgRyY97SyNdRuS2W5hLw+ZJ
        cRawqqelQDAFPf7ihbgW15nF/ntie32QWI0gjwHk6kM3BVNxhztaUQcUa2CXFAaE
        S7uwllZcfwtBMjfzOUYus2L1oq0qrHyeKKGYBG4T9l8Gpq8GxbVOTyY4GHQC5lK/
        cLTCzHEnDgSH+EfEkh61WXTBmV5YblqViOfIlvP6v0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LWbAkv
        WvTOa4/NhzgKx+d5FE+oD7OtLXsqLGPhJiiBo=; b=f0isMgVWYq2wkxF8inf2tD
        IotNRQ8UNelCMX3Q+xs+3tEmuTa2bvPYIIM2LEIL4o7RRtuQwJIxkEt3F3CSRuqw
        YpDnu4dcw1XpVyFii/IW8JH4sBQR04BkD3w2E4po+Dt/pI1I7i0xDut7KwLrEvVU
        wXC9H0DFyoU8FSJq1/olaZDlqCVBrwppvJlTaezMNcPHRLiOyvCJvPG4G0Sc3fL7
        E8q4Ka8Kgd/yY3IIThmqd018M+MOOYblsidMeu1cOB3HuLpDpcvfa1z8mkASHtNS
        CbZg9g13llkpv/tgRIVEmEMpZaa0sJxIkh22l8i4kf091KbpWZ4R2pYu+XK5dNhw
        ==
X-ME-Sender: <xms:uH5vXhIxifZAfa-lBFB9P8zq4SHzwYKn9bf1lODvwlEQpFvoWf4fkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:uH5vXvxPDafXloas2LVaZMOheqVX0eM4wHlr4mfOu3ARyCehAtYjRA>
    <xmx:uH5vXpMk8bRmhwiULl0h9eRM6WG32VOwCeChU4-Wk_IjWAIIhNTfAQ>
    <xmx:uH5vXjuYkpKm5gxcYNeOPp9aeINbUxgUG2eCkEhnW2nnLp_dpk-9OQ>
    <xmx:uH5vXgOpOAZA-YXV1gKY9wySYLAymQWzyRR02CH1vi53b_FQK1kAkQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9D393061856;
        Mon, 16 Mar 2020 09:27:19 -0400 (EDT)
Date:   Mon, 16 Mar 2020 14:27:18 +0100
From:   Greg KH <greg@kroah.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19, 4.14, 4.9, 4.4 1/2] efi: Fix a race and a buffer
 overflow while reading efivars via sysfs
Message-ID: <20200316132718.GA3960435@kroah.com>
References: <20200316131938.31453-1-vdronov@redhat.com>
 <20200316131938.31453-2-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316131938.31453-2-vdronov@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 02:19:37PM +0100, Vladis Dronov wrote:
> commit 286d3250c9d6437340203fb64938bea344729a0e upstream.
> 
> There is a race and a buffer overflow corrupting a kernel memory while
> reading an EFI variable with a size more than 1024 bytes via the older
> sysfs method. This happens because accessing struct efi_variable in
> efivar_{attr,size,data}_read() and friends is not protected from
> a concurrent access leading to a kernel memory corruption and, at best,
> to a crash. The race scenario is the following:
> 
> CPU0:                                CPU1:
> efivar_attr_read()
>   var->DataSize = 1024;
>   efivar_entry_get(... &var->DataSize)
>     down_interruptible(&efivars_lock)
>                                      efivar_attr_read() // same EFI var
>                                        var->DataSize = 1024;
>                                        efivar_entry_get(... &var->DataSize)
>                                          down_interruptible(&efivars_lock)
>     virt_efi_get_variable()
>     // returns EFI_BUFFER_TOO_SMALL but
>     // var->DataSize is set to a real
>     // var size more than 1024 bytes
>     up(&efivars_lock)
>                                          virt_efi_get_variable()
>                                          // called with var->DataSize set
>                                          // to a real var size, returns
>                                          // successfully and overwrites
>                                          // a 1024-bytes kernel buffer
>                                          up(&efivars_lock)
> 
> This can be reproduced by concurrent reading of an EFI variable which size
> is more than 1024 bytes:
> 
>   ts# for cpu in $(seq 0 $(nproc --ignore=1)); do ( taskset -c $cpu \
>   cat /sys/firmware/efi/vars/KEKDefault*/size & ) ; done
> 
> Fix this by using a local variable for a var's data buffer size so it
> does not get overwritten.
> 
> Fixes: e14ab23dde12b80d ("efivars: efivar_entry API")
> Reported-by: Bob Sanders <bob.sanders@hpe.com> and the LTP testsuite
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20200305084041.24053-2-vdronov@redhat.com
> Link: https://lore.kernel.org/r/20200308080859.21568-24-ardb@kernel.org
> ---
>  drivers/firmware/efi/efivars.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> index 3e626fd9bd4e..c8688490f148 100644
> --- a/drivers/firmware/efi/efivars.c
> +++ b/drivers/firmware/efi/efivars.c
> @@ -139,13 +139,16 @@ static ssize_t
>  efivar_attr_read(struct efivar_entry *entry, char *buf)
>  {
>  	struct efi_variable *var = &entry->var;
> +	unsigned long size = sizeof(var->Data);
>  	char *str = buf;
> +	int ret;
>  
>  	if (!entry || !buf)
>  		return -EINVAL;
>  
> -	var->DataSize = 1024;
> -	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
> +	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
> +	var->DataSize = size;
> +	if (ret)
>  		return -EIO;
>  
>  	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
> @@ -172,13 +175,16 @@ static ssize_t
>  efivar_size_read(struct efivar_entry *entry, char *buf)
>  {
>  	struct efi_variable *var = &entry->var;
> +	unsigned long size = sizeof(var->Data);
>  	char *str = buf;
> +	int ret;
>  
>  	if (!entry || !buf)
>  		return -EINVAL;
>  
> -	var->DataSize = 1024;
> -	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
> +	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
> +	var->DataSize = size;
> +	if (ret)
>  		return -EIO;
>  
>  	str += sprintf(str, "0x%lx\n", var->DataSize);
> @@ -189,12 +195,15 @@ static ssize_t
>  efivar_data_read(struct efivar_entry *entry, char *buf)
>  {
>  	struct efi_variable *var = &entry->var;
> +	unsigned long size = sizeof(var->Data);
> +	int ret;
>  
>  	if (!entry || !buf)
>  		return -EINVAL;
>  
> -	var->DataSize = 1024;
> -	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
> +	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
> +	var->DataSize = size;
> +	if (ret)
>  		return -EIO;
>  
>  	memcpy(buf, var->Data, var->DataSize);
> @@ -314,14 +323,16 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
>  {
>  	struct efi_variable *var = &entry->var;
>  	struct compat_efi_variable *compat;
> +	unsigned long datasize = sizeof(var->Data);
>  	size_t size;
> +	int ret;
>  
>  	if (!entry || !buf)
>  		return 0;
>  
> -	var->DataSize = 1024;
> -	if (efivar_entry_get(entry, &entry->var.Attributes,
> -			     &entry->var.DataSize, entry->var.Data))
> +	ret = efivar_entry_get(entry, &var->Attributes, &datasize, var->Data);
> +	var->DataSize = datasize;
> +	if (ret)
>  		return -EIO;
>  
>  	if (is_compat()) {
> -- 
> 2.20.1
> 

This is already in all of my stable trees, did it need to be somehow
backported differently to 4.19 and older?

thanks,

greg k-h
