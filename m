Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49777172A6F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 22:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgB0VtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 16:49:04 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:50976 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgB0VtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 16:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582840145; x=1614376145;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=n53MUtSC3NBRDDsvMjCTeVQS69aEnwo1yBqhTNlQZSE=;
  b=MCgJPEVIeebdKoJWSmXP5D9yuZG4D1ENltyYo3WOQ9sGpxbdYcjGxRak
   gUKkMlXAHMFS1XMZFjadcfve6cC5JLIyJzfemrrBpAQjU4Bosauw5hdi1
   SgyePC+jlmeSo9Ttr+VvKWVruTs9xSQYdXaXkDhuAew5Yj1Zelz5OM8/j
   o=;
IronPort-SDR: dsLq/uPis6BcRoBIGvg5GKz74zHPo6jI4mZqIczvSVhj5wND9COH7rrEeypn/+axW+C8czFunS
 64g4FdQ82Uuw==
X-IronPort-AV: E=Sophos;i="5.70,493,1574121600"; 
   d="scan'208";a="19593072"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 27 Feb 2020 21:49:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 586FCA2E74;
        Thu, 27 Feb 2020 21:49:00 +0000 (UTC)
Received: from EX13D17UWB004.ant.amazon.com (10.43.161.132) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 27 Feb 2020 21:48:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D17UWB004.ant.amazon.com (10.43.161.132) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 27 Feb 2020 21:48:59 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 27 Feb 2020 21:48:59 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id 033C9825CF; Thu, 27 Feb 2020 13:48:58 -0800 (PST)
Date:   Thu, 27 Feb 2020 13:48:58 -0800
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <aris@redhat.com>, <tony.luck@intel.com>
Subject: Request for inclusion on linux-5.4.y/linux-5.5.y
Message-ID: <20200227214858.GB21308@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please consider including the following patch in the stable
linux-5.4.y and linux-5.5.y?

This is to downgrade "EDAC skx: Can't get tolm/tohm" to debug level 
on missing PCI device.

854bb48018d5("EDAC: skx_common: downgrade message importance 
on missing PCI device")

Thanks,
Qian Lu
