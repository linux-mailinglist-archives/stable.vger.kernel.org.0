Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3751C5026
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 10:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgEEIVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 04:21:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:64275 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEIVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 04:21:30 -0400
IronPort-SDR: 2cvwDrCknwWzSM4z8qGNa8cItZHzAgskZ7ZAtXExpInBTlT5yjvoqRUgku/NfNDDlcjiFO8pPP
 r0VH41nf6Kzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 01:21:29 -0700
IronPort-SDR: uALX4vBNqI6oR7zVVgMuwTZ31VgSAujfozQ1cBn9Lwlusex1nz6z5N0Xvshz+57bUnRztvAYqU
 +4PaxwDnXeAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="259616754"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga003.jf.intel.com with ESMTP; 05 May 2020 01:21:27 -0700
Subject: Re: [PATCH] usb: xhci: Fix NULL pointer dereference as part of
 completion
To:     Sriharsha Allenki <sallenki@codeaurora.org>,
        mathias.nyman@intel.com, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, mgautam@codeaurora.org,
        jackp@codeaurora.org, stable@vger.kernel.org
References: <20200505061446.21850-1-sallenki@codeaurora.org>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=mathias.nyman@linux.intel.com; prefer-encrypt=mutual; keydata=
 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 fiD/
Message-ID: <a4942ed2-848c-8f4d-d181-86c2456319d3@linux.intel.com>
Date:   Tue, 5 May 2020 11:24:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200505061446.21850-1-sallenki@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5.5.2020 9.14, Sriharsha Allenki wrote:
> On platforms with IOMMU enabled, multiple SGs can be
> coalesced into one by the IOMMU driver. In that case
> the SG list processing as part of the completion of
> a urb on a bulk endpoint can result into a NULL pointer
> dereference with the below stack dump.
> 
> <6> Unable to handle kernel NULL pointer dereference at virtual address 0000000c
> <6> pgd = c0004000
> <6> [0000000c] *pgd=00000000
> <6> Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> <2> PC is at xhci_queue_bulk_tx+0x454/0x80c
> <2> LR is at xhci_queue_bulk_tx+0x44c/0x80c
> <2> pc : [<c08907c4>]    lr : [<c08907bc>]    psr: 000000d3
> <2> sp : ca337c80  ip : 00000000  fp : ffffffff
> <2> r10: 00000000  r9 : 50037000  r8 : 00004000
> <2> r7 : 00000000  r6 : 00004000  r5 : 00000000  r4 : 00000000
> <2> r3 : 00000000  r2 : 00000082  r1 : c2c1a200  r0 : 00000000
> <2> Flags: nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
> <2> Control: 10c0383d  Table: b412c06a  DAC: 00000051
> <6> Process usb-storage (pid: 5961, stack limit = 0xca336210)
> <snip>
> <2> [<c08907c4>] (xhci_queue_bulk_tx)
> <2> [<c0881b3c>] (xhci_urb_enqueue)
> <2> [<c0831068>] (usb_hcd_submit_urb)
> <2> [<c08350b4>] (usb_sg_wait)
> <2> [<c089f384>] (usb_stor_bulk_transfer_sglist)
> <2> [<c089f2c0>] (usb_stor_bulk_srb)
> <2> [<c089fe38>] (usb_stor_Bulk_transport)
> <2> [<c089f468>] (usb_stor_invoke_transport)
> <2> [<c08a11b4>] (usb_stor_control_thread)
> <2> [<c014a534>] (kthread)
> 
> The above NULL pointer dereference is the result of block_len and
> the sent_len set to zero after the first SG of the list when IOMMU
> driver is enabled. Because of this the loop of processing the SGs
> has run more than num_sgs which resulted in a sg_next on the
> last SG of the list which has SG_END set.
> 
> Fix this by check for the sg before any attributes of the sg are
> accessed.
> 
> Fixes: f9c589e142d04 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
> ---
>  drivers/usb/host/xhci-ring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index a78787bb5133..18141b38f7bf 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -3399,8 +3399,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  			/* New sg entry */
>  			--num_sgs;
>  			sent_len -= block_len;
> -			if (num_sgs != 0) {
> -				sg = sg_next(sg);
> +			sg = sg_next(sg);
> +			if (num_sgs != 0 && sg) {
>  				block_len = sg_dma_len(sg);
>  				addr = (u64) sg_dma_address(sg);
>  				addr += sent_len;
> 

Nice catch, thanks.

Adding to queue.

-Mathias
