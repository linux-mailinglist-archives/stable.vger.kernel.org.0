Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DE749BA91
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356929AbiAYRpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243634AbiAYRo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:44:58 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4B5C06173B;
        Tue, 25 Jan 2022 09:44:58 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id g15-20020a9d6b0f000000b005a062b0dc12so5723027otp.4;
        Tue, 25 Jan 2022 09:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7vX4nyqejSQmy9dz2iyqijGV41MCWq3gqftrjQINecY=;
        b=k/l9FjpCYXSt3zbvE5JbT1CkCjILrHr7A3FoO24pRpB2fL3xO17Bvgkugr0VLF6l9N
         io/rPEOCTRRWDFGxfOFXoSVI2L2UPVK7Ve/zQpqJDYwGod8H7TT8sVf10Vn/lXBfWLnf
         ZXq3IA25AufLkVr5IU6IvYSXUMTQHjHf0G7YxzKhemJpQZwCyP0Xhw5I7YFaTgewX4BC
         ErpIsmz1NEFKPMzycZRVCv/l5aUi20hXe6C5i5XDAt2UjaqAZ2VkLoNci6m2q7vw3yDX
         Le2yqdmkwog/MToDibHgl+byp4hxPbTok69NAYoKb1yCMiCthDZ7G6nBFedqfFsVqOV+
         hOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7vX4nyqejSQmy9dz2iyqijGV41MCWq3gqftrjQINecY=;
        b=w75RTnzt3OZaOebY9MLA064qRyTrKFPlmZZOvCEAsFR4z76Un4M+5DB3I4QrVofMhd
         kxG1URsjd8V0PK0uJQLV+AUXzo9KGQIgRdimCDhnSWw5f60QOQJySpHHhj6jm0EKAXHm
         N9Uo3MT7qp889BubXM+w65oasq4D1L+CHbAUV2ETbEr33flgRM/XimC3YO5Bqv5Af7H4
         gG7M+3L8TIYxuVxZNEMAjX9hAgb1nbuquggdXIuetuWL9cPnSsWs7OIu2+O/m73yr1PO
         cggIwfPKGkyWD5HJNKR2N7KyVx2/aheIP5w0DLjHo4RvITv+lvhbN9hRtqurmrSpN/u/
         XixQ==
X-Gm-Message-State: AOAM5325INKv5fN2tDZtzNA85MpKAqjKqUDV4HereqUV9t8BtJQG4kH8
        fhTWXtfZzbSoxy+hB/ZXWUw=
X-Google-Smtp-Source: ABdhPJyUZOL40OvNXd1HAAACGNCE4I9VFtKSJxZrE7uXSd5cWdUa1CIAv9Nqo7B/rILzpGX9qPBL7g==
X-Received: by 2002:a9d:7091:: with SMTP id l17mr8527880otj.341.1643132697418;
        Tue, 25 Jan 2022 09:44:57 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bq9sm8216416oib.28.2022.01.25.09.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 09:44:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e0c3a8ba-3975-f847-cb50-00398531f67b@roeck-us.net>
Date:   Tue, 25 Jan 2022 09:44:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 2/2] usb: typec: tcpm: Do not disconnect when receiving
 VSAFE0V
Content-Language: en-US
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
References: <20220122015520.332507-1-badhri@google.com>
 <20220122015520.332507-2-badhri@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220122015520.332507-2-badhri@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/21/22 17:55, Badhri Jagan Sridharan wrote:
> With some chargers, vbus might momentarily raise above VSAFE5V and fall
> back to 0V causing VSAFE0V to be triggered. This will
> will report a VBUS off event causing TCPM to transition to

s/will will/will/

> SNK_UNATTACHED state where it should be waiting in either SNK_ATTACH_WAIT
> or SNK_DEBOUNCED state. This patch makes TCPM avoid VSAFE0V events
> while in SNK_ATTACH_WAIT or SNK_DEBOUNCED state.
> 
> Stub from the spec:
>      "4.5.2.2.4.2 Exiting from AttachWait.SNK State
>      A Sink shall transition to Unattached.SNK when the state of both
>      the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
>      A DRP shall transition to Unattached.SRC when the state of both
>      the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."
> 
> [23.194131] CC1: 0 -> 0, CC2: 0 -> 5 [state SNK_UNATTACHED, polarity 0, connected]
> [23.201777] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
> [23.209949] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
> [23.300579] VBUS off
> [23.300668] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [rev3 NONE_AMS]
> [23.301014] VBUS VSAFE0V
> [23.301111] Start toggling
> 
> Fixes: 28b43d3d746b8 ("usb: typec: tcpm: Introduce vsafe0v for vbus")
> Cc: stable@vger.kernel.org
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
>   drivers/usb/typec/tcpm/tcpm.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index b8afe3d8c882..5fce795b69c7 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5264,6 +5264,10 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
>   	case PR_SWAP_SNK_SRC_SOURCE_ON:
>   		/* Do nothing, vsafe0v is expected during transition */
>   		break;
> +	case SNK_ATTACH_WAIT:
> +	case SNK_DEBOUNCED:
> +		/*Do nothing, still waiting for VSAFE5V for connect */

Space before Do

s/for connect/to connect/, maybe ?

Other than that,

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> +		break;
>   	default:
>   		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
>   			tcpm_set_state(port, SNK_UNATTACHED, 0);

