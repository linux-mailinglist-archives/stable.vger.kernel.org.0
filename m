Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E354D0188
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 15:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiCGOi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 09:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243319AbiCGOiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 09:38:24 -0500
X-Greylist: delayed 1338 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Mar 2022 06:37:29 PST
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.61.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62E23A9
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 06:37:29 -0800 (PST)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 5C5A2400F02EF
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 08:15:06 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id RE8fno8AxHnotRE8gnFne3; Mon, 07 Mar 2022 08:15:06 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mExfza9Swq8QkIJylEbCbdZzmqYa/N9/7AiymPbUTCM=; b=rYNQMX+01131Q8XdRFTD87aLuD
        mQZXzvMFnaxxvYTfvBLW+3zKJ601cNRfA4eME2mcxX3PnBhUamllQ0190VDcGE9Mo3JcH767LOBSX
        xqcGlbUytabfC9WPxJWzEeZ6IOeZ5apKh6C0RnSUqityirORLyr+zV3DVUff2iQ9KxvOgDr1PidcX
        mPdl0BIU8SMRQdHJuHY7YbTH1JZAGDByoLKNUkLTXFdZt/vRj8nTKwhIvX0ppXAUiTOLeqLAQgg4p
        pxu6eYuefCBHujZaeoqFzP9O2hJES+nsnPQ8W0rYQLrryM1kPz8bRbcdgo56fsezxuza/eiZiyLEQ
        yB2N+C1A==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38090)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRE8f-001zAT-7h; Mon, 07 Mar 2022 14:15:05 +0000
Message-ID: <d71d84d2-5aa2-7d72-9fdb-a0ac203cefb2@roeck-us.net>
Date:   Mon, 7 Mar 2022 06:15:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/105] 5.10.104-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091644.179885033@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
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
X-Exim-ID: 1nRE8f-001zAT-7h
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:38090
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 11
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

On 3/7/22 01:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 


Building powerpc:allmodconfig ... failed

In file included from include/linux/module.h:12,
                  from drivers/net/ethernet/ibm/ibmvnic.c:35:
drivers/net/ethernet/ibm/ibmvnic.c: In function 'ibmvnic_reset':
drivers/net/ethernet/ibm/ibmvnic.c:2349:23: error: 'entry' undeclared
