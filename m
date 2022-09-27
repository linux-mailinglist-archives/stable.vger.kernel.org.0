Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622855EB99A
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 07:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiI0FXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 01:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiI0FXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 01:23:50 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AA4A4B86;
        Mon, 26 Sep 2022 22:23:49 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id o5so5812756wms.1;
        Mon, 26 Sep 2022 22:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qZji9TsHBMGVqL1hBdrpDzy/w/2AOyjefSDOj4a4nLI=;
        b=BnVUB3pSApnnz5xc7ITEjDtiuX0awXPUuUL0zwMCgogKcHRlRTp4dJ1BWm+Wm21uHW
         KDAYcMVBlV+VFsjxuvSOkyGvvbu4EhsOzm3L/WgpDv1BG2V60q4TKOobIyGuzwcqg/fv
         N+6YqrfPy9NV4ohB9l1HFaXBooWAJWulRozDzcwINAhK0b3xPEcQcPVML7RtJ3irX20h
         3A/sv/Iy3b7fN48FumTmnvYfxmYl1/cLkkpHZ8+TcBTYqhHuGwPROUIQpUCUv25eQAsl
         mBOTgTgUZcn5yFCsH09h08RVu6hGMY+mccwSbKq2xMpcOUJqbcpgvpSMhHK5DIFurjDQ
         l0cw==
X-Gm-Message-State: ACrzQf3+zluX0SLdLe0alY6mnNh0ePN0X/oWdRMUfnDj1pWJ7t921JJV
        RRdFfIgxkC4pqu0rDEs/4WU=
X-Google-Smtp-Source: AMsMyM7i2Is0QB/LIP7TtrKonCQ5s7ljwdcbTsz0JWLMf06Yp46Oy9FDMVOeVdz3Vu+B+ZOq/YonAA==
X-Received: by 2002:a7b:c848:0:b0:3b4:73f4:2320 with SMTP id c8-20020a7bc848000000b003b473f42320mr1219919wml.124.1664256227766;
        Mon, 26 Sep 2022 22:23:47 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id l2-20020a05600c1d0200b003a62052053csm16300404wms.18.2022.09.26.22.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 22:23:47 -0700 (PDT)
Message-ID: <d9d9651b-2561-03ce-8076-5b471929ff2d@kernel.org>
Date:   Tue, 27 Sep 2022 07:23:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5.19 014/207] Revert "usb: add quirks for Lenovo OneLink+
 Dock"
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20220926100806.522017616@linuxfoundation.org>
 <20220926100807.118539823@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220926100807.118539823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I wonder, does it make sense to queue the commit (as 011/207) and 
immediately its revert (the patch below) in a single release? I doubt 
that...

The same holds for 012 (patch) + 015 (revert).

On 26. 09. 22, 12:10, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [ Upstream commit 58bfe7d8e31014d7ce246788df99c56e3cfe6c68 ]
> 
> This reverts commit 3d5f70949f1b1168fbb17d06eb5c57e984c56c58.
> 
> The quirk does not work properly, more work is needed to determine what
> should be done here.
> 
> Reported-by: Oliver Neukum <oneukum@suse.com>
> Cc: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
> Cc: stable <stable@kernel.org>
> Fixes: 3d5f70949f1b ("usb: add quirks for Lenovo OneLink+ Dock")
> Link: https://lore.kernel.org/r/9a17ea86-079f-510d-e919-01bc53a6d09f@gmx.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/usb/core/quirks.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 999b7c9697fc..f99a65a64588 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -437,10 +437,6 @@ static const struct usb_device_id usb_quirk_list[] = {
>   	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
>   			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
>   
> -	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
> -	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },
> -	{ USB_DEVICE(0x17ef, 0x1019), .driver_info = USB_QUIRK_RESET_RESUME },
> -
>   	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
>   	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
>   

-- 
js
suse labs

