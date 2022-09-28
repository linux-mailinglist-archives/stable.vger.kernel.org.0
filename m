Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178AF5ED292
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiI1BT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiI1BTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:19:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B65C1114FE;
        Tue, 27 Sep 2022 18:19:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l9-20020a17090a4d4900b00205e295400eso354260pjh.4;
        Tue, 27 Sep 2022 18:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=cDGC1p/IDa6yE33JhmAS0LH/wUOVCV7+7nJ3wQ7IJgE=;
        b=IfargIZVX5kD6sfAryJzN1CKyUZROZfkYtVmZxExdsLWgE2tiIatHKMTZhL9BsBZ6H
         nTiITkweM2vM85AVEMnauZZENedFR0oJBj90EmR3fpCoywNp8yq1CWdqNMXJlJO8QaAE
         xdgmyCxfahTw8lIv0I8pNTPr6p5r2InAm+8srec+xY7BGvNIroNcB/RXMW3+LjLj9lhe
         Plmb3LlyLWbrZHx5JgjTdfCznAK2EyUBrEDv+GZqQ75Wo9xm0HSREjP0UzcBKoMz+Urz
         +b25hfgzSmb6iVPnjIMFENV93UaMvfABGhTYqEg7bJtRWyMzRrraUs1cHdRqhzF59XUi
         8pEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cDGC1p/IDa6yE33JhmAS0LH/wUOVCV7+7nJ3wQ7IJgE=;
        b=olo7WgpDemro7EEPdC8I0VAeDJ0fWHiUQcXcQAbk7x4aQ+xfLFvBtBMQdhFRpGKRYt
         DmZKsdhmSJ/6Xpwk5r3toESf46crHHa+MVjFe0klKdS83OhcSXKtzDsu5awiqCJ566Wq
         fEC2eYy2HiMdFQX+/O7tZyrBJGroCi/lRQBGNOsk8LNDK1f0pguqUnK/yVSM4sg1P1M/
         bAFTsEgWsl8ZwdXDKPWAFEFuDio8+XRVEPhlq32RDQLiaeDgEmv0DXYlqvf+kZvxMjQE
         M1OnSfshUvBpOazcSjVdzxuu81iPioltn+l8pbNcQFwfEaIJTD94DXaXmXj66gVcukrB
         c3uA==
X-Gm-Message-State: ACrzQf3Jyrc1hroujXRTowQ5WMHi9h9e9CozgzO4ecnrrESRRfiseT9g
        DL7tfJGIaO3VN2OQQl5N1RI=
X-Google-Smtp-Source: AMsMyM4E/7Wk0eO+cuQqLWbF6mCITnrCXqd0NVYZVeOA4xABpGt3JvsnTfORzB06AnI6VfAJNKZ9CA==
X-Received: by 2002:a17:90b:4b04:b0:203:9c4e:7cc1 with SMTP id lx4-20020a17090b4b0400b002039c4e7cc1mr7436556pjb.16.1664327963941;
        Tue, 27 Sep 2022 18:19:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q4-20020a17090a430400b0020036e008bcsm183620pjg.4.2022.09.27.18.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:19:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:19:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
Message-ID: <20220928011922.GD1700196@roeck-us.net>
References: <20220926163546.791705298@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163546.791705298@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:36:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
