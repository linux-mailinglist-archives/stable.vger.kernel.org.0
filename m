Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579795FD4A3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJMGVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 02:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJMGVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 02:21:44 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01507123457;
        Wed, 12 Oct 2022 23:21:43 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id u10so1274790wrq.2;
        Wed, 12 Oct 2022 23:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTg4h0yMza3o/vrO4K70GOGER7dHNLxEuY4nmy9ggyQ=;
        b=JdEwDyfO2rpNBIb93V8Iwn51o4rZDh8iUwFC25SCtMjT75K21fGIgvkGmb72aFsYhx
         uqOUjHwnSRClwp0ux2gDD9j1lb6k64mPCRd2q7M+N3qguwgN9AJdGSaW0tRzPVocsCFV
         Z7z5kHr9NlHPkcbY46jF36t9UZUwWdyeelrJAKCtMkRVvFkB6d0d/741LCOlRideH3CY
         aC/KZFC2uZ4oNBEBxwDjpTink1Heop6Pb/AyPDxNmnJIyf3c/MnP6eip682TGCd08TkF
         bjkVdiQfxO8MGNmvSbpP3K4EO+czKIK92C7HHA0Ug1J69u6otFJJMQQPmJBXanRc5Y8H
         p3Xw==
X-Gm-Message-State: ACrzQf12Wf4xCG3gYdrlWoTIwk3rOGdbOD9P6srLiwF6NI+Uvnx8imof
        rzyL+4K2jGEgWZR+qWTg9x4=
X-Google-Smtp-Source: AMsMyM6dKtfMuzrm0jaUVmfY40rRrt0MnPCBK3OCxUz0bwOyKMCYuGW+SZIWW5GnvEDjIgZqUZ6OyQ==
X-Received: by 2002:a5d:668a:0:b0:22e:470:174e with SMTP id l10-20020a5d668a000000b0022e0470174emr20749277wru.131.1665642099740;
        Wed, 12 Oct 2022 23:21:39 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id m6-20020a1c2606000000b003c452678025sm3639746wmm.4.2022.10.12.23.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 23:21:39 -0700 (PDT)
Message-ID: <df8b824a-5479-0593-4f87-7ac8317584fa@kernel.org>
Date:   Thu, 13 Oct 2022 08:21:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH AUTOSEL 5.15 34/47] tty: n_gsm: replace use of
 gsm_read_ea() with gsm_read_ea_val()
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Daniel Starke <daniel.starke@siemens.com>,
        kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
 <20221013002124.1894077-34-sashal@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221013002124.1894077-34-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13. 10. 22, 2:21, Sasha Levin wrote:
> From: Daniel Starke <daniel.starke@siemens.com>
> 
> [ Upstream commit 669609cea1d294f43efdd8d57ab65927df90e6df ]
> 
> Replace the use of gsm_read_ea() with gsm_read_ea_val() where applicable to
> improve code readability and avoid errors like in the past. See first link
> below for reference.

I don't think this warrants for stable. It's only a cleanup, not a fix. 
And it's quite intrusive.

> Link: https://lore.kernel.org/all/20220504081733.3494-1-daniel.starke@siemens.com/
> Link: https://lore.kernel.org/all/202208222147.WfFRmf1r-lkp@intel.com/
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
> Link: https://lore.kernel.org/r/20220831073800.7459-3-daniel.starke@siemens.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/tty/n_gsm.c | 95 ++++++++++++++++++++++-----------------------
>   1 file changed, 47 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 154697be11b0..d27247a84aab 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -1297,18 +1297,12 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
>   	unsigned int modem = 0;
>   	struct gsm_dlci *dlci;
>   	int len = clen;
> -	int slen;
> +	int cl = clen;
>   	const u8 *dp = data;
>   	struct tty_struct *tty;
>   
> -	while (gsm_read_ea(&addr, *dp++) == 0) {
> -		len--;
> -		if (len == 0)
> -			return;
> -	}
> -	/* Must be at least one byte following the EA */
> -	len--;
> -	if (len <= 0)
> +	len = gsm_read_ea_val(&addr, data, cl);
> +	if (len < 1)
>   		return;
>   
>   	addr >>= 1;
> @@ -1317,15 +1311,20 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
>   		return;
>   	dlci = gsm->dlci[addr];
>   
> -	slen = len;
> -	while (gsm_read_ea(&modem, *dp++) == 0) {
> -		len--;
> -		if (len == 0)
> -			return;
> -	}
> -	len--;
> +	/* Must be at least one byte following the EA */
> +	if ((cl - len) < 1)
> +		return;
> +
> +	dp += len;
> +	cl -= len;
> +
> +	/* get the modem status */
> +	len = gsm_read_ea_val(&modem, dp, cl);
> +	if (len < 1)
> +		return;
> +
>   	tty = tty_port_tty_get(&dlci->port);
> -	gsm_process_modem(tty, dlci, modem, slen - len);
> +	gsm_process_modem(tty, dlci, modem, cl);
>   	if (tty) {
>   		tty_wakeup(tty);
>   		tty_kref_put(tty);
> @@ -1819,11 +1818,10 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
>   	struct tty_port *port = &dlci->port;
>   	struct tty_struct *tty;
>   	unsigned int modem = 0;
> -	int len = clen;
> -	int slen = 0;
> +	int len;
>   
>   	if (debug & 16)
> -		pr_debug("%d bytes for tty\n", len);
> +		pr_debug("%d bytes for tty\n", clen);
>   	switch (dlci->adaption)  {
>   	/* Unsupported types */
>   	case 4:		/* Packetised interruptible data */
> @@ -1831,24 +1829,22 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
>   	case 3:		/* Packetised uininterruptible voice/data */
>   		break;
>   	case 2:		/* Asynchronous serial with line state in each frame */
> -		while (gsm_read_ea(&modem, *data++) == 0) {
> -			len--;
> -			slen++;
> -			if (len == 0)
> -				return;
> -		}
> -		len--;
> -		slen++;
> +		len = gsm_read_ea_val(&modem, data, clen);
> +		if (len < 1)
> +			return;
>   		tty = tty_port_tty_get(port);
>   		if (tty) {
> -			gsm_process_modem(tty, dlci, modem, slen);
> +			gsm_process_modem(tty, dlci, modem, len);
>   			tty_wakeup(tty);
>   			tty_kref_put(tty);
>   		}
> +		/* Skip processed modem data */
> +		data += len;
> +		clen -= len;
>   		fallthrough;
>   	case 1:		/* Line state will go via DLCI 0 controls only */
>   	default:
> -		tty_insert_flip_string(port, data, len);
> +		tty_insert_flip_string(port, data, clen);
>   		tty_flip_buffer_push(port);
>   	}
>   }
> @@ -1869,24 +1865,27 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
>   {
>   	/* See what command is involved */
>   	unsigned int command = 0;
> -	while (len-- > 0) {
> -		if (gsm_read_ea(&command, *data++) == 1) {
> -			int clen = *data++;
> -			len--;
> -			/* FIXME: this is properly an EA */
> -			clen >>= 1;
> -			/* Malformed command ? */
> -			if (clen > len)
> -				return;
> -			if (command & 1)
> -				gsm_control_message(dlci->gsm, command,
> -								data, clen);
> -			else
> -				gsm_control_response(dlci->gsm, command,
> -								data, clen);
> -			return;
> -		}
> -	}
> +	unsigned int clen = 0;
> +	unsigned int dlen;
> +
> +	/* read the command */
> +	dlen = gsm_read_ea_val(&command, data, len);
> +	len -= dlen;
> +	data += dlen;
> +
> +	/* read any control data */
> +	dlen = gsm_read_ea_val(&clen, data, len);
> +	len -= dlen;
> +	data += dlen;
> +
> +	/* Malformed command? */
> +	if (clen > len)
> +		return;
> +
> +	if (command & 1)
> +		gsm_control_message(dlci->gsm, command, data, clen);
> +	else
> +		gsm_control_response(dlci->gsm, command, data, clen);
>   }
>   
>   /**

-- 
js
suse labs

