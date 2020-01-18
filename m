Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D41416AD
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 10:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgARJFM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 18 Jan 2020 04:05:12 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2992 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726602AbgARJFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 04:05:12 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 578413010E8474B783C3;
        Sat, 18 Jan 2020 17:05:09 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 18 Jan 2020 17:05:08 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 18 Jan 2020 17:05:08 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 18 Jan 2020 17:05:08 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Thomas Backlund <tmb@mageia.org>
CC:     Stefan Berger <stefanb@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before
 probing for interrupts"
Thread-Topic: [PATCH] tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before
 probing for interrupts"
Thread-Index: AdXN3HzLtgoc6aHwQfq2XaZEDY1mnw==
Date:   Sat, 18 Jan 2020 09:05:08 +0000
Message-ID: <4964f9787b8848e0807938109e689bc4@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi:
Thomas Backlund <tmb@mageia.org>:
> Den 18-01-2020 kl. 22:25, skrev Miaohe Lin:
>> 
>
>Please check before posting...
>
>This is already reverted in 5.4.12 relased ~4 days ago..
>

I'am really really sorry about it. I was just installed my git send-email command in new environment
and randomly select a patch with --to myself email address only for command test just as below:

git send-email --to linmiaohe@huawei.com 0001-tpm-Revert-tpm_tis_core-Set-TPM_CHIP_FLAG_IRQ-before.patch

I though this patch would send to myself only and I have no idea why this would come to you (it seems git send-email command
would automatic cc the people in the patch).
I'am sorry for making noise :'(. Wish you have a good day.
