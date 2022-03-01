Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7F4C93FA
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiCATLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiCATLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:11:10 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4DE63BED;
        Tue,  1 Mar 2022 11:10:29 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id r41-20020a4a966c000000b0031bf85a4124so23592966ooi.0;
        Tue, 01 Mar 2022 11:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jihHGA4pbQxWZc7vImFG8Ig3lKmwh2M9/yWB0qegmPI=;
        b=BYdAoxF2CsIuTUUwgX5zhRu0KjZRxDwEUL/s59I5P64ZrsrCiG0Jd81oGKWGUjGEJ9
         B7lrWjMfrSJhx1ajM7iyM2e5u4O6E7fQtAvfb7CFeLrHr/rDndzfC49Z3jtN7iYA7boM
         //mZFIQjIt9zILjxp/Q4Sk4quJGhQQzc/iyG+tfIl6UM0KE2oXXcumaYnbhqT9958xKn
         PMNCYSUYcXSWFM/t8494uSERWu4PfQaumLk92dmlaWmgrUoLN8RaHsC/LNtBQSMSVWbI
         hpMT62VZo9tk9rGjqjTffcO8i4chRLhia3861WFtJj0I7BIiK73+aIFV3SZ7D3Em5I+y
         T1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jihHGA4pbQxWZc7vImFG8Ig3lKmwh2M9/yWB0qegmPI=;
        b=j6H3BVtReKRVWMkicl4fM1Yf97QKJdW0oKwLggQoXTLmW5O+TLCvaJJR/NNMUIuEXE
         7KS6D8QBVuW9dxyTFnd3P27fr07uK3ECQSyQ18rCaGga3e4NWgBvcNYsaWtQ63HA/rA7
         BrPSLwoZBwqV5RdzO9irJf7jEaODl7ZFLJ9XrJVUyoxHzUTLefamPt9J0X8YAzsAHUbx
         I22hW4qvsr1fnKiDqbVtwBY9gKz8I/5N6hrLhQVPVETCWQWphvAyTERwe2kNOGjsyq1m
         cawImt4BCE1nqUDpxkyULGhsiYoumRJhLFJ0eLxUq+yaNSrRxIJheRB4AAdAs/jDkCEF
         angA==
X-Gm-Message-State: AOAM532QLn2PNmcLBqx+I28TNMPZHP/kngjx6tje8fooihFAAqK6IULQ
        7xGLPIR3/iqND/aXMT+LkGQ=
X-Google-Smtp-Source: ABdhPJyOE8sv8FFgE2SYbJ9wjWxj62Xty8q0ahKK0n1oLTgL9udbkhTxNOvtG5pvw94MDZrgBjVwqg==
X-Received: by 2002:a05:6870:60a9:b0:d7:2d7a:e994 with SMTP id t41-20020a05687060a900b000d72d7ae994mr5014890oae.43.1646161828601;
        Tue, 01 Mar 2022 11:10:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eq37-20020a056870a92500b000c6699dad62sm6648089oab.41.2022.03.01.11.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:10:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:10:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/34] 4.19.232-rc1 review
Message-ID: <20220301191025.GC563901@roeck-us.net>
References: <20220228172207.090703467@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:24:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.232 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
