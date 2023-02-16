Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC969999B
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBPQPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBPQO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:14:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCC14C13;
        Thu, 16 Feb 2023 08:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=l4YF2zCJQqUne0X/GcJ8KUXk9bV1BG6i4WMocOZ1sIc=; b=XCfuWIm77rWUun8PYHYtInBH+L
        DxSOJxxlfFfpW3e50lK6jS9Yaynk3cT6+N1ePA08aKk7r5tHwTZ2qnx6p3+NR6FiAD6ciUvoWia6o
        Ye3D59RbPD5KXVQQ4yLnVuPKnkU/SJxaimJFyMLM0pP5q6vh1RaEBfmyS22utFme02J0lUM4+TJl4
        N61yoQ0s9s2JCEfeXtOPbTieiUCbBNiNtl9siuzxYrb6JPWeYYXIopJEP1Wz8Cp+essHpqGr9ge9E
        04ZtFZ9X19MYC5G2tjvLx122HBBACgjO68Jpczvs2KsnrHIZ1IEztZG9yZcvvEmflIZJ35apMavgM
        tIl0EsZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSguQ-00B7ms-HM; Thu, 16 Feb 2023 16:14:58 +0000
Date:   Thu, 16 Feb 2023 08:14:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] brd: return 0/-error from brd_insert_page()
Message-ID: <Y+5WgmTEbGP5oz8P@infradead.org>
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-2-axboe@kernel.dk>
 <Y+5UYrUgp9lg8zRD@infradead.org>
 <e4fb52d3-25da-4796-2f79-d9630b7168d6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4fb52d3-25da-4796-2f79-d9630b7168d6@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 16, 2023 at 09:12:33AM -0700, Jens Axboe wrote:
> On 2/16/23 9:05 AM, Christoph Hellwig wrote:
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> >> Cc: stable@vger.kernel.org # 5.10+
> > 
> > But why is this a stable candidate?
> 
> Only because the other patches depend on it.

But none of those is stable material either as I can tell.  It's
a fairly simple and nice to have enhancement, but not really a
grave bug or regression fix.
