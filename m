Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1E6BD31C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 16:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjCPPOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjCPPOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 11:14:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F62B719D;
        Thu, 16 Mar 2023 08:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qo1V+cb49gj6iQTeAQn1XTvxnv
        nlPh5RJD8psCWtaotjpOYrC/BgzRsxd0M+yY3AVnIWNx1mfNWLpcJMbieF5lptQJZShRZ6ULQGDXU
        rd6VBFkMpqzL2smxBdQrMy+q7KpCh87AI75BGRYH1IhYqT6BxuyQkokoYoCdhoIGFjW8dSI1Usblv
        gW4CMMi6HWrWrQdcmPR9rVPEXjFuHWQFMhEc6pKu3mYiHOmIvwaogX5FhN0Lscu8YWwaNBjip6j7E
        stByKNdfRgorVut/j8afoXCAq25JiKqTBYG9YTtFAwbE0TN0VKIwD43mGN//zWNGEDnNd5R6qf1Bp
        DPXgW7ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcpJ8-00Gmlh-1J;
        Thu, 16 Mar 2023 15:14:22 +0000
Date:   Thu, 16 Mar 2023 08:14:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/6] blk-crypto: make blk_crypto_evict_key() return
 void
Message-ID: <ZBMyTiCFACn7johv@infradead.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315183907.53675-3-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
