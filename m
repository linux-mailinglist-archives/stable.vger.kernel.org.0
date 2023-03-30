Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDA56CF919
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 04:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjC3CXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 22:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3CXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 22:23:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975454C2C
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 19:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QsdrcA/589ltjZTcCcSDKKxhiJ7CxFHhrMptES1Y1Y4=; b=kCLl9rOwAukh7rxNPXxtiHwW8O
        lQAXiJJLCBIJoYmn25bgm7fUmTyjao2WNq0fUKa7MYSEoZkj5uhTcDXOflP0I/EG+CK/Wew4f9MDI
        ev9V3sICwqrdQpAn8cdhaRxIIySQ9L+GQDxbS2RKgQ5Clti3OhhC46fYAIb/TmKjYBq4fWhPdCVlm
        mPaO8xMRZ4Sz8smTpsbJBXGG990uT1jm5bcRHC+covfjndwA+GADrfEG+E/pEawLdsgkRos45E+gF
        ERT5FiN9iD7VrIq4peh8JlAgh3StRBGWf8owsshEdK50kvcTDDS5QLMix8kDddaydtYeZ6kXnt0PJ
        x7iNrOnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1phhwZ-002LET-1c;
        Thu, 30 Mar 2023 02:23:15 +0000
Date:   Wed, 29 Mar 2023 19:23:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        nouveau@lists.freedesktop.org,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Take a page reference when removing device
 exclusive entries
Message-ID: <ZCTykyabcaS98Jnm@infradead.org>
References: <20230330012519.804116-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330012519.804116-1-apopple@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

s/page/folio/ in the entire commit log?
