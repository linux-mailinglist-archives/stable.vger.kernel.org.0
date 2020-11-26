Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABE02C53EF
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 13:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgKZMZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 07:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729563AbgKZMZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 07:25:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE72C0613D4;
        Thu, 26 Nov 2020 04:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=AW/2IfJ/CuxPOYgFJ8DJmpuZds
        0M3CxBZSxowS0Xwr0pSGUki5gLAkEOT+DB1OTQCr1MEy5OGKSvJMomrbJa4Kfn3lcOEjzR2/gW6tF
        2wkz0KWi89ly+jWH6WC1b15EJYPKEgArZMRA1YaLolgxIsLxsdbutMxx45IW8mFAthTO+hOGXZD92
        p041klDnjNYE4tqurIOVWSZ/gkyodeJE+RIGzzpCcr6LVQyz2N0Psp1+gtXsy67z+Kqnnd4auUMkp
        wGPARCU7VP48XztftAF6gFtHqKLVdddljYvJtIzTvUeh3aEMhoxRiJNuw5a6TEyTjJ/DaB6qqw5ef
        9xrEi4qw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiGLC-0001Jg-Kn; Thu, 26 Nov 2020 12:25:38 +0000
Date:   Thu, 26 Nov 2020 12:25:38 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, torvalds@linux-foundation.org,
        hch@infradead.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ima: Don't modify file descriptor mode on the fly
Message-ID: <20201126122538.GA4626@infradead.org>
References: <20201126103456.15167-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126103456.15167-1-roberto.sassu@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
