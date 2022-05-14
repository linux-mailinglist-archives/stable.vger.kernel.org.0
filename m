Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB3552724D
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiENO6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbiENO57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:57:59 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D1C18392;
        Sat, 14 May 2022 07:57:59 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id n24so13513816oie.12;
        Sat, 14 May 2022 07:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RaF6NzwcNAWNTwbrKL/WqJqFfOyg8GqDHSxrJv3f5X4=;
        b=eHAhwwS2VKUGx8y3Cfz/p5+BWIeyeU5ogoAWDSqTSOQcJaKm9PyfwbOalcKxAYEHA5
         VSEHLWBPut0OCS+ToTmDDnyfaSu5MhNO89YpQVDkwSqhtMQHxHwCY4WP4HreavZctfEy
         05F+5TiecGhqpIBxrYzfSAUvUlkmzPBi7sKAgvjcvXUdypvq/vo+1piyI7GmaHpHnZ6c
         AtAYLLoT/AByBLVHKjl89JlRg14NBeUXiECfni97BRgCwnYQC7WpIZTtPGSl4NJ5H9h1
         r6C//LalwGVzbcqIXSjSsl96DvOEJkUf80VxmizSIz0dbvTGElZGOyC2qIiZEj5O7FZb
         B4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RaF6NzwcNAWNTwbrKL/WqJqFfOyg8GqDHSxrJv3f5X4=;
        b=VUzdPshTcAch39MRgciodY/y/C6nnxGy8Sd0ofF+GePR7ljq6IoWsL8L6dJrNQFvd7
         CsLzJhi5pYpONtpstmQi5cJNRhULSyho3kBbp+JXRANCtVJF5JePzKnxbVCFJdXdSyUw
         SHY5tyUetTxa61RKgsJThndlPLxRlVXEFq5j9woKQwCNXR44TvjxEVEyO4M2JJM3AyNx
         LUeIRhIoYDz5kEEfRDk7r2GUwR4+06FcZ39d7BUi21ePgSaR/Ot82WxCFRQEk9OibnEc
         if3g4fFflAfUjsaYi8P/Tff3zxdFfGwvcGO13ZehTX6lvG943AwRSlJqxL6PBVQ4zNK7
         8+BQ==
X-Gm-Message-State: AOAM530hToXKRka4dIbFSyXuN2gG40VBYoA52rZvzHtDZWlShSyFbtUt
        KjNbVwSt/FaPCBCxz4PyjgI=
X-Google-Smtp-Source: ABdhPJxS5iu3k5HbmGh3GvxTEXXj5JP1+7gcaUSTjxpRLm3y2hXuTQFedZtOY5TD0WNXdbeYw1lpZg==
X-Received: by 2002:a05:6808:10d6:b0:326:d4b2:851 with SMTP id s22-20020a05680810d600b00326d4b20851mr4916732ois.295.1652540278486;
        Sat, 14 May 2022 07:57:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n18-20020aca2412000000b00326b27905adsm2122973oic.2.2022.05.14.07.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:57:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:57:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
Message-ID: <20220514145756.GG1322724@roeck-us.net>
References: <20220513142228.651822943@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:24:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
