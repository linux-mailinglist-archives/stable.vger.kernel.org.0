Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93F550C5ED
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiDWBKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 21:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 21:10:11 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C7B1A433D
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 18:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1650676034; x=1682212034;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5x35e7lsDWgAiMVVNhnJSclVfLi48ss41CAGv8OAmb4=;
  b=tQ+UDTxynfyfE43isX0i0rS6apXa7ZxeZQFIQ7ouiCxRmEwkqllIgLoV
   ROE7Oaog7sJVYsxlUB9InXnkd7C1TbAKXrZfofRQZ96rQUQTEAkWBDZWc
   tq0T9xTg0zVkxCPG1+9iNg71kqsCUN8WRxdVuqm6l2u17Y73/YyVm0sNR
   c=;
X-IronPort-AV: E=Sophos;i="5.90,283,1643673600"; 
   d="scan'208";a="1010029407"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 23 Apr 2022 01:07:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 7018241698;
        Sat, 23 Apr 2022 01:07:13 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Sat, 23 Apr 2022 01:07:12 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.156) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Sat, 23 Apr 2022 01:07:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     stable <stable@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: Request to cherry-pick c89dffc70b34 to 4.14, 4.19, and 5.4.
Date:   Sat, 23 Apr 2022 10:07:06 +0900
Message-ID: <20220423010706.79913-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D08UWB001.ant.amazon.com (10.43.161.104) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi maintainers,

Upstream commit 01770a166165 ("tcp: fix race condition when creating child
sockets from syncookies") is planned to be backported to 4.14, 4.19 and
5.4:

  https://marc.info/?l=linux-stable-commits&m=165063781908608&w=3
  https://marc.info/?l=linux-stable-commits&m=165063781708604&w=3
  https://marc.info/?l=linux-stable-commits&m=165063781708603&w=3

Another commit c89dffc70b34 ("tcp: Fix potential use-after-free due to
double kfree()") has a Fixes tag for it, so please backport this also.

Best regards,
Kuniyuki
