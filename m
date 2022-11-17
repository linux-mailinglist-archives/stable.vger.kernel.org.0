Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E571B62DA15
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 13:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiKQMBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 07:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiKQMBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 07:01:11 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B8228729;
        Thu, 17 Nov 2022 04:01:10 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id a6so1284004vsc.5;
        Thu, 17 Nov 2022 04:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HBt8DUE3xpm3UcQFvGVPGZx2MhTcfsoY3gAkEK/8Wf8=;
        b=QjyhNjW80NVWL/lOz+SS3leVzo7NyiaXDJVo8kceK9mWHhVjmrue29+e/mGzcVDgDB
         GKOUph429uqyuyYNnW6HWM9BMmcnC7YmDXvkZu1P+bum8p0M3581aUUj0VYQJrlaz9X7
         4cNaf5RdYczDKVfEUrETPU0vlRQpGoDsQQPSwJnHV9Yj5X2nGMxQF7sl8M3+VqCuM0oE
         LTcOcRE+EAqjGr8OL37NBxYxm4OLVZWmI6NNQbRVwJzoZdrNzl1pANMY4jK5vemvr0Uo
         aieHd79W6fhAGRqJzBQDeJH7L1He9N3NB1EMIOeauBRXHVjiLoVFuBpOFiUaD6TCe841
         5Wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HBt8DUE3xpm3UcQFvGVPGZx2MhTcfsoY3gAkEK/8Wf8=;
        b=skXuoiTNwxftzIY2Aosw6aS2DoT05bna4usQvvbheZCyVCjCGQ5gKI0wfPd5uLqrsl
         NAfqbeAnxGOmCUePDXJYZfWmgC93wgs4esdP/6HjbTEDyFiPdsRQo0uJgYgs8WL4gMRy
         sLcPgdp0oRdfBF4HGFRf7Km/aVlbNW9MVlJ+v0QPDU9OiIBkwBLjxDOWgCjIVy4ohIrd
         ADuoQqlVjFc+pVdXaqSAuHElsB+YXlN1RWwmV8hcjmjkUX4f8zB0wK0+869yNV51JegV
         a+UWeHXvwsLEtKOc++pkkHNvrny7AZ7OjbNpCp5NfdEQGfptVJLEr9X8ah3xCytl2npz
         /AXw==
X-Gm-Message-State: ANoB5pluJWK7equR3p+k11d1eRI7AXaMDrB3FaXuytmCjThP/j5APMPl
        2Yfj879WXWw/5apDzWznIf3v/LfVQ3HP8/yPPe0=
X-Google-Smtp-Source: AA0mqf7YJOFWKiWLY57JD/Q1OmjIAGhJtBpJbVqZ3q1Oh9sn7GRcRB6FXVUQzqZ4Wt+7NNl5GwV1929V/KdLcRcXijI=
X-Received: by 2002:a05:6102:11f1:b0:3a6:fde0:cf74 with SMTP id
 e17-20020a05610211f100b003a6fde0cf74mr1364150vsg.73.1668686469693; Thu, 17
 Nov 2022 04:01:09 -0800 (PST)
MIME-Version: 1.0
References: <20221115100039.441295-1-pawell@cadence.com>
In-Reply-To: <20221115100039.441295-1-pawell@cadence.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Thu, 17 Nov 2022 20:00:00 +0800
Message-ID: <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
Subject: Re: [PATCH] usb: cdns3: remove fetched trb from cache before dequeuing
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, felipe.balbi@linux.intel.com,
        rogerq@kernel.org, a-govindraju@ti.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 6:01 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> After doorbell DMA fetches the TRB. If during dequeuing request
> driver changes NORMAL TRB to LINK TRB but doesn't delete it from
> controller cache then controller will handle cached TRB and packet
> can be lost.
>
> The example scenario for this issue looks like:
> 1. queue request - set doorbell
> 2. dequeue request
> 3. send OUT data packet from host
> 4. Device will accept this packet which is unexpected
> 5. queue new request - set doorbell
> 6. Device lost the expected packet.
>
> By setting DFLUSH controller clears DRDY bit and stop DMA transfer.
>
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdns3-gadget.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
> index 5adcb349718c..ccfaebca6faa 100644
> --- a/drivers/usb/cdns3/cdns3-gadget.c
> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> @@ -2614,6 +2614,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
>         u8 req_on_hw_ring = 0;
>         unsigned long flags;
>         int ret = 0;
> +       int val;
>
>         if (!ep || !request || !ep->desc)
>                 return -EINVAL;
> @@ -2649,6 +2650,13 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
>
>         /* Update ring only if removed request is on pending_req_list list */
>         if (req_on_hw_ring && link_trb) {
> +               /* Stop DMA */
> +               writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
> +
> +               /* wait for DFLUSH cleared */
> +               readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val,
> +                                         !(val & EP_CMD_DFLUSH), 1, 1000);
> +
>                 link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma +
>                         ((priv_req->end_trb + 1) * TRB_SIZE)));
>                 link_trb->control = cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) |
> @@ -2660,6 +2668,10 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
>
>         cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
>
> +       req = cdns3_next_request(&priv_ep->pending_req_list);
> +       if (req)
> +               cdns3_rearm_transfer(priv_ep, 1);
> +

Why the above changes are needed?

Peter

>  not_found:
>         spin_unlock_irqrestore(&priv_dev->lock, flags);
>         return ret;
> --
> 2.25.1
>
