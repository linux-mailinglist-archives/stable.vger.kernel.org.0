Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9AD4EBD8F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiC3JY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244774AbiC3JY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:24:26 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D582B1A7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:22:39 -0700 (PDT)
X-UUID: ec22b327a6cc44eaaf3b2d73f5aed227-20220330
X-UUID: ec22b327a6cc44eaaf3b2d73f5aed227-20220330
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 345178334; Wed, 30 Mar 2022 17:22:31 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 30 Mar 2022 17:22:30 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Mar
 2022 17:22:30 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Mar 2022 17:22:29 +0800
Message-ID: <c317f485cee7925f43881058b3bb546d71895b85.camel@mediatek.com>
Subject: Re: suggest commit 5b61343b50 to stable
From:   Miles Chen <miles.chen@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <yf.wang@mediatek.com>
Date:   Wed, 30 Mar 2022 17:22:25 +0800
In-Reply-To: <YkQV0OjQOoGV/QBg@kroah.com>
References: <20220330082157.3444-1-miles.chen@mediatek.com>
         <YkQV0OjQOoGV/QBg@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-03-30 at 10:33 +0200, Greg KH wrote:
> On Wed, Mar 30, 2022 at 04:21:57PM +0800, Miles Chen wrote:
> > Hi reviewers,
> > 
> > I suggest to apply the following patch to stable kernel 5.4.y and
> > 5.10.y:
> > 
> > commit: 5b61343b50590fb04a3f6be2cdc4868091757262
> > Subject: iommu/iova: Improve 32-bit free space estimate
> > kernel version to apply to: 5.4.y and 5.10.y
> 
> What about 5.15 and 5.16 and 5.17?  Why skip them?

Sorry for missing that, please add them to 5.15, 5.16 and 5.17. (I saw
you already added them, thanks).

I tested the patch(no merge conflict) and buld with Linux 5.15.32,
Linux 5.17.1, and Linux 5.16.18

Thanks,
Miles
> 
> thanks,
> 
> greg k-h

