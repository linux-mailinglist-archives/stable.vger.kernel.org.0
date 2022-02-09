Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA5E4AF4F5
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 16:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiBIPRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 10:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiBIPRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 10:17:22 -0500
X-Greylist: delayed 495 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 07:17:25 PST
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E36C06157B;
        Wed,  9 Feb 2022 07:17:25 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E948168BEB; Wed,  9 Feb 2022 16:09:04 +0100 (CET)
Date:   Wed, 9 Feb 2022 16:09:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
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
Message-ID: <20220209150904.GA22025@lst.de>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209085243.3136536-1-lee.jones@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> 
> Reverting since this commit opens a potential avenue for abuse.
> 
> The C-reproducer and more information can be found at the link below.
> 
> With this patch applied, I can no longer get the repro to trigger.

Well, maybe you should actually debug and try to understand what is
going on before blindly reverting random commits.
