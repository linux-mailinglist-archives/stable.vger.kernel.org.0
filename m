Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02865BB449
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiIPWIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 18:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiIPWIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 18:08:39 -0400
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.49.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EA6BB923
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 15:08:38 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 64414400C74A3
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 16:46:00 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZJ9sody0FSQZkZJ9so5F61; Fri, 16 Sep 2022 16:46:00 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6A/1Xc0AcvbQPB1FKwFOyX/vKvUf0YDnXqsk5LaKAZw=; b=F5YG9H6hemKtwL6w7qqOx7Nxwc
        nC1m48jfOZK5MJ15uWPyF8Mf+re2b2D8UlJpOFHtY//aADTVpurHsX9NoUxQg/5WCil/FGnzAWLPU
        0dm6LXzEKb1ftFWsgNAzrF96Bsli/QnfuEb5NUqmDIjMJTmFQVL6OrPwWKbx1bXGq5QhgK8gjRi0k
        0BZpuyJzpA7fZSRg0SNEg1ZzjYwM+eVVavECjpIdobtEAowd+Wb49YBxsvgc1okPzXodfeB/xaEWV
        Ly6Cwlxp3CyHMI7MzEJ8gHJEcyrMfGTvONt2ntJjb49QyBjbZffDAOBeSKiPYky1Ev0P094HM4QZZ
        A8uOdf5A==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:58452 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oZJ9r-002btv-6R;
        Fri, 16 Sep 2022 21:45:59 +0000
Date:   Fri, 16 Sep 2022 14:45:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 0/7] 4.14.294-rc1 review
Message-ID: <20220916214554.GB3350231@roeck-us.net>
References: <20220916100441.528608977@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100441.528608977@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oZJ9r-002btv-6R
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:58452
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 24
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 12:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.294 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
