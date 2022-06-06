Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEAE53F1B7
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 23:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiFFVas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 17:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiFFVas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 17:30:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5402114;
        Mon,  6 Jun 2022 14:30:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 50CAB10E7564;
        Tue,  7 Jun 2022 07:30:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nyKJ8-003WJk-LK; Tue, 07 Jun 2022 07:30:42 +1000
Date:   Tue, 7 Jun 2022 07:30:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
Message-ID: <20220606213042.GS227878@dread.disaster.area>
References: <20220606143255.685988-1-amir73il@gmail.com>
 <20220606143255.685988-9-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606143255.685988-9-amir73il@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=629e7206
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=SPCyhYlST5j3E4FAFNoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> 
> xfs/538 on a 1kB block filesystem failed with this assert:
> 
> XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448

You haven't mentioned that you combined a second upstream
commit into this patch to fix the bug in this commit.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
