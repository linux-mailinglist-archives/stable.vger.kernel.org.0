Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF26D367929
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 07:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhDVFSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 01:18:55 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:45000 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhDVFSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 01:18:55 -0400
Received: by mail-ej1-f50.google.com with SMTP id r20so17068709ejo.11;
        Wed, 21 Apr 2021 22:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T68H21/yRSJllYAB5Jd1QXkWmcnbS65PN8kB5kpIvTw=;
        b=ArGaNVf3Qa1SvPGAews7lpnzllRnzsXMnX9EuX+uzvaCvu07GH0VtfTWyqGfo7DzZu
         i9Qitpa77BYIgbChPar0AMwObbDKZkE4jZO0+HRBRbvO4aY8bDxEMBQeMEx4d2/a5YkT
         lPfEg0mfoqXK0EOCgrSaYZ9g16lbTLsE+/zBH0quNQroKesFxD8bqA1DAyYwg/kmMF8S
         xm/+CllZBFFkt7G3IKIz5YjSry5pXZIdctvxKrLdp3oU1B8p0mpU252AF77mUj/drrSI
         XxTf0v+OYn3tJFwP0VKCjZM9UdJJtNWzMb7ZX+4bRSt+90QPwjHpwxI+lLPivUiYfBCp
         3YFg==
X-Gm-Message-State: AOAM533cFpKbQ1/xT0NsdNAgi1l3pjEjO+ad7exTOzyzveiGj22su4e5
        LsE3ttFZiryhGz/VGIxGfodIIF5QCR4=
X-Google-Smtp-Source: ABdhPJwAinWUpP6VG4/USFR7HARR71YxsQ+f2ukAs14Oe5SYHLdnGc8xw+vphVJq1oq5nWQU0+Ty8w==
X-Received: by 2002:a17:906:5052:: with SMTP id e18mr1447674ejk.112.1619068699923;
        Wed, 21 Apr 2021 22:18:19 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id hq16sm1030375ejc.5.2021.04.21.22.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 22:18:19 -0700 (PDT)
Subject: Re: [PATCH 120/190] Revert "tty: atmel_serial: fix a potential NULL
 pointer dereference"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        Richard Genoud <richard.genoud@gmail.com>,
        stable <stable@vger.kernel.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-121-gregkh@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <57f44dfa-a502-ee4f-6d53-0ab7cba00e1b@kernel.org>
Date:   Thu, 22 Apr 2021 07:18:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421130105.1226686-121-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 04. 21, 14:59, Greg Kroah-Hartman wrote:
> This reverts commit c85be041065c0be8bc48eda4c45e0319caf1d0e5.
> 
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
> 
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
> 
> Cc: Kangjie Lu <kjlu@umn.edu>
> Cc: Richard Genoud <richard.genoud@gmail.com>
> Cc: stable <stable@vger.kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/tty/serial/atmel_serial.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index a24e5c2b30bc..9786d8e5f04f 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1256,10 +1256,6 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
>   					 sg_dma_len(&atmel_port->sg_rx)/2,
>   					 DMA_DEV_TO_MEM,
>   					 DMA_PREP_INTERRUPT);
> -	if (!desc) {
> -		dev_err(port->dev, "Preparing DMA cyclic failed\n");
> -		goto chan_err;
> -	}

I cannot find anything malicious in the original fix:
* port->dev is valid for dev_err
* dmaengine_prep_dma_cyclic returns NULL in case of error
* chan_err invokes atmel_release_rx_dma which undoes the previous 
initialization code.

Hence a NACK from me for the revert.

>   	desc->callback = atmel_complete_rx_dma;
>   	desc->callback_param = port;
>   	atmel_port->desc_rx = desc;
> 


-- 
js
suse labs
