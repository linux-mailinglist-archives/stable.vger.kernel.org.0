Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D194D4FB2
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiCJQtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 11:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244335AbiCJQtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 11:49:16 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E154E0A0F;
        Thu, 10 Mar 2022 08:48:02 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 705A792009C; Thu, 10 Mar 2022 17:48:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 6995C92009B;
        Thu, 10 Mar 2022 16:48:01 +0000 (GMT)
Date:   Thu, 10 Mar 2022 16:48:01 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Christoph Hellwig <hch@lst.de>
cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [BUG] new MIPS compile error on v5.15.27
In-Reply-To: <20220310162818.GA4436@lst.de>
Message-ID: <alpine.DEB.2.21.2203101640560.47558@angie.orcam.me.uk>
References: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com> <20220310162818.GA4436@lst.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022, Christoph Hellwig wrote:

> Please fix <asm/asm.h>.   The most trivial fix might be to only defined
> END() under __ASSEMBLY__, although in the long run it probably wants a
> better name as well.

 FWIW the END macro has its roots in IRIX if not MIPSCO.  It's been around 
for some 30 years if not more.  MIPS/ULTRIX may have had it too, as it's 
originally all ECOFF stuff, i.e. `.end', `.ent', `.frame', etc. assembly 
pseudo-ops for symbol/debug information.

  Maciej
