Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF7B320FE8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 05:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBVD7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 22:59:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12561 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhBVD7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 22:59:48 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DkT035VpNzMYF6;
        Mon, 22 Feb 2021 11:57:07 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 11:58:58 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <lee.jones@linaro.org>, <tglx@linutronix.de>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4.257 0/1] Bugfix for ad4740ceccfb ("futex: Avoid violating the 10th rule of futex")
Date:   Mon, 22 Feb 2021 12:06:17 +0800
Message-ID: <20210222040618.2911498-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

*** BLURB HERE ***

Peter Zijlstra (1):
  futex: Fix OWNER_DEAD fixup

 kernel/futex.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.25.4

