Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E45688C49
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 02:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjBCBK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 20:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjBCBKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 20:10:24 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545E410FF;
        Thu,  2 Feb 2023 17:10:23 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P7HbZ0JpBzJqhq;
        Fri,  3 Feb 2023 09:08:42 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 3 Feb 2023 09:10:13 +0800
Message-ID: <02723ce8-0ad4-7860-b76c-7d2b30710dcf@huawei.com>
Date:   Fri, 3 Feb 2023 09:10:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 4.19 0/3] Backport handling -ESTALE policy update failure
 to 4.19
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>
CC:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <zohar@linux.ibm.com>,
        <paul@paul-moore.com>, <luhuaxin1@huawei.com>
References: <20230201023952.30247-1-guozihua@huawei.com>
 <Y9vw6RhQ6KJ5+E1I@sashalap>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Y9vw6RhQ6KJ5+E1I@sashalap>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/3 1:20, Sasha Levin wrote:
> On Wed, Feb 01, 2023 at 10:39:49AM +0800, GUO Zihua wrote:
>> This series backports patches in order to resolve the issue discussed
>> here:
>> https://lore.kernel.org/selinux/389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com/
>>
>> This required backporting the non-blocking LSM policy update mechanism
>> prerequisite patches.
> 
> Do we not need this on newer kernels? Why only 4.19?
> 
Hi Sasha.

The issue mentioned in this patch was fixed already in the newer kernel.
All three patches here are backports from mainline.

-- 
Best
GUO Zihua

