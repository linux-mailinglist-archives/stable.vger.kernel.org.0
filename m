Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20664340A2B
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 17:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhCRQ0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 12:26:13 -0400
Received: from out28-217.mail.aliyun.com ([115.124.28.217]:35578 "EHLO
        out28-217.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhCRQZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 12:25:55 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1427447|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.018844-0.000811314-0.980345;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.JmuzqJv_1616084746;
Received: from zhouyanjie-virtual-machine.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.JmuzqJv_1616084746)
          by smtp.aliyun-inc.com(10.147.41.138);
          Fri, 19 Mar 2021 00:25:51 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     wsa@kernel.org, paul@crapouillou.net
Cc:     stable@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        sernia.zhou@foxmail.com
Subject: Fix bug for Ingenic X1000.
Date:   Fri, 19 Mar 2021 00:25:42 +0800
Message-Id: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For SoCs after X1000, only send "X1000_I2C_DC_STOP" when last byte,
or it will cause error when I2C write operation.

周琰杰 (Zhou Yanjie) (1):
  I2C: JZ4780: Fix bug for Ingenic X1000.

 drivers/i2c/busses/i2c-jz4780.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.7.4

