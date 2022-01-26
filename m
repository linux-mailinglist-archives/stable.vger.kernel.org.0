Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4449C108
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 03:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiAZCIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 21:08:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59936 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiAZCIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 21:08:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AAD7B81B99;
        Wed, 26 Jan 2022 02:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DD3C340E7;
        Wed, 26 Jan 2022 02:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643162915;
        bh=00kpCvtcpU4vowgW4ojdH7s5+YxuzyKWhK86nnGDviE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O5bfKQoGUZWq4D/p1F3ahQZmcZ5my5rhOsm/pEptkGFTJ3dwkK4jTFiiUcDdzBPLQ
         8xXQUu+6X7HjuXaCrxbOf7SrBLw2JSyHVv1mCaPMVRMWxE+i0CAHpMQOLf6ExkkUNb
         2jeWho+BDV0VzwgyMjfQxa96G2607RWl2GSZdB1A=
Date:   Tue, 25 Jan 2022 18:08:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for
 migration entry
Message-Id: <20220125180832.8d12103399c82dd652b56577@linux-foundation.org>
In-Reply-To: <CAHbLzkoY36htvh-+0qtFUM1yF2Jnq-wzXdHJJ82x28q=HK5njw@mail.gmail.com>
References: <20220120202805.3369-1-shy828301@gmail.com>
        <CAHbLzkoY36htvh-+0qtFUM1yF2Jnq-wzXdHJJ82x28q=HK5njw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:59:48 -0800 Yang Shi <shy828301@gmail.com> wrote:

> The proper fixes tag should be:
> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()").
> 
> Andrew, could you please update this in -mm tree? Thanks.

Done, thanks.
