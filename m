Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD437423268
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 22:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhJEU41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 16:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230027AbhJEU41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 16:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDFDC6121F;
        Tue,  5 Oct 2021 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633467276;
        bh=vrx4nycNQWe2zmH+Kp1Mpj5jptOEbE1oU7OEdqQQccs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E5hcnzj+39m9VFZG2KWUDcC8VTs69ZGMY/BhDLHVq725LOL7svRszbZU3EtkyYacn
         kmlxB1l9gYYSsmSMpnkgE7f2H129rVkpJWzWCgBmRDn41RVZo5ZjDxC2l8wt6xLMt/
         HCMnMX+CsoW0f//3reQDnRYwM1uUQm/UAYxuBq1U=
Date:   Tue, 5 Oct 2021 13:54:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/hugetlb: fix CMA gigantic page order for non-4K
 PAGE_SIZE
Message-Id: <20211005135435.341477bb4b50b84202c32450@linux-foundation.org>
In-Reply-To: <20211005202529.213812-1-mike.kravetz@oracle.com>
References: <20211005202529.213812-1-mike.kravetz@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  5 Oct 2021 13:25:29 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
> CONT_PMD_SHIFT order.

What are the user visible effects of this bug?


