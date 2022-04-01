Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D34D4EFA57
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 21:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350115AbiDATZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 15:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349178AbiDATZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 15:25:29 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933561A0E
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 12:23:37 -0700 (PDT)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D75F23F7F5
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648841010;
        bh=ay5vnR1FzgYbrJ3fVkSq0cJeptmHke/9bnDckfAaX/o=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=K3tnyMtReIujd4XnvLAgdwlRO77LCcvwAgGVxfqdSlv5lfpI4XawnbO2cXDn2MR75
         WMP56Zfdi1QR9gLjugduHd/StzlgGYtTIaWVvUAcHEE1PrQ/PhebGpdHHtlIluDEyF
         eyBgV9XJW+ME2QwUsZDNBDgd7dYsWqBAo4cQPu0tHkM4sna1FQdx6KoMITeqRP5DV4
         LKB2j9wF3g8iTQlSMgjE2V7lQNPdeX/GpJsZeEIsKy54D3BE+E5wE+1RzvwaqfOag/
         3uNqbbzP0qAan68+tbUHTN7sF0jwSqsh0zvQKwK7LWfVzzFsHsB9gh6ebc5AtM1qR/
         gRtZj+91zmsPQ==
Received: by mail-pg1-f198.google.com with SMTP id r16-20020a638f50000000b00386086767c6so2103935pgn.6
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 12:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ay5vnR1FzgYbrJ3fVkSq0cJeptmHke/9bnDckfAaX/o=;
        b=w4uQySHaWRSvJpRW4KBPGd+Msz+PB1NY5/iVIYg46iy2UgPm/Ds1S+QCBSzs8E6vn2
         WzY4XO9O33MjaCEqXSxy/TDgcP2SpfNooWeHGdkr05qrwMeaJYvkGE8AAZAbeM7uV40A
         WwxMnUEcRO/NWoRsEpzNEfgfEMaVw0DwljZ+qPIGQPl3SD0dVpFs/dVUavzlt+t65ux8
         Az+P2OvFwgD+4zK8H8ehE0986OoncejJyCjwlo1Y1kGRZl5dFgRoUUiVAM+Hzq9lPoTT
         vkh/RkwPUjJv6fEF5/yQQJGHZcRg2JZ8y1HdTKsqQh44tDaFS1PBOA+XUYdadvHvOi8Q
         VEOg==
X-Gm-Message-State: AOAM533uZNeuaWbKdHzS9W4CaGWVPYA/LlryMiQV4osur8iYM2tIJtFz
        Z4srR8h6tUYU3X0SUD4xl2kV1geERpUeUzitUEx/3qcMsNHBqt8+I6xo1ijc7Cy41QPzRwwY9xo
        GsXWKw8Z43qPqLSWCQNGZ81npIu4bBQW7dQ==
X-Received: by 2002:a17:90b:2502:b0:1c6:d783:6e76 with SMTP id ns2-20020a17090b250200b001c6d7836e76mr13563506pjb.158.1648841009192;
        Fri, 01 Apr 2022 12:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWu4ERuNPbVHVxEdRpUveht1sZeHrPOxeFBGCqUoQpU1ZtjtBIRI2kg4sRtWOVVVbNq5mfzQ==
X-Received: by 2002:a17:90b:2502:b0:1c6:d783:6e76 with SMTP id ns2-20020a17090b250200b001c6d7836e76mr13563497pjb.158.1648841008912;
        Fri, 01 Apr 2022 12:23:28 -0700 (PDT)
Received: from [192.168.1.3] ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id me5-20020a17090b17c500b001c63699ff60sm15103659pjb.57.2022.04.01.12.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 12:23:28 -0700 (PDT)
Message-ID: <b8ebba84-62cb-b1fb-d6f7-1d6b6682da45@canonical.com>
Date:   Fri, 1 Apr 2022 13:23:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] qed: fix ethtool register dump
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, aelior@marvell.com, palok@marvell.com,
        pkushwaha@marvell.com, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20220401185304.3316-1-manishc@marvell.com>
From:   Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <20220401185304.3316-1-manishc@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/1/22 12:53, Manish Chopra wrote:
> To fix a coverity complain, commit d5ac07dfbd2b
> ("qed: Initialize debug string array") removed "sw-platform"
> (one of the common global parameters) from the dump as this
> was used in the dump with an uninitialized string, however
> it did not reduce the number of common global parameters
> which caused the incorrect (unable to parse) register dump
> 
> this patch fixes it with reducing NUM_COMMON_GLOBAL_PARAMS
> bye one.
> 
> Cc: stable@vger.kernel.org
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Fixes: d5ac07dfbd2b ("qed: Initialize debug string array")
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> ---
>   drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index e3edca187ddf..5250d1d1e49c 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -489,7 +489,7 @@ struct split_type_defs {
>   
>   #define STATIC_DEBUG_LINE_DWORDS	9
>   
> -#define NUM_COMMON_GLOBAL_PARAMS	11
> +#define NUM_COMMON_GLOBAL_PARAMS	10
>   
>   #define MAX_RECURSION_DEPTH		10
>   

Looks good to me.

Reviewed-by: Tim Gardner <tim.gardner@canonical.com>

rtg
-- 
-----------
Tim Gardner
Canonical, Inc
