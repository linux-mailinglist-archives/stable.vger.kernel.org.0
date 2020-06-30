Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACB920EE7E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 08:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgF3GaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 02:30:01 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:54700 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730015AbgF3GaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 02:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593498601; x=1625034601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=tJ1nJN+//wpEjNcsi2nxNdbUXSkgN0xe5Wv7VlT9jyY=;
  b=Oj1NyUji2sgzq2gizewLKwi6+S7tNAfKTLYA42ZH68xa6WuIoOqRPpPa
   YHMlbT6dQQlsMuI/JdK3k7c9Mh+VWUesi5Mu/5nF+PSjbvl5/6Pi08yTw
   nZGRk6nHHeV3gIBFsQIlWY7Waua+n6zfAqatKwg9IECAF/a4EewNTKdYt
   c=;
IronPort-SDR: dqd7N/pkCAiROI/QrABbRhv/XE2hXrBdFbrnKkiJRP+PEUwrdUFkEiJFLlMGx0DlrkbAiqzet2
 OXV8+8X/xE6Q==
X-IronPort-AV: E=Sophos;i="5.75,296,1589241600"; 
   d="scan'208";a="47964491"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 30 Jun 2020 06:29:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id D8001A082E;
        Tue, 30 Jun 2020 06:29:54 +0000 (UTC)
Received: from EX13D31EUA004.ant.amazon.com (10.43.165.161) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 06:29:54 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.100) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 06:29:50 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <sj38.park@gmail.com>,
        <sashal@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Re: Upstream fixes not merged in 5.4.y
Date:   Tue, 30 Jun 2020 08:29:35 +0200
Message-ID: <20200630062935.15087-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629161542.GA683634@kroah.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D11UWB002.ant.amazon.com (10.43.161.20) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 18:15:42 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Jun 29, 2020 at 04:28:05PM +0200, SeongJae Park wrote:
> > Hello,
> > 
> > 
> > With my little script, I found below commits in the mainline tree are more than
> > 1 week old and fixing commits that back-ported in v5.4..v5.4.49, but not merged
> > in the stable/linux-5.4.y tree.  Are those need to be merged in but missed or
> > dealyed?
> > 
> > 9210c075cef2 ("nvme-pci: avoid race between nvme_reap_pending_cqes() and nvme_poll()")
> > 9fecd13202f5 ("btrfs: fix a block group ref counter leak after failure to remove block group")
> > 9d964e1b82d8 ("fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"")
> > 8ab3a3812aa9 ("drm/i915/gt: Incrementally check for rewinding")
> > 6e2f83884c09 ("bnxt_en: Fix AER reset logic on 57500 chips.")
> > efb94790852a ("drm/panel-simple: fix connector type for LogicPD Type28 Display")
> > ff58bbc7b970 ("ALSA: usb-audio: Fix potential use-after-free of streams")
> > ff58bbc7b970 ("ALSA: usb-audio: Fix potential use-after-free of streams")
> > 8dbe4c5d5e40 ("net: dsa: bcm_sf2: Fix node reference count")
> > ca8826095e4d ("selftests/net: report etf errors correctly")
> > 5a8d7f126c97 ("of: of_mdio: Correct loop scanning logic")
> > d35d3660e065 ("binder: fix null deref of proc->context")
> > 
> > The script found several more commits but I exclude those here, because those
> > seems not applicable on 5.4.y or fixing trivial problems only.  If I'm not
> > following a proper process for this kind of reports, please let me know.
> 
> For commits that only have a "Fixes:" tag, and not a "cc: stable..."
> tag, wait a few weeks, or a month, for us to catch up with them.  We
> usually get to them eventually, but it takes us a while as we have lots
> more to deal with by developers and maintainers that are properly
> tagging patches for this type of thing.
> 
> Some of the above commits are queued up already, but not all of them.
> I'll take a look at the list after this next round of patches go out,
> and will let you know.
> 
> And yes, we do want this type of list, it's greatly appreciated.

Appreciate your kind explanation.  I will keep those in my mind for future
reports.


Thanks,
SeongJae Park

> 
> thanks,
> 
> greg k-h
