Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071A477F41
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 13:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfG1Lbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 07:31:48 -0400
Received: from mail.seal-one.com ([194.9.72.89]:50200 "EHLO mail.seal-one.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfG1Lbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 07:31:47 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jul 2019 07:31:46 EDT
Received: from [IPv6:2003:de:270b:7300:e034:e169:5dd0:2055] (p200300DE270B7300E034E1695DD02055.dip0.t-ipconnect.de [IPv6:2003:de:270b:7300:e034:e169:5dd0:2055])
        by mail.seal-one.com (Postfix) with ESMTPSA id 2491420010D;
        Sun, 28 Jul 2019 13:25:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=seal-one.com; s=mail;
        t=1564313134; bh=wuxfDWbOGZdH206sGEQEAbvHWiTRDIw4hF2AfTBysR8=;
        h=From:Subject:Date:In-Reply-To:Cc:To:References:From;
        b=lTW0GOfFjzdIz2GRG0/IB/zG/XotVT1PRI3FEUuVovOOq7PlJgl0sALOLlvwCU/u9
         OCDqJkE2g6A969FlGhPt7aIrEh1Gk7S5lek7bb59j+t6czPygO/9JDSV8rbeyCc9Qc
         eLycHEyc61xjN2ykawTJJSVY4tlqMKhVWMnC+nLg=
From:   Maik Stohn <maik.stohn@seal-one.com>
Message-Id: <0430A0F6-6777-4EC3-B0D6-BBAF3AAF900C@seal-one.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_68DBF42D-5993-40BB-950C-DF32CC59DA04";
        protocol="application/pkcs7-signature";
        micalg=sha-256
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: patch "xhci: Fix crash if scatter gather is used with Immediate
 Data" added to usb-linus
Date:   Sun, 28 Jul 2019 13:25:32 +0200
In-Reply-To: <1564046825237139@kroah.com>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        nsaenzjulienne@suse.de, stable@vger.kernel.org
To:     Greg KH <gregkh@linuxfoundation.org>
References: <1564046825237139@kroah.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Virus-Scanned: clamav-milter 0.100.3 at mail.seal-one.com
X-Virus-Status: Clean
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_68DBF42D-5993-40BB-950C-DF32CC59DA04
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello Greg,

Sorry to trouble you again.

I was waiting and observing how the FIX is applied and it looks like it =
will not be applied to 5.2.x (5.2.3 and 5.2.4 came out without this =
patch).
Personally I think it is a big mistake not to merge the fix but this is =
your decision.=20

I have to tell my users now to AVOID KERNEL 5.2 at all since it is buggy =
and most likely will never be fixed.

But since it is also not part of any 5.3 (right now) I'm a bit afraid I =
also need to put a warning to avoid 5.3 as well.

Would be nice to get an official statement like: "Linux kernel will not =
merge the USB fix to 5.2, maybe 5.3 will have it, but better wait for =
5.4",
so I can quote this to my users.


Best Regards,

Maik Stohn

> Am 25.07.2019 um 11:27 schrieb gregkh@linuxfoundation.org:
>=20
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>    xhci: Fix crash if scatter gather is used with Immediate Data
>=20
> to my usb git tree which can be found at
>    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> in the usb-linus branch.
>=20
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>=20
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
>=20
> If you have any questions about this process, please let me know.
>=20
>=20
> =46rom d39b5bad8658d6d94cb2d98a44a7e159db4f5030 Mon Sep 17 00:00:00 =
2001
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> Date: Thu, 25 Jul 2019 11:54:21 +0300
> Subject: xhci: Fix crash if scatter gather is used with Immediate Data
> Transfer (IDT).
>=20
> A second regression was found in the immediate data transfer (IDT)
> support which was added to 5.2 kernel
>=20
> IDT is used to transfer small amounts of data (up to 8 bytes) in the
> field normally used for data dma address, thus avoiding dma mapping.
>=20
> If the data was not already dma mapped, then IDT support assumed data =
was
> in urb->transfer_buffer, and did not take into accound that even
> small amounts of data (8 bytes) can be in a scatterlist instead.
>=20
> This caused a NULL pointer dereference when sg_dma_len() was used
> with non-dma mapped data.
>=20
> Solve this by not using IDT if scatter gather buffer list is used.
>=20
> Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
> Cc: <stable@vger.kernel.org> # v5.2
> Reported-by: Maik Stohn <maik.stohn@seal-one.com>
> Tested-by: Maik Stohn <maik.stohn@seal-one.com>
> CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link: =
https://lore.kernel.org/r/1564044861-1445-1-git-send-email-mathias.nyman@l=
inux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> drivers/usb/host/xhci.h | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 7a264962a1a9..f5c41448d067 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -2175,7 +2175,8 @@ static inline bool =
xhci_urb_suitable_for_idt(struct urb *urb)
> 	if (!usb_endpoint_xfer_isoc(&urb->ep->desc) && =
usb_urb_dir_out(urb) &&
> 	    usb_endpoint_maxp(&urb->ep->desc) >=3D TRB_IDT_MAX_SIZE &&
> 	    urb->transfer_buffer_length <=3D TRB_IDT_MAX_SIZE &&
> -	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
> +	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP) &&
> +	    !urb->num_sgs)
> 		return true;
>=20
> 	return false;
> --=20
> 2.22.0
>=20
>=20


--Apple-Mail=_68DBF42D-5993-40BB-950C-DF32CC59DA04
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

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
AAAAAA==
--Apple-Mail=_68DBF42D-5993-40BB-950C-DF32CC59DA04--
