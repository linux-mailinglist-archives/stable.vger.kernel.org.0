Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D1BE19C1
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389248AbfJWMQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:16:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51610 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730796AbfJWMQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 08:16:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id q70so13804830wme.1;
        Wed, 23 Oct 2019 05:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CVMZIlFOmsUq+Vskr+tW0iGHn90ty7G6Hxjpnt8OG8M=;
        b=ojnE0DcvbLt/j4uUZPeFzmfKmga2rO8E+9NXFcWrlKCvPSGUgr/vQUU+szzDg1mDA+
         v5NhCBILtyORwkN20a+IzCYLSo0bhiFsahfEB5sOikH758RLyZdDpnK4LsnhdngGsI7Q
         jq3Z7lDpcyKYLQ6He4l2vT2rSbdmO3/R74AlnQvfKurtejnhO9FBxTBItXeVcM92zZvB
         dl56umDy9DdZX68gLVthIzBQFJEeG9E3tmamcBX6IiC6Dg7isKf9s1Rb17K7BNQa2tI9
         VHYNAv7l98J09PaL6TE344tTiLdPL3w/vbngEYCQSU2/6Zhi4FwLQwR9oCw1x9zOTmTg
         EPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CVMZIlFOmsUq+Vskr+tW0iGHn90ty7G6Hxjpnt8OG8M=;
        b=oe/Kib51tvoG5skXGBDRuLLGSIFTSB+2fttQgBbjEWxH4haKTvDj2TCO+li+jNl6tK
         2VFs3HdcufEGdT9/ZVJkkrOSDtj/wCXYiB7IUBOsXu+WKcSNQa9ZaZ61iRr1aRb2A+dc
         p0mqMROwdr2LTCo92YT+X1ST3pOprkmenKiupvbPIskpdCHbJ1LVBEt6DhxcfWqmvFgR
         7PiaCoUuZZU5xq+SZ2m8D1EQkke33eXdj15eeyU4wEJ4Wo4L3C0ix+Etuc+wMI7bJSjD
         sQcoo4wsT5rvfLrRgfbQKK7gjZOarHeMFQxFupRykW1AcAdarxVHlhYeJTWIe/FrzZHT
         Kkzg==
X-Gm-Message-State: APjAAAW0Ps5WABEvoAA7IvR2VokWQ+PssuOL5gXpm0VzxlMCduD46usO
        s0ueEPugLp42N6XP2CDeiXCO8GBZvTU=
X-Google-Smtp-Source: APXvYqyPu5nM/9wohUAJp6nNJluOH/TU3xDM7gzETkX6nv5t8ka6YdF9i5MOGNXaVmNYHrsl/qf8Hw==
X-Received: by 2002:a1c:6405:: with SMTP id y5mr3559550wmb.175.1571832970440;
        Wed, 23 Oct 2019 05:16:10 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1012:517c:6bd4:d9e0:aab5])
        by smtp.gmail.com with ESMTPSA id a189sm7930047wma.2.2019.10.23.05.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:16:09 -0700 (PDT)
Date:   Wed, 23 Oct 2019 14:16:03 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        bsingharora@gmail.com, dvyukov@google.com, elver@google.com,
        stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021113327.22365-1-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 01:33:27PM +0200, Christian Brauner wrote:
> When assiging and testing taskstats in taskstats_exit() there's a race
> when writing and reading sig->stats when a thread-group with more than
> one thread exits:
> 
> cpu0:
> thread catches fatal signal and whole thread-group gets taken down
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The tasks reads sig->stats without holding sighand lock.
> 
> cpu1:
> task calls exit_group()
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The task takes sighand lock and assigns new stats to sig->stats.
> 
> The first approach used smp_load_acquire() and smp_store_release().
> However, after having discussed this it seems that the data dependency
> for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> Furthermore, the smp_load_acquire() would only manage to order the stats
> check before the thread_group_empty() check. So it seems just using
> READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> up for discussion at least.

Mmh, the RELEASE was intended to order the memory initialization in
kmem_cache_zalloc() with the later ->stats pointer assignment; AFAICT,
there is no data dependency between such memory accesses.

Correspondingly, the ACQUIRE was intended to order the ->stats pointer
load with later, _independent dereferences of the same pointer; the
latter are, e.g., in taskstats_exit() (but not thread_group_empty()).

Looking again, I see that fill_tgid_exit()'s dereferences of ->stats
are protected by ->siglock: maybe you meant to rely on such a critical
section pairing with the critical section in taskstats_tgid_alloc()?

That memcpy(-, tsk->signal->stats, -) at the end of taskstats_exit()
also bugs me: could these dereferences of ->stats happen concurrently
with other stores to the same memory locations?

Thanks,
  Andrea
