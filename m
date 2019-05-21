Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338FC248F1
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfEUH0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 03:26:54 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32959 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbfEUH0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 03:26:54 -0400
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A6F2ABF97D3015593510;
        Tue, 21 May 2019 08:26:52 +0100 (IST)
Received: from [10.220.96.108] (10.220.96.108) by smtpsuk.huawei.com
 (10.201.108.37) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 21 May
 2019 08:26:45 +0100
Subject: Re: [PATCH 3/4] ima: don't ignore INTEGRITY_UNKNOWN EVM status
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        <stable@vger.kernel.org>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
 <20190516161257.6640-3-roberto.sassu@huawei.com>
 <1558387212.4039.77.camel@linux.ibm.com>
From:   Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <e81b761c-9133-a432-4d06-3cfe57e29e4b@huawei.com>
Date:   Tue, 21 May 2019 09:26:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1558387212.4039.77.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.220.96.108]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/2019 11:20 PM, Mimi Zohar wrote:
> On Thu, 2019-05-16 at 18:12 +0200, Roberto Sassu wrote:
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 52e6fbb042cc..80e1c233656b 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -1588,6 +1588,9 @@
>>   			Format: { "off" | "enforce" | "fix" | "log" }
>>   			default: "enforce"
>>   
>> +	ima_appraise_req_evm
>> +			[IMA] require EVM for appraisal with file digests.
> 
> As much as possible we want to limit the number of new boot command
> line options as possible.  Is there a reason for not extending
> "ima_appraise=" with "require-evm" or "enforce-evm"?

ima-appraise= can be disabled with CONFIG_IMA_APPRAISE_BOOTPARAM, which
probably is done when the system is in production.

Should I allow to use ima-appraise=require-evm even if
CONFIG_IMA_APPRAISE_BOOTPARAM=n?

Thanks

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
