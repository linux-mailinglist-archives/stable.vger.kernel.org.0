Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE700142D70
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgATOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:25:03 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42916 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATOZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:25:03 -0500
Received: by mail-pl1-f194.google.com with SMTP id p9so13249664plk.9;
        Mon, 20 Jan 2020 06:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wQgdM7cXLeZs12//3r3/JJb1p5qc+L/55P5m/D0zegU=;
        b=i7qY1BHZee3KWcBfEhyEjqtaYWILJyaaZqBDnC1MrxND8HnaPJzovqYUDsBeSaYXXy
         ldJZG9cS1rCdyZwhfumexvUdYjJOONNjT8wjq83CTlCObk7FmkhrAfxxnN6vfbjPvS+B
         tqDJDh7xcGwkk3cd9z8CXlXMjYHr/9WjMn0ncEjj4r6p9AJZKxecvoD2VDuSM1LueDwG
         GYYaKkfjvgSnTuuZIjag6ODuiWJu8UbOvKLyjMEGqGJdVp5Fa3NjqinYRqEdr/kAvPW7
         6AbCD7ZiBgwY5P2bqcEk/rf+8TP8VITpsfPo7iiWG8k4HKdFRMPvPf7Vir7q2iPpjkyD
         weiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wQgdM7cXLeZs12//3r3/JJb1p5qc+L/55P5m/D0zegU=;
        b=RLo1c8fhtxwAviPHTLq8//leMxpanKWOC38hGes8THzo58gDz3l+Dc4d0dfGYGCjks
         PLn8x5vwdfT3dDgO3N7DrX55R4KH67XZfG7RUXkJSWI9KMaMBfm7ZMwvETFeH+ROl1ur
         1cwkMuz9gc9Ml5proji4FvK0l0PanYBw5LklE/yIaKRyn4XGrZENNuPVHQF0bDE/icDi
         +C7OH+lVLnNVh7S6BYyYtqeAL89czRX1DHNG3NM1mwVqF+ueL6VAH2ezygtMidoOWmnF
         Wbn5U5HgZxlvgFLgJjIgnIpp5EkEwz0wATQBZUQs64LhqJifMCCptKwChmln0IcyKoT8
         9ZPA==
X-Gm-Message-State: APjAAAXKWIoYaKu36S6pun5cdU1gP4At9uBm2VEmVqQ3myu0lcDtZffW
        zHvQ3BVOfZHeFUey/0kDDbqqpWYj
X-Google-Smtp-Source: APXvYqylGGiOksCDXe2BnOB8kt/Rew4e4lhOVfHbwcgcXgvTis/+7bKVDb7q/T5ydsjl/O0t9oWvEw==
X-Received: by 2002:a17:902:9a08:: with SMTP id v8mr15482497plp.134.1579530302547;
        Mon, 20 Jan 2020 06:25:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a22sm42008556pfk.108.2020.01.20.06.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 06:25:01 -0800 (PST)
Subject: Re: [PATCH v3 1/2] usb: typec: wcove: fix "op-sink-microwatt" default
 that was in mW
To:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org
References: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <432ff907-044d-3e7c-75fc-0a172d1ed6c1@roeck-us.net>
Date:   Mon, 20 Jan 2020 06:25:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/20 6:09 AM, Thomas Hebb wrote:
> commit 4c912bff46cc ("usb: typec: wcove: Provide fwnode for the port")
> didn't convert this value from mW to uW when migrating to a new
> specification format like it should have.
> 
> Fixes: 4c912bff46cc ("usb: typec: wcove: Provide fwnode for the port")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> 
> ---
> 
> Changes in v3:
> - Use the right stable email address
> 
> Changes in v2:
> - Split fix into two patches
> - Added stable cc
> 
>   drivers/usb/typec/tcpm/wcove.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/wcove.c b/drivers/usb/typec/tcpm/wcove.c
> index edc271da14f4..9b745f432c91 100644
> --- a/drivers/usb/typec/tcpm/wcove.c
> +++ b/drivers/usb/typec/tcpm/wcove.c
> @@ -597,7 +597,7 @@ static const struct property_entry wcove_props[] = {
>   	PROPERTY_ENTRY_STRING("try-power-role", "sink"),
>   	PROPERTY_ENTRY_U32_ARRAY("source-pdos", src_pdo),
>   	PROPERTY_ENTRY_U32_ARRAY("sink-pdos", snk_pdo),
> -	PROPERTY_ENTRY_U32("op-sink-microwatt", 15000),
> +	PROPERTY_ENTRY_U32("op-sink-microwatt", 15000000),
>   	{ }
>   };
>   
> 

