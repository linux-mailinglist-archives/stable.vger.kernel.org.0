Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91159190B
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 08:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiHMGde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 02:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMGde (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 02:33:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E772BC89;
        Fri, 12 Aug 2022 23:33:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2B2BF68AA6; Sat, 13 Aug 2022 08:33:30 +0200 (CEST)
Date:   Sat, 13 Aug 2022 08:33:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, hch@lst.de, david@redhat.com,
        bhe@redhat.com, mhocko@suse.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20220813063329.GB10523@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810013308.5E23AC433C1@smtp.kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I noticed this is still in -mm.  As state before any change to
kernel/dma/pool.c should go through the dma-mapping tree, AND this
patch is not correct.  Please drop it.
