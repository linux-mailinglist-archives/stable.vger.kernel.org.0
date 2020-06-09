Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE9C1F3B5E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 15:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgFINGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 09:06:02 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:15805 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgFINGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 09:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591707962; x=1623243962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=0XeOyj+5k20ROXk3Q1DUjE/n+U5532PlRrUIVZVWxW0=;
  b=TieoZhNsaXXnKyU2V5emQU3cq85Mq7ArVGz4k7NB0pflCCY5M7m6rACq
   MCadI8ma9uf1gunI3Ci2jG0osAasA6k18dPuQuO8vStNBy2iXH23Ls2ij
   qsgwxkJwrCbmHCOTwI/FT6NdlUMIEduQcTdAEZZd7UBxpQdkJKIj4tpDi
   s=;
IronPort-SDR: j5J0W5atFLcNtse/m+nzXHtGxqZSvtfVxwsQR+KE5MBnv/WqLlye7Yy6lmuxWQ6fdzXuIqmPWO
 Sk+dNKPiksEQ==
X-IronPort-AV: E=Sophos;i="5.73,492,1583193600"; 
   d="scan'208";a="35280945"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Jun 2020 13:06:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id DDBC0282917;
        Tue,  9 Jun 2020 13:05:58 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 13:05:58 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.161.145) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 13:05:54 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <akpm@linux-foundation.org>,
        <colin.king@canonical.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH v2] scripts/spelling: Recommend blocklist/allowlist instead of blacklist/whitelist
Date:   Tue, 9 Jun 2020 15:05:38 +0200
Message-ID: <20200609130538.3573-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609125607.GB827447@kroah.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13d09UWC002.ant.amazon.com (10.43.162.102) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Jun 2020 14:56:07 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Jun 09, 2020 at 02:25:49PM +0200, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > This commit recommends the patches to replace 'blacklist' and
> > 'whitelist' with the 'blocklist' and 'allowlist', because the new
> > suggestions are incontrovertible, doesn't make people hurt, and more
> > self-explanatory.
> > 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  scripts/spelling.txt | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Sorry, I only mistakenly Cc-ed stable@vger.kernel.org.  Please don't pull this
in the stable tree.


Thanks,
SeongJae Park

> 
> </formletter>
> 
