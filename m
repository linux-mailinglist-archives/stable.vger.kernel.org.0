Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AAB2429C1
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 14:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgHLMvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 08:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgHLMvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 08:51:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7723AC06174A;
        Wed, 12 Aug 2020 05:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1BOYYaOKtqrBkKeeYxmAJRigV3uKydm40c6msuVCcwA=; b=C3DuZ4T8MqBw8ViK7uH0FXX4m1
        ns8VWzEbXnAE1tPnOpEeyMdnmTzOKxFSK7cGAKaJupx/rmWSbDF4lSk1mKGFpqj4c7fSXyF6q3bgN
        PXIx3qGWenSlQ/7z9gYZsHKUx4+qxYXYKQQSHla/+Ky/gGyWD+pl7kXvmt/HYEr+2OzjreCCJZ4dY
        2Re7f5yRZcg2McQtclHCaNQVlKWF5TiI5OxHtiBWO00gRgWYTRaeHC6xYEbFaiQLNqa1HIuAxEYe3
        3+GfbNAfp725ors/HjPLY2tERnMBQiHf8X05ztsNEWgCUjBD6ljjaN4hmqxKU+SI9bW9rodUmKqNG
        RprVEbnw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5qDz-00069g-Lq; Wed, 12 Aug 2020 12:51:23 +0000
Date:   Wed, 12 Aug 2020 13:51:23 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] block: allow for_each_bvec to support zero len bvec
Message-ID: <20200812125123.GA17456@casper.infradead.org>
References: <20200810031915.2209658-1-ming.lei@redhat.com>
 <db57f8ca-b3c3-76ec-1e49-d8f8161ba78d@i-love.sakura.ne.jp>
 <20200810162331.GA2215158@T590>
 <20200812090039.GA2317340@T590>
 <242fc33d-686b-928d-415e-8b519c56a62c@i-love.sakura.ne.jp>
 <20200812124712.GA2331687@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812124712.GA2331687@T590>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 08:47:12PM +0800, Ming Lei wrote:
> On Wed, Aug 12, 2020 at 07:03:59PM +0900, Tetsuo Handa wrote:
> > On 2020/08/12 18:00, Ming Lei wrote:
> > > BTW, for_each_bvec won't be called in the above splice test code.
> > 
> > Please uncomment the // lines when testing for_each_bvec() case.
> 
> What is the '//' lines?

The lines in the test-case which begin with the sequence '//'.

> > This is a test case for testing all empty pages.
> 
> But the case for testing all empty pages is not related with this patch,
> is it?
> 
> 
> Thanks,
> Ming
> 
