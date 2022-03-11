Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6574D5718
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiCKBE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbiCKBE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:04:58 -0500
Received: from gateway31.websitewelcome.com (gateway31.websitewelcome.com [192.185.144.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77722C683C
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:03:56 -0800 (PST)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 0095B113D51
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:03:56 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id STfHnl4lrRnrrSTfHnP4tU; Thu, 10 Mar 2022 19:01:55 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ytH+doHtBFYUDclgFkaIkx83Z2JDV/D8Ysa+LbIjoBY=; b=DHBLxR6Zf9oH2Yb4mip+xLzufC
        KRh3xBX5hHkaE2i7X950QCwrycC+wb0indR567T4Og0FgKo+1Kh1I+N8T3hok5P/SVtJpmCfBOKBX
        r8oGrZJt+l3v7f7X1uJq1nQ8c7sA2lDfcgx1+fBuKnN7I58XJE7dbaU5n6RkzUqZEyH8NMQwyklPJ
        bfg5I7OZv1WE/HguUl9ZGWgXM7zeui6yRyZtsXmWrEbVtOKmHFIn7U/8ndBRN43SolRR0num2EGgi
        aw+GSuQt7NsKVUagVwTQbEpQeMGEuBvfRx4s8hi6Pki90k2vt9p8o6NqN9mkmBWez3L1ubaA54tpm
        U8X7VB6g==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57428 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nSTfG-001mDL-Lo; Fri, 11 Mar 2022 01:01:54 +0000
Date:   Thu, 10 Mar 2022 17:01:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/33] 4.19.234-rc2 review
Message-ID: <20220311010153.GB3881529@roeck-us.net>
References: <20220310140807.749164737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nSTfG-001mDL-Lo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57428
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 31
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

On Thu, Mar 10, 2022 at 03:18:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
