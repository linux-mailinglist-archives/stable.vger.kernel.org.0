Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6425FEE82
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJNNXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiJNNXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:23:40 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B6C19E03A;
        Fri, 14 Oct 2022 06:23:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VS82Pwh_1665753811;
Received: from 30.39.66.211(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VS82Pwh_1665753811)
          by smtp.aliyun-inc.com;
          Fri, 14 Oct 2022 21:23:33 +0800
Message-ID: <fb274631-f985-d0cf-4ad9-2fd5711d2064@linux.alibaba.com>
Date:   Fri, 14 Oct 2022 21:23:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
 <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
 <8313d192-f103-35fc-2931-de0a8eb927ff@linux.alibaba.com>
 <SJ1PR11MB6083F89F430B664FC10270C6FC259@SJ1PR11MB6083.namprd11.prod.outlook.com>
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB6083F89F430B664FC10270C6FC259@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.8 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/10/14 AM1:18, Luck, Tony 写道:
>> Thank you for your review, but I am still having problems with this question.
>>
>> Do you have any interest to extend ras-tools to Arm platform? I forked a arm-devel branch[1]
>> from your repo:
>>
>> - port X86 arch specific cases to Arm platform
>> - add some common cases like hugetlb, thread and Arm specific cases like prefetch, strb, etc, which
>>   are helpful to test hardware and firmware RAS problems we encountered.
>>
>> I am pleasure to contribute these code to your upstream repo and looking forward to see a more
>> powerful and cross platform tools to inject and debug RAS ability on both X86 and Arm platform.
>>
>> I really appreciate your great work, and look forward to your reply. Thank you.
>>
>> Best Regards,
>> Shuai
>>
>>> [1] https://gitee.com/anolis/ras-tools/tree/arm-devel
> 
> Shaui,
> 
> Sorry I didn't follow up on this part.  Yes, I'm happy to take your (excellent) changes.
> 
> I did a "git fetch" from your repo and the a "git merge" of all except the README and LICENSE
> commits at the tip of your repo. Those I manually cherry-picked (since the last section of your
> README said "clone of Tony's repo" ... which makes no sense in my repo).
> 
> Resulting tree has been pushed out to git://git.kernel.org/pub/scm/linux/kernel/git/aegl/ras-tools.git

Thank you. I am glad to see it really happens :)

> 
> Please check that I didn't break anything.
> 
> -Tony

I recheck it and all look good except hornet.

hornet use PTRACE_GETREGS to read the tracee's general-purpose registers, but it does not work
on Arm. I will send a new patch to extend it into Arm platform.

Cheers,
Shuai


