Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D448A439931
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 16:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhJYOvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 10:51:42 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:51470
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233664AbhJYOut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 10:50:49 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 12BCD3F320
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635173304;
        bh=LH+S+D+GBCzu9tGuajRTF5P0LpOZ1vWiDJ3BDbAqLVU=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=jQwyEy3ypLjpxbaeLC5qu1VL2fUCaIVSldhHDh2qRUI22l7T4NE5mCID9r5uAp/bM
         lYqxYgKlJL+NB0vxU3bPAvUDtaC/6Ge/2yO6AjjlyawN2fdUKJOlOFbimjQ2TfAI+9
         R2bwbB93409LjHWBSwzAuS6tLuFCKn5GeyuDjyMlvTzxWualPOEG2uPe8wX16UpDLf
         eUon/ictqi/cDDq0sVWeHabm6nKvU2AiN3CghrTqxTfkz72FG4ZMC0gvgdrGyPks9p
         8UPOPRvx7et14dy2K9JPNtMJnLYTNDe76H3Fh5GibFfQ+wmPvMmCDu/kLMQcAH7LFb
         nU7hoTKnQB2MQ==
Received: by mail-lj1-f199.google.com with SMTP id z20-20020a05651c023400b0021162ead40fso1957691ljn.10
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 07:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LH+S+D+GBCzu9tGuajRTF5P0LpOZ1vWiDJ3BDbAqLVU=;
        b=aXJdQ2xqHrvXYNfYgdfmzUdWgoLZtC6TMvpPY52toh4HXpO8KtcNttAkqSPOiMvHA/
         br5jW0K+jR7JEll9WYCG3rubjNF2jUDqgJDa30d62bGMtyeawdxcavg/Mx7b6AdM97BG
         g56sTjnjIO71Ev+bPqm884DeJTUZbZ6FE47PqWWiuwCeemtbpzojYLBxX3pcE4zh5LFM
         Ov9COFOIp0tmkJBYZ0Brs/Qy+AhvDNYN3NUDzwzTcQ87A0epjs+iQ5dujE/cMRV2I0JM
         GvtkbsML13OhNxEhp2lYGkt0kQ39+crLjvBBARN1b1Ws7S58pRg7b8GAJ+Rpxxq8NJet
         gubw==
X-Gm-Message-State: AOAM532Hg3w7LZdpBQx4gNKk547YXqKW7vAwrwg8Yc5NOW6on8F7oyAY
        Ucczr7rdifL7dKbXijCun4myBW9RfPsC2fHw7UmuMe2LasjpxOKvBAAZkuMMx6X3trlLYYCWMqf
        wvdCsfz9z3hHsNaqge2v47NLLxf1obpOZ5Q==
X-Received: by 2002:a05:6512:b97:: with SMTP id b23mr7435098lfv.50.1635173303256;
        Mon, 25 Oct 2021 07:48:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd6m499afz2jxS9BIn4Prm070HwxBO4wn8iB0xS8fXZQi09axQW2YeeTU0Wbfj4YyPtfX6Rw==
X-Received: by 2002:a05:6512:b97:: with SMTP id b23mr7435050lfv.50.1635173302733;
        Mon, 25 Oct 2021 07:48:22 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o5sm1667767lft.278.2021.10.25.07.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:48:22 -0700 (PDT)
Subject: Re: [PATCH] nfc: port100: fix using -ERRNO as command type mask
To:     Thierry Escande <thierry.escande@linux.intel.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211025144751.555551-1-krzysztof.kozlowski@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <42e958ae-7786-4d80-7491-6955e37a4f25@canonical.com>
Date:   Mon, 25 Oct 2021 16:48:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025144751.555551-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2021 16:47, Krzysztof Kozlowski wrote:
> During probing, the driver tries to get a list (mask) of supported
> command types in port100_get_command_type_mask() function.  The value
> is u64 and 0 is treated as invalid mask (no commands supported).  The
> function however returns also -ERRNO as u64 which will be interpret as
> valid command mask.
> 
> Return 0 on every error case of port100_get_command_type_mask(), so the
> probing will stop.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/nfc/port100.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
> index 1296148b4566..ec1630bfedf4 100644
> --- a/drivers/nfc/port100.c
> +++ b/drivers/nfc/port100.c
> @@ -1109,15 +1109,11 @@ static u64 port100_get_command_type_mask(struct port100 *dev)
>  
>  	skb = port100_alloc_skb(dev, 0);
>  	if (!skb)
> -		return -ENOMEM;
> +		return 0;
>  
> -	nfc_err(&dev->interface->dev, "%s:%d\n", __func__, __LINE__);

Mistake, please ignore.

Best regards,
Krzysztof
