Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852FD1243EC
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 11:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbfLRKFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 05:05:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43204 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbfLRKFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 05:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576663547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSkrFpm1DW1Y7i6HiHHtFhN9Nhr2jT7JhuCbqt9yG0o=;
        b=HMa3mKavab7DQS2DFwwIWWNhmOmZWMoMFVdu21e8w+LbkG5UedcBRm3DMMoXm5yatDYskF
        XuBIJf+ESBkOnB3GNvphc2Kr9h8rprswGAqZ5vwMjqNdDOXIOXoYiVw4vSLNsKONzjx/fc
        dSOcv6KPjh0GosY2FFeODBSihENLfQE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-WOdplLdKMRemhvP5r9jliw-1; Wed, 18 Dec 2019 05:05:44 -0500
X-MC-Unique: WOdplLdKMRemhvP5r9jliw-1
Received: by mail-wr1-f71.google.com with SMTP id l20so662607wrc.13
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 02:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FSkrFpm1DW1Y7i6HiHHtFhN9Nhr2jT7JhuCbqt9yG0o=;
        b=nWU7XsMVIGN+pWUpPXRtmgf0rBpfE3XNSN3anndGSyPzR5rayr/Y36C421DQOZTRdH
         RlvOJKr2wCdn/VIMOV7cwDeazJ7g0hDFL6eKs+o5YHoP2zaEiaqtVBDeyYsQXjBcttf0
         nSRGNYIs4D38F+Qo6OdCFhIRtl9X+NilwlbH91PdwMKhmQvjcJ0wQadw4EkfRiHTpgtf
         3HDp38CuRY0o5p6IUMnOBGhGUcr+9z2C299q4/RCKWP9xEb6szSSI9f/TWtN6YGEa/9n
         fJfdhhi2fPeZqbVKmwZdpBkYsUY1JBAShIVboagRpndgs1YqJhh+nV48tNr2x7+C9QXz
         xF4A==
X-Gm-Message-State: APjAAAUPWVsSH45I+D0m+Q9/QxWVdoiOkwa1cYyl/AYJTHZ6jcqebaU0
        vHbEobzGKDRqMvbGoGwuVSWdOB2ON9Uh7aXmNjRDR/mjrTnrhMaYYK8QA0onVNJKMZNwCeLzusB
        FnGPub2FMD5T6XIQF
X-Received: by 2002:adf:f54d:: with SMTP id j13mr499122wrp.19.1576663542651;
        Wed, 18 Dec 2019 02:05:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxX6RhlxdEWJs66pu6RNx9WXgk/AjvVABJfgEXDOjUWKh9KkobAdo1xitp5e/cWXJ63qptzmA==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr499080wrp.19.1576663542320;
        Wed, 18 Dec 2019 02:05:42 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id 5sm2130892wrh.5.2019.12.18.02.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 02:05:41 -0800 (PST)
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        linux-serial@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, shrirang.bagul@canonical.com,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <096046b6-324a-8496-8599-ed7e5ffc6e3c@redhat.com>
Date:   Wed, 18 Dec 2019 11:05:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 18-12-2019 07:56, Punit Agrawal wrote:
> Serdev sub-system claims all serial devices that are not already
> enumerated. As a result, no device node is created for serial port on
> certain boards such as the Apollo Lake based UP2. This has the
> unintended consequence of not being able to raise the login prompt via
> serial connection.
> 
> Introduce a blacklist to reject devices that should not be treated as
> a serdev device. Add the Intel HS UART peripheral ids to the blacklist
> to bring back serial port on SoCs carrying them.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Hans de Goede <hdegoede@redhat.com>

Thank you for addressing this long standing issue.

The basic approach here looks good to me, once the minor
comments from other reviewers are addressed you can add my:

Acked-by: Hans de Goede <hdegoede@redhat.com>

to the next version.

Regards,

Hans



> ---
> 
> Hi,
> 
> The patch has been updated based on feedback recieved on the RFC[0].
> 
> Please consider merging if there are no objections.
> 
> Thanks,
> Punit
> 
> [0] https://www.spinics.net/lists/linux-serial/msg36646.html
> 
>   drivers/tty/serdev/core.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> index 226adeec2aed..0d64fb7d4f36 100644
> --- a/drivers/tty/serdev/core.c
> +++ b/drivers/tty/serdev/core.c
> @@ -663,6 +663,12 @@ static acpi_status acpi_serdev_register_device(struct serdev_controller *ctrl,
>   	return AE_OK;
>   }
>   
> +static const struct acpi_device_id serdev_blacklist_devices[] = {
> +	{"INT3511", 0},
> +	{"INT3512", 0},
> +	{ },
> +};
> +
>   static acpi_status acpi_serdev_add_device(acpi_handle handle, u32 level,
>   					  void *data, void **return_value)
>   {
> @@ -675,6 +681,10 @@ static acpi_status acpi_serdev_add_device(acpi_handle handle, u32 level,
>   	if (acpi_device_enumerated(adev))
>   		return AE_OK;
>   
> +	/* Skip if black listed */
> +	if (!acpi_match_device_ids(adev, serdev_blacklist_devices))
> +		return AE_OK;
> +
>   	if (acpi_serdev_check_resources(ctrl, adev))
>   		return AE_OK;
>   
> 

