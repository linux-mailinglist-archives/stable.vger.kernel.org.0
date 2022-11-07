Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0714861FD40
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiKGSTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiKGSTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:19:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0143B1FFA8;
        Mon,  7 Nov 2022 10:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1FBFB81613;
        Mon,  7 Nov 2022 18:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A8EC433D6;
        Mon,  7 Nov 2022 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667845116;
        bh=OTz39AVvt2pScOPpFzIDs3L2EQHnOYR8fVe0Jw6Bskg=;
        h=Date:From:To:Cc:Subject:From;
        b=BKfDCTZUt3NJjf8Z7aIgLGcB+a8nGkvI3IvB+TCbyGx1x/PRY/1ib3kB4tRMdAuDh
         7NFPv2KXk5tIFToualgBDwQjZVyvzJBr4p4IGIhsKIZLcFbVUGGvZGV5T9g+sj+gEF
         7ZdfP7yLpJgCmd5+rfqnhg8Xio8nX9RyPJAf++vst/cxFlH2ymoDm/F6h5NKY4Tw6s
         eQUv7SDhvqZzbnIarh55TAY5G89O1w4eUrklF8Aq5e1t86ZyO3Oofc7ILE8xClZ9Wp
         6W8gx5sYm3+n/AMoeFhZA9tVTEcc6Keah0oFzO7XY11XVnoChywTNNs1PmSqOwcCqQ
         FG08hNLOeF/Hg==
Date:   Mon, 7 Nov 2022 10:18:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jintao Yin <nicememory@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Please apply "ext4,f2fs: fix readahead of verity data" to stable
Message-ID: <Y2lL+lSibGY9hPEE@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable maintainers,

Please apply commit 4fa0e3ff217f775cb58d2d6d51820ec519243fb9
("ext4,f2fs: fix readahead of verity data") to stable, 5.10 and later.  It
cherry-picks cleanly to 6.0 and 5.15.  I'll send it out manually for 5.10.

- Eric
