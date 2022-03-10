Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8239F4D4F3F
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 17:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbiCJQ32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 11:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244740AbiCJQ3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 11:29:23 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6804C41C;
        Thu, 10 Mar 2022 08:28:22 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3885468B05; Thu, 10 Mar 2022 17:28:19 +0100 (CET)
Date:   Thu, 10 Mar 2022 17:28:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [BUG] new MIPS compile error on v5.15.27
Message-ID: <20220310162818.GA4436@lst.de>
References: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please fix <asm/asm.h>.   The most trivial fix might be to only defined
END() under __ASSEMBLY__, although in the long run it probably wants a
better name as well.
