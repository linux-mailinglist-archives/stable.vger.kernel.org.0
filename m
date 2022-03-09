Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5F14D3AA0
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiCITvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbiCITvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:51:42 -0500
X-Greylist: delayed 1374 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 11:50:43 PST
Received: from gateway31.websitewelcome.com (gateway31.websitewelcome.com [192.185.143.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE16F205F3
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:50:43 -0800 (PST)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 9E181EDFF9
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:27:48 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id S1yOn0xv2HnotS1yOnOdQL; Wed, 09 Mar 2022 13:27:48 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3YPETikwgZf/61jCoqWj0cVi6BGtD6q2kACd4EOhH0A=; b=u6PyuyK3WByUv1ne6OQc+fEH58
        U5sSA80HLmCvK/uMHiF0GCK0vFUOkLVMnvJhrQMmh53zXDAfR1HAPp2PGpu4Eum7PXMoDGvEk/h0H
        D7VvnjWsymzb8CV9kho0woFyr4476sOVq5F5Pmg3OtxEcx7XnYrk1IWTxnWwiJzkCjx7IgX5vo/b/
        Ju0dzrOihPktuqVOEyeEqGwgOBjQo1WE/t/D1jxtNyIMr/pXC9Ys0SRjO6bIEe/dzlpCrmIMaM/tc
        Kp3HPp21Kha/tz0EHzZ0y7//E2reIcVboAJ+IdVy002kz+TpbqOYWSbQvO/W6zWpBPXnGP5YzrhQJ
        XJu8zUrw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54204)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nS1yN-002JpO-Qk; Wed, 09 Mar 2022 19:27:47 +0000
Message-ID: <244cf721-8e68-c540-384a-a8cf24f450e4@roeck-us.net>
Date:   Wed, 9 Mar 2022 11:27:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/18] 5.4.184-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155856.552503355@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nS1yN-002JpO-Qk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54204
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 37
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 07:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 

Building i386:defconfig ... failed
--------------
Error log:
arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of function 'unprivileged_ebpf_enabled' [-Werror=implicit-function-declaration]
   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
