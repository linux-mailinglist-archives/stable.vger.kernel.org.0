Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB1C1F5101
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 11:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFJJRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 05:17:19 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10664 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgFJJRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 05:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591780638; x=1623316638;
  h=from:to:cc:subject:date:message-id:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=yTRa4iuclDKGDxr3hcHPUWfgnxSsbA46QRlOw0aYhtg=;
  b=WrTnAwhxAQFjLo7KM+ygP8tUzTfPQSjzSLAbURGr+MnUh8NgCpVS3JWj
   aOa0HtJZv5zZbFmVxrqjg6cncnAwWwX+hZuGgkOfYvbRD85w5G5VFeIxq
   hzzMPDnyY9UTseZZ5OllmTAMzY5U8tZdxW988Ki2fsK0+0u6OhM4Nuygt
   Y=;
IronPort-SDR: sb3XkJQpvy2MlML82JqCdr/sI1XZ9v9qBgg0lP+DmB50kMsjl6syi1tvgFFSGRakZy5XTecow3
 Lxd2RZUHzuNA==
X-IronPort-AV: E=Sophos;i="5.73,495,1583193600"; 
   d="scan'208";a="36829050"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Jun 2020 09:17:17 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id 93D91A1D47;
        Wed, 10 Jun 2020 09:17:15 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Jun 2020 09:17:15 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.26) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Jun 2020 09:17:10 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Jiri Slaby <jslaby@suse.cz>
CC:     SeongJae Park <sjpark@amazon.com>, <akpm@linux-foundation.org>,
        <colin.king@canonical.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH v2] scripts/spelling: Recommend blocklist/allowlist instead of blacklist/whitelist
Date:   Wed, 10 Jun 2020 11:16:55 +0200
Message-ID: <20200610091655.4682-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
In-Reply-To: <b16e47c9-db60-4d20-6e72-bf0b5ab29a38@suse.cz> (raw)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D40UWA003.ant.amazon.com (10.43.160.29) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Jun 2020 10:50:24 +0200 Jiri Slaby <jslaby@suse.cz> wrote:

> On 09. 06. 20, 14:25, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > This commit recommends the patches to replace 'blacklist' and
> > 'whitelist' with the 'blocklist' and 'allowlist', because the new
> > suggestions are incontrovertible, doesn't make people hurt, and more
> > self-explanatory.
> 
> Sorry, but no, it's definitely not.
> 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  scripts/spelling.txt | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/scripts/spelling.txt b/scripts/spelling.txt
> > index d9cd24cf0d40..ea785568d8b8 100644
> > --- a/scripts/spelling.txt
> > +++ b/scripts/spelling.txt
> > @@ -230,6 +230,7 @@ beter||better
> >  betweeen||between
> >  bianries||binaries
> >  bitmast||bitmask
> > +blacklist||blocklist
> 
> Blocklist means a list of blocks here.

How about 'denylist', then?

> 
> >  boardcast||broadcast
> >  borad||board
> >  boundry||boundary
> > @@ -1495,6 +1496,7 @@ whcih||which
> >  whenver||whenever
> >  wheter||whether
> >  whe||when
> > +whitelist||allowlist
> 
> Wut? allowlist I am seeing for the 1st time.

Wouldn't it easy to infer the intention, though?

> 
> Some purists, linguists, and politicians are true fellows at times, or
> at least they think so. This comes in waves and even if they try hard,
> people won't adopt their nonsense. Like we, Czechs, still call piano by
> German Klavier, and not břinkoklapka, suggested in 19th century (among
> many others) by the horny extremists.
> 
> Shall we stop using black, white, blue, and other colors only because
> they relate to skin color of avatars now? I doubt that.

Well, I have no strong opinion on this, but... if some people are really being
hurt by use of some terms and we could avoid spread of the term with only
little cost, I believe it's worth to make the change.


Thanks,
SeongJae Park

> 
> thanks,
> -- 
> js
> suse labs
