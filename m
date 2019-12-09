Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8911644E
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 01:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfLIAM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 19:12:27 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33498 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726422AbfLIAM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 19:12:27 -0500
Received: from callcc.thunk.org (ec2-52-55-121-20.compute-1.amazonaws.com [52.55.121.20])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xB90CFYW000391
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 8 Dec 2019 19:12:19 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B2F87421A48; Sun,  8 Dec 2019 19:12:11 -0500 (EST)
Date:   Sun, 8 Dec 2019 19:12:11 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: Fix ext4_empty_dir() for directories with holes
Message-ID: <20191209001211.GA9343@mit.edu>
References: <20191202170213.4761-1-jack@suse.cz>
 <20191202170213.4761-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202170213.4761-2-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 06:02:12PM +0100, Jan Kara wrote:
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

Applied, thanks.

					- Ted
