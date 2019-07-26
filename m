Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411A277115
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 20:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfGZSRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 14:17:47 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:59293 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfGZSRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 14:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564165066; x=1595701066;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6r1JoVKmrIhhd5yCQ7e4JWNPkw/gLCQVMjUwgblpGpc=;
  b=XArRdpGT1ewe4+dZIZlRbdVmWa0OH8eVTqS0XvOPonKV0Z+Xt295LGBf
   5zcqHSk7pc+JimG1mHHFd7rAwG/nvV7TnBd5LhmcEz4vhgwtJZwvab7Ew
   e24buVpDYf9y4I2u4LJE9nC5oQmIAw4pBotw36DKM500CDgsKJbnTKwlq
   Q=;
X-IronPort-AV: E=Sophos;i="5.64,311,1559520000"; 
   d="scan'208";a="688304482"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Jul 2019 18:17:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 8EE03A290F;
        Fri, 26 Jul 2019 18:17:41 +0000 (UTC)
Received: from EX13D17UWB001.ant.amazon.com (10.43.161.252) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 26 Jul 2019 18:17:41 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D17UWB001.ant.amazon.com (10.43.161.252) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 26 Jul 2019 18:17:40 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 26 Jul 2019 18:17:40 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id D5E6C8C64F; Fri, 26 Jul 2019 11:17:39 -0700 (PDT)
Date:   Fri, 26 Jul 2019 11:17:39 -0700
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <tigran.mkrtchyan@desy.de>, <trond.myklebust@primarydata.com>,
        <Anna.Schumaker@Netapp.com>, <stable@vger.kernel.org>
Subject: Request for inclusion on linux-4.14.y
Message-ID: <20190726181739.GB31189@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please consider including the following patch in the stable linux-4.14.y branch?

This is to fix that NFS client incorrectly handling a failed OPEN and ensure that we present the same verifier.

8fd1ab747d2b("NFSv4: Fix open create exclusive when the server reboots")

Thanks,
Qian Lu
