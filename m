Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1CA6AAD92
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 01:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCEAAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 19:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCEAAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 19:00:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A744199CE;
        Sat,  4 Mar 2023 16:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TkIQu3TPsM6ji5C2QtwbOmWwtOZkLwyJUtqHPGL53xE=; b=eTiY+jAgsZl8q470a4XOe8TBmP
        ujKjrZTDRfH0d5knsDYYetvbHuxg0LRvMhM2MV9tZXJe4d60f3I3dckhIw/GNjgnl0FrFMx+rUZl1
        13D35Qdb61mtDiFWfSfmWDgCC4Vh8dpxbH5yeic7K/oGRK3EmB5niWRzJqPLzQwGTIJFvzyZtM07U
        p+u5APYXYCSxsiWB4SmHb8XF8kDgWN7VHZ8FTsWLJRI0Pfor4JbmN6ATpgU3MiwZsCH9Us5W2M3IW
        ckHwBS8L+46xSVAcP8XJ5KKOgn9RI2vvr/HL1iJquGsRjZpJUznt7xFsYfHvY21gFVXvUxd/8XE36
        19+xbmdA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYbnp-0047Nz-7v; Sun, 05 Mar 2023 00:00:37 +0000
Date:   Sun, 5 Mar 2023 00:00:37 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/paddr: fix folio_nr_pages() after
 folio_put() in damon_pa_mark_accessed_or_deactivate()
Message-ID: <ZAPbpUkiw3T2blE5@casper.infradead.org>
References: <20230304193949.296391-1-sj@kernel.org>
 <20230304193949.296391-3-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304193949.296391-3-sj@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 07:39:49PM +0000, SeongJae Park wrote:
> damon_pa_mark_accessed_or_deactivate() is accessing a folio via
> folio_nr_pages() after folio_put() for the folio has invoked.  Fix it.
> 
> Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")
> Cc: <stable@vger.kernel.org> # 6.3.x
> Signed-off-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

