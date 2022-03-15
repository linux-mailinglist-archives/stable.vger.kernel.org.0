Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192BF4D91BB
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbiCOAuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245641AbiCOAui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:50:38 -0400
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.145.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCAA3D1DF
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:49:27 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id A1970749C1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 19:49:26 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TvNOnADCVb6UBTvNOnbvSA; Mon, 14 Mar 2022 19:49:26 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3a9lfZp86vtLknE/eSHMX4MMCOPJye7CBuZw/TfwS+s=; b=oHaw1Ijfq0sFeO8YziyziTTf6M
        EiU2un/bB/S1IpAn6MlouiaCh5skW1e6WggQJDHJD2gIrHhXMRBUt8IAXC5QPlWpSU2ogso2jd71y
        jMvJRH043xabTEobM7KjqSfMaSdSaJHnEfJWlYcgEQ53woyUVSIQPEgivkRFtN221PSa+BvVaww06
        KZNchbPi86PmxNJAoTIhYPqENzT1qIigR+6/mrFl86rD7Ub+ahU+/GWOTF8FEAlDwogeXgd9oTZuz
        heZGssJ0N+o0XZjrnaxgi0/taIBogRUzScIG2q6tnZyOkmXf90TeKULS5z0sKACgPBpLgIB6BHBLD
        biCn0Zew==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57466 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTvNN-003ohA-Q4; Tue, 15 Mar 2022 00:49:25 +0000
Date:   Mon, 14 Mar 2022 17:49:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/22] 4.14.272-rc2 review
Message-ID: <20220315004924.GB1943350@roeck-us.net>
References: <20220314145907.257355309@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314145907.257355309@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nTvNN-003ohA-Q4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57466
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 24
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

On Mon, Mar 14, 2022 at 04:00:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.272 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:58:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
