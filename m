Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8C039FD3C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhFHRJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhFHRJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 13:09:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302DBC061574;
        Tue,  8 Jun 2021 10:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Nfy7uHyPPkAWxLl39aLZblVFB7
        0vwbycBZf/vrgq0OMEhKhsgDEH0Egmu4lo26/o7ub+2LWA2WnxqaiWi0mY0P4mcGiOoHAd1P0fUFV
        vPG3JNOTyJd84AYKjmMtyFDX97Hebo6tnkVmablx7T14R3G/3tQVCXjLzsnaIirU8zKDEx1iwDUct
        MM69W1nxXe/T8O3/En2V/2jegx7uk4APqwpvWFO7NiiWUBqhelaye+p1aIWjhq1tjYdLfm6ru+fGr
        ku8arZlwmYam9VpPVFmK5cCVLydyG+qT2uhYuCzKBPJ/BfdP+O+wQyTe7BITV2tw47D4PSpdjeUBj
        pm3pPpyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqfBy-00HBTn-VX; Tue, 08 Jun 2021 17:07:14 +0000
Date:   Tue, 8 Jun 2021 18:07:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     longli@linuxonhyperv.com
Cc:     linux-block@vger.kernel.org, Long Li <longli@microsoft.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Patch v3] block: return the correct bvec when checking for gaps
Message-ID: <YL+jusm3DVsWpQ5b@infradead.org>
References: <1623094445-22332-1-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623094445-22332-1-git-send-email-longli@linuxonhyperv.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
