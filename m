Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A955213C67C
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 15:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAOOsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 09:48:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58024 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgAOOsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 09:48:45 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irjyB-008qVP-Ak; Wed, 15 Jan 2020 14:48:31 +0000
Date:   Wed, 15 Jan 2020 14:48:31 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200115144831.GJ8904@ZenIV.linux.org.uk>
References: <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
 <20200114045733.GW8904@ZenIV.linux.org.uk>
 <20200114200150.ryld4npoblns2ybe@yavin>
 <20200115142517.GI8904@ZenIV.linux.org.uk>
 <20200115142906.saagd2lse7i7njux@yavin>
 <20200115143459.l4wurqyetkmptsdm@yavin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115143459.l4wurqyetkmptsdm@yavin>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 01:34:59AM +1100, Aleksa Sarai wrote:
> On 2020-01-16, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > On 2020-01-15, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > On Wed, Jan 15, 2020 at 07:01:50AM +1100, Aleksa Sarai wrote:
> > > 
> > > > Yes, there were two patches I sent a while ago[1]. I can re-send them if
> > > > you like. The second patch switches open_how->mode to a u64, but I'm
> > > > still on the fence about whether that makes sense to do...
> > > 
> > > IMO plain __u64 is better than games with __aligned_u64 - all sizes are
> > > fixed, so...
> > > 
> > > > [1]: https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar@cyphar.com/
> > > 
> > > Do you want that series folded into "open: introduce openat2(2) syscall"
> > > and "selftests: add openat2(2) selftests" or would you rather have them
> > > appended at the end of the series.  Personally I'd go for "fold them in"
> > > if it had been about my code, but it's really up to you.
> > 
> > "fold them in" would probably be better to avoid making the mainline
> > history confusing afterwards. Thanks.
> 
> Also (if you prefer) I can send a v3 which uses u64s rather than
> aligned_u64s.

<mode "lazy bastard">
Could you fold and resend the results of folding (i.e. replacements
for two commits in question)?
</mode>

The hard part is, of course, in updating commit messages ;-)
