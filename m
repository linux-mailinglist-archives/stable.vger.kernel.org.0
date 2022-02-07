Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C7D4ACBF5
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244112AbiBGWVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiBGWU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:20:59 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B407C0612A4;
        Mon,  7 Feb 2022 14:20:59 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id u3so2739726oiv.12;
        Mon, 07 Feb 2022 14:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eZgQj3qg0hAAOScDuL00r06V7ZEknbZD9/c3sFuuBa8=;
        b=gfQu1hcbSCJukbWECBib8PSLu0g9RPGPoSZbKaA36LhVUyGXQyxIoyTKUtgOZqo2/K
         5oXO5lgLnFWk+fVMBnS4v4kuo53hovrcSiGllouyc8UH90eyQ8ekq0TNZf/28RSkJBhz
         FGWnXKUwe9YfNFb7UbFugEhX27rY8F4ST6pPSSa8Lq4/g6l73Zz2UqnNSj88eUHe977R
         1KNlbL6HkyvFRLosAXOmoqPdzujs65AMt8qUdCdvoEzujT4y3cCM9GxSSj1BMEgovh0l
         Jb1ed1dotn2Cg57aqQ7xTOMEpHfkGi70MR77RFtkPb6Wk6I3W+zHh4oxHsufP26KXVIC
         F+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eZgQj3qg0hAAOScDuL00r06V7ZEknbZD9/c3sFuuBa8=;
        b=mhbrE7r+c3zJy6X4tZEc/5CnyXu9Hre0ZHqURH70KYIrVK7TwrZeJGa+vcYpqKKcZ2
         dzDWcDzJrQmvvrP/NftH3q6RIlJiP9vphOae/G99ZsrRw6SazFXNiSqmg9JZnTN8VE0g
         vO+/KivnTiBxxlkZNOidS8LBeeEQjzsOmZfpE0XcblDh1zfWMrZojccd53L7HKl3pREr
         r4glAj0Ic8vfStTtpFOHWSIFLZWroCBoTSrcOGUH6ZzHntdbvEdul1NOvVL6rHItPcEt
         z5C7ZlMF2J3qLeDxpQgV4D0AwrM/C/HvRHtgi6LufvvHnZjqC9nNko2xYi6iPeuN9deh
         8Rxw==
X-Gm-Message-State: AOAM530kR86Eu45cAxdBq8CAc0sWOmrVmwLDLE3GV4gI8zMw2jPlVkG0
        pcWR1ceSwEFrpzbvY5v4qME=
X-Google-Smtp-Source: ABdhPJyqmPqH7adutEO21rlmJErq3W99H9T+TNjBmHvQdi1/kXwte13ZAs19RfBBC5NRSi69hgzlQA==
X-Received: by 2002:aca:4b4b:: with SMTP id y72mr469917oia.263.1644272458740;
        Mon, 07 Feb 2022 14:20:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x31sm5020142oao.13.2022.02.07.14.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:20:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 14:20:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/86] 4.19.228-rc1 review
Message-ID: <20220207222056.GC3388316@roeck-us.net>
References: <20220207103757.550973048@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 12:05:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.228 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
