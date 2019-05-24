Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B02628FB0
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388460AbfEXDql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:46:41 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58070 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387454AbfEXDql (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 23:46:41 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4O3kSkw010622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 May 2019 23:46:28 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BC0E8420481; Thu, 23 May 2019 23:46:27 -0400 (EDT)
Date:   Thu, 23 May 2019 23:46:27 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ext4: Wait for outstanding dio during truncate in
 nojournal mode
Message-ID: <20190524034627.GB2532@mit.edu>
References: <20190522090317.28716-1-jack@suse.cz>
 <20190522090317.28716-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522090317.28716-2-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 11:03:15AM +0200, Jan Kara wrote:
> We didn't wait for outstanding direct IO during truncate in nojournal
> mode (as we skip orphan handling in that case). This can lead to fs
> corruption or stale data exposure if truncate ends up freeing blocks
> and these get reallocated before direct IO finishes. Fix the condition
> determining whether the wait is necessary.
> 
> CC: stable@vger.kernel.org
> Fixes: 1c9114f9c0f1 ("ext4: serialize unlocked dio reads with truncate")
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
