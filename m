Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B884D02B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfFTOQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbfFTOQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 10:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D7FE20679;
        Thu, 20 Jun 2019 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561040212;
        bh=9iRebO6DLKsf5fGTm7JWX4wTJr9M2g78lVVOWiI329U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AQ386KG/y054gecT++bUjaurqIH56NLWa099TjUwJEjpUaMR3NnklNkw5IMY91nvl
         A4T5XvHW8nMYJyYDdXM4XASK/i/EyvBfTEpJL7WaHAcrUkt93Ey/qGxp0yy+QrtgYz
         uO66rXsb1iNid4qAoefbvCvX+fgVNlFzyk3aD3DI=
Date:   Thu, 20 Jun 2019 16:16:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        jstancek@redhat.com, mgorman@suse.de, minchan@kernel.org,
        namit@vmware.com, npiggin@gmail.com, peterz@infradead.org,
        will.deacon@arm.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND 5.1-stable PATCH] mm: mmu_gather: remove
 __tlb_reset_range() for force flush
Message-ID: <20190620141650.GB9832@kroah.com>
References: <1560805037-35324-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560805037-35324-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 04:57:17AM +0800, Yang Shi wrote:
> commit 7a30df49f63ad92318ddf1f7498d1129a77dd4bd upstream

THanks for the backport, now queued up.

greg k-h
