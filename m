Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAD739C004
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDTAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 15:00:52 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48068 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229823AbhFDTAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 15:00:52 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 154Iwj1m006548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Jun 2021 14:58:46 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id ADDD215C39C3; Fri,  4 Jun 2021 14:58:45 -0400 (EDT)
Date:   Fri, 4 Jun 2021 14:58:45 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Daniel Rosenberg <drosen@google.com>,
        Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Message-ID: <YLp35XvlTuuZrcYf@mit.edu>
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-3-drosen@google.com>
 <YLlj+h4RiT6FvyK6@sol.localdomain>
 <YLmv5Ykb3QUzDOlL@google.com>
 <YLmzkzPZwBVYf5LO@sol.localdomain>
 <YLm8aOs6Sc/CLaAv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLm8aOs6Sc/CLaAv@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 10:38:48PM -0700, Jaegeuk Kim wrote:
 > > Yes, but in the on-disk case, encrypted_casefold is redundant because it simply
> > means encrypt && casefold.  There is no encrypted_casefold flag on-disk.
> 
> I prefer to keep encrypted_casefold likewise kernel feature, which is more
> intuitive to users.

At least for ext4, there are kernel vesions which support encryption
and casefold *separetely*, but which do not support the file systems
that have encryption and casefold enabled simultaneously.  This is why
I had added /sys/fs/ext4/features/encrypted_casefold.  It was
originally not to indicate whether the on-disk file system supported
those features, but to indicate that the kernel in question supported
both features being enabled simultaneously.

					- Ted
