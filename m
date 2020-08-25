Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E92125139A
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 09:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgHYHxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 03:53:41 -0400
Received: from out28-220.mail.aliyun.com ([115.124.28.220]:46857 "EHLO
        out28-220.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgHYHxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 03:53:41 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2716255|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.0264806-0.00131182-0.972208;FP=0|0|0|0|0|-1|-1|-1;HT=e01l04362;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.INWxsBw_1598342001;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.INWxsBw_1598342001)
          by smtp.aliyun-inc.com(10.147.42.198);
          Tue, 25 Aug 2020 15:53:37 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     tsbogend@alpha.franken.de
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, zhenwenjin@gmail.com,
        sernia.zhou@foxmail.com, yanfei.li@ingenic.com,
        rick.tyliu@ingenic.com, aric.pzqi@ingenic.com,
        dongsheng.qiu@ingenic.com, krzk@kernel.org, hns@goldelico.com,
        ebiederm@xmission.com, paul@crapouillou.net
Subject: [PATCH 0/1] MIPS: CI20: Update defconfig for EFUSE.
Date:   Tue, 25 Aug 2020 15:52:38 +0800
Message-Id: <20200825075239.17133-1-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

周琰杰 (Zhou Yanjie) (1):
  MIPS: CI20: Update defconfig for EFUSE.

 arch/mips/configs/ci20_defconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
2.11.0

