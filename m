Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE904EEBBA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345054AbiDAKpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345018AbiDAKpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:45:21 -0400
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.146.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0A2F5D
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:43:26 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id DD126E8BC9
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 05:43:24 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id aEkWnX5ezRnrraEkWneGfD; Fri, 01 Apr 2022 05:43:24 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5pbQIg6YsXn8wmWGH2b/MXNYF1+hu6+lMoTU2gl7eSg=; b=AFJKAziXCupPs4DhNl+gP49sfx
        gWF7KxrysPtoLYUL1dPEejvSiF2GP+ofhxYYM/k47Cr2LInnbsWEYpfacISGWIWKiwgBFHhgzGdxL
        Y4gmlp/YzZu9irLzqbBgEz9AV/Y83MIxVaClG/rzBo8PWvgOQbBkav0ZydWkxwvtl/FciB3rr/IIQ
        lOZ3XjHmlNXuuSifSuXNvtn2xkrG+KEkbzDZg9FnFjKgGbfDwAfHwuECx0c+U27DFAGIcfeVvsBzP
        GFPXBCAL/2gmcR9pVoP+ftnntjxuwk9t5/omkyvMtGeDZ6ZczEK0Id5ZEnaenP1QVsueUfWDhRA1h
        bYz6X7Ug==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57790 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1naEkW-000lhx-42; Fri, 01 Apr 2022 10:43:24 +0000
Date:   Fri, 1 Apr 2022 03:43:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/27] 4.14.275-rc1 review
Message-ID: <20220401104322.GA3911910@roeck-us.net>
References: <20220401063624.232282121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1naEkW-000lhx-42
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57790
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 11
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 08:36:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.275 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 Apr 2022 06:36:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
