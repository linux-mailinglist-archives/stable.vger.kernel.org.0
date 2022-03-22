Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83784E365B
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiCVCBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiCVCBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:01:24 -0400
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com [192.185.47.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C3962101
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 18:59:58 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 5C832606A
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 20:59:57 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WToTnvZPSRnrrWToTnIhqt; Mon, 21 Mar 2022 20:59:57 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4mTxbMmJPnDA9ocWsyW+BSlEZF/A2islwkLTwf5mctA=; b=1eqb9IgKb3XhMuZwRA2hhZbh56
        cne5/cKbnrtVDnpyLIQzBT4Z9CFib/QnLSb35Ezb635FNy6eSltzrjs5BFllGnOYQITFxmTz1x/af
        xQW8Oxv8UGCNT0Nz8npRBaxrXQE73MtOkGsmhOVTRJNxL3BRqBXcVIL0m6211Pv4LCOhIUK8ztcSS
        ZLN7iQ75ugxDRfb8qt1ROy3qkBu6HcRYKx55q/0+cSudePal0q72/QKbIgcnVNI7aq3EzauHJmSgP
        m2wFXC8MM4uEIF2/czhRMZBruS0L591yRa9APUQEkcv+aA62Ti8KuBhkWphWxrF1FEvmqP2rHhrO3
        kTZUIGuA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57588 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWToS-00264l-IW; Tue, 22 Mar 2022 01:59:56 +0000
Date:   Mon, 21 Mar 2022 18:59:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/17] 5.4.187-rc1 review
Message-ID: <20220322015955.GD4126967@roeck-us.net>
References: <20220321133217.148831184@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWToS-00264l-IW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57588
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 53
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

On Mon, Mar 21, 2022 at 02:52:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.187 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
