Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A794ED3BA
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 08:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiCaGJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 02:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiCaGJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 02:09:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616E41E747E;
        Wed, 30 Mar 2022 23:07:27 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KTXrV6lRmzdZMw;
        Thu, 31 Mar 2022 14:07:06 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 14:07:25 +0800
Subject: Re: [PATCH] KVM: x86/pmu: Update AMD PMC smaple period to fix guest
 NMI-watchdog
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Hankland <ehankland@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20220329134632.6064-1-likexu@tencent.com>
 <516a87a9-71d3-a4a7-83bf-1d8e36745e61@huawei.com>
 <YkUxjlv48jAF3gZ5@kroah.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <72d8d629-d550-19ed-02dd-95456bb2857d@huawei.com>
Date:   Thu, 31 Mar 2022 14:07:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YkUxjlv48jAF3gZ5@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022/3/31 12:43, Greg KH wrote:
> On Thu, Mar 31, 2022 at 11:51:55AM +0800, wangyanan (Y) wrote:
>> helped to Cc stable@ list...
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>
> .
Ah, got it. Thank you for the reminder.
