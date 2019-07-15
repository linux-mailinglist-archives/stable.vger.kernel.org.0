Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A1569A11
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 19:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbfGORmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 13:42:17 -0400
Received: from len.romanrm.net ([91.121.75.85]:46084 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730235AbfGORmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 13:42:17 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 4AB9220282;
        Mon, 15 Jul 2019 17:42:15 +0000 (UTC)
Date:   Mon, 15 Jul 2019 22:42:15 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-ide@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Disable queued TRIM for Samsung 860 series SSDs
Message-ID: <20190715224215.2186bc8e@natsu>
In-Reply-To: <yq1y30z2ojx.fsf@oracle.com>
References: <20190714224242.4689a874@natsu>
        <yq1y30z2ojx.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jul 2019 13:30:26 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> 
> Roman,
> 
> > My Samsung 860 EVO mSATA 500GB SSD lockups for 20-30 seconds on
> > fstrim, while dmesg is repeatedly flooded with:
> 
> Is that specific to the mSATA model?
> 
> FWIW, queued TRIM works fine on the 2.5" form factor. So it would be
> best if we could limit the blacklist entry to the mSATA version (or a
> particular firmware rev).

Hello,

I do not have other Samsung (m)SATA models to verify. On the bugreport someone
confirmed this to be an issue for them too. Let's try asking if they have the
mSATA model too, and what firmware revision. Mine is RVT42B6Q and there were
no updates available last time I checked.

-- 
With respect,
Roman
