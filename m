Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C2357F879
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 05:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiGYD3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 23:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGYD3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 23:29:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC982FE;
        Sun, 24 Jul 2022 20:29:53 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LrlqS1d0wzmV9v;
        Mon, 25 Jul 2022 11:28:04 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Jul 2022 11:29:44 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Jul 2022 11:29:43 +0800
Subject: Re: [PATCH MANUALSEL 5.10 1/2] KVM: x86: lapic: don't touch
 irr_pending in kvm_apic_update_apicv when inhibiting it
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC:     Maxim Levitsky <mlevitsk@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>
References: <20220222140532.211620-1-sashal@kernel.org>
 <e9e3f438-8699-abba-a1f8-d4d8bfbd63ed@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <6d900dc3-44c0-5a0d-a545-1a51936e6a80@huawei.com>
Date:   Mon, 25 Jul 2022 11:29:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e9e3f438-8699-abba-a1f8-d4d8bfbd63ed@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2022/3/2 1:10, Paolo Bonzini wrote:
> On 2/22/22 15:05, Sasha Levin wrote:
>> From: Maxim Levitsky <mlevitsk@redhat.com>
>>
>> [ Upstream commit 755c2bf878607dbddb1423df9abf16b82205896f ]
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

What prevented it to be accepted into 5.10-stable? It can still be
applied cleanly on top of linux-5.10.y.
