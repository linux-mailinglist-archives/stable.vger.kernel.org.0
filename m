Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100874D2314
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 22:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350055AbiCHVMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 16:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiCHVMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 16:12:09 -0500
X-Greylist: delayed 1277 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 13:11:10 PST
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.145.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EF849C8D
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 13:11:10 -0800 (PST)
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 32C565B79A
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 14:49:53 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id RgmGnUieOdx86RgmHnbR8Z; Tue, 08 Mar 2022 14:49:53 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mtK1aVJ31smKWIVWWlv6HiJulv7YkPPlGrK3oIjYevI=; b=o761dwgjzaq47QnG0dIgBHlD9c
        K4d1RHNDj9+nt/CTKSmTxPIV33WcCtC9aOQcVPFdc9THoEgc78edIrYt5gXs12ks84Mu92tHlhLfp
        8UVETJCoFEu2q4OrtNE45PWj05GCqDqnUk7wYkZUWGQ1hMK619Ddivb/v2figDwiN9IiL4fJI7uWu
        IFswxF/Kl35MC9o18+CmkVBcFcaoSNwdOE3fH2MlZfooOcQXQo63PSK35UN5+ei9YPiPWyKhc6tle
        Ks0USAwH9DXxyGnhkEPEvmegBMI3NVqvSUeOdicIf1yxk4hhl2VfHfOIUJbpXZ6Iw8iOeUmjrTeid
        f763QrCg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38106)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRgmF-002ViM-W1; Tue, 08 Mar 2022 20:49:52 +0000
Message-ID: <d687840f-1622-59de-8369-f1a8c090ae46@roeck-us.net>
Date:   Tue, 8 Mar 2022 12:49:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307162147.440035361@linuxfoundation.org>
 <20220308185219.GA3686655@roeck-us.net> <YienMYvdhGPCcPSv@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
In-Reply-To: <YienMYvdhGPCcPSv@kroah.com>
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
X-Exim-ID: 1nRgmF-002ViM-W1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:38106
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 12
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

On 3/8/22 10:57, Greg Kroah-Hartman wrote:
> On Tue, Mar 08, 2022 at 10:52:19AM -0800, Guenter Roeck wrote:
>> On Mon, Mar 07, 2022 at 05:28:30PM +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.16.13 release.
>>> There are 184 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Your cycles are getting too short for my test system to provide results
>> in time. It gets overwhelmed, especially when there are updates affecting
>> all stable branches which trigger a complete rebuild of all those branches.
> 
> Sorry, but this one had to go out a bit sooner for reasons I don't want
> to speculate about :)
> 

Another one, after the write file issue ? Sigh.
I really hate that the Powers That Be don't tell me about that stuff :-(.

We have severe conflicts against all Chrome OS kernel branches in this series.
I hope that fix was worth it.

> Anyway, I checked your builders, and they all looked ok except the 5.15
> tree, which I know is broken on MIPS right now.
> 
Hmm, sorry, I didn't realize that there was more than one END issue.

Guenter
