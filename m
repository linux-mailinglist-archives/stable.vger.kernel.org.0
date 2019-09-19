Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7166AB815D
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbfISTZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 15:25:55 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:48207 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404419AbfISTZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 15:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568921154; x=1600457154;
  h=date:from:to:subject:message-id:mime-version;
  bh=+SW9l7OSsW8indnPrZTGb9PIoiWsXbbY4wCLGLR3Pc8=;
  b=oHiS+OXfRIbtKUILl5qAgwpmfDTLBdu7CQQQcr3UCPq0WfKVQ/5gqLmb
   BzT7JB/lOAn+i2wF40nKBRwIkH0rsvw8uGgZIY7l1/H4oovwP/0jKpR+K
   e03YA9wxAr+6X7kmTE/+TKwVnHBwtLu3WYv3y1wgTEWcg2Z67GdS9dqUP
   A=;
X-IronPort-AV: E=Sophos;i="5.64,524,1559520000"; 
   d="scan'208";a="785880765"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Sep 2019 19:25:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id ED444A2091
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 19:25:52 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 19:25:52 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 19:25:51 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Thu, 19 Sep 2019 19:25:52 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 35746C130D; Thu, 19 Sep 2019 19:25:52 +0000 (UTC)
Date:   Thu, 19 Sep 2019 19:25:52 +0000
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
Subject: binfmt_elf patch [4.14, 4.19]
Message-ID: <20190919192552.GA7060@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please include the following patch in 4.14 and 4.19, where it applies
cleanly and has been tested by us.

commit bbdc6076d2e5d07db44e74c11b01a3e27ab90b32 upstream

("binfmt_elf: move brk out of mmap when doing direct loader exec")

Thanks,

- Frank
