Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3796A6145F2
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 09:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKAIsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 04:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAIsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 04:48:30 -0400
X-Greylist: delayed 348 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 01:48:28 PDT
Received: from chronos.abteam.si (chronos.abteam.si [46.4.99.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D04F13DE9;
        Tue,  1 Nov 2022 01:48:27 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by chronos.abteam.si (Postfix) with ESMTP id 611F05D000A6;
        Tue,  1 Nov 2022 09:42:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bstnet.org; h=
        content-transfer-encoding:content-type:content-type:in-reply-to
        :from:from:content-language:references:subject:subject
        :user-agent:mime-version:date:date:message-id; s=default; t=
        1667292156; x=1669106557; bh=orYPDonopnYWnk6KNpWogha3A6MFzQO5b8n
        13W0ne5c=; b=T/HCgOCtyy1/43tBkBG/wrh4kCnAotRCtT5BIY5+hHrWWDwQZ5S
        Dsjh0eBQLYzIo7TVFQxVFwHiKYVpbEWWr1KtutULUD6urokKp0UzHk8W6K2OWwKU
        /mpn+9T12hR6Do5tm5x4LC3EVvg0buHm/lxAl4taY9Diw6Cw8kNnSA6I=
X-Virus-Scanned: Debian amavisd-new at chronos.abteam.si
Received: from chronos.abteam.si ([127.0.0.1])
        by localhost (chronos.abteam.si [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id TQGiW9kMgI9y; Tue,  1 Nov 2022 09:42:36 +0100 (CET)
Received: from [IPV6:2a00:ee2:4d00:602:9f2b:eb04:ae5e:7a5f] (unknown [IPv6:2a00:ee2:4d00:602:9f2b:eb04:ae5e:7a5f])
        (Authenticated sender: boris@abteam.si)
        by chronos.abteam.si (Postfix) with ESMTPSA id B4FC85D000A3;
        Tue,  1 Nov 2022 09:42:35 +0100 (CET)
Message-ID: <ba4caf7a-9e1f-d5fb-f20c-dba81dc00c06@bstnet.org>
Date:   Tue, 1 Nov 2022 09:42:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 6.0 20/20] fbdev/core: Remove
 remove_conflicting_pci_framebuffers()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20221024112934.415391158@linuxfoundation.org>
 <20221024112935.205547130@linuxfoundation.org>
Content-Language: en-US
From:   "Boris V." <borisvk@bstnet.org>
In-Reply-To: <20221024112935.205547130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,NO_DNS_FOR_FROM,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/10/2022 13:31, Greg Kroah-Hartman wrote:
> From: Thomas Zimmermann <tzimmermann@suse.de>
>
> commit 9d69ef1838150c7d87afc1a87aa658c637217585 upstream.
>
> Remove remove_conflicting_pci_framebuffers() and implement similar
> functionality in aperture_remove_conflicting_pci_device(), which was
> the only caller. Removes an otherwise unused interface and streamlines
> the aperture helper. No functional changes.
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220718072322.8927-5-tzimmermann@suse.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/video/aperture.c         |   30 ++++++++++++++----------
>   drivers/video/fbdev/core/fbmem.c |   48 ---------------------------------------
>   include/linux/fb.h               |    2 -
>   3 files changed, 18 insertions(+), 62 deletions(-)
>
> --- a/drivers/video/aperture.c
> +++ b/drivers/video/aperture.c
> @@ -335,30 +335,36 @@ EXPORT_SYMBOL(aperture_remove_conflictin
>    */
>   int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *name)
>   {
> +	bool primary = false;
>   	resource_size_t base, size;
>   	int bar, ret;
>   
> -	/*
> -	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
> -	 * otherwise the vga fbdev driver falls over.
> -	 */
> -#if IS_REACHABLE(CONFIG_FB)
> -	ret = remove_conflicting_pci_framebuffers(pdev, name);
> -	if (ret)
> -		return ret;
> +#ifdef CONFIG_X86
> +	primary = pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
>   #endif
> -	ret = vga_remove_vgacon(pdev);
> -	if (ret)
> -		return ret;
>   
>   	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
>   		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>   			continue;
> +
>   		base = pci_resource_start(pdev, bar);
>   		size = pci_resource_len(pdev, bar);
> -		aperture_detach_devices(base, size);
> +		ret = aperture_remove_conflicting_devices(base, size, primary, name);
> +		if (ret)
> +			break;
>   	}
>   
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
> +	 * otherwise the vga fbdev driver falls over.
> +	 */
> +	ret = vga_remove_vgacon(pdev);
> +	if (ret)
> +		return ret;
> +
>   	return 0;
>   
>   }
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -1788,54 +1788,6 @@ int remove_conflicting_framebuffers(stru
>   EXPORT_SYMBOL(remove_conflicting_framebuffers);
>   
>   /**
> - * remove_conflicting_pci_framebuffers - remove firmware-configured framebuffers for PCI devices
> - * @pdev: PCI device
> - * @name: requesting driver name
> - *
> - * This function removes framebuffer devices (eg. initialized by firmware)
> - * using memory range configured for any of @pdev's memory bars.
> - *
> - * The function assumes that PCI device with shadowed ROM drives a primary
> - * display and so kicks out vga16fb.
> - */
> -int remove_conflicting_pci_framebuffers(struct pci_dev *pdev, const char *name)
> -{
> -	struct apertures_struct *ap;
> -	bool primary = false;
> -	int err, idx, bar;
> -
> -	for (idx = 0, bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
> -		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
> -			continue;
> -		idx++;
> -	}
> -
> -	ap = alloc_apertures(idx);
> -	if (!ap)
> -		return -ENOMEM;
> -
> -	for (idx = 0, bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
> -		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
> -			continue;
> -		ap->ranges[idx].base = pci_resource_start(pdev, bar);
> -		ap->ranges[idx].size = pci_resource_len(pdev, bar);
> -		pci_dbg(pdev, "%s: bar %d: 0x%lx -> 0x%lx\n", __func__, bar,
> -			(unsigned long)pci_resource_start(pdev, bar),
> -			(unsigned long)pci_resource_end(pdev, bar));
> -		idx++;
> -	}
> -
> -#ifdef CONFIG_X86
> -	primary = pdev->resource[PCI_ROM_RESOURCE].flags &
> -					IORESOURCE_ROM_SHADOW;
> -#endif
> -	err = remove_conflicting_framebuffers(ap, name, primary);
> -	kfree(ap);
> -	return err;
> -}
> -EXPORT_SYMBOL(remove_conflicting_pci_framebuffers);
> -
> -/**
>    *	register_framebuffer - registers a frame buffer device
>    *	@fb_info: frame buffer info structure
>    *
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -615,8 +615,6 @@ extern ssize_t fb_sys_write(struct fb_in
>   /* drivers/video/fbmem.c */
>   extern int register_framebuffer(struct fb_info *fb_info);
>   extern void unregister_framebuffer(struct fb_info *fb_info);
> -extern int remove_conflicting_pci_framebuffers(struct pci_dev *pdev,
> -					       const char *name);
>   extern int remove_conflicting_framebuffers(struct apertures_struct *a,
>   					   const char *name, bool primary);
>   extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
>
>
>
>

Hello,

this patch seems to disable console/framebuffer when vfio-pci is used.
I hava 2 nvidia GPUs one is used for host and other is passed through to VM.
Now after this patch, when vfio-pci module is loaded with parameter 
ids=10de:2486,10de:228b,
console is lost/frozen, last message is that vfio-pci module was loaded 
and then there is no more output.
This PCI IDs (10de:2486,10de:228b) are for secondary GPU, primary/boot 
GPU is used for host and boot messages are displayed on primary/boot GPU.

Using dmesg I see this messages after vfio-pci is loaded:

[    3.993601] VFIO - User Level meta-driver version: 0.3
[    4.020239] Console: switching to colour dummy device 80x25
[    4.020335] vfio-pci 0000:1a:00.0: vgaarb: changed VGA decodes: 
olddecodes=io+mem,decodes=none:owns=none
[    4.020722] vfio_pci: add [10de:2486[ffffffff:ffffffff]] class 
0x000000/00000000
[    4.116616] vfio_pci: add [10de:228b[ffffffff:ffffffff]] class 
0x000000/00000000

I guess the problem here is "Console: switching to colour dummy device 
80x25", but I don't know why this happens.
Last working kernel is 6.0.3, after upgrading to 6.0.4 (and 6.0.5, 
6.0.6), console is no longer working.
By git bisecting it seems bad commit is 
af9ac541e88390d97b01d5e8c77309d2637c1d4c.

