Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDF236790F
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 07:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhDVFEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 01:04:32 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:35727 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhDVFEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 01:04:32 -0400
Received: by mail-ed1-f44.google.com with SMTP id h8so11705817edb.2;
        Wed, 21 Apr 2021 22:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2RwTGPgXpv05ZdbJTmuZwvlW3qUkElzdbyy36+xkXno=;
        b=DjnXSqUf1U/iAZ5YaNEg2z4X1DNxoVW2PccCiO6l05EwmeT59qEbrI9MCa+1vVcogb
         fog/32orhIruoGJHS1fT3RxqIvOViCKz6CxdkiXaGiWVkdnAAKL7CmdMm/lxTGFvdpvM
         Lt4uA6aJxP0gQ+Ydi3fmWOGLNdeutr3/DOtYkcJjR7PFaQVAyZx2qv0F/0waRUPiKDJg
         iY2qyecdNfKZKe56wAnNbW/zey93Miarn7+d1i0LHlIYnIu1O+HMT9iNw1dRPxeIUvtn
         84LVemhgZFWRY9MTEQU1nXJKqaL0kimXhKuk64XgqQHwG7QHAEMQbu7jFB19BU9d4Us2
         3kwQ==
X-Gm-Message-State: AOAM531Jfqvy6cmETqnWd/2hsGWy6AdACQxwKNawu2hsxOngTneCM++2
        F72lnc0UXaPbykCdl12IV2MAzuRmbjA=
X-Google-Smtp-Source: ABdhPJwrguWKsctqP3uJqYW/NBmnu7x/9eA3MRZnHIeOa61bRLMN+APXbOAJiOjKSCAavHvhGOvukQ==
X-Received: by 2002:a05:6402:a4a:: with SMTP id bt10mr1461856edb.39.1619067836911;
        Wed, 21 Apr 2021 22:03:56 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id s13sm1008805ejz.110.2021.04.21.22.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 22:03:56 -0700 (PDT)
Subject: Re: [PATCH 119/190] Revert "tty: mxs-auart: fix a potential NULL
 pointer dereference"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, stable <stable@vger.kernel.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-120-gregkh@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <1af822a8-2a1b-9110-9832-ba0fe237a1c1@kernel.org>
Date:   Thu, 22 Apr 2021 07:03:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421130105.1226686-120-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 04. 21, 14:59, Greg Kroah-Hartman wrote:
> This reverts commit 6734330654dac550f12e932996b868c6d0dcb421.
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
> Cc: stable <stable@vger.kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/tty/serial/mxs-auart.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
> index f414d6acad69..edad6ebbdfd5 100644
> --- a/drivers/tty/serial/mxs-auart.c
> +++ b/drivers/tty/serial/mxs-auart.c
> @@ -1644,10 +1644,6 @@ static int mxs_auart_probe(struct platform_device *pdev)
>   
>   	s->port.mapbase = r->start;
>   	s->port.membase = ioremap(r->start, resource_size(r));
> -	if (!s->port.membase) {
> -		ret = -ENOMEM;
> -		goto out_disable_clks;
> -	}

I don't think this needs to be reverted -- the original fix is correct.

>   	s->port.ops = &mxs_auart_ops;
>   	s->port.iotype = UPIO_MEM;
>   	s->port.fifosize = MXS_AUART_FIFO_SIZE;
> 


-- 
js
suse labs
