Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266E04A7F50
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 07:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbiBCGbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 01:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiBCGbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 01:31:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF29C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 22:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a3C1Ia2fPQvJ2jHdpSYVkre4n72E08491jrojoCfRv0=; b=2SSscc+7Dgj20dBzh4RMEj6OpE
        UShSvXs8ITEUlLc0mrqmaJ6JwY7vu17xQ4BUnZAUxfWTYyyyH8RTI1X7DfI5OJOxyalrr4xzOG8Mk
        KZ3EUzpF2CVVoCV9EksneyQVKJ59+zl/ZmIeDh9h7dQOOgqWPJKzlWV5yECDw/AeT1Vh3JVI6iaj8
        sWXhL3NNALD9kw2geYQ7Y4OMSwAwENKFfHm5P6y+306T/GVjgpOuw2/tF3J15/udm/06b6vnNHzfs
        RAs0BvINWPYBMdm3dSYN5ms2zHWWfJiR3w04DPR933bm6NfQY4lHWoDvRbAJi6t1kGZk5RKPIKUWK
        cICu1f+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFVeM-0004qJ-W7; Thu, 03 Feb 2022 06:31:22 +0000
Date:   Wed, 2 Feb 2022 22:31:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Uday Shankar <ushankar@purestorage.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] nvme-fabrics: Fix state check in
 nvmf_ctlr_matches_baseopts()
Message-ID: <Yft2unhvXO/fPK+Z@infradead.org>
References: <20220120201737.65390-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120201737.65390-1-jsmart2021@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-5.17.
