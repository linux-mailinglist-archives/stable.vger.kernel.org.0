Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE218100587
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 13:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKRMZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 07:25:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRMZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 07:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6IPkMgH3WQszKmAHVy1q8dAoUqcLAYFmxcz5zZyy7iI=; b=p6KNA0Kjm3fBzop5XZRxZz21J
        QsAjDbthTD4PCGXVVMMdJAArJvLkLzf1nEp3u1WTV7Ycz2OvsCo8W1C7g/gQ1GedrJnTKuSwZkyMk
        ZXd4+UWqa5t54xJi73+M/BC2qji2kFUqY7akItJDd7s+BKHjuX8A0dAxAd41ChlwH/6CktW5gMRNl
        Zm8XVI6HPSfJRVsLN0xnzmeLuVqY3MEUkQ0c7dU2Yvp+/1a9cjnJoj/a6Yr5vwGu93xSjpVbYZPqi
        qB6YWOfI6Sldn40o0f14R8WNa66xIS6WWSPcWNjaNxhW6C9haIAkwGstHMfyG0XWIXZ2ag/pu5RIw
        4fTILzG5g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iWg5Y-0007BW-TI; Mon, 18 Nov 2019 12:25:06 +0000
Date:   Mon, 18 Nov 2019 04:25:04 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        yangyingliang@huawei.com
Subject: Re: [PATCH 4.19] memfd: Use radix_tree_deref_slot_protected to avoid
 the warning.
Message-ID: <20191118122504.GI20752@bombadil.infradead.org>
References: <20191118032610.182862-1-zhongjiang@huawei.com>
 <20191118032610.182862-2-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118032610.182862-2-zhongjiang@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 11:26:08AM +0800, zhong jiang wrote:
> The commit 99b45e7a1ba1 ("memfd: Fix locking when tagging pins")
> introduces the following warning messages.
> 
> *WARNING: suspicious RCU usage in memfd_wait_for_pins*
> 
> It is because we still use radix_tree_deref_slot without read_rcu_lock.
> We should use radix_tree_deref_slot_protected instead in the case.
> 
> Cc: stable@vger.kernel.org
> Fixes: 99b45e7a1ba1 ("memfd: Fix locking when tagging pins")
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

