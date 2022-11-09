Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09A7622258
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiKIC6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKIC6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:58:35 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAFC1175;
        Tue,  8 Nov 2022 18:58:34 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id n83so17525847oif.11;
        Tue, 08 Nov 2022 18:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JV+c3N5MDzaK4Gv+svglNBxHNYLyHGNN1rocCPcj0H4=;
        b=AvZOHmcv4zbDrrZL7ahTl61qth4Dm1U2tGx11kkpcU+NPFg3TJ0njg9u5vd6KxHaEY
         CPeOR7ZAcYpPMtwle5czuaBFV9tPMoW+3olgrLf4HEM8xyGnP38IBDmG1JPuJ035O5X7
         /9yca8aVxMZAcVUQhxGo4br4BLV0cujsuUzQRv8czQlhbhy30MhvHexUYTkJ6mEJOfiV
         1GTi/7lmYQ2bwDpagzr+zl4NbXWfaY+rpvptC4ezLU++AylWL/Vnvm1kTLmdD0t9fpsZ
         GutLk+0c4UoYmZdN5xN1O0MRtEvjnwSk0lH0PK1grWZeVuq6vwZgXmD4jSsNyISYI5Ni
         KKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JV+c3N5MDzaK4Gv+svglNBxHNYLyHGNN1rocCPcj0H4=;
        b=zo/o7sYdeRF/VONv5cdaas95/iTuY9tQglJjh68wy50vLE97nzaQA+M/pZQ5pW9wvh
         4yi4R/CxEUtH4u5yQNyLhDxS48VlIfWwZ8LkZi91nRLwMqCfPjjAahn83B1aJnaTygD8
         BNYXbodyTQvu4Hs7Pr7Gv78rLdrNYqkpjpoVxB+wiVJRZFyFZ7U9+gCgZM9M6QrEFY3X
         6pVmKHYdchZl4bHZCFS9GL7Lfs5HMq6jdAneaMEuprKg4/uES2DwyfF3q7WhQs/pO/uA
         QXCu0S0lj3UEXpal4mfqauzR0dYtiGV9tU9GrByz00rRD4RH0aj0CzW0PZr0KSnJnUXa
         MQFQ==
X-Gm-Message-State: ACrzQf3YublLvpyhOy1WURGcs9pIxZfUp6ekaU7SgtarPIAQXpyUokPu
        2TNXM5WQnUI4dM10y/AN68s=
X-Google-Smtp-Source: AMsMyM6oX7ebOxq9tPaEGMlYZSltK6HMyCIAy/Xesh5OdqZodzl8xmKAb5jlN5vjelXrXgNic3ku5A==
X-Received: by 2002:a05:6808:2120:b0:35a:57da:74b4 with SMTP id r32-20020a056808212000b0035a57da74b4mr15245083oiw.213.1667962713495;
        Tue, 08 Nov 2022 18:58:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i4-20020aca3b04000000b00353fe4fb4casm4120379oia.48.2022.11.08.18.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:58:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:58:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
Message-ID: <20221109025832.GG2033086@roeck-us.net>
References: <20221108133326.715586431@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 02:38:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
