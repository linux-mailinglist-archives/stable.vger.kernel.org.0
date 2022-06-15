Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A0854C563
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 12:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345694AbiFOKEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 06:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347207AbiFOKEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 06:04:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA473BBF9;
        Wed, 15 Jun 2022 03:04:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 060A31F8AA;
        Wed, 15 Jun 2022 10:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655287479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBBtOz7K9YiymUBEHKlogoH1FpxY6bRraUxdMFY2N0c=;
        b=If4+KDuyGJu6SvM4LbZs1XQBCpPWPa2oAQf8dXy1jPIccOYPsl2PlLFgfHXVX28p3jqFfx
        uHO2QEqgthieowR8BKU9w4RjGknoREGp39LjK0cW00OxWxXs26/RIdq3YxiGdFLe4Xvn5T
        fwqhgZ3bOVmLdoXWqkMtNXEDb+VJSBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655287479;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBBtOz7K9YiymUBEHKlogoH1FpxY6bRraUxdMFY2N0c=;
        b=E4D+smZTgJuutRiSSDt+Et9RgerzFxvY90ADS4ZJNe8UmyrvtISuN7HiZrvSZMF/oI6z4+
        g6gbbU6U2+ouvlBQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8616B2C141;
        Wed, 15 Jun 2022 10:04:38 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B8BF9A062E; Wed, 15 Jun 2022 12:04:32 +0200 (CEST)
Date:   Wed, 15 Jun 2022 12:04:32 +0200
From:   Jan Kara <jack@suse.cz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, Jan Kara <jack@suse.cz>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220615100432.gd7jeeyjk3qyayyi@quack3.lan>
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
 <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 14-06-22 11:51:35, Linus Torvalds wrote:
> On Tue, Jun 14, 2022 at 11:20 AM Thomas Backlund <tmb@tmb.nu> wrote:
> >
> > I "think" this is the suggested fix:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git/commit/?h=for_next&id=46b6418e26c7c26f98ff9c2c2310bce5ae2aa4dd
> 
> Ugh, this is just too ugly for words.
> 
> That's not a fix. That's a "hide the problem" patch.

I agree it is papering over the real problem. I consider that a stopgap
solution so that machines can boot until we find a cleaner solution.

> Now, admittedly clearly the "hide the problem" code already existed,
> and was just moved earlier, but I really think this whole "we're
> calling __mark_inode_dirty() on an inode that isn't even *initialized*
> yet" is a much deeper issue, and shouldn't have some hacky work-around
> in __mark_inode_dirty() that just happens to make it work.
> 
> I don't mind that patch per se - moving the code is fine.
> 
> But I *do* mind the patch when the reason is to hide that wrong
> ordering of operations.
> 
> Now, maybe a proper fix might be to say that new_inode_pseudo() should
> always initialize i_state to I_DIRTY_ALL or something like that. The
> comment already says that they cannot participate in writeback, so
> maybe they should be disabled that way (ie a pseudo inode is always
> dirty and marking it dirty does nothing).

Sadly it is not so simple. Firstly, new_inode_pseudo() gets used for all
inodes (through new_inode()), secondly, tmpfs allocates fully standard
inodes through new_inode() as any other filesystem. We could check
writeback capabilities of the sb->s_bdi in new_inode_pseudo() but that
would not work for inodes that will become block device inodes because
blockdev_superblock has noop_backing_dev_info so we'd have to specialcase
that. Overall it looks a bit hairy to my taste.

> And then you get rid of the noop_backing_dev_info entirely.

And this would be even more difficult because there are other places that
expect there's *some* bdi associated with each sb.

> Or just make sure that noop_backing_dev_info is fully initialized
> before it's used.
> 
> Because I think the real problem here is that things have a pointer to
> an uninitialized backing_dev_info.

I fully agree with this. IMHO we need to initialize noop_backing_dev_info
earlier but early init is not exactly my comfort zone so I have to verify
whether various stuff in cgwb_bdi_init() is safe to call so early...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
