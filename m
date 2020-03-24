Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFA919032C
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 02:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgCXBIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 21:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgCXBIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 21:08:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D072220714;
        Tue, 24 Mar 2020 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585012117;
        bh=N8ny1ddSH/WDtO8Ur8IBPuVWrQVYsU/hhfFIi/kKH78=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=NwnIBNso0VcDySPOFtACQf/IyXu0Mx81CcufV3Yhj8Jn7rhCANQZJz6uoNGQyDOZy
         5k1pBQ/MUwcPz2GnuBF6J1L2ryc47EjmuCy9nKNzp5AbYhbUmSQc9lLA6uAKVuDYal
         UXd78+ngt+C8WcQe+0oJMHCjjpl/4SZZ2BwT4tWk=
Date:   Mon, 23 Mar 2020 18:08:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various
 stack implementations
Message-Id: <20200323180836.2d824f5d45f2f5dce729d5b2@linux-foundation.org>
In-Reply-To: <20200323180633.5e75654282d076d74766bd88@linux-foundation.org>
References: <20200303233550.251375-1-guro@fb.com>
        <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
        <20200324004221.GA36662@carbon.dhcp.thefacebook.com>
        <20200323180358.7603217aa9955f298255da4e@linux-foundation.org>
        <20200323180633.5e75654282d076d74766bd88@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Mar 2020 18:06:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> And here's the altered "mm: memcg/slab: introduce
> mem_cgroup_from_obj()", which I have renamed to "mm: memcg/slab: use
> mem_cgroup_from_obj()":
> 
> The end result is slightly different - mem_cgroup_from_obj() will now
> end up inside #ifdef CONFIG_MEMCG_KMEM.  Should I undo that?

err, no, we've just fed forward the build fixes in
mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch so I think we're
all good.
