Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DC7552FEA
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiFUKjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiFUKjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:39:12 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B7528E11
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:39:12 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id h23so26510807ejj.12
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lkJMKAJjRsl5ZS0u93LR0jk9L+B4CuQVfKwsp8trKjY=;
        b=A6pDkBHFM1RQR/Fj8UNlm9lq0reNTkSaeWVYIzH2Tze+4yYCxlLOtp7aGwaLjB6EII
         w88sQ4Hr7D6VwlrvzDuZSGM9ApsJaWaXkLGh6N4gB9Lf7Bq2gIzoQv+LwBnhKVASOq1c
         dZ1ydddjsuLfottKcgX1lnSLSSyQVS57XPjeVQ4dwvb+IA0uAE76Zlu60SaRfO/KKHK0
         WUD/gDOa/QFF6i4gZnUqpSaEjRBwwjXazhSfGzsamBVxhHMzKoNqOiBJ02pjk+4/UHQU
         zTnbHzEbf8N/dq+A36BURv2QTM2dTxccozS8Ad5fVQevYULc+stzUJdJQgK1II5GtVDU
         WLQQ==
X-Gm-Message-State: AJIora8/0IObTcag7oCWfAfymHMICT2rOv9OjQdu6U9qlJFlDJxSvvIO
        sV6/b3xvzPOXll0ozOQujIMqjY0vyWRqLw==
X-Google-Smtp-Source: AGRyM1smtROrPyevfVpWOGRiL+Z+9zEPOnndcKm7HPX+tpWBs4CifNDeQtgtPJkK55kdv/mydLWPDQ==
X-Received: by 2002:a17:906:7394:b0:712:3c15:ba52 with SMTP id f20-20020a170906739400b007123c15ba52mr24530561ejl.169.1655807950612;
        Tue, 21 Jun 2022 03:39:10 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id u15-20020a170906124f00b006feec47dae7sm7461446eja.149.2022.06.21.03.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 03:39:10 -0700 (PDT)
Message-ID: <ce23efa0-70d3-41f4-eb4a-ea047e0dfb91@kernel.org>
Date:   Tue, 21 Jun 2022 12:39:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: patch request for 5.18-stable to fix gcc-12 build (hopefully
 last)
Content-Language: en-US
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <YrGZxGoKgKxcvVTG@debian>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <YrGZxGoKgKxcvVTG@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 06. 22, 12:13, Sudip Mukherjee wrote:
> Hi Greg,
> 
> The following will be needed for the gcc-12 builds:
> 
> ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
> 32329216ca1d ("eth: sun: cassini: remove dead code")
> dbbc7d04c549 ("net: wwan: iosm: remove pointless null check")
> 
> 
> With this 3 applied on top of v5.18.6-rc1 allmodconfig for x86_64, riscv
> and mips passes. (not checked other arch yet)
> 
> Will request you to add these to 5.18-stable queue please.

On the top of that, I had to apply this too:
aeb84412037b x86/boot: Wrap literal addresses in absolute_pointer()

thanks for the list,
-- 
js
suse labs
