Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA184A535E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 00:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiAaXjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 18:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiAaXjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 18:39:11 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A179C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 15:39:11 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id 15so12842683ilg.8
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 15:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QRhzaY4xOMHO1aRFcH8wJ6cIO/T9oQW4cmxNBT1EMac=;
        b=WlG63XAKnnMjs2RqhkaUD1BFgLNKk9wln6ARJM5o/dDwkiwy+d/G/NRYGSW4COTHh0
         8CtPg8w7EvEUa+pYOVg7+EMiuiMjXEKN3nir1xTA9l9bHUSuTkZDSApDk1gbWnl07brb
         WXNZTH2GwqfOb7g+tMa5X7SBY5W5sk3POZ/wihMq6rWTVpIxow2be3LbUjmbs0a9FPkN
         FdjcezOXLhZzu+5fqo1nb2nlHCrkvUG/UPVZBUIUqNAhqy0G+tsHrDxoEIqC0OzOZh/z
         NULPcwQyxagePXc6mY/P1otSNmLQjGsPvENHuLdrFwqg0ScTtbeby9a0Sb/azPnsl496
         NqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QRhzaY4xOMHO1aRFcH8wJ6cIO/T9oQW4cmxNBT1EMac=;
        b=kXU/m2hf081OoYa+chsumkP0ncfH3zRRwXxCqjZKB2asoI4wdJmM5xdk6aA+lijJ4b
         KcKmd6oXj3OZMeIKVaF6xv+vtoRrQpI3r+olJnjiyOxjf0UcTFRwiGjVBbKf3OxB6Jb5
         a/NfT/3+VKRBI5WRd900SRubbY57WS04QwmDuiisU3jl57G3fbah8Sn4PQ1oopDLf9Vg
         iEL2wEgJHWXq0fGLGgw3qhmPZRZoHJQ+kACJ9BM4K0uhq2RYt+f0wmhW1rv3JBQd/8l5
         MlKaQW1edU+2/bumzIpBv/FZPMb8DYw8EjCvIRCK4jEZ9PUmlJ9vrw2K4XhKbxsz7PtN
         6RwQ==
X-Gm-Message-State: AOAM533euLPRg9wM7dLQFVxaQJx4a4fRCu/9t12clBKSSdWREIr6A6jb
        WiQ4XnWDO/f1SKsBqJdxW2E1N5Dgao2cLx6r
X-Google-Smtp-Source: ABdhPJxajGGfTIUJyWbMFeqZAXKEjw9UK6tTDD32KaeidrqjLG8MAY5pmSg75C+LazZOCRCImELUiw==
X-Received: by 2002:a92:2811:: with SMTP id l17mr5223447ilf.311.1643672350111;
        Mon, 31 Jan 2022 15:39:10 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id u17sm7817531ilk.49.2022.01.31.15.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:39:09 -0800 (PST)
Message-ID: <d1ed0879-0555-254e-7255-d6442bf940c3@linaro.org>
Date:   Mon, 31 Jan 2022 17:39:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: FAILED: patch "[PATCH] net: ipa: prevent concurrent replenish"
 failed to apply to 5.16-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, davem@davemloft.net
Cc:     stable@vger.kernel.org
References: <1643031462146216@kroah.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <1643031462146216@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 7:37 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Sorry about that.

Unfortunately, the commit in question:

   998c0bd2b3715 net: ipa: prevent concurrent replenish


has one predecessor commit as a prerequisite:

   c1aaa01dbf4ce net: ipa: use a bitmap for endpoint replenish_enabled


I find that I can cleanly cherry-pick the two commits on top of
tag "v5.16.4" cleanly.  I.e.:

   git reset --hard v5.16.4
   git cherry-pick -x c1aaa01dbf4ce 998c0bd2b3715


Is that an adequate solution?  If not, I can supply patches that
do essentially that.

This works on tag "v5.15.18" as well.

Doing this does *not* work on v5.10.95, and I'm working on a
resolution for that and one other back-port that failed.

Thanks.

					-Alex



> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 998c0bd2b3715244da7639cc4e6a2062cb79c3f4 Mon Sep 17 00:00:00 2001
> From: Alex Elder <elder@linaro.org>
> Date: Wed, 12 Jan 2022 07:30:12 -0600
> Subject: [PATCH] net: ipa: prevent concurrent replenish
> 
> We have seen cases where an endpoint RX completion interrupt arrives
> while replenishing for the endpoint is underway.  This causes another
> instance of replenishing to begin as part of completing the receive
> transaction.  If this occurs it can lead to transaction corruption.
> 
> Use a new flag to ensure only one replenish instance for an endpoint
> executes at a time.
> 
> Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
> Signed-off-by: Alex Elder <elder@linaro.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index cddddcedaf72..68291a3efd04 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -1088,15 +1088,27 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
>   		return;
>   	}
>   
> +	/* If already active, just update the backlog */
> +	if (test_and_set_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags)) {
> +		if (add_one)
> +			atomic_inc(&endpoint->replenish_backlog);
> +		return;
> +	}
> +
>   	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
>   		if (ipa_endpoint_replenish_one(endpoint))
>   			goto try_again_later;
> +
> +	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
> +
>   	if (add_one)
>   		atomic_inc(&endpoint->replenish_backlog);
>   
>   	return;
>   
>   try_again_later:
> +	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
> +
>   	/* The last one didn't succeed, so fix the backlog */
>   	delta = add_one ? 2 : 1;
>   	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
> @@ -1691,6 +1703,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
>   		 * backlog is the same as the maximum outstanding TREs.
>   		 */
>   		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
> +		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
>   		atomic_set(&endpoint->replenish_saved,
>   			   gsi_channel_tre_max(gsi, endpoint->channel_id));
>   		atomic_set(&endpoint->replenish_backlog, 0);
> diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
> index 07d5c20e5f00..0313cdc607de 100644
> --- a/drivers/net/ipa/ipa_endpoint.h
> +++ b/drivers/net/ipa/ipa_endpoint.h
> @@ -44,10 +44,12 @@ enum ipa_endpoint_name {
>    * enum ipa_replenish_flag:	RX buffer replenish flags
>    *
>    * @IPA_REPLENISH_ENABLED:	Whether receive buffer replenishing is enabled
> + * @IPA_REPLENISH_ACTIVE:	Whether replenishing is underway
>    * @IPA_REPLENISH_COUNT:	Number of defined replenish flags
>    */
>   enum ipa_replenish_flag {
>   	IPA_REPLENISH_ENABLED,
> +	IPA_REPLENISH_ACTIVE,
>   	IPA_REPLENISH_COUNT,	/* Number of flags (must be last) */
>   };
>   
> 

