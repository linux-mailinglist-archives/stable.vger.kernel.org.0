Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5754E3698
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbiCVCYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiCVCYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:24:46 -0400
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FC838A144
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:22:33 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id B62D8968635
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 20:59:33 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WTo5n9pWK22u3WTo5nawDR; Mon, 21 Mar 2022 20:59:33 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OC5mI0xzkany4H/OFUJcNYXc5p1u5zF7zzUPXqUWxoA=; b=lkA/8SsVZid2UsK0LYYVYGcNv3
        1xwTaoQ2h6Rg9z2dqXF5t0gnSANlDdCLB41V4XxXcUSDeP/pby85Ww4PiDFz993eMwYqqBn72vM9L
        v207anZb/rGe38IZPdXklsgMgs7ozkjaUPGecQTZCZqFkV8y+8TRKY0zt7qnYKq2E72xBgvooF+F6
        8XAR4ARSi9/gnPGLwWQxUXVST2bW3hbT3f/i3Nb0xFIJYK+9zcewULhiyjinV5byKP1Zc1R0K1v7I
        RbJ6hbo09kgCjFRUlLr1xQM1kKj+vIvJ90yuwZpzlzVi+sCNFp+d5uYi6OuSgc2MMESYw9eTHKLHJ
        /CKHxNLA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57586 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWTo4-0025rD-TN; Tue, 22 Mar 2022 01:59:33 +0000
Date:   Mon, 21 Mar 2022 18:59:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/57] 4.19.236-rc1 review
Message-ID: <20220322015931.GC4126967@roeck-us.net>
References: <20220321133221.984120927@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWTo4-0025rD-TN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57586
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 40
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

On Mon, Mar 21, 2022 at 02:51:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.236 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
