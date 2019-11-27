Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276E310B71F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfK0UAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:00:24 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48331 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727305AbfK0UAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 15:00:23 -0500
Received: from callcc.thunk.org (97-71-153.205.biz.bhn.net [97.71.153.205] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xARK0FIN002934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 15:00:16 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 21F7D4202FD; Wed, 27 Nov 2019 15:00:15 -0500 (EST)
Date:   Wed, 27 Nov 2019 15:00:15 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix ext4_empty_dir() for directories with holes
Message-ID: <20191127200015.GC22921@mit.edu>
References: <20191127131258.1163-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127131258.1163-1-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 02:12:58PM +0100, Jan Kara wrote:
> Function ext4_empty_dir() doesn't correctly handle directories with
> holes and crashes on bh->b_data dereference when bh is NULL. Reorganize
> the loop to use 'offset' variable all the times instead of comparing
> pointers to current direntry with bh->b_data pointer. Also add more
> strict checking of '.' and '..' directory entries to avoid entering loop
> in possibly invalid state on corrupted filesystems.
> 
> References: CVE-2019-19037
> CC: stable@vger.kernel.org
> Fixes: 4e19d6b65fb4 ("ext4: allow directory holes")
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
