Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CC429F9A8
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJ3A2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ3A2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 20:28:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C37D20738;
        Fri, 30 Oct 2020 00:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604017703;
        bh=ptxAW43ZYEtEh9RNA40gJaK1af0/mySHiXBUQyFs5sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0SPR28G4LS98nv2G4G40LSUsro9NFglW5zu1ytvGTIaZW8+mzEnl5FrIboQLGDoDR
         u1QBdej3OCEer6Gm7JJepAc+lQJ4cXzXbux3g55oqbge6rNXYpqFNKYZKEpVpLNxm1
         V8bWXspMKUBj77oR5uVJScnhp22I/T/4H3Y/kk7s=
Date:   Thu, 29 Oct 2020 17:28:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Zi Yan <ziy@nvidia.com>
Cc:     Yang Shi <shy828301@gmail.com>, Linux MM <linux-mm@kvack.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/compaction: count pages and stop correctly during
 page isolation.
Message-Id: <20201029172822.da31fa5ab34c3a795361768f@linux-foundation.org>
In-Reply-To: <EC915762-AE2E-4ACB-AB27-E7C95A584A0C@nvidia.com>
References: <20201029200435.3386066-1-zi.yan@sent.com>
        <CAHbLzkpka7s1DFeXO5dxfGvxZFcTYb9KH0AE_AXuxeFO4q_rtg@mail.gmail.com>
        <EC915762-AE2E-4ACB-AB27-E7C95A584A0C@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Oct 2020 17:31:28 -0400 Zi Yan <ziy@nvidia.com> wrote:

> >
> > Shall you add Fixes tag to commit
> > 1da2f328fa643bd72197dfed0c655148af31e4eb? And may cc stable.
> 
> Sure.
> 
> Fixes: 1da2f328fa64 (“mm,thp,compaction,cma: allow THP migration for CMA allocations”)
> 
> stable cc'ed.

A think a cc:stable really requires a description of the end-user
visible effects of the bug.  Could you please provide that?

