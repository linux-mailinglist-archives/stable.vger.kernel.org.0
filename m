Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1553FB3A6
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 12:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhH3KMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 06:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhH3KMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 06:12:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10126C0613D9;
        Mon, 30 Aug 2021 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Doe4Y3c6/HJtxTnrRvUecOMxbV
        hAKGS2IT+m/CFY0EWvhW1kBD0dcQzsv/3PNVnOSm9SMUaQCat/daHakiW/J6YK8aVjjDcNqp+jZUp
        43H+J7goe/lX9D3edt2RBBJ0Xh44B+FZu8cRKf3gpV2ak92rhjzQ9wMSozENGstSZSmSirA6MRChq
        LWTMforeaPsMRMRdMAXtwMXAbmWSDOsb8Ww9Pj1tKH52qK9KukPfBQrFyIxNz9dke1un9r2koSSOL
        yIbtIW4DpqE3AiBYk0Q+oWW+ytNSvl+VpwBXV087fJNltKpVdJbP0Tsd7DrfgiEuog2047v5EzNS3
        XVN+rFGg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKeEc-0000Bp-6a; Mon, 30 Aug 2021 10:10:09 +0000
Date:   Mon, 30 Aug 2021 11:09:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        akpm@linux-foundation.org, jglisse@redhat.com, jgg@ziepe.ca,
        hch@infradead.org, yishaih@nvidia.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/hmm: bypass devmap pte when all pfn requested
 flags are fulfilled
Message-ID: <YSyuavTm7UDfvHdH@infradead.org>
References: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
