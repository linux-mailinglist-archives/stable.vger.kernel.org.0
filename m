Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA48699972
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBPQF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBPQF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:05:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F9C7EDC;
        Thu, 16 Feb 2023 08:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O2D5nW5XF0g0jK/l4mhY8Kd11zhtKlQjQHYsfFEYi8k=; b=BOszm+o5h2IqKAPTgvineJhAea
        5njh1E0Wi0DPv4RIPkbCEDECyFoJBLGQWhijTRvsq50RLhmsJ9q7Twk3vFILGej0Ezc3tm6UEqPmm
        5uc//W1Nob31knAR/L3gPhS0ABnv4ndc5CCmhWOuY4XAK5wF0UdNLCqrS0yHG8X+4g4Fx03H+rXs5
        F7Wq5FesPMOEKUmPwDlUyNlum6zuDsNCdj8lOoQwFUNCylo7TDtrtNLpy0hqqd8RnDx1Myi/LKfPC
        mKSrKrFABuuPoLUHRPbQejDPLQ+8fhqOqRwJxhkigsGvROFDgomcNaTrvGjIxmc++1q9JeOOHdsWg
        GN0bdBQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSgle-00B3OK-Ee; Thu, 16 Feb 2023 16:05:54 +0000
Date:   Thu, 16 Feb 2023 08:05:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] brd: return 0/-error from brd_insert_page()
Message-ID: <Y+5UYrUgp9lg8zRD@infradead.org>
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216151918.319585-2-axboe@kernel.dk>
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

> Cc: stable@vger.kernel.org # 5.10+

But why is this a stable candidate?
