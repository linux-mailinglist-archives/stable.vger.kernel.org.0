Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BA77387
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 23:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfGZVgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 17:36:40 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:46572 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGZVgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 17:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564176999; x=1595712999;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Bxp0T6AFznKfqC68Lt5DDbl5bAwaw/y/czxi020Db6s=;
  b=PUe+ng5Nkxw0QCTaDaQZokNg6fpSCKc0FQ4v8jAtrMjTrIX1nsA5QBsA
   y8W8eA+FgJ8zSdRtN0RMst3JqDV50aLN6qTBVyJpDqF8gs2PVWs7QwREx
   ukidTM9qtwL0loSMkmDUYzMRRVu4M0i439N+aZSqR3+5ioECBSbCxXLWs
   8=;
X-IronPort-AV: E=Sophos;i="5.64,312,1559520000"; 
   d="scan'208";a="814146004"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 26 Jul 2019 21:36:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 174DEA1BD8;
        Fri, 26 Jul 2019 21:36:37 +0000 (UTC)
Received: from EX13D17UWB001.ant.amazon.com (10.43.161.252) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 26 Jul 2019 21:36:36 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D17UWB001.ant.amazon.com (10.43.161.252) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 26 Jul 2019 21:36:36 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 26 Jul 2019 21:36:35 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id 5DB068C64F; Fri, 26 Jul 2019 14:36:35 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:36:35 -0700
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <bfields@redhat.com>,
        <ctracy@engr.scu.edu>
Subject: Request for inclusion on linux-4.14.y
Message-ID: <20190726213635.GB1900@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please consider including the following patches in the stable
linux-4.14.y branch?

An NFS server accepts only a limited number of concurrent v4.1+ mounts. Once
that limit is reached, on the affected client side, mount.nfs appears to hang to
keep reissuing CREATE_SESSION calls until one of them succeeds. This is to bump
the limit, also return smaller ca_maxrequests as the limit approaches instead of
waiting till we have to fail CREATE_SESSION completely.

44d8660d3bb0("nfsd: increase DRC cache limit")
de766e570413("nfsd: give out fewer session slots as limit approaches")
c54f24e338ed("nfsd: fix performance-limiting session calculation")


Thanks, 
Qian Lu
