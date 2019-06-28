Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A917593D4
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 07:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfF1FyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 01:54:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53208 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfF1FyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 01:54:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 83E75607B9; Fri, 28 Jun 2019 05:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561701259;
        bh=x9RisAVUfvk62Lv/TAzoribJc0J8BQpLPnAwsNTP0lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1oGPaVL68JZopMaDRpR84+NtuC9kmK5W1WaGjm45kwNviMIbKRzkkS8Rd7CmR6g0
         yzHfUmG2qp0WnMR6dohvCjhqE8BPafWzNFpzwcYMjvYnQCUhZmM7IYr9++wIiD8OyD
         iQey9vUdNNoq/VdQ3kpmu+4uKN6sNUPjjcK0D5Ec=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 853C9607C3;
        Fri, 28 Jun 2019 05:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561701258;
        bh=x9RisAVUfvk62Lv/TAzoribJc0J8BQpLPnAwsNTP0lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o+gGUTqs6hqZ8a6zvemY0qG+QBWrHHtauKP9nLFJrOP1WP3Cyvbb9GY2yKREeBmvL
         Ah3dtBEwsm0F8pItBZk7Nzh6pxN7bfaz4XgEQHboB43VfWkRertYdl2cbVcC9EVmAz
         jthIzXb7/PZHo40RLiD6czVNWE8+aoPHoF4HFKMU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 853C9607C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jackp@codeaurora.org
Date:   Thu, 27 Jun 2019 22:54:14 -0700
From:   Jack Pham <jackp@codeaurora.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 4.19.y 8/9] Revert "usb: dwc3: gadget: Clear
 req->needs_extra_trb flag on cleanup"
Message-ID: <20190628055414.GA3380@jackp-linux.qualcomm.com>
References: <20190627205240.38366-1-john.stultz@linaro.org>
 <20190627205240.38366-9-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627205240.38366-9-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John,

On Thu, Jun 27, 2019 at 08:52:39PM +0000, John Stultz wrote:
> This reverts commit 25ad17d692ad54c3c33b2a31e5ce2a82e38de14e,
> as with other patches backported to -stable, we can now apply
> the actual upstream commit that matches this.
> 
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Sam Protsenko <semen.protsenko@linaro.org>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: linux-usb@vger.kernel.org
> Cc: stable@vger.kernel.org # 4.19.y
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/usb/dwc3/gadget.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 879f652c5580..843586f20572 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -177,8 +177,6 @@ static void dwc3_gadget_del_and_unmap_request(struct dwc3_ep *dep,
>  	req->started = false;
>  	list_del(&req->list);
>  	req->remaining = 0;
> -	req->unaligned = false;
> -	req->zero = false;

Given that these structure members are removed in Patch 1/9, wouldn't
having these lines remain until this revert patch present compilation
errors when applying the patches in this series individually?

For bisectability would it be better to fix-up Patch 1 to also convert
these two flags to req->needs_extra_trb in one shot? Alternatively you
could sandwich Patch 1 between Patch 8 & 9.

Thanks,
Jack
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
