Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EF54D91C8
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiCOAwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbiCOAwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:52:37 -0400
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770E242A34
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:51:26 -0700 (PDT)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id E33798CFAA
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 19:51:25 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TvPJnUFnYXvvJTvPJnhe75; Mon, 14 Mar 2022 19:51:25 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pCQyhKIzdwJRZj5d+qeDKkVBVrWjlQZ56RLSsmiAbCQ=; b=AnXYisVKcO6CUM3k8PJoI76cuZ
        QyrghgBaUVLRW6RL/zE95KefEucKtWaHPIjCzvD+F5a328nG+twEuZoHlxrAroVNkByh2y9qLwhLT
        nLlgovDXBPYXi3ftwPHVjENNWeJWuvEfBzCuWdSf4/pdo5FRcEyYRBhupqc8v3j100GRrPtV3hH24
        /w+OvBQG3CVkw+BtAPJ9rrieEmzFQI9QDL2rzCpWu9DTGVdUl3dOrkz1WGOpUyXArLccZRjoZm7c7
        4fL7kOAH6tMT2at8MNnaoOJX00MBhME67TdkEoHAbMvMOWMGeug5xFuTCHJ+shKPBK9vg3ozsciDa
        SS8UMFQA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57470 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTvPJ-003q7Z-3W; Tue, 15 Mar 2022 00:51:25 +0000
Date:   Mon, 14 Mar 2022 17:51:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
Message-ID: <20220315005123.GC1943350@roeck-us.net>
References: <20220314145920.247358804@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314145920.247358804@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nTvPJ-003q7Z-3W
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57470
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 37
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 04:00:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 153 fail: 3
Failed builds:
	ia64:defconfig
	ia64:allnoconfig
	ia64:tinyconfig
Qemu test results:
	total: 425 pass: 425 fail: 0

Build failures as already reported.

arch/ia64/kernel/acpi.c: In function 'acpi_numa_fixup':
arch/ia64/kernel/acpi.c:540:17: error: implicit declaration of function 'slit_distance'; did you mean 'node_distance'? [-Werror=implicit-function-declaration]
  540 |                 slit_distance(0, 0) = LOCAL_DISTANCE;
      |                 ^~~~~~~~~~~~~
      |                 node_distance
arch/ia64/kernel/acpi.c:540:37: error: lvalue required as left operand of assignment
  540 |                 slit_distance(0, 0) = LOCAL_DISTANCE;
      |                                     ^

Tested-and-reported-failed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
