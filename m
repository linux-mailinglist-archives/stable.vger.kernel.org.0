Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40E158FA0B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 11:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiHKJ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiHKJ3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 05:29:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ACF92F54;
        Thu, 11 Aug 2022 02:29:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id ED6AD68AA6; Thu, 11 Aug 2022 11:29:11 +0200 (CEST)
Date:   Thu, 11 Aug 2022 11:29:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20220811092911.GA22246@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org> <20220810140030.GA24195@lst.de> <YvP9YITH0RpgpblG@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvP9YITH0RpgpblG@dhcp22.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is what I think should solve your problem properly:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-pool-sizing



