Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743B5530336
	for <lists+stable@lfdr.de>; Sun, 22 May 2022 15:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345605AbiEVNIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 May 2022 09:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbiEVNH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 May 2022 09:07:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F6A39834;
        Sun, 22 May 2022 06:07:58 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 90DB668AFE; Sun, 22 May 2022 15:07:53 +0200 (CEST)
Date:   Sun, 22 May 2022 15:07:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     hch@lst.de, m.szyprowski@samsung.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        thomas.lendacky@amd.com, rientjes@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] dma-direct: Don't over-decrypt memory
Message-ID: <20220522130752.GA25785@lst.de>
References: <796ddc256b8a3054cb0b2f43363613463fcf0d61.1653066613.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796ddc256b8a3054cb0b2f43363613463fcf0d61.1653066613.git.robin.murphy@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to the dma-mapping for-next branch.
