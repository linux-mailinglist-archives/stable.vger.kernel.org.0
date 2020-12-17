Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67752DD1CB
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 14:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgLQNFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 08:05:14 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:37055 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgLQNFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 08:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608210314; x=1639746314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=bE7D90KlVd4iO8CcTy0iOt4Oce3p/63L3jHohC3ijas=;
  b=Xrx757XdpPIj1FQ5Xo4VunlLfui5WfgxwZ+cm8szEJPmhZA1SAgYw9X3
   yr/fEqO/HEskUHFHerhzV+6SawdmhAComfuxrp9q+7y6w5gyel2sgQ6u+
   qZ/WjkAU27IZOV7qcMh6e8z1xR2zldXTFbb/eLTV60rBwdL6RHq6buFMn
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="903914151"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 17 Dec 2020 13:04:24 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 4C3A7A209E;
        Thu, 17 Dec 2020 13:04:24 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.68) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 13:04:18 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     SeongJae Park <sjpark@amazon.com>
CC:     <stable@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>,
        <doebel@amazon.de>, <aams@amazon.de>, <mku@amazon.de>,
        <jgross@suse.com>, <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>,
        "Author Redacted" <security@xen.org>
Subject: Re: [PATCH 2/5] xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
Date:   Thu, 17 Dec 2020 14:04:03 +0100
Message-ID: <20201217130403.12531-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217081727.8253-3-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D49UWB003.ant.amazon.com (10.43.163.121) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Dec 2020 09:17:24 +0100 SeongJae Park <sjpark@amazon.com> wrote:

> From: SeongJae Park <sjpark@amazon.de>
> 
> Some code does not directly make 'xenbus_watch' object and call
> 'register_xenbus_watch()' but use 'xenbus_watch_path()' instead.  This
> commit adds support of 'will_handle' callback in the
> 'xenbus_watch_path()' and it's wrapper, 'xenbus_watch_pathfmt()'.
> 
> This is part of XSA-349
> 
> This is upstream commit 2e85d32b1c865bec703ce0c962221a5e955c52c2
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> Reported-by: Michael Kurth <mku@amazon.de>
> Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
> Signed-off-by: Author Redacted <security@xen.org>

Juergen found this wrong line (thank you, Juergen!).  I will remove the lines
from the patches and send 2nd version soon.


Thanks,
SeongJae Park
