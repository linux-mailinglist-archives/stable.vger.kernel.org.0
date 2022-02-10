Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B924B05B7
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 06:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiBJFsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 00:48:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiBJFr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 00:47:59 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E6E10CC;
        Wed,  9 Feb 2022 21:47:58 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7187268B05; Thu, 10 Feb 2022 06:47:54 +0100 (CET)
Date:   Thu, 10 Feb 2022 06:47:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <20220210054754.GB3293@lst.de>
References: <20220209085243.3136536-1-lee.jones@linaro.org> <20220209150904.GA22025@lst.de> <YgPk9HhIeFM43b/a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgPk9HhIeFM43b/a@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 03:59:48PM +0000, Lee Jones wrote:
> > Well, maybe you should actually debug and try to understand what is
> > going on before blindly reverting random commits.
> 
> That is not a reasonable suggestion.

In that case we fudamentally disagree what "reasonable" means.

Sending a revert for a 2 year old commit based on a BUG in consumer of
that subsystem based on a really old kernel without any explanation
of why that revert is even directly related to the problem and not just
a casuality is what I would define as completely unreasable.

Please send a proper bug report to the ext4 maintainer first, and we
can work from there.
