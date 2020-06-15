Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEED81F8DCD
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 08:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgFOG1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 02:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgFOG1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 02:27:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B61C061A0E;
        Sun, 14 Jun 2020 23:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=YrnsVawQg1rNycf0O3bwMyBiAl
        /8maVyl+YFA92CQi1hrxDUdSU3eEc3UU1ITrGMFD8BZWQ30Yr7qz67QcIKo8AOmnFqXXL3pLTAdBC
        Ba24UC8MraTsDFTzmubVNjYb97ogjc9+ltP33FQERe+dh0VItRZO8K6iFoHTnnPovk9Ov8g29s6xa
        nZcDDUYzNQkeD5hJqQ7TvJAwXHbuQZ/upcakOUtzNx1KY96cADDQOYUqSNtFEk+DDSpB/GIRiMN6k
        T9xzL8a0tghGshvO0FMRh84taabFAeM9gfDWlLj2dL53q+zWEt1NZGwRvFZF1zdubggq3RoJc2XPR
        S8gdA7tA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkiaj-00075t-6W; Mon, 15 Jun 2020 06:27:33 +0000
Date:   Sun, 14 Jun 2020 23:27:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] writeback: Avoid skipping inode writeback
Message-ID: <20200615062733.GB26438@infradead.org>
References: <20200611075033.1248-1-jack@suse.cz>
 <20200611081203.18161-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611081203.18161-2-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
