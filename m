Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0694225E94
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgGTMbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:31:31 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61634 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgGTMbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595248291; x=1626784291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=B7TTGtY4SziIvCD/DMZj35NfyE0QefT2lQmcnjqpo5w=;
  b=POK5hLCNbttnbjT1wls2qhw7omleDEKG2imqdJ7OS81wtZvUYiGxdcTy
   r58is1c0aE5XzoXSv9E2fasFi9VXMLl1e7aRh21jz53fQRd45H25BxSwt
   rvh/5SuUtTnmll8BClsqq0ffeqNJiiHXMicZWodD2gPozcPVbj/kiqY1Y
   o=;
IronPort-SDR: nu3nUjjlvEcBjuOaPn39TwfnSWSHlbTWknnyvAtHrbDeIJ2nM43GLqnEByLqXqOvA6QDpjY1Vu
 30oCyLl0FqdA==
X-IronPort-AV: E=Sophos;i="5.75,375,1589241600"; 
   d="scan'208";a="42783398"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 20 Jul 2020 12:31:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 15A6CA18C6;
        Mon, 20 Jul 2020 12:31:27 +0000 (UTC)
Received: from EX13D31EUA004.ant.amazon.com (10.43.165.161) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 12:31:27 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.73) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 12:31:24 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <sashal@kernel.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Re: Upstream fixes not merged in 5.4.y
Date:   Mon, 20 Jul 2020 14:31:07 +0200
Message-ID: <20200720123107.22001-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720121543.GA2984743@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D17UWB004.ant.amazon.com (10.43.161.132) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jul 2020 14:15:43 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

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
> 
> I tried this first patch, and it doesn't apply to the 5.4.y tree, so are
> you sure you tried these yourself?
> 
> If so, please send a series of backported patches that you have
> successfully tested, or if a patch applies cleanly, just the git id.

Yes, I backported it on the latest 5.4.y before.  I will rebase it on the
latest 5.4.y, test, and send the patch.  Nonetheless, please note that it might
take some time (say, a couple of weeks?).


Thanks,
SeongJae Park
