Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198596775BF
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjAWHm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjAWHm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:42:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADF57A94
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:42:27 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s67so8323832pgs.3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IptttD0zrwJVBHp5bq7+qjBs5ITPKtnNpW0l4jsQDD8=;
        b=Y/Y3FQZLk+38WgNCmQ2OEds8uRmKp8aAxAXLlryFng7Rd1c0zkOatiPk9MVWHg1BSj
         hIdSrzm7kOd4b7Zhy/dL1Wow5ZGv8JYLa6ixF/PUcbb89KtIPMW5d7tsvUkW7g8JnCLU
         hzi2Ot7NA4GUrDD41EutU3IfEywqwovLxNahs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IptttD0zrwJVBHp5bq7+qjBs5ITPKtnNpW0l4jsQDD8=;
        b=mNxOh0l6f21x/uqqxOImIzpFtAfVyfBXChr6VFK3UUTK1r4aFLlZY7MqWgdAGV8Ug0
         u3VDL5Y2aUMYvq0Q5yOFUNcx/+G0DfQLiB3wSnbUjVYazy+G5bLvm7b5P20BPqWxtwRh
         JM/WMZspdzmJ12YY59x212yWjqp6wi+W4JzLzQ131btTTUQdB6eE2EGHBJiJzqXmxXyk
         2T2JJ8LegzkJpeTqxeWZSZjgoIoxaNw0K0Gp/sL20QQRHpJdtgOJE0IgsDfCIwf8JY/n
         eAH4nB9qDPC63vtCIN54tiGhFfO2HZUiUtCQVhyEm8WsncV9i/jHaGChP5s2bpovsgbn
         YfmQ==
X-Gm-Message-State: AFqh2koCLsW6SMOl2ykg5rreKcqCBr6UhDqXE4tqTY0t8stsn3ZKWf3f
        ZmG+bvWlFMbxxenSU6cJoAFvNQ==
X-Google-Smtp-Source: AMrXdXs/81TXfWznGLnO9cWhRlZliwMffE/3OQvySFgG0JWO27eatGQvjwmpdBdxcRxyDX+HKcQTOg==
X-Received: by 2002:a62:1488:0:b0:586:b33c:be2 with SMTP id 130-20020a621488000000b00586b33c0be2mr25117581pfu.26.1674459746487;
        Sun, 22 Jan 2023 23:42:26 -0800 (PST)
Received: from 939e86c225aa (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id a10-20020a62bd0a000000b0058837da69edsm397042pff.128.2023.01.22.23.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 23:42:25 -0800 (PST)
Date:   Mon, 23 Jan 2023 07:42:18 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <20230123074218.GA219043@939e86c225aa>
References: <20230122150246.321043584@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

6.1.8-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
