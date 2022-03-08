Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819EA4D212F
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 20:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240225AbiCHTPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 14:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240107AbiCHTPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 14:15:45 -0500
X-Greylist: delayed 1346 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 11:14:48 PST
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.147.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556694EA1D
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 11:14:48 -0800 (PST)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id C583D32045B
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 12:52:21 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id RewXnAyidb6UBRewXnma4g; Tue, 08 Mar 2022 12:52:21 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rG5f3jQYnuxfEk/KKG0uOcNSlv/iKtxoSLVQ4t4GFXg=; b=E0ikV0HCb7WrLCcdBIxeGlDaq6
        FZ2J+lamLMADM0hIuF6nlz/QnwmxgPJFDHLSbhTxb3cDG6DVy6o906vwIU+Kfhz8gYvWN+e4afJLg
        LX9w8s311fIaiEl0nk390QjlFYwHNg7PWlu0WHRaXWCT3cfMF8qtSdXk5FCrW1tnxyT9aBJzDv6kk
        lvjp4RXNXtMAKcMcxq6YY1Mh6jsV2VlytHuvR8e9M+fhKxxn3qmht0qcE4lUqsxHLPCleU3b09uCH
        U96eSJ3fzb4LT4rRJ0mbbMydbAgycbGgzLbMmXxMIWQMwCnFfIXw8CbFOx5w+wldypOn3N6arpdPg
        t+qjH4qQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:58904 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRewX-0012O6-1e; Tue, 08 Mar 2022 18:52:21 +0000
Date:   Tue, 8 Mar 2022 10:52:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
Message-ID: <20220308185219.GA3686655@roeck-us.net>
References: <20220307162147.440035361@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nRewX-0012O6-1e
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:58904
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

On Mon, Mar 07, 2022 at 05:28:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
> 

Your cycles are getting too short for my test system to provide results
in time. It gets overwhelmed, especially when there are updates affecting
all stable branches which trigger a complete rebuild of all those branches.

I see you published the current set of releases already, so I won't bother
sending test feedback this time around.

Guenter
