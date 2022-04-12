Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CF14FDBBD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiDLKGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 06:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351714AbiDLJmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 05:42:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5201B13DF8
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 01:50:26 -0700 (PDT)
Received: from kwepemi100022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KczsJ1bdvzgYgY;
        Tue, 12 Apr 2022 16:48:36 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100022.china.huawei.com (7.221.188.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 16:50:24 +0800
Received: from [10.174.177.234] (10.174.177.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 16:50:24 +0800
Subject: Re: [PATCH 5.10 1/2] hamradio: defer 6pack kfree after
 unregister_netdev
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <duoming@zju.edu.cn>, <linma@zju.edu.cn>,
        <davem@davemloft.net>, <kuba@kernel.org>
References: <1649745544-19915-1-git-send-email-xujia39@huawei.com>
 <YlUmU+YrN69AQ37K@kroah.com>
From:   "xujia (Q)" <xujia39@huawei.com>
Message-ID: <a79e8c4a-e47a-eb94-e15f-471ffd6c1f70@huawei.com>
Date:   Tue, 12 Apr 2022 16:50:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YlUmU+YrN69AQ37K@kroah.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.234]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yes, They also need in 5.15.y.

I ignore that.

Thank you, Greg!

ÔÚ 2022/4/12 15:12, Greg KH Ð´µÀ:
> On Tue, Apr 12, 2022 at 02:39:03PM +0800, Xu Jia wrote:
>> From: Lin Ma <linma@zju.edu.cn>
>>
>> commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.
> Don't these two also need to go into 5.15.y?  You do not want someone
> upgrading to a newer kernel and having a regression.
>
> thanks,
>
> greg k-h
> .
