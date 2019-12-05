Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A061146AF
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfLESRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 13:17:30 -0500
Received: from gentwo.org ([3.19.106.255]:47082 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfLESR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 13:17:29 -0500
Received: by gentwo.org (Postfix, from userid 1002)
        id 013E93EA37; Thu,  5 Dec 2019 18:17:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id F0A2E3E951;
        Thu,  5 Dec 2019 18:17:28 +0000 (UTC)
Date:   Thu, 5 Dec 2019 18:17:28 +0000 (UTC)
From:   Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     Qian Cai <cai@lca.pw>
cc:     Yang Shi <yang.shi@linux.alibaba.com>, fabecassis@nvidia.com,
        jhubbard@nvidia.com, mhocko@suse.com, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if
 the page is already on the target node
In-Reply-To: <1707CDD0-E05E-411A-A093-35E8E50ACA4B@lca.pw>
Message-ID: <alpine.DEB.2.21.1912051815100.9722@www.lameter.com>
References: <a16b53f9-92c9-ff01-06c1-530647ecaff1@linux.alibaba.com> <1707CDD0-E05E-411A-A093-35E8E50ACA4B@lca.pw>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="531401748-729306102-1575569848=:9722"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531401748-729306102-1575569848=:9722
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 5 Dec 2019, Qian Cai wrote:

> > On Dec 5, 2019, at 12:39 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
> >
> > There are definitely a few inconsistencies, but I think the manpage is quite clear for this specific case, which says "status is an array of integers that return the status of each page. The array contains valid values only if move_pages() did not return an error." And, it looks kernel just misbehaved since 4.17 due to the fixes commit, so it sounds like a regression too.
>
> “Only if”  in strictly logical term does not necessarily mean it must contain valid values if move_pages() succeed.

The intended meaning is that valid values in the status array are provided
when the syscall succeeds and not otherwise. In the error case there may
be some valid values but since the operation may have aborted not all
values may have a value.





--531401748-729306102-1575569848=:9722--
