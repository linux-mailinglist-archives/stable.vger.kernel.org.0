Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79CC6AB450
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 02:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCFB0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 20:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFB0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 20:26:35 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEE8F97C;
        Sun,  5 Mar 2023 17:26:33 -0800 (PST)
Received: from dggpeml100012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PVLTS4DTLz9tLG;
        Mon,  6 Mar 2023 09:24:28 +0800 (CST)
Received: from [10.67.110.218] (10.67.110.218) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 09:26:31 +0800
Message-ID: <acc08af9-fdb3-5451-5c53-44784982fe2a@huawei.com>
Date:   Mon, 6 Mar 2023 09:26:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 5.15] usb: dwc3: dwc3-qcom: Add missing
 platform_device_put() in dwc3_qcom_acpi_register_core
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <agross@kernel.org>,
        <bjorn.andersson@linaro.org>, <balbi@kernel.org>,
        <lee.jones@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230303023439.774616-1-zhengyejian1@huawei.com>
 <ZAIW9mkHpKKQyIK+@kroah.com>
From:   Zheng Yejian <zhengyejian1@huawei.com>
In-Reply-To: <ZAIW9mkHpKKQyIK+@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/3 23:49, Greg KH wrote:
> On Fri, Mar 03, 2023 at 10:34:39AM +0800, Zheng Yejian wrote:
>> From: Miaoqian Lin <linmq006@gmail.com>
>>
>> commit fa0ef93868a6062babe1144df2807a8b1d4924d2 upstream.
>>
>> Add the missing platform_device_put() before return from
>> dwc3_qcom_acpi_register_core in the error handling case.
>>
>> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
>> Link: https://lore.kernel.org/r/20211231113641.31474-1-linmq006@gmail.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CVE: CVE-2023-22995
> 
> That is a bogus CVE, please go revoke it.

Agree. I see this CVE and its fixes information from NVD,
so try to backport this patch to fix it:
Link: https://nvd.nist.gov/vuln/detail/CVE-2023-22995

Then should I just remove the "CVE: " field and send a v2 patch?
Or you mean "revoke" the CVE from NVD? I actually don't know how
to do that :(

> 
> thanks,
> 
> greg k-h
