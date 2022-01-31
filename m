Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F94B4A3E95
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 09:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343685AbiAaI3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 03:29:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60882 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiAaI3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 03:29:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F2D612C6
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 08:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B26C340E8;
        Mon, 31 Jan 2022 08:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643617746;
        bh=pzBBzUVblElYhohG6YAHECebGDWiecUp5NWhMIzTVc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pexQbDkBtqJwbMtfdwahwcdsKVZwctx4153Lme5sPhUCWsc0AyfFteK3c657Cdgs8
         zdxxDdTugbhJIiAxTLhpYS+HvZ2FgHRT/0/McclZryA54HEXmbrmJApgM+XQnYNfYW
         vAY0m+xzhrD2xhQUF6zJrxPLOJTXUZ7hofkM4JPY=
Date:   Mon, 31 Jan 2022 07:40:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Albert Geanta <albertgeanta@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek: Add quirk for ASUS GU603
Message-ID: <YfeETp1AKeek7zwj@kroah.com>
References: <20220131010523.546386-1-albertgeanta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220131010523.546386-1-albertgeanta@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 03:05:23AM +0200, Albert Geanta wrote:
> The ASUS GU603 (Zephyrus M16 - SSID 1043:16b2) requires a quirk similar to
> other ASUS devices for correctly routing the 4 integrated speakers. This
> fixes it by adding a corresponding quirk entry, which connects the bass
> speakers to the proper DAC.
> 
> Signed-off-by: Albert Geantă <albertgeanta@gmail.com>
> ---
>  sound/pci/hda/patch_realtek.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index 668274e52674..61b314c7dbc9 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -8969,6 +8969,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
>  	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
>  	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
>  	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
> +	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
>  	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
>  	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
>  	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),
> -- 
> 2.35.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
