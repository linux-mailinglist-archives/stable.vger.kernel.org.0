Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566D943581F
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 03:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJUBXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 21:23:21 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:8461 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUBXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 21:23:21 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56170c072adc-0f24a; Thu, 21 Oct 2021 09:20:51 +0800 (CST)
X-RM-TRANSID: 2ee56170c072adc-0f24a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.26.114] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26170c072c15-3fcf0;
        Thu, 21 Oct 2021 09:20:51 +0800 (CST)
X-RM-TRANSID: 2ee26170c072c15-3fcf0
Subject: Re: [PATCH v2] crypto: s5p-sss - Add error handling ins5p_aes_probe()
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        vz@mleia.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
 <ff261b7b-47a2-0cd8-8dcd-91f18998a482@canonical.com>
From:   tangbin <tangbin@cmss.chinamobile.com>
Message-ID: <f2c152bd-edc5-25ea-816f-092f18549658@cmss.chinamobile.com>
Date:   Thu, 21 Oct 2021 09:20:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ff261b7b-47a2-0cd8-8dcd-91f18998a482@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Krzysztof：

On 2021/10/20 19:38, Krzysztof Kozlowski wrote:
> On 20/10/2021 13:06, Tang Bin wrote:
>> The function s5p_aes_probe() does not perform sufficient error
>> checking after executing platform_get_resource(), thus fix it.
>>
>> Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>> Changes from v1
>>   - add fixed title
>> ---
>>   drivers/crypto/s5p-sss.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
> You still missed the cc-stable tag. I pasted it last time.
> Cc: <stable@vger.kernel.org>

I am deeply sorry for my patch v2，I thought it to cc when use git to 
send-email.

I am sorry to waste your precious time. I will correct it immediately.

Thanks

Tang Bin



> Best regards,
> Krzysztof


