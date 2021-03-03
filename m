Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08F032BC1A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442739AbhCCNkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:40:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12678 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355014AbhCCGRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 01:17:55 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dr3cy04DqzlRjg;
        Wed,  3 Mar 2021 14:14:58 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Mar 2021 14:16:57 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kiyin@tencent.com>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <linville@tuxdriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <stefan@datenfreihafen.org>, <matthieu.baerts@tessares.net>,
        <netdev@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <xiaoqian9@huawei.com>
Subject: [PATCH 0/4] nfc: fix Resource leakage and endless loop
Date:   Wed, 3 Mar 2021 14:16:50 +0800
Message-ID: <20210303061654.127666-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

fix Resource leakage and endless loop in net/nfc/llcp_sock.c,
 reported by "kiyin(尹亮)".

Link: https://www.openwall.com/lists/oss-security/2020/11/01/1



Xiaoming Ni (4):
  nfc: fix refcount leak in llcp_sock_bind()
  nfc: fix refcount leak in llcp_sock_connect()
  nfc: fix memory leak in llcp_sock_connect()
  nfc: Avoid endless loops caused by repeated llcp_sock_connect()

 net/nfc/llcp_sock.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
2.27.0

