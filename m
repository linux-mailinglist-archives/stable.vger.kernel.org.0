Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D652EA8EF
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbhAEKiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:38:12 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:41319 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729321AbhAEKiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609843091; x=1641379091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=mPgqYvT9twuHVMlI0OVkYcEKNKnwJB9l+TzR0S/ALmI=;
  b=gjyVoJhIODft+iuPNHYQ4DyR10/g2rkqCJzRMk8iiyYZA/3a/z3eo/PI
   QWgFdVegJQWBOf8Or/ne/7/+SPmlaflIAp2qg6IacPPc5G6xm2559sm6z
   +RYdXBhIPzQGN8g5RESYwgMYwgyIAFjCuA+HNNp0+DYC1lvOUmveHWGNh
   s=;
X-IronPort-AV: E=Sophos;i="5.78,476,1599523200"; 
   d="scan'208";a="75421730"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 Jan 2021 10:37:24 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 8E2D9A2255;
        Tue,  5 Jan 2021 10:37:22 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.160.27) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 Jan 2021 10:37:16 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <stable@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] Backport of patch series for stable 4.4 branch
Date:   Tue, 5 Jan 2021 11:37:02 +0100
Message-ID: <20210105103702.15804-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <X+nBh/5nsI8QrWCg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, 28 Dec 2020 12:29:11 +0100 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Dec 17, 2020 at 05:03:57PM +0100, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > Changes from v2
> > (https://lore.kernel.org/stable/20201217130501.12702-1-sjpark@amazon.com/)
> > - Move 'nr_pending' increase from 5th patch to 4th patch
> > 
> > Changes from v1
> > (https://lore.kernel.org/stable/20201217081727.8253-1-sjpark@amazon.com/)
> > - Remove wrong 'Signed-off-by' lines for 'Author Redacted'
> 
> All now queued up, but you also need a series of this for the 4.9.y tree
> as well.

Thank you for your efforts!

However, I was able to cherry-pick this series, which is already merged in
4.4.y, to 4.9.y without conflicts.

    $ git checkout stable/linux-4.9.y -b xsa349_4.9
    $ git cherry-pick d8b0d52e408ca..3c71d2f637c8
    warning: inexact rename detection was skipped due to too many files.
    warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
    [xsa349_4.9 51b4cb3db28a] xen/xenbus: Allow watches discard events before queueing
     Date: Mon Dec 14 10:02:45 2020 +0100
     4 files changed, 16 insertions(+), 1 deletion(-)
    warning: inexact rename detection was skipped due to too many files.
    warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
    [xsa349_4.9 3242225d9645] xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
     Date: Mon Dec 14 10:04:18 2020 +0100
     6 files changed, 17 insertions(+), 7 deletions(-)
    warning: inexact rename detection was skipped due to too many files.
    warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
    [xsa349_4.9 10d6c1301412] xen/xenbus/xen_bus_type: Support will_handle watch callback
     Date: Mon Dec 14 10:05:47 2020 +0100
     2 files changed, 4 insertions(+), 1 deletion(-)
    warning: inexact rename detection was skipped due to too many files.
    warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
    [xsa349_4.9 3875703f1e6b] xen/xenbus: Count pending messages for each watch
     Date: Mon Dec 14 10:07:13 2020 +0100
     2 files changed, 21 insertions(+), 12 deletions(-)
    warning: inexact rename detection was skipped due to too many files.
    warning: you may want to set your merge.renamelimit variable to at least 6130 and retry the command.
    [xsa349_4.9 40e3b315cd18] xenbus/xenbus_backend: Disallow pending watch messages
     Date: Mon Dec 14 10:08:40 2020 +0100
     1 file changed, 7 insertions(+)

Seems you tried to merge the series for upstream in 4.9.y:

    https://lore.kernel.org/stable/1609154834239118@kroah.com/

This must because I didn't test this series with v4.9 and mention it.  Sorry
for making a confusion.  Could you please check this again?


Thanks,
SeongJae Park
