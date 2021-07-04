Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C14A3BAAC3
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 02:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhGDBAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 21:00:45 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49657 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229557AbhGDBAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 21:00:45 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1640w2GV025380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 3 Jul 2021 20:58:02 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 2BB1915C3CEB; Sat,  3 Jul 2021 20:58:02 -0400 (EDT)
Date:   Sat, 3 Jul 2021 20:58:02 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tahsin Erdogan <trdgn@amazon.com>
Cc:     Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: eliminate bogus error in
 ext4_data_block_valid_rcu()
Message-ID: <YOEHmjjY9facxtIY@mit.edu>
References: <20210703230555.4093-1-trdgn@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703230555.4093-1-trdgn@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 03, 2021 at 04:05:55PM -0700, Tahsin Erdogan wrote:
> Mainline commit ce9f24cccdc0 ("ext4: check journal inode extents more carefully")
> enabled validity checks for journal inode's data blocks. This change got
> ported to stable branches, but the backport for 4.19 has a bug where it will
> flag an error even when system block entry's inode number matches journal
> inode.

Tahsin,

If I understand the commit description, this patch is only intended
for the 4.19 stable kernel.  If this is the case, I'd suggest using
the Subject prefix [PATCH 4.19] for future patches.  This is more
likely to be clearer (via a quick glance at the Subject line) for
subsystem maintainers, as well as for stable kernel maintainers, that
this is meant for the stable kernel.  It would perhaps also be useful
if you could indicate whether a similar fix is needed for 4.14, and
other older LTS kernels, or whether the only stable backport which had
this bug was 4.19.

Cheers,

					- Ted

P.S.  Great to see you've landed at Amazon!  It's been a while; if I
have a chance to make it out to Seattle, one of these days, it would
be great to catch up.
