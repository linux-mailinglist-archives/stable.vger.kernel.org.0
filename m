Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B1E1F3A93
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 14:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgFIMZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 08:25:33 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:22150 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgFIMZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 08:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591705532; x=1623241532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=7X8FiA3me7TPMvFE9ad5LnLwzdMbCB+eU+xJvgSdv5A=;
  b=rO+v0VTW3xwLeR0VLV/s9Bqq7bmQMuG1n0nLJhV3NWotsTaYudTqED/Y
   cMopDycT93CHU9bgJIXdMwKksOXB4sGp5jXpMh6EKdHnBIUFSuCPFYMA2
   LYJribd6kZHXCNp4QGW7kyhpvjayv4wVh70JGzKhQuEKTOiqiKMjVFtxn
   g=;
IronPort-SDR: wtuvN4RmzP2Vo+OSj4dmxNhETKKTUVaabPG9qE5jtrAaS7bNLrO0od8oq18iN3XC546NdVSIh9
 vmJcjErtV5XA==
X-IronPort-AV: E=Sophos;i="5.73,492,1583193600"; 
   d="scan'208";a="35175724"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 09 Jun 2020 12:25:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id B40AE140225;
        Tue,  9 Jun 2020 12:25:28 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 12:25:27 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.53) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 12:25:23 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     SeongJae Park <sjpark@amazon.com>
CC:     <akpm@linux-foundation.org>, <colin.king@canonical.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH] scripts/spelling: Recommend blocklist/allowlist instead of blacklist/whitelist
Date:   Tue, 9 Jun 2020 14:24:50 +0200
Message-ID: <20200609122450.25842-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609121843.24147-1-sjpark@amazon.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Jun 2020 14:18:43 +0200 SeongJae Park <sjpark@amazon.com> wrote:

> From: SeongJae Park <sjpark@amazon.de>
> 
> This commit recommends the patches to replace 'blacklist' and
> 'whitelist' with the 'blocklist' and 'allowlist', because the new
> suggestions are incontrovertible, doesn't make people hurt, and more
> self-explanatory.
> 
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> 
> cr https://code.amazon.com/reviews/CR-27247203

Oops, sorry for leaving this unnecessary text.  Will post the 2nd version soon,
please ignore this patch.


Thanks,
SeongJae Park

> ---
>  scripts/spelling.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/spelling.txt b/scripts/spelling.txt
> index d9cd24cf0d40..ea785568d8b8 100644
> --- a/scripts/spelling.txt
> +++ b/scripts/spelling.txt
> @@ -230,6 +230,7 @@ beter||better
>  betweeen||between
>  bianries||binaries
>  bitmast||bitmask
> +blacklist||blocklist
>  boardcast||broadcast
>  borad||board
>  boundry||boundary
> @@ -1495,6 +1496,7 @@ whcih||which
>  whenver||whenever
>  wheter||whether
>  whe||when
> +whitelist||allowlist
>  wierd||weird
>  wiil||will
>  wirte||write
> -- 
> 2.17.1
> 
