Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6DC2619C
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 12:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfEVKUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 06:20:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41717 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfEVKUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 06:20:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id q16so1548378ljj.8
        for <stable@vger.kernel.org>; Wed, 22 May 2019 03:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=I6Y5uva2ZOylkepfkW7JjoryC+I9mnJT08CLLH1/zB4=;
        b=zavVrEDe37Qme7JszDwtBit8a9goL7Xf7lo7dzYs9F/s32qJMMV7ciqBvmraiaXv0z
         1z3SGu/sXwQJ1PJmUaUHUlv2qKFBXe95+hZWV3jIDL13S66YAp9x3vdJ+Fn6BuT9VU8u
         NOBZwoAp6T7manfujvUuR9RbpVzziZD+GjSMxlsGQWytCUClTW4rehuBUJjupvskHUr5
         kkJC7rbA7qka6A7HM8y0PHco+9oNkv0LZrTNeFi/W/MkRmVZ39mK5bOW4nSVp1i03h5/
         0214MndB/t3uNnBA7L4B/uS6WoXe29jOMrI0wiGoFHJkTYyz2kReyg2TfKgbDZfWpW6q
         QOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=I6Y5uva2ZOylkepfkW7JjoryC+I9mnJT08CLLH1/zB4=;
        b=CMe5vQFR7+TvjblDeVjdqfec38uhpI+pzEBIJ/RiQLZhHyJkcbg3aeA3Xkgi10jtHr
         np0NBefkY1qplx7PgWSQ8pFktHdtG2uUMqIxHovwoEDpnGdiY5nUilWVv8iIDFQOapdy
         qb1NTelLgvdtN9OUpYWRxWcE13jDR5x0+e0TZ7AVQcr4duOsFNHSg45EJYQr3uKxyB+G
         TBXaX6JWv/zvPYcy9oDMljuxi8GnJs1IL0e6LFaxAtRB53somQeytw2s+Lf9VMl8Uywd
         3LEYONK+v8kceFWgbkMvakKLtUTBR5uSmf/aM7MVjcLsJwd1HyEHHgbB566Qb1k6gjMQ
         YF0Q==
X-Gm-Message-State: APjAAAUAhn6unon3AunImF9WYQQRzHDP4BKk/J6/3gHTZpJLtGire88f
        JQThTogtiGqHPFNBjTfscQ89e3g/BDgMAxEU/iJscg==
X-Google-Smtp-Source: APXvYqw2FkuDKjiOL0U5uxbmW7MBLTaBuIHCxmZceyZcoQRr1MyCfA1j64zoamAnH8hiGk5sO35Kb1+BFqH+Lu24ZA0=
X-Received: by 2002:a2e:7411:: with SMTP id p17mr2152330ljc.24.1558520448161;
 Wed, 22 May 2019 03:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115247.060821231@linuxfoundation.org> <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
 <20190521085956.GC31445@kroah.com> <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
 <20190521093849.GA9806@kroah.com> <CA+G9fYveeg_FMsL31aunJ2A9XLYk908Y1nSFw4kwkFk3h3uEiA@mail.gmail.com>
 <20190521162142.GA2591@mit.edu> <CA+G9fYunxonkqmkhz+zmZYuMTfyRMVBxn6PkTFfjd8tTT+bzHQ@mail.gmail.com>
 <20190522050511.GB4943@mit.edu>
In-Reply-To: <20190522050511.GB4943@mit.edu>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 May 2019 15:50:37 +0530
Message-ID: <CA+G9fYsA6BWh+W+U-9BSQWq63WZMKGXGbsh92LS94ZCempgm5A@mail.gmail.com>
Subject: Re: ext4 regression (was Re: [PATCH 4.19 000/105] 4.19.45-stable review)
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 May 2019 at 10:36, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Tue, May 21, 2019 at 11:27:21PM +0530, Naresh Kamboju wrote:
> > Steps to reproduce is,
> > running LTP three test cases in sequence on x86 device.
> > # cd ltp/runtest
> > # cat syscalls ( only three test case)
> > open12 open12
> > madvise06 madvise06
> > poll02 poll02
> > #
> >
> > as Dan referring to,
> >
> > LTP is run using '/opt/ltp/runltp -d /scratch -f syscalls', where the
> > syscalls file has been replaced with three test case names, and
> > /scratch is an ext4 SATA drive. /scratch is created using 'mkfs -t ext4
> > /dev/disk/by-id/ata-TOSHIBA_MG03ACA100_37O9KGKWF' and mounted to
> > /scratch.
>
> I'm still having trouble reproducing the problem.  I've followed the
> above exactly, and it doesn't trigger on my system.  I think I know
> what is happening, but even given my theory, I'm still not able to
> trigger it.  So, I'm not 100% sure this is the appropriate fix.  If
> you can reproduce it, can you see if this patch, applied on top of the
> Linus's tip, fixes the problem for you?

Applied your patch on mainline master branch and tested on x86_64 and
confirms that the reported problem fixed.

Thanks for your fix patch.

LTP syscalls full test output log,
https://lkft.validation.linaro.org/scheduler/job/739075

---
Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using
block_validity")
    Reported-by: Dan Rue <dan.rue@linaro.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2c62e2a0c98..d40ed940001e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -518,10 +518,14 @@ __read_extent_tree_block(const char *function,
unsigned int line,
        }
        if (buffer_verified(bh) && !(flags & EXT4_EX_FORCE_CACHE))
                return bh;
-       err = __ext4_ext_check(function, line, inode,
-                              ext_block_hdr(bh), depth, pblk);
-       if (err)
-               goto errout;
+       if (!ext4_has_feature_journal(inode->i_sb) ||
+           (inode->i_ino !=
+            le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum))) {
+               err = __ext4_ext_check(function, line, inode,
+                                      ext_block_hdr(bh), depth, pblk);
+               if (err)
+                       goto errout;
+       }
        set_buffer_verified(bh);
        /*
         * If this is a leaf block, cache all of its entries


- Naresh
