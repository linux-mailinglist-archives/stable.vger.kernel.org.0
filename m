Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907974FCC5B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 04:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiDLCUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 22:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiDLCUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 22:20:00 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A64833E26;
        Mon, 11 Apr 2022 19:17:44 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kcq8B06N8zgYW7;
        Tue, 12 Apr 2022 10:15:54 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 10:17:42 +0800
Received: from linux-suspe12sp5.huawei.com (10.67.133.83) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 10:17:42 +0800
From:   ChenJingwen <chenjingwen6@huawei.com>
To:     <christophe.leroy@csgroup.eu>
CC:     <chenjingwen6@huawei.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <mpe@ellerman.id.au>, <stable@vger.kernel.org>
Subject: Re: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not updated correctly
Date:   Tue, 12 Apr 2022 10:17:41 +0800
Message-ID: <20220412021741.127386-1-chenjingwen6@huawei.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
References: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.133.83]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is backport for 5.4
> 
> Upstream commit 5647a94a26e352beed61788b46e035d9d12664cd

Thank you for your rebase.
I went on vacation and couldn't submit the code at that time
