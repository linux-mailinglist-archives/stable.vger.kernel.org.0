Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744AF4D91CD
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344022AbiCOAyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344009AbiCOAyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:54:55 -0400
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.50.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B6EBF50
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:53:44 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id BF51D233F7
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 19:53:43 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TvRXnbc7fRnrrTvRXn9W5R; Mon, 14 Mar 2022 19:53:43 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5fgNwEORq9lNtfunc3Gc7PDe4t3ywET2mVsMrjGjJrc=; b=jpvhu2JuAc9EkLg3wh5k3r0sXX
        fcbWRJXWG86lgWzJ7SmdRv+yAvzG6t7pXSDIXGdGBFgRzDyK78xNXJco5Pwac4Kfg/7rwkhUmwsmk
        NjhNJWFs5gUGw3DOltUwv5rIyne/TuyJi4m3/veDw4F6Yvc260E+zIbMdjLyNjjQt7Z5KxW23xmVH
        ygqGZp1K10OFexoxdidAoMppEpitKDY7Azf13aBKN1Neo/Nm1ZYnr68TnI99iQMf870LdyzREw6TJ
        vDKscVJsATqluCxRFVbb4NNClJO9Kn82mULeYSKyH6kMPz9Z96WxespbaCHME0pPNKIrHPhTf0iSL
        ks7sWdgA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57476 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTvRW-003rrZ-U6; Tue, 15 Mar 2022 00:53:43 +0000
Date:   Mon, 14 Mar 2022 17:53:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/110] 5.15.29-rc1 review
Message-ID: <20220315005341.GF1943350@roeck-us.net>
References: <20220314112743.029192918@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nTvRW-003rrZ-U6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57476
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 76
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

On Mon, Mar 14, 2022 at 12:53:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
