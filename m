Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0BF5EBA71
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 08:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiI0GSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 02:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiI0GSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 02:18:32 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D0677EA4;
        Mon, 26 Sep 2022 23:18:29 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id u16-20020a05600c211000b003b5152ebf09so6216181wml.5;
        Mon, 26 Sep 2022 23:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HRHVydyc2AVnBKc7zUNGFH4cypE1JGKi+IGpNXuzLms=;
        b=5womiVW+d2sRGLp+gqSN0WmhFOAEcj/xzt9ZqNK20lPCCUO2ioCHLu1rLJXG/Cmmn6
         Bf3H1w7mgnN2dXOVgLtNxuqvUuueOWHKwVBLrYMTB+YJawaO3AIClnOgEAnELEK2f25o
         ANaF5Ejsb7XwPqpaITNwq2/3ufYMPCcLK1buaodseQnc4CMklNAx1vD8E2sJP9WRdVXo
         h/SbU2dH+lArZFEoyP7A/pEdY93YNEgJPNqdUhYDuVGjOALrexMEJX9qtRldSUpLL+dE
         nr0QnkrFYt33GC2YfisBYNBZECJenREEomboZm3T/UvUrNL5QpzhSwlDdE0eiFLIVknZ
         PiyA==
X-Gm-Message-State: ACrzQf3OLww3okXwN1hW1i1s3OH30VgfTfjkC5pEbTvlrw9rGI6XEd5x
        l165jp07U5aXjAENK1wXuX0=
X-Google-Smtp-Source: AMsMyM4yft8JKyTcugWJ92FbGU6Z3Qm6I+UAN1E/mai9qlatpTe63ICSY56g6UC9jEfkAbH8uqbIng==
X-Received: by 2002:a05:600c:21c3:b0:3b4:7e47:e3a with SMTP id x3-20020a05600c21c300b003b47e470e3amr1316925wmj.167.1664259508068;
        Mon, 26 Sep 2022 23:18:28 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id x5-20020a5d6b45000000b002238ea5750csm959927wrw.72.2022.09.26.23.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 23:18:27 -0700 (PDT)
Message-ID: <5ce2a0bd-d39a-71d7-2327-3850dfdd646c@kernel.org>
Date:   Tue, 27 Sep 2022 08:18:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 5.19 014/207] Revert "usb: add quirks for Lenovo OneLink+
 Dock"
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20220926100806.522017616@linuxfoundation.org>
 <20220926100807.118539823@linuxfoundation.org>
 <d9d9651b-2561-03ce-8076-5b471929ff2d@kernel.org>
 <YzKOdhT7jTXwCaG8@kroah.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <YzKOdhT7jTXwCaG8@kroah.com>
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

On 27. 09. 22, 7:47, Greg Kroah-Hartman wrote:
> On Tue, Sep 27, 2022 at 07:23:46AM +0200, Jiri Slaby wrote:
>> I wonder, does it make sense to queue the commit (as 011/207) and
>> immediately its revert (the patch below) in a single release? I doubt
>> that...
>>
>> The same holds for 012 (patch) + 015 (revert).
> 
> Yes it does, otherwise tools will pick up "hey, you forgot this patch
> that should have been applied here!" all the time.  Having the patch,
> and the revert, in the tree prevents that from happening.

It'd be fairly easy to fix the tools not to pick up reverted commits, right?

thanks,
-- 
js
suse labs

