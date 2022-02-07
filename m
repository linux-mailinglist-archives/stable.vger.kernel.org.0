Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A94ACBF8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbiBGWUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiBGWUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:20:16 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE91C061355;
        Mon,  7 Feb 2022 14:20:15 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id c7-20020a4ad207000000b002e7ab4185d2so15384102oos.6;
        Mon, 07 Feb 2022 14:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bTpxVIGNIJguskdskzj9PIgSKWznud3SIw0EmR6AlZo=;
        b=G3mvYMnvT3P8jVsWaosWHJYmAFhNOpB/M2ogFhA3pkPBkr+PdttQshkGCCw1SmzFJK
         HJ+5YzUrudGAgXfTzbIuHkgn5AG1LOf7XfCgCdRA6FpZLoyiwDCOhksdYuVNwoe20tp/
         T4ogET57J5gtlpspcsgUC95yz5hMKidQ24zLUqJLjabMGeQm5hgJa0iCo3N01+pdjdMT
         Q7q63r94gcT9bzdFrqelYjplZwA+BMq+43IFqw8U4GBXTdcYw82KGfK3hO9RfszskgTD
         50cX7JMVmBXEFrp9mQjoQGBp5HqcaKmeAYwNzBkcBWptTz9QIK+finI4OAE/NhjqgNkS
         Yx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bTpxVIGNIJguskdskzj9PIgSKWznud3SIw0EmR6AlZo=;
        b=zxIngG2vnxLuqYWZn9pSMozwOxFTm/KsSlRPnUnY7vArzMOn11sfDfQiCtdsBtKYhA
         jZcyRJYzsBDacpo4JBBHxAfZE9HIYZ+FEtrYIskXJDOu8nzEfBL8x+gcSrJo0KlJ0DUF
         iZgQMyQm+HKbbZsNVKoRp4KRDQSwFV4eXKlsJXF8kQ+oFoiJ1Z/o54mT/ZAxsUxyBlAR
         7ZqbwiG6SnJvPk7HhRuzhltTKvBDdhBZblM7vvq8KPRoMQMdrSt1XhUjeW5RBhnGjvbU
         bp4Zvpgcj3buq6edD2bwXwe8WUm6XsDoscVwQS2/FmOr1VvnZMyTsG5efWHzI2BZSWL3
         fMXA==
X-Gm-Message-State: AOAM530HE4bloZzk0oBKUIexB/jiS1OMfmuXBHhMxXx3b3JjAth5rR41
        inex/WGTZV+2YAzAtx2IQSA=
X-Google-Smtp-Source: ABdhPJy9dMjClfCLoRqazIYUsANKA4sr+5u7kIS+4oV30bvXxN4UOarc2TiR9yDBqddm7Ro2M154yQ==
X-Received: by 2002:a05:6870:514c:: with SMTP id z12mr368727oak.118.1644272415057;
        Mon, 07 Feb 2022 14:20:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eq37sm5175175oab.19.2022.02.07.14.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:20:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 14:20:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/48] 4.9.300-rc1 review
Message-ID: <20220207222012.GA3388316@roeck-us.net>
References: <20220207103752.341184175@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 12:05:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.300 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
