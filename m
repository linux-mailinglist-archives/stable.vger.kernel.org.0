Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF244B51F9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 14:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354530AbiBNNmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 08:42:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352260AbiBNNmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 08:42:18 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D84C01;
        Mon, 14 Feb 2022 05:42:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 577B368AA6; Mon, 14 Feb 2022 14:42:06 +0100 (CET)
Date:   Mon, 14 Feb 2022 14:42:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20220214134206.GA29930@lst.de>
References: <20220209085243.3136536-1-lee.jones@linaro.org> <20220210045911.GF8338@magnolia> <YgTl2Lm9Vk50WNSj@google.com> <YgZ0lyr91jw6JaHg@casper.infradead.org> <YgowAl01rq5A8Sil@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgowAl01rq5A8Sil@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Let me repeat myself:  Please send a proper bug report to the linux-ext4
list.  Thanks!
