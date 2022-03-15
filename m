Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59DF4D9220
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 02:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343975AbiCOBP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 21:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbiCOBP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 21:15:27 -0400
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com [192.185.47.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E991FA5C
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:14:16 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 0092B7778
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 19:50:59 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TvMwnSsNgHnotTvMwniPEx; Mon, 14 Mar 2022 19:48:58 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7e9lSAFHRQsL8MFUd6MmPjvyFA+eusMwmM6ijWIYdM0=; b=IBLBZLFk4GjLrday5OAr4L/EEK
        aWlp6ZDw0fjfHdZ++aZ5kD7HFDx8WKDGL2d7gkrbyi3Uro+FCVbAKHhfLMcs6X5IF6x3Cn3rc/Afi
        2bqCsRGjQsYRC+qVuQKr0L6ApaexgzMmL3FpzmI62lrUWjQjrYXHmGDE4Wu2XozNHBQ5ovlyrb7mX
        9isQScJlJwL96QM5F5dwAKyD3P2v5KcH1LFOBRZPPhONMxr+nCBribzbqN5gwh/5+XspUI+t2oweq
        JeoZsHQGS47EAG9WYU7xoyjxHVBiRKlt86atB2ld75qedzr3z5+5FhYY5dTD/JuM3kPa/ZDUFBZsI
        VX8ZVSwQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57464 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTvMv-003oQh-HM; Tue, 15 Mar 2022 00:48:57 +0000
Date:   Mon, 14 Mar 2022 17:48:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/19] 4.9.307-rc2 review
Message-ID: <20220315004856.GA1943350@roeck-us.net>
References: <20220314145911.396358404@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314145911.396358404@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nTvMv-003oQh-HM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57464
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 11
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

On Mon, Mar 14, 2022 at 03:59:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.307 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
