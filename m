Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C422B142D73
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgATOZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:25:31 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35316 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATOZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:25:31 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so15633276pgk.2;
        Mon, 20 Jan 2020 06:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fNKRTRtBnPFWAFkuQzCQKN9dEv7hjDLDlNUPP8sBK/k=;
        b=cKBbjA0SLrgW6ZfrcetgX6X3btPYYvvSg6KKW+L/TKsjZw6DkrjlAfTEPcGESpJNCa
         +gM50cxvUHknU4Iff5SXuk2LbX82X6AsEX3QKx1GsZV/9EDQq5R9G5+SJIWQqj4UG6Tv
         2lGdG9GfjrGpn6lPUwwPqJAuGCpsmL1oDp7fT9XEXxxNTJMrRSaKRyqh0mkQfTLsgU7f
         KzuMOoLRJelDJiK/aRsbpK+N4FptR/kzfqlg+eMNVwIgPouLBwF9JopntGg6DVKkbTEs
         7U6g7lmqlsL4VAk8re4l20JDQmtd+yd0GVmZX4rQZQY53ZOR41852AQp/rQB4ZpORTAm
         lugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fNKRTRtBnPFWAFkuQzCQKN9dEv7hjDLDlNUPP8sBK/k=;
        b=D7NBRKD95fgnpvzvtdb0CDJfTDpTapADNhNIWfA2QjEQCpDO/8X2I/05UBC5n7qDEm
         m3vjWRcaTQQnBuTmxWGft3oUJUF8nChDAcBcrfqSMtW7tabVCC6cfzHRGtD6kvMzvjVX
         S7POpInzOWFl9VNxbtV8y4LlvtfUdfpcCLDjEoVax8s338zaI2/9pHHNjm93AG0bECVD
         VTvEz4L8aACk/ayxuRST1kcIINA4ZpqAnme73m0IhBWOAq7G1mWJ4ooF6VhbFJbu5hzW
         hls5IhSwIRns/oZ820V5RsdY1uOZ4CWETy6RoxLO3GzfWDpG6tcCL3yEOGEbqx25ob3J
         ohOA==
X-Gm-Message-State: APjAAAXkX1aZY/KhlGstyX2o7irG1HD254P1GRzRgA67vkSKB629qILF
        PWlFNQVdOBEawLFXO9uftcCJpEgC
X-Google-Smtp-Source: APXvYqysH7Se3abO8VcCIIdDiututU2fUyy5/Qwk/NS+wa26+uUV6t8kgVs4ZuAcOmzNxCRTxVxE5w==
X-Received: by 2002:a62:1944:: with SMTP id 65mr11403073pfz.151.1579530330082;
        Mon, 20 Jan 2020 06:25:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d20sm18102237pjs.2.2020.01.20.06.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 06:25:29 -0800 (PST)
Subject: Re: [PATCH v3 2/2] usb: typec: fusb302: fix "op-sink-microwatt"
 default that was in mW
To:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org
References: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
 <0da564559af75ec829c6c7e3aa4024f857c91bee.1579529334.git.tommyhebb@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <50c97432-becd-0c5f-414f-1fd6d8c6c409@roeck-us.net>
Date:   Mon, 20 Jan 2020 06:25:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0da564559af75ec829c6c7e3aa4024f857c91bee.1579529334.git.tommyhebb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/20 6:09 AM, Thomas Hebb wrote:
> commit 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the
> port") didn't convert this value from mW to uW when migrating to a new
> specification format like it should have.
> 
> Fixes: 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the port")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> 
> ---
> 
> Changes in v3: None
> Changes in v2: None
> 
>   drivers/usb/typec/tcpm/fusb302.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
> index ed8655c6af8c..b498960ff72b 100644
> --- a/drivers/usb/typec/tcpm/fusb302.c
> +++ b/drivers/usb/typec/tcpm/fusb302.c
> @@ -1666,7 +1666,7 @@ static const struct property_entry port_props[] = {
>   	PROPERTY_ENTRY_STRING("try-power-role", "sink"),
>   	PROPERTY_ENTRY_U32_ARRAY("source-pdos", src_pdo),
>   	PROPERTY_ENTRY_U32_ARRAY("sink-pdos", snk_pdo),
> -	PROPERTY_ENTRY_U32("op-sink-microwatt", 2500),
> +	PROPERTY_ENTRY_U32("op-sink-microwatt", 2500000),
>   	{ }
>   };
>   
> 

