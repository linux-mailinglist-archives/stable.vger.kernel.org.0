Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9774B1D0EA4
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388374AbgEMKBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388164AbgEMKBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 06:01:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312F3C061A0C;
        Wed, 13 May 2020 03:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=oIT4W0UovA9RYEFGH4V9/aZ3QD
        hyM0HMD4InNFSrgj32nIFn8imntzyDKDbjjJUQvkjni/54C6idoRcT0lFhmxQQeJfpIe7mDl+6WqR
        frTvton/ZWQXVki3uxSWX/37/yuDQ9SKqv8atDCt4O8rGTLw6YlmmEw9WnsoFnq0hwFG8C/XIx7uS
        nSDj9uwo9Y/oAHVd4zUxr6NLNLp0gl6Y3oxAqb1dO+4xOgD2rpZMnJhBzHNNHtIX0gWFd2lnVg4Xd
        +LgzvwCw/8U0Xh7RvmOYTzROvULrlpN0DdmuNAei3lqk3iUXD4cXkcH2e4ooENAoqsyBvOnOdMKjE
        4DPajK7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYoCf-00025o-CN; Wed, 13 May 2020 10:01:29 +0000
Date:   Wed, 13 May 2020 03:01:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] aio: fix async fsync creds
Message-ID: <20200513100129.GA7720@infradead.org>
References: <20200505095915.11275-1-mszeredi@redhat.com>
 <20200505095915.11275-3-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505095915.11275-3-mszeredi@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
