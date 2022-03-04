Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1079D4CD857
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiCDPyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 10:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240525AbiCDPyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 10:54:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D48C1C4B2D;
        Fri,  4 Mar 2022 07:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1+Qh0+uXxcAV1aciqUFtIAq+pnhtnrmQDTbORGN7Wvs=; b=3QQrs5rXY6WU70eO/f3dbib5GH
        1Ws7kXHYxdcDcAalTNsFLK3BV1kg7uGIHGVnBQete1rgLW9fjlhnqalk9dOEL4JJa0MPBVJwlxqzO
        3UzDYk4CkgReFuLQE8JMN3vTlaedMY+f+WSzSqWSZ/1kLzmW//fsbQMNve5dYzvrxDlWD93ocTpqy
        /Lxvj+suxpIpyo1DOLyDHSclHsL0ZMNHWETaraBuE18e/b2PKmCEN7emT3yeb64ie6gKiVNrFMUMf
        6TrTwrsXmvRy2MIkLwTSE5ayJXIjKVEBRaSdpUnWkMLwKwI1fKfY2nj9SudJlPQrMAXuLdKcvtDZp
        Y2j0uk1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAFY-00As6b-1X; Fri, 04 Mar 2022 15:53:48 +0000
Date:   Fri, 4 Mar 2022 07:53:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/2] swiotlb: rework fix info leak with DMA_FROM_DEVICE
Message-ID: <YiI2DPIrNLKwanZw@infradead.org>
References: <20220304135859.3521513-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304135859.3521513-1-pasic@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 02:58:57PM +0100, Halil Pasic wrote:
> Unfortunately, we ended up with the wrong version of the patch "fix info
> leak with DMA_FROM_DEVICE" getting merged. We got v4 merged, but the
> version we want is v7 with some minor tweaks which were supposed to be
> applied by Christoph (swiotlb maintainer). After pointing this out, I
> was asked by Christoph to create an incremental fix. 
> 
> IMHO the cleanest way to do this is a reverting the incorrect version
> of the patch and applying the correct one. I hope that qualifies as
> an incremental fix.

I'd really do one patch to move to the expected state.  I'd volunteer
to merge the two patches, but I've recently shown that I'm not
exactly good at that..
