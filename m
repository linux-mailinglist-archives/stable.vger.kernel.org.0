Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DB54E3654
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 02:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiCVCAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiCVCAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:00:17 -0400
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.47.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D15B53A64
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 18:58:51 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id C76A7400C8B5D
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 20:58:50 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WTnOn9p4x22u3WTnOnavnm; Mon, 21 Mar 2022 20:58:50 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4kblsdvEDHbSbsAVFaKduZeml1zNSn0GT8XiiXDHh0I=; b=ueckAKNpoevupahBVkLwsmAQNh
        fbg5kxZrLgtv8gvfQAh6+HhCfppDp7odFHOj9XBWdbrG854iJyuF9HGktj2rS91pE4gbIOVtGEYJS
        ChSCw+4xrC0qr+kiOO2RWAmxd+fMxrn06yrgGuUD1Mw1XhcasWbGoDFN+iLoenx81tSWTWBQoFUrC
        3UoE7oBB8KpEM1WActQgy6DvsEqbG7sCHGaQKjkNJiXSrighfLanvaBnV0jDjR+dRUjhKJ9VAReoH
        E6GVAZne7U2wKX0V31SpL3DSQRBP6Djsk8Fh7rzGEzmsNDPjhBvmkEvrzG/Je4593CezFosWo1tHy
        MOQUl4KA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57582 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWTnN-0025Nl-Vw; Tue, 22 Mar 2022 01:58:50 +0000
Date:   Mon, 21 Mar 2022 18:58:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/16] 4.9.308-rc1 review
Message-ID: <20220322015848.GA4126967@roeck-us.net>
References: <20220321133216.648316863@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWTnN-0025Nl-Vw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57582
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 14
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

On Mon, Mar 21, 2022 at 02:51:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.308 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
