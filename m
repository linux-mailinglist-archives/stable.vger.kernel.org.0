Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC75100589
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 13:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfKRMZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 07:25:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRMZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 07:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TJ2JeIO6Q3wjCCUTgGmLHim7HC98v5OYR1iIlbW1p14=; b=ZzFz2m7MAuo9T+24GOitYZtp2
        chZu+oYG+oZPpt7HrBjPl6R1fKUBO4QSGcv5O/aF2+i+ODy31VJfbEr7IXhJQqTQd6iWk29oTEwII
        yj31EGSIIt6lhiPbZShgrqLvBfDYq2/RvUAw6gBtORldw3xAkICjjnE5cfFVXVyF2pS5qBWNGu+tT
        WtFUpji8RGWyQi3yg2QfLZoyFCfgzBw4k64OgbobXkUqohrqPA949Y6EIPbZc/lFmS9gtEq68gFCB
        TEjiryTBcoJ2P5giT2H3Ig4nr2ePC3acduMLKDeDO72Z1e2MKb2sBnDNzJ0qBL1LTACbPGBmoaeN9
        ycSYbcuYg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iWg5q-0007ta-2u; Mon, 18 Nov 2019 12:25:22 +0000
Date:   Mon, 18 Nov 2019 04:25:22 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        yangyingliang@huawei.com
Subject: Re: [PATCH 4.4] memfd: Use radix_tree_deref_slot_protected to avoid
 the warning.
Message-ID: <20191118122522.GJ20752@bombadil.infradead.org>
References: <20191118032610.182862-1-zhongjiang@huawei.com>
 <20191118032610.182862-3-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118032610.182862-3-zhongjiang@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 11:26:09AM +0800, zhong jiang wrote:
> The commit eb4058d8daf8 ("memfd: Fix locking when tagging pins")
> introduces the following warning messages.
> 
> *WARNING: suspicious RCU usage in memfd_wait_for_pins*
> 
> It is because we still use radix_tree_deref_slot without read_rcu_lock.
> We should use radix_tree_deref_slot_protected instead in the case.
> 
> Cc: stable@vger.kernel.org
> Fixes: eb4058d8daf8 ("memfd: Fix locking when tagging pins")
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

