Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A4D5B918E
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiIOAQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 20:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiIOAQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 20:16:21 -0400
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Sep 2022 17:16:19 PDT
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5635FACC
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 17:16:19 -0700 (PDT)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id CCD1633A9B4
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 19:16:18 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YcYEoJUrq9ULXYcYEo6Sjo; Wed, 14 Sep 2022 19:16:18 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OWeZ3X+YfpufrP32pFwnzjr9SmrTxIgR0t/8xkGDE+g=; b=lbSCNqvYwIKnQwtr6jZnwojPe2
        JckGwmoNcDxLyAcdED+Hw4TEZ0Rtz47ZJ8btAoA8ODOOPvx4dhYkfv0LOK4l6YvsjNFPcHfS/QGFb
        uQNAi7O8d8cAZre0YlB3i18onUcQerBLOEClRj4qe+YFSYoSrDTpFe0cuImL//HfxTlDiJBsuJqcm
        ZOrtzCVBWWXJt9vfY5GgxXwteuAhH4qb4VHrq9jPkEK+o458U/xzJchVCm2TyuwG6lGVSCjh1qSZi
        oK8uBzLE+auzkyrtG/S0OIeIF0AIJZZlPBgTD23iLs4OqvBtOGz6/0pzNbcevwVijGJlQ+S7KcMOq
        5KYtrkUQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:37962 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oYcYD-003OQQ-RQ;
        Thu, 15 Sep 2022 00:16:17 +0000
Date:   Wed, 14 Sep 2022 17:16:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/42] 4.9.328-rc1 review
Message-ID: <20220915001613.GG603793@roeck-us.net>
References: <20220913140342.228397194@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oYcYD-003OQQ-RQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:37962
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 89
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

On Tue, Sep 13, 2022 at 04:07:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.328 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
