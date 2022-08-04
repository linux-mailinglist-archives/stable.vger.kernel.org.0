Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEEF589B66
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 14:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbiHDMCN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 4 Aug 2022 08:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiHDMCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 08:02:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04315142C
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 05:01:59 -0700 (PDT)
Received: from kwepemi100013.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lz6jW5KH8zmVR3;
        Thu,  4 Aug 2022 19:59:59 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi100013.china.huawei.com (7.221.188.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 20:01:57 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2375.024;
 Thu, 4 Aug 2022 20:01:57 +0800
From:   "chenjun (AM)" <chenjun102@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "xuqiang (M)" <xuqiang36@huawei.com>
Subject: Re: [PATCH stable 4.14 v2 2/3] fbcon: Prevent that screen size is
 smaller than font size
Thread-Topic: [PATCH stable 4.14 v2 2/3] fbcon: Prevent that screen size is
 smaller than font size
Thread-Index: AQHYp/hdYJD7UJyWWUS8XlpsXQHo6Q==
Date:   Thu, 4 Aug 2022 12:01:57 +0000
Message-ID: <26cfcda29c38417e83ecd4e0e35297c3@huawei.com>
References: <20220804111539.96424-1-chenjun102@huawei.com>
 <20220804111539.96424-3-chenjun102@huawei.com> <YuuyebRA0slDJVwx@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.43]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/8/4 19:50, Greg KH 写道:
> On Thu, Aug 04, 2022 at 11:15:38AM +0000, Chen Jun wrote:
>> From: Helge Deller <deller@gmx.de>
>>
>> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
>>
>> We need to prevent that users configure a screen size which is smaller than the
>> currently selected font size. Otherwise rendering chars on the screen will
>> access memory outside the graphics memory region.
>>
>> This patch adds a new function fbcon_modechange_possible() which
>> implements this check and which later may be extended with other checks
>> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
>> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
>> for a too small screen size.
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Link: https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
>> [sudip: adjust context]
> 
> Who is "sudip" here?

Em..I misunderstood the meaning "sudip". I just mean I made some 
contextual adjustments.

> And the Link: line wasn't in the original commit, where did that come
> from?
> 

The mainline commit appears to be from this link. Should I remove the link?

> thanks,
> 
> greg k-h
> 

-- 
Regards
Chen Jun
