Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C6557AD8D
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 04:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiGTCEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 22:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiGTCEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 22:04:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA8254AFE;
        Tue, 19 Jul 2022 19:04:29 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lnf9K5cwXzlVpK;
        Wed, 20 Jul 2022 10:02:45 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:04:27 +0800
Message-ID: <c79e6488-9fb0-271d-0f56-fee60f09b7da@huawei.com>
Date:   Wed, 20 Jul 2022 10:04:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.19] ext4: fix race condition between ext4_ioctl_setflags
 and ext4_fiemap
To:     Greg KH <gregkh@linuxfoundation.org>, Theodore Ts'o <tytso@mit.edu>
CC:     <stable@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <enwlinux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yebin10@huawei.com>, <yukuai3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>
References: <20220715023928.2701166-1-libaokun1@huawei.com>
 <YtF1XygwvIo2Dwae@kroah.com>
 <425ab528-7d9a-975a-7f4c-5f903cedd8bc@huawei.com>
 <YtaVAWMlxrQNcS34@kroah.com>
 <ffb13c36-521e-0e06-8fd6-30b0fec727da@huawei.com>
 <YtairkXvrX6IZfrR@kroah.com> <Ytb+ji56S/de/5Rm@mit.edu>
 <YtcCmILbA9mTh4Au@kroah.com>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <YtcCmILbA9mTh4Au@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/7/20 3:14, Greg KH 写道:
> On Tue, Jul 19, 2022 at 02:57:18PM -0400, Theodore Ts'o wrote:
>> P.S.  If we go down this path, Greg K-H may also insist on getting the
>> bug fix to the 5.4 LTS kernel, so that a bug isn't just fixed in 4.19
>> LTS but not 5.4 LTS.  In which case, the same requirement of running
>> "-c ext4/all -g auto" and showing that there are no test regressions
>> is going to be a requirement for 5.4 LTS as well.
> Yes, if this issue is also in 5.4 or any newer kernels, it HAS to be
> fixed there at the same time, or before, as we can not have anyone
> upgrading from an older kernel to a newer one and having a regression.
>
> thanks,
>
> greg k-h
> .

Indeed.

-- 
With Best Regards,
Baokun Li


