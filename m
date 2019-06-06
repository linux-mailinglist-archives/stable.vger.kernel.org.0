Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89B9377C2
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 17:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfFFPXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 11:23:00 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32991 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727309AbfFFPXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 11:23:00 -0400
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 2DBB8E100CBDDB9E06CD;
        Thu,  6 Jun 2019 16:22:58 +0100 (IST)
Received: from [10.220.96.108] (10.220.96.108) by smtpsuk.huawei.com
 (10.201.108.35) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 6 Jun
 2019 16:22:48 +0100
Subject: Re: [PATCH v3 0/2] ima/evm fixes for v5.2
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
 <3711f387-3aef-9fbb-1bb4-dded6807b033@huawei.com>
 <1559832596.4278.124.camel@linux.ibm.com>
From:   Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <e5bc45e0-dd61-c2ef-ba51-2bccb7a07676@huawei.com>
Date:   Thu, 6 Jun 2019 17:22:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1559832596.4278.124.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.220.96.108]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/6/2019 4:49 PM, Mimi Zohar wrote:
> On Thu, 2019-06-06 at 13:43 +0200, Roberto Sassu wrote:
>> On 6/6/2019 1:26 PM, Roberto Sassu wrote:
>>> Previous versions included the patch 'ima: don't ignore INTEGRITY_UNKNOWN
>>> EVM status'. However, I realized that this patch cannot be accepted alone
>>> because IMA-Appraisal would deny access to new files created during the
>>> boot. With the current behavior, those files are accessible because they
>>> have a valid security.ima (not protected by EVM) created after the first
>>> write.
>>>
>>> A solution for this problem is to initialize EVM very early with a random
>>> key. Access to created files will be granted, even with the strict
>>> appraisal, because after the first write those files will have both
>>> security.ima and security.evm (HMAC calculated with the random key).
>>>
>>> Strict appraisal will work only if it is done with signatures until the
>>> persistent HMAC key is loaded.
>>
>> Changelog
>>
>> v2:
>> - remove patch 1/3 (evm: check hash algorithm passed to init_desc());
>>     already accepted
>> - remove patch 3/3 (ima: show rules with IMA_INMASK correctly);
>>     already accepted
>> - add new patch (evm: add option to set a random HMAC key at early boot)
>> - patch 2/3: modify patch description
> 
> Roberto, as I tried explaining previously, this feature is not a
> simple bug fix.  These patches, if upstreamed, will be upstreamed the
> normal way, during an open window.  Whether they are classified as a
> bug fix has yet to be decided.

Sorry, I understood that I can claim that there is a bug. I provided a
motivation in patch 2/2.


> Please stop Cc'ing stable.  If I don't Cc stable before sending the pull request, then Greg and Sasha have been really good about deciding which patches should be backported.  (Please refer to the comment on "Cc'ing stable" in section "5) Select the recipients for your patch" in Documentation/process/submitting-patches.rst.)
> 
> I'll review these patches, but in the future please use an appropriate patch set cover letter title in the subject line.

Ok.

Thanks

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
