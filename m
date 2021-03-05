Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935BF32EBF0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 14:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhCENNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 08:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhCENNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 08:13:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB12EC061574;
        Fri,  5 Mar 2021 05:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=tIA0NXDSyz49QGV+/MhXdn6xDD
        7fCk5gSXFl4tCHyUz+RI+CAqse6j2yxe+AM5TiB2Q92QLonrCrDei96xLHGbX/rpuT8fddwnCHgLW
        mVaZ8fRIWgQ0QxECZQ8ePN4lurdX2ac0QorwPtgbpWi+awHr/WvEUx0Aftl78Q4Al/l+kAsXBubVo
        S2P3jBvDOx4apE6oCVwiJuKCQoFedpeYcLFgkzdwU1Lmv2KGLj7QZtwB4tunBd0kQVZNhr2WMFdMD
        joZ/+tmmOMDj2jcihlIU/7fratWOQf+Pejeuyz3RJ8zkCC7GBF3NUP92azMJZj9oS/iNa+2B9FXnh
        YxzZ/nFQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lIAFz-00BkCK-Az; Fri, 05 Mar 2021 13:12:48 +0000
Date:   Fri, 5 Mar 2021 13:12:39 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] block: Try to handle busy underlying device on discard
Message-ID: <20210305131239.GA2799004@infradead.org>
References: <20210222094809.21775-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222094809.21775-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
