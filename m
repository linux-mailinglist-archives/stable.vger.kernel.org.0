Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D53DC2A6
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 04:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhGaCRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 22:17:07 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13216 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhGaCRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 22:17:07 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Gc76D589yz1CQtW;
        Sat, 31 Jul 2021 10:11:00 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 31 Jul 2021 10:16:59 +0800
Received: from dggeme756-chm.china.huawei.com ([10.6.80.68]) by
 dggeme756-chm.china.huawei.com ([10.6.80.68]) with mapi id 15.01.2176.012;
 Sat, 31 Jul 2021 10:16:59 +0800
From:   "wangliang (C)" <wangliang101@huawei.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wangle (RTOS FAE)" <wangle6@huawei.com>,
        "Chenxin (RTOS)" <kepler.chenxin@huawei.com>,
        Nixiaoming <nixiaoming@huawei.com>,
        "Wangkefeng (OS Kernel Lab)" <wangkefeng.wang@huawei.com>
Subject: =?gb2312?B?s7e72DogW1BBVENIIHYyXSBsaWI6IFVzZSBQRk5fUEhZUygpIGluIGRldm1l?=
 =?gb2312?B?bV9pc19hbGxvd2VkKCk=?=
Thread-Topic: [PATCH v2] lib: Use PFN_PHYS() in devmem_is_allowed()
Thread-Index: AQHXhbIkauys7qng8E6jm3dZNQrM0g==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Sat, 31 Jul 2021 02:16:59 +0000
Message-ID: <bbcc9fdbf33c4a3d80426847ce428f0c@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.101.54]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

d2FuZ2xpYW5nIChDKSC9q7O3u9jTyrz+obBbUEFUQ0ggdjJdIGxpYjogVXNlIFBGTl9QSFlTKCkg
aW4gZGV2bWVtX2lzX2FsbG93ZWQoKaGxoaM=
