Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E33F396764
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 19:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhEaRti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 13:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbhEaRtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 13:49:23 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1329C074B02
        for <stable@vger.kernel.org>; Mon, 31 May 2021 10:28:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z4so5518275plg.8
        for <stable@vger.kernel.org>; Mon, 31 May 2021 10:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ultZWLSJXHjD/NDoDi7dRR5xSSmHzfIKA0oXYNi9NUE=;
        b=zokO7hme+4avv5q6TaA4Luwpm6oKkm7dtD0IdrdHEG+5VOxtO7H4SINbiPiNmfqrn3
         YVrhPwG4obBtb9OT3JfaA3DyTu93m5UDC3BfzVETWZDH5oK2HmKxtkEoEXbzAQFFsF1x
         ODEXS5HVGdUVACAeTZ/qmObhT1+fCRnQHwKnHj18Ovb7lvtKYSBVkIhrP1saxOIUlC7J
         OUBQdpkWAD0ltZa4Er0iTvzs4pTuozbVVHJshVGhxz8BGBOtdAxi3iA5M+Mhihqtb/Fu
         FVPpIEu2Fu1msS7CBUJfkHO+1HCglRnZI7R0XI2F5w+5fx3Zu+Ez4Pos1f+dtsxEdGfc
         2UYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ultZWLSJXHjD/NDoDi7dRR5xSSmHzfIKA0oXYNi9NUE=;
        b=H0ZJ4Rw0lzZEB+r22NoS+qNVxZjtTcc78HFDPQTolNAvh+eHw/DEXZXTq/gkCBuMA8
         B0VVz1s9QvxMbrdS22/E8GPiiuibp4QHBxsllPa34+ZNbqPtQR8AI3VboeVfLpz8kWtH
         YSS4hJ08DKsMu1UZPm9bkZ4XF7OkJ3+pLBAfAmxKX632HQiZYjFCOPmee7OCv/voXT8E
         uVDqoI6jT7Ksl2Jcna2ILukXLsViFBlpBWdETXoit3CtZP/OQaZPqtWh+1SpstkfrvDN
         ue5x4+AbbOJ3MWghn4REcV9zzEA8bx8FlBDZ1fNVgXXxqsIR4TcZW8f3PEogByvpXvpS
         MTPA==
X-Gm-Message-State: AOAM532FSom8giLHb4qe97hemS5B50VLIt2tgB2BWQqRTBTrj7IueW6q
        aGbVEh0AbTe8LeNkkUDzBIm16A==
X-Google-Smtp-Source: ABdhPJx5m1UTqxTXcCJiV4/XDgn7iAKF8n00hou0oP4urgg3LcoNupGXr4tTVIPst6zP3b+rs9k+EA==
X-Received: by 2002:a17:90a:b28d:: with SMTP id c13mr202477pjr.80.1622482135140;
        Mon, 31 May 2021 10:28:55 -0700 (PDT)
Received: from x1 ([2601:1c0:4701:ae70:a449:bb:b7e3:9c7c])
        by smtp.gmail.com with ESMTPSA id g2sm3896526pfv.106.2021.05.31.10.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 10:28:54 -0700 (PDT)
Date:   Mon, 31 May 2021 10:28:52 -0700
From:   Drew Fustini <drew@beagleboard.org>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     Bin Liu <b-liu@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling
Message-ID: <20210531172852.GA706339@x1>
References: <20210528140446.278076-1-thomas.petazzoni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528140446.278076-1-thomas.petazzoni@bootlin.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 04:04:46PM +0200, Thomas Petazzoni wrote:
> In commit 92af4fc6ec33 ("usb: musb: Fix suspend with devices
> connected for a64"), the logic to support the
> MUSB_QUIRK_B_DISCONNECT_99 quirk was modified to only conditionally
> schedule the musb->irq_work delayed work.
> 
> This commit badly breaks ECM Gadget on AM335X. Indeed, with this
> commit, one can observe massive packet loss:
> 
> $ ping 192.168.0.100
> ...
> 15 packets transmitted, 3 received, 80% packet loss, time 14316ms
> 
> Reverting this commit brings back a properly functioning ECM
> Gadget. An analysis of the commit seems to indicate that a mistake was
> made: the previous code was not falling through into the
> MUSB_QUIRK_B_INVALID_VBUS_91, but now it is, unless the condition is
> taken.
> 
> Changing the logic to be as it was before the problematic commit *and*
> only conditionally scheduling musb->irq_work resolves the regression:
> 
> $ ping 192.168.0.100
> ...
> 64 packets transmitted, 64 received, 0% packet loss, time 64475ms
> 
> Fixes: 92af4fc6ec33 ("usb: musb: Fix suspend with devices connected for a64")
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/usb/musb/musb_core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 8f09a387b773..4c8f0112481f 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -2009,9 +2009,8 @@ static void musb_pm_runtime_check_session(struct musb *musb)
>  			schedule_delayed_work(&musb->irq_work,
>  					      msecs_to_jiffies(1000));
>  			musb->quirk_retries--;
> -			break;
>  		}
> -		fallthrough;
> +		break;
>  	case MUSB_QUIRK_B_INVALID_VBUS_91:
>  		if (musb->quirk_retries && !musb->flush_irq_work) {
>  			musb_dbg(musb,
> -- 
> 2.31.1

Tested-by: Drew Fustini <drew@beagleboard.org>

This patches fixes the problem on the BeagleBone Black (AM3358) where
the USB gadget interfaces would frequently reset. For example:

  configfs-gadget gadget: init rndis
  configfs-gadget gadget: RNDIS RX/TX early activation ...
  usb0: qlen 10
  configfs-gadget gadget: rndis_open
  rndis_set_param_medium: 0 4259840
  usb0: eth_start
  rndis_set_param_dev:
  configfs-gadget gadget: set_config: interface 2 (Mass Storage Function) requested delayed status
  configfs-gadget gadget: delayed_status count 1
  configfs-gadget gadget: reset ncm control 3
  configfs-gadget gadget: init ncm ctrl 3
  configfs-gadget gadget: notify speed 425984000
  configfs-gadget gadget: reset acm ttyGS0
  configfs-gadget gadget: activate acm ttyGS0
  configfs-gadget gadget: acm ttyGS0 serial state 0000
  configfs-gadget gadget: usb_composite_setup_continue
  configfs-gadget gadget: usb_composite_setup_continue: Completing delayed status
  configfs-gadget gadget: rndis req21.00 v0000 i0000 l24
  rndis_msg_parser: RNDIS_MSG_INIT
  configfs-gadget gadget: rndis reqa1.01 v0000 i0000 l1025
  configfs-gadget gadget: rndis req21.00 v0000 i0000 l32
  gen_ndis_query_resp: RNDIS_OID_GEN_PHYSICAL_MEDIUM
  configfs-gadget gadget: rndis reqa1.01 v0000 i0000 l1025
  configfs-gadget gadget: rndis req21.00 v0000 i0000 l76
  gen_ndis_query_resp: RNDIS_OID_802_3_PERMANENT_ADDRESS
  configfs-gadget gadget: rndis reqa1.01 v0000 i0000 l1025
  configfs-gadget gadget: rndis req21.00 v0000 i0000 l32
  gen_ndis_set_resp: RNDIS_OID_GEN_CURRENT_PACKET_FILTER 0000002d
  configfs-gadget gadget: rndis reqa1.01 v0000 i0000 l1025
  configfs-gadget gadget: init ncm
  configfs-gadget gadget: activate ncm
  usb1: qlen 10
  configfs-gadget gadget: ncm_open
  usb1: eth_start
  configfs-gadget gadget: reset ncm
  usb1: gether_disconnect
  configfs-gadget gadget: ncm reqa1.80 v0000 i0003 l28
  configfs-gadget gadget: non-CRC mode selected
  configfs-gadget gadget: ncm req21.8a v0000 i0003 l0
  configfs-gadget gadget: NCM16 selected
  configfs-gadget gadget: ncm req21.84 v0000 i0003 l0
  configfs-gadget gadget: init ncm
  configfs-gadget gadget: activate ncm
  usb1: qlen 10
  configfs-gadget gadget: ncm_open
  usb1: eth_start
  configfs-gadget gadget: acm ttyGS0 req21.20 v0000 i0005 l7
  configfs-gadget gadget: notify speed 425984000
  configfs-gadget gadget: notify connect true

I have posted dmesg log without the patch [1] where this happens often
and the dmesg log with the patch [2] where it does happen at all.

Thank you for fixing this!
Drew

[1] https://gist.github.com/pdp7/bd61e5f78545de182605992254d3eeee
[2] https://gist.github.com/pdp7/95b0f34fa1d423d4764984b400c562cf

