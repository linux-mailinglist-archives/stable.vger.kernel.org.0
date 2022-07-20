Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F8A57AD63
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbiGTBwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbiGTBwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:52:30 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574354D150;
        Tue, 19 Jul 2022 18:52:29 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lndtj5kMJzkX6g;
        Wed, 20 Jul 2022 09:50:05 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 09:52:27 +0800
Message-ID: <a49ccfcd-51ae-eade-8c76-08c4d5d10afc@huawei.com>
Date:   Wed, 20 Jul 2022 09:52:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.19] ext4: fix race condition between ext4_ioctl_setflags
 and ext4_fiemap
To:     Theodore Ts'o <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>
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
 <YtaVAWMlxrQNcS34@kroah.com> <Yta6THyDwHulhfi5@mit.edu>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <Yta6THyDwHulhfi5@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

在 2022/7/19 22:06, Theodore Ts'o 写道:
> On Tue, Jul 19, 2022 at 01:26:57PM +0200, Greg KH wrote:
>> On Sat, Jul 16, 2022 at 10:33:30AM +0800, Baokun Li wrote:
>>> This problem persists until the patch d3b6f23f7167("ext4: move ext4_fiemap
>>> to use iomap framework") is incorporated in v5.7-rc1.
>> Then why not ask for that change to be added instead?
> Switching over to use the iomap framework is a quite invasive change,
> which is fraught with danager and potential performance regressions.
> So it's really not something that would be considered safe for an LTS
> kernel.
>
> As an upstream developer I'd ask why are people trying to use a kernel
> as old as 4.19, but RHEL has done more insane things than that.  Also,
> I know what the answer is, and it's just too depressing for a nice
> summer day like this.  :-)
>
>         	  	    	     	       - Ted
> .

Indeed.

-- 
With Best Regards,
Baokun Li

