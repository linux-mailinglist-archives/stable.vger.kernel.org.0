Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DA1644315
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiLFMZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFMZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:25:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEE813F64;
        Tue,  6 Dec 2022 04:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11575B819EB;
        Tue,  6 Dec 2022 12:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BE0C433D6;
        Tue,  6 Dec 2022 12:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670329511;
        bh=Zhel367AShSXh2mO9nrfDUKNLZGOArG9Z2AeqVaLZnk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcPpQFSRjbwvEp6A+iUmGWPoV1QzMAAlZRyW0S3H2tawPpVrXOkFV3rfuPXNMPn8E
         Y14ZtHUn6mi+aAFqsBiJVZucTODmieiacAwty0OrEPOobJzxvUF2KdrxSqHMDiJi/r
         TFqkQWPf0lyh5hA5GpnVKrY52hvRQae4D4rm/wqI=
Date:   Tue, 6 Dec 2022 13:25:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dicheng Wang <wangdicheng123@hotmail.com>
Cc:     perex@perex.cz, tiwai@suse.com, sdoregor@sdore.me,
        connerknoxpublic@gmail.com, wangdicheng@kylinos.cn,
        hahnjo@hahnjo.de, john-linux@pelago.org.uk,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 -next] ALSA:usb-audio:Add the information of KT0206
 device driven by USB audio
Message-ID: <Y480pd/XynYddrHk@kroah.com>
References: <SG2PR02MB58780ED138433086A3213AE98A1B9@SG2PR02MB5878.apcprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SG2PR02MB58780ED138433086A3213AE98A1B9@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:36:37PM +0800, Dicheng Wang wrote:
> From: wangdicheng <wangdicheng@kylinos.cn>
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
> ---
> v2:use USB_DEVICE_VENDOR_SPEC() suggested by Takashi Iwai
> 
>  sound/usb/quirks-table.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 874fcf245747..271884e35003 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -76,6 +76,8 @@
>  { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f0a) },
>  /* E-Mu 0204 USB */
>  { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f19) },
> +/* Ktmicro Usb_audio device */
> +{ USB_DEVICE_VENDOR_SPEC(0x31b2, 0x0011) },
>  
>  /*
>   * Creative Technology, Ltd Live! Cam Sync HD [VF0770]
> -- 
> 2.25.1
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch contains warnings and/or errors noticed by the
  scripts/checkpatch.pl tool.

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

- It looks like you did not use your "real" name for the patch on either
  the Signed-off-by: line, or the From: line (both of which have to
  match).  Please read the kernel file, Documentation/SubmittingPatches
  for how to do this correctly.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
