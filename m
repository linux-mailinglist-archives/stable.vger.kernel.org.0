Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374444D88E5
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbiCNQNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiCNQNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:13:52 -0400
X-Greylist: delayed 1388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 09:12:42 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.49.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F86D3CFED
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 09:12:41 -0700 (PDT)
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 00E6BCA36
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 10:49:32 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TmuxnCmcCdx86TmuxnAdTm; Mon, 14 Mar 2022 10:47:31 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tRqjCxvAZu7oVyWFJbLmTP0gKVyFUe+nsBqmNBS8AjM=; b=qPBu/eIy+wOL0xOMpiZvJY8Oti
        5uVq1Vf/xOJWsF6WxMdKYnbcZEONDTU8PAyF+SPIihghziOrWcEHNkQaO47XtcXK/Lt412Fw+5F6V
        2jN47CcCjPgkKNQNelr6+CdVm93AYKoPAKjNeF2xQU5ORJq0lt9KdpEV+4U+qQjkEP48ZNtDQ3mkh
        /pkEtze2DNPin4YuOsiWIIIt8N5rt4v0Xq4oe1Sh3SUWZD1jEWokBlp24WKHvY9cNaUj8gV6QAmC2
        l6oyWlOaD9vx7C2+eEbPnUy0NQ6RWQCRxkh+mJgbVYnJyylZOIaRjh9NwO3b5cl4HafFpaQz/0q2X
        HG42j/uw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54250)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTmux-0024nF-39; Mon, 14 Mar 2022 15:47:31 +0000
Message-ID: <3bae3cee-2daf-b622-7057-8e8ae79a1425@roeck-us.net>
Date:   Mon, 14 Mar 2022 08:47:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220314145920.247358804@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220314145920.247358804@linuxfoundation.org>
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
X-Exim-ID: 1nTmux-0024nF-39
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54250
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 11
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/14/22 08:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> Anything received after that time might be too late.
> 

All ia64 builds:

kernel/fork.c:728:13: warning: 'task_struct_whitelist' defined but not used [-Wunused-function]
   728 | static void task_struct_whitelist(unsigned long *offset, unsigned long *size)
       |             ^~~~~~~~~~~~~~~~~~~~~
arch/ia64/kernel/acpi.c: In function 'acpi_numa_fixup':
arch/ia64/kernel/acpi.c:540:17: error: implicit declaration of function 'slit_distance'; did you mean 'node_distance'? [-Werror=implicit-function-declaration]
   540 |                 slit_distance(0, 0) = LOCAL_DISTANCE;
       |                 ^~~~~~~~~~~~~
       |                 node_distance
arch/ia64/kernel/acpi.c:540:37: error: lvalue required as left operand of assignment
   540 |                 slit_distance(0, 0) = LOCAL_DISTANCE;
       |                                     ^

Guenter
