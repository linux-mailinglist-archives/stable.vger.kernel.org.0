Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAAC526281
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380509AbiEMNCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 09:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380503AbiEMNB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 09:01:59 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712072F002;
        Fri, 13 May 2022 06:01:58 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 23E6F4D2; Fri, 13 May 2022 15:01:57 +0200 (CEST)
Date:   Fri, 13 May 2022 15:01:55 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     yf.wang@mediatek.com
Cc:     Will Deacon <will@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, wsd_upstream@mediatek.com,
        Libo Kang <Libo.Kang@mediatek.com>,
        Yong Wu <yong.wu@mediatek.com>, Ning Li <Ning.Li@mediatek.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/dma: Fix iova map result check bug
Message-ID: <Yn5Ww0xCuH+y4h+Y@8bytes.org>
References: <20220507085204.16914-1-yf.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507085204.16914-1-yf.wang@mediatek.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 07, 2022 at 04:52:03PM +0800, yf.wang@mediatek.com wrote:
>  drivers/iommu/dma-iommu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Applied, thanks.
