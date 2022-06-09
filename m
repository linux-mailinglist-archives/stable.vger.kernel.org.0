Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5BA544E1D
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbiFINyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiFINyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:54:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB98E17328E;
        Thu,  9 Jun 2022 06:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OMC1sUVQLs6fZQNfeuWq1wWHGIfJxaObEnYZgL5kSsM=; b=RUCdtNskO4cmCafm6v0q0U25P7
        I/hXHxTW0wzvKNnWvXnG5KOARelAzgr+GiaINTNdFTDPpk7w1OIEUimcmQpM1ahNr4D7gUK8bYfbr
        wxwzLDKlN1dobQO/kDf5fYmym5+HOJahS3cuedPmQC8XDmxG2s7EjQuiW9dh2J7N0JJPK75wqjrO7
        SWmWbSoH0jPOvWOecjbJZzQI1cWDaYo98uB+rTC5vgnjnt68KfteBn4ylCGIaCaMKuWsN74NEwjpc
        Ib520xGXzm2DlXviPbvneBWCI4M75hft1muG3LY+8Mg3siUFnKKYy9agJMjyA8PrMrgDUMrNZsFpV
        N8calTDw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nzIbg-002KfG-8W; Thu, 09 Jun 2022 13:53:52 +0000
Date:   Thu, 9 Jun 2022 06:53:52 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     keescook@chromium.org, yzaikin@google.com,
        akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, peterz@infradead.org,
        dhowells@redhat.com, willy@infradead.org, Liam.Howlett@oracle.com,
        mhocko@suse.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: sysctl: fix missing numa_stat when
 !CONFIG_HUGETLB_PAGE
Message-ID: <YqH7cD3xRQ85TuN7@bombadil.infradead.org>
References: <20220609104032.18350-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609104032.18350-1-songmuchun@bytedance.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 06:40:32PM +0800, Muchun Song wrote:
> "numa_stat" should not be included in the scope of CONFIG_HUGETLB_PAGE, if
> CONFIG_HUGETLB_PAGE is not configured even if CONFIG_NUMA is configured,
> "numa_stat" is missed form /proc. Move it out of CONFIG_HUGETLB_PAGE to
> fix it.
> 
> Fixes: 4518085e127d ("mm, sysctl: make NUMA stats configurable")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>

Thanks! Queued onto sysctl-fixes.

  Luis
