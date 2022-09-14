Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7125B8A7C
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 16:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiINO2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 10:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiINO2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 10:28:48 -0400
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.48.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE108DAC
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 07:28:47 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id CB91A1663ED
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 09:28:46 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YTNeos8RASQZkYTNeoKn9r; Wed, 14 Sep 2022 09:28:46 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2nbWnZpDqspK8M+l3wuY1LlZYNNNGLo4dDPJVIDYOn8=; b=pxGivBBmG7m2joqZGJWU1azhNw
        mbZ02DgKrnei52l8GvUf5FLPmktwBrnYXPGjM7m4BQsovdRrN7BKKJyPqDNADXRar0w66xAvQuws7
        v2p9r7IxAsE54R3UDuaMPbuTBxfAqIWgRrNwdXIFWNaWtrwowPwv7ocIvD5R9PzN6v5ye9kIj2Fw3
        SVw3Ks6/nO344ycn6IH6puOeMX6YPsEyq8zh7Aln5RsFOn+/IBAf1LN9ngOjiRVhEehboKma3eSFp
        blqvym236lbuRM0O9qRQU3VYtJrMltoP2CDLIs7nIPQwrhygruJlkjLVM329HcAPCsYmbrxguGL0l
        v1dH3EFg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:39584 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oYTNd-002R0A-9S;
        Wed, 14 Sep 2022 14:28:45 +0000
Date:   Wed, 14 Sep 2022 07:28:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <20220914142843.GA941669@roeck-us.net>
References: <20220913140410.043243217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oYTNd-002R0A-9S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:39584
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 16
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

On Tue, Sep 13, 2022 at 04:01:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
[ ... ]
> Csókás Bence <csokas.bence@prolan.hu>
>     net: fec: Use a spinlock to guard `fep->ptp_clk_on`
> 

This commit is broken, will be reverted upstream, and should not be
applied to any stable releases.

Guenter
