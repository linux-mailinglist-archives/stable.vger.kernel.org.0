Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9634C9410
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiCATPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiCATPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:15:16 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800064B859;
        Tue,  1 Mar 2022 11:14:35 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id s1-20020a056830148100b005acfdcb1f4bso13013643otq.4;
        Tue, 01 Mar 2022 11:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZWD1fDpt8R4kmlw66WceqA8vOywcT27Cox35ZOcjIZk=;
        b=CtmfC19JbM70E18Ez4BNQ+iCq7iRxopS2jzBDwa7j05qi6KTu19mJnwZKUxMgEO9CU
         IQmgd/+zRPnhqP3aDH7bOtIXstSrPe85xtPN4lhD5mKRDmsDN9FkGD+7nkgpJIyZ8lpn
         lCnRqSJMfVpTwWOEEg32iitEaZk6uPPGvQ9CGUkqZ5gvNc16FPaGhQ3hqt9evMQnJTcQ
         DatS9R+WNb2QEpzxTWaCI/PXKdYqz6Y3Yp2pE93JKTHfYYc+cIetHLysQYM6CiNa9wn2
         ZHheZ9alo8qaUmMVgzNjOHIiZFpPkjJq1plAIvnyK1Jh+sntQXbqvEAvUsAtBYbn+Y/3
         VWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZWD1fDpt8R4kmlw66WceqA8vOywcT27Cox35ZOcjIZk=;
        b=OEeGas/pO4GQuGse0dWPptrnctV59QLMue4JYeCP8uLh8+gBn/tUh9aSMpT+28w6pn
         bKMl7t7r/7Y7LOcE/BtLf1DAbSmd1SQZO1i+5DK178ICr7/bYgJZEf5ZKQKvpPOi84It
         5gOSQM6lmg/GKRIFACjpgIPFq1fb6pp1DfMcMmcLFL37i/d7JvmTzxcpldCzfCiTj1R2
         XGfxWQ1KF3lypij2gR2ar2bt2j+h6TPe7+9YwiOPqaiTV4HVlPcnkB2iHTcgthmyb6na
         mh+3A17MsZDcvupTbIvOZjRSBY8IxzCP/XhWb+iC9/ILnM9E2uWFKGB4trVYh/Tgz/Sr
         rgFw==
X-Gm-Message-State: AOAM533DXWQ8kaLZO7TIwb0jyIFYhD22wN756wrJJKyebUyzHMOxIWN8
        QhoLmpfufMiCKSjg9BPim/g=
X-Google-Smtp-Source: ABdhPJw+9QT/5CTrp7g04D2LB6Dk6uY1Zv5Mt+VBJvb9EJE72HMgaujFGqbI9uzw/kGHQJdfuxoJaw==
X-Received: by 2002:a05:6830:4424:b0:5af:dbac:64ed with SMTP id q36-20020a056830442400b005afdbac64edmr11069138otv.49.1646162074893;
        Tue, 01 Mar 2022 11:14:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 67-20020aca0746000000b002d71928659dsm8219752oih.8.2022.03.01.11.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:14:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:14:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
Message-ID: <20220301191432.GC607121@roeck-us.net>
References: <20220228172347.614588246@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:22:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
