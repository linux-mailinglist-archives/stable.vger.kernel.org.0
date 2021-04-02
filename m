Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED577352D83
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhDBPak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 11:30:40 -0400
Received: from out28-172.mail.aliyun.com ([115.124.28.172]:56979 "EHLO
        out28-172.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbhDBPak (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 11:30:40 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1216449|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.00690669-0.000830163-0.992263;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047209;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.JuCJUHM_1617377433;
Received: from 192.168.88.133(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.JuCJUHM_1617377433)
          by smtp.aliyun-inc.com(10.147.40.26);
          Fri, 02 Apr 2021 23:30:33 +0800
Subject: Re: [PATCH] I2C: JZ4780: Fix bug for Ingenic X1000.
To:     Wolfram Sang <wsa@kernel.org>
Cc:     paul@crapouillou.net, stable@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, sernia.zhou@foxmail.com
References: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
 <20210318170623.GA1961@ninjato>
 <644d19d8-9444-4dde-a891-c9dfd523389e@wanyeetech.com>
 <20210331071835.GB1025@ninjato>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <b93bf84f-73fd-f0f9-c25b-d7063be76987@wanyeetech.com>
Date:   Fri, 2 Apr 2021 23:30:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210331071835.GB1025@ninjato>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Wolfram,

On 2021/3/31 下午3:18, Wolfram Sang wrote:
> Hi,
>
>>> Any write operation? I wonder then why nobody noticed before?
>>
>> The standard I2C communication should look like this:
>>
>> Read:
>>
>> device_addr + w, reg_addr, device_addr + r, data;
>>
>> Write:
>>
>> device_addr + w, reg_addr, data;
>>
>>
>> But without this patch, it looks like this:
>>
>> Read:
>>
>> device_addr + w, reg_addr, device_addr + r, data;
>>
>> Write:
>>
>> device_addr + w, reg_addr, device_addr + w, data;
>>
>> This is clearly not correct.
> Thanks for the additional information! I understand now. I added a bit
> of this to the commit message of v2 to explain the situation.
>

Thanks!


Best regards!

