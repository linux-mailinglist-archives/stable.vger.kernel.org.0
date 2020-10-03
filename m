Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0240282175
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 06:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJCE4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 00:56:37 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52766 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725446AbgJCE4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 00:56:37 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0934uS1W015912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 3 Oct 2020 00:56:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 85B3942003C; Sat,  3 Oct 2020 00:56:28 -0400 (EDT)
Date:   Sat, 3 Oct 2020 00:56:28 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: fix leaking sysfs kobject after failed mount
Message-ID: <20201003045628.GH23474@mit.edu>
References: <000000000000443d8a05afcff2b5@google.com>
 <20200922162456.93657-1-ebiggers@kernel.org>
 <20200924090859.GF27019@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924090859.GF27019@quack2.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 11:08:59AM +0200, Jan Kara wrote:
> On Tue 22-09-20 09:24:56, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > ext4_unregister_sysfs() only deletes the kobject.  The reference to it
> > needs to be put separately, like ext4_put_super() does.
> > 
> > This addresses the syzbot report
> > "memory leak in kobject_set_name_vargs (3)"
> > (https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).
> > 
> > Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
> > Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
