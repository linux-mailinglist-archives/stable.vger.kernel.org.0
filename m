Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7324E84E2
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 03:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiC0BMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 21:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiC0BMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 21:12:44 -0400
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.197.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD5A6B081
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 18:11:04 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 3832F4CC38
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 19:50:29 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YH6zno47Ub6UBYH6znx5Ba; Sat, 26 Mar 2022 19:50:29 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T8ViQ4LT/HZVhOZ36SdMZva535S2DMq1nlWcIs7Wy94=; b=jCdjStWhTztUg/6Mu70NhRL94h
        eSgYZ44O1ibiFdeYatiBJthnk1SUa8KLogmTHTyoWROqJrwJ3kzXUNHjBodYSRRuqa4TTzmn3R70i
        LUHmT0eyeLj3S01Njyo029GsiwDr+vnxlsJS1S64ggkAAfnY7WxiRxKE4CUt4neHc3mAKdgTWSbc+
        ZKsOiIhGICr5YT6G4XGl9+8xjEjaMt/jFsduNZZak6BFuVYNboeEFQVLGfmazcqSo61RkGO1q4Ju/
        iuSeiyv3s0cnvdh0oyZzr/qvcAOX/9FmntlLti0bQuqx0z0gsXY1PyZo7qsCKrAQ8hcAUPxEsMLrI
        GVyRz9AQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57682 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nYH6y-001F4o-DQ; Sun, 27 Mar 2022 00:50:28 +0000
Date:   Sat, 26 Mar 2022 17:50:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/17] 4.14.274-rc1 review
Message-ID: <20220327005027.GB1645909@roeck-us.net>
References: <20220325150416.756136126@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150416.756136126@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nYH6y-001F4o-DQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57682
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 24
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 04:04:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.274 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
