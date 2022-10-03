Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3D75F34E0
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJCRxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJCRwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:52:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C021E3ED42;
        Mon,  3 Oct 2022 10:52:49 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 2so4711825pgl.7;
        Mon, 03 Oct 2022 10:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=tAHqQfXd6qsaHu7dJQkYgecF1KOscsZbFzSuW6p8r5c=;
        b=VD+Y6WsWVrDxbQBgt2KmseZDjbqMJdJoAp7aN2jGlV9wv/IfxFTkLcMjhKMyMe5jpx
         6YXglitCqWgm3jmqJkwk7jBYmDTxRofoiFZyxOXpkBh6Dp6OTqhCFIuzw5f7NS318HJW
         UAiG7w1pOsknMgHxELHl0x2b08Zki/WHCfJTd0iIodbx4hPTwMTXjWmjrRL0RkQ9l4Ti
         4ECvkgEcQgG0fqt27YF5FDwDrJygDKHNYFBLEMnMrSGGuXbKeNRKrkIu/LSo5Sfdmz9E
         rc8ndmJVY7dFB9Afmo7NfBj0QFpHLBXkra0cWT3U9e1LLA98f6MRwbcfp1afawaN4RUh
         KbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tAHqQfXd6qsaHu7dJQkYgecF1KOscsZbFzSuW6p8r5c=;
        b=ZExhXiTc8vTk/zw/1am5X/Vi+rXulKsuhOUJhbdDSR9Wun76JykXtQ5EDS26F401p4
         0nLi1CeraPYImSqt4gUl+Af+SqTVN/ermrkm9UWw/JhnE8VGPtt5Mu1xbqBFSJoxjG38
         8sQPXfsYMQ4i1UEqzFZINx6/zv1HqtfogGT+iL2yjY32GNKgm0BeKK6DW2NvidVDVlUX
         3XP78qf63e2sBfvZ+tss+eEVMzaM44o9f94Eaqcj5P8C1yMbOGsV0gp+VhxVt7KB5XLH
         +PLNprSVP3mS3RN4Zplb/ELgPfnuDIuVClqe1Y7X5vAnKxstzNtVGwTT2nZ77Zla/Hdz
         gfhg==
X-Gm-Message-State: ACrzQf0pL9/+F1jrgYbq5J2CXkdA947/A0p+lLezjl2Cs3PjmdGi3r3l
        8kW7HR67GMnzL3RyvVw/Qfc=
X-Google-Smtp-Source: AMsMyM4Z/QtOM0NhTVsR5O3j2a1Ge8y3mfnhtnECiKy8jRWZtek3erTIQ7J6TyjxX0W2XGsgv/Jz6Q==
X-Received: by 2002:a63:5221:0:b0:434:37b4:17f5 with SMTP id g33-20020a635221000000b0043437b417f5mr19815013pgb.479.1664819569188;
        Mon, 03 Oct 2022 10:52:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p26-20020aa79e9a000000b005385e2e86eesm7877279pfq.18.2022.10.03.10.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:52:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Oct 2022 10:52:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/52] 5.10.147-rc1 review
Message-ID: <20221003175247.GC1022449@roeck-us.net>
References: <20221003070718.687440096@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:11:07AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.147 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
