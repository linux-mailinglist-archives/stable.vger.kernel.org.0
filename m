Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC585F37E1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 23:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJCVer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 17:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJCVeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 17:34:25 -0400
Received: from premium237-5.web-hosting.com (premium237-5.web-hosting.com [66.29.146.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2174B286EB;
        Mon,  3 Oct 2022 14:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sladewatkins.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DIBc1nStTrOqSv0pL7+PmETfuH70Ti7x9rGGbFx7i5Q=; b=qqonJElMz7gJPVNG8qegZCAyQB
        5GMnGLnXwtfi/E16w9EZQ2bu5/ZbVuNoWyFken54+y5FTXpc+nxaTv4tXAK78NzeAHk1p24bHyGKb
        ZNtpfWX7aLXHwg7O/1oMvM0tz4QyU6aX+hTuDsqu1+Ynam/bxmwArDlpoxtbpVm+nJYAbG4tMS7Ja
        SCyNzSDPb+Xv9nv2jtSXZEILhNIL7oCnngCPrvBpaDWlgJbZKDb6Hf6DTq6pYssmdAPx0ypma9/ne
        50Lz4SYCUR/IOGKXvaoS3LrLahDAcAlRGdtWBTgPCa1nMQAjbUYA52YyGV5STl7g6x3y923Yvo0HF
        ovhfE+iw==;
Received: from pool-108-4-135-94.albyny.fios.verizon.net ([108.4.135.94]:55609 helo=[192.168.1.30])
        by premium237.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srw@sladewatkins.net>)
        id 1ofT12-000jEh-GC;
        Mon, 03 Oct 2022 17:30:20 -0400
Message-ID: <69d9f828-e322-b019-7e09-faa95fccb1fe@sladewatkins.net>
Date:   Mon, 3 Oct 2022 17:30:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.1
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20221003070721.971297651@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - premium237.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sladewatkins.net
X-Get-Message-Sender-Via: premium237.web-hosting.com: authenticated_id: srw@sladewatkins.net
X-Authenticated-Sender: premium237.web-hosting.com: srw@sladewatkins.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/3/22 at 3:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

5.15.72-rc1 compiled and booted with no errors or regressions on my 
x86_64 test system.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-srw
