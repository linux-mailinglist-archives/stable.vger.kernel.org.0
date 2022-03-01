Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7318B4C9405
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiCATOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiCATOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:14:14 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5664C7BB;
        Tue,  1 Mar 2022 11:13:32 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id j24so17055607oii.11;
        Tue, 01 Mar 2022 11:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ujlOryYDX+Uz1Cdim2GXChjh0V7g5nXW3ZfxZjFO3YU=;
        b=PWbQVTioG3vwlaqD0z5RAOXnxxM1k/o5oepPwRzJBaHAr+tQErAlqMEqSnV0a/k8gh
         7LqLzID0LawePcAj3m2tOsyryJmKIHbPUjgvrP+W3cz/6qApe5e9TVcR5HoFyc7fnrAE
         JbonWlbqJkOUFUrDPAKQHhgfU8VysNjTAyuMBU7B2CAwSCF/Aj8vGFxKVgzpn32K83UU
         MoWaRpY/gCrTrf3O5b8PnMrPEibNzYQIcxYVI1cF/Mq7aATLFI1sEpUNCCsH0Qa/vgbQ
         wrzzymi0enwQqnp48Dlx/tB7GCPhxX/A1KkTqb6gkalu+lT42mfnUDkDek1X27LI5Mg0
         IjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ujlOryYDX+Uz1Cdim2GXChjh0V7g5nXW3ZfxZjFO3YU=;
        b=vLK1T89pjhdHQDr+JbNtrfbXkeHVT2Ezu0FQLE71Gqihlyb2RxzgEfQtGRaLsVEliC
         R/30jDTkMGcsLodAP4sqwmo5+xfaoGY9IMhKL9FSs8z+7NCbTtGYZyyRqJrfB73YNFS8
         gD2Fca38rbDBdJtD2QceICuMa6t2Bm26W4bkPQaktDgKr1idMjSeMNgbM+cwC/pOY5CS
         74oNBXRTy72oQIEWoqc0VlJMFQUhJkv1NMPAVOm6eoGQRyMCt+367+XrAYGIKUm60z/l
         Oy9VsA0H36zXLhc/isVnXVk0HcRgxNp+kxu49Clxaly1Ucy0aHzCywm5OKpbgsMKXqkF
         PaVQ==
X-Gm-Message-State: AOAM5320QWUTAGemfQXCZc+6D0DTs6rc5uo+vHcwSHOEDZcZi1ynP5kk
        PD4gIRQ9mAHh6pLBZjHG3cs=
X-Google-Smtp-Source: ABdhPJyw4fq4W7iLTxjaaH5NhNNQ32bRkyKezRIZu6X36b/j6fwcHZaJ0TR6x/FpbFZKUZn4v8BUPQ==
X-Received: by 2002:a05:6808:1819:b0:2d4:9606:8d58 with SMTP id bh25-20020a056808181900b002d496068d58mr14724080oib.128.1646162011904;
        Tue, 01 Mar 2022 11:13:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 16-20020a9d0490000000b005ad3c83e927sm6828844otm.60.2022.03.01.11.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:13:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:13:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
Message-ID: <20220301191330.GA607121@roeck-us.net>
References: <20220228172248.232273337@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:23:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
