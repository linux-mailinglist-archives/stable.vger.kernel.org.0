Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AE5311F6C
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 19:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhBFSuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 13:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhBFSuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 13:50:09 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA77C06174A;
        Sat,  6 Feb 2021 10:49:29 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id f26so182488oog.5;
        Sat, 06 Feb 2021 10:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m+gVT0idsq8zz7Je1jz/ZqC1FkpV+UmjQ/XmteqQxxc=;
        b=XnZwLNuXqpgzh+XM5mPY3158jgMzvDh1zPBUquZQxTBwwov8jjxv9mPEzHSHXQyuZy
         DhMFsPlXqjihA23U+nlcEH6H1kK9gI0+Ak14WZ/JwI0JWwJSghJIircQaEvZDY2ah4/y
         chY8rhf0+X2CF38pMKKARiF+iXhZnOQkR/9FrlpTjVTOoafZQhl5eaKjtCGmc9b6otgU
         g5jDJcm33/DCkXRgJuk9QMNsIExaZo2z9O5q0t8jjHS/ki8Xg/kjbUszWEfARbKl95Wb
         PzITOIeS4H2SMkyqyccsXVWNT/kdJHqD0fUuZX9u6STKPITAY1sa1d0IZzRE70/V/UYu
         wIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=m+gVT0idsq8zz7Je1jz/ZqC1FkpV+UmjQ/XmteqQxxc=;
        b=gIrz4cjentuMtKQJVZ0XZRMwAEgFM1OmRdd0qqTR7CmKQaQBOnD0eUDuSTxWH5MTOU
         vNZzM7eZqAWli4Z5oiKSOO50KbtjT0y1z//O8jhD2+iU5Qo4CHeuFsQBpbL9/3kuQrHW
         2LL3eEbMcrtgAirCdXPfjksz6bK/kumYNKAws11S36y8r1vQVYBWMsmbt0oqc+ppS3bf
         W2JHV7glhMfREYZcgYo3uYBviMlbaQ8WIoRwSb1YinbR5otS+i669LJ8astGRSHjE9C2
         QqKTi/OAz0MUREObbqCRpZdx5c/6t0PTVkG5QfFeMDmBTbIuHTnKV4JdNvakLiFyeyaR
         gUzQ==
X-Gm-Message-State: AOAM531Nr5OndhRQovic4y8uM/sacbrDjSmdtbUJMY8yXLXjDqzS+6Zi
        XMqKeTL/+A2qNymJRh2Bh99nvhycpr0=
X-Google-Smtp-Source: ABdhPJwVsmzjz/c7LwYpOuxizi7I63zvRsqPgRd7+PT9/zkdN6qL9wSR0chtmvunQv7Ay392xun9iw==
X-Received: by 2002:a4a:c896:: with SMTP id t22mr7615971ooq.8.1612637368815;
        Sat, 06 Feb 2021 10:49:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y10sm259475otq.71.2021.02.06.10.49.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 10:49:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Feb 2021 10:49:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <20210206184926.GA19587@roeck-us.net>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu>
 <20210206132239.GC7312@1wt.eu>
 <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
 <YB7cU7SCyBOHFJGS@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YB7cU7SCyBOHFJGS@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 06, 2021 at 07:13:39PM +0100, Greg Kroah-Hartman wrote:
> On Sat, Feb 06, 2021 at 08:59:42AM -0800, Guenter Roeck wrote:
> > On 2/6/21 5:22 AM, Willy Tarreau wrote:
> > > On Sat, Feb 06, 2021 at 02:11:13PM +0100, Willy Tarreau wrote:
> > >> Something like this looks more robust to me, it will use SUBLEVEL for
> > >> values 0 to 255 and 255 for any larger value:
> > >>
> > >> -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> > >> +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* (0$(SUBLEVEL) > 255) + 0$(SUBLEVEL) * (0$(SUBLEVEL \<= 255)); \
> > > 
> > > Bah, I obviously missed a backslash above and forgot spaces around parens.
> > > Here's a tested version:
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 7d86ad6ad36c..9b91b8815b40 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1252,7 +1252,7 @@ endef
> > >  
> > >  define filechk_version.h
> > >  	echo \#define LINUX_VERSION_CODE $(shell                         \
> > > -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> > > +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* \( 0$(SUBLEVEL) \> 255 \) + 0$(SUBLEVEL) \* \( 0$(SUBLEVEL) \<= 255 \) ); \
> > >  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
> > >  endef
> > >  
> > 
> > I like that version.
> 
> See the patch that Sasha queued up already, it just fixes it at 255 for
> now, and we will update with what is in Linus's tree like the above when
> that gets merged in 5.12-rc1.
> 
> > Two questions: Are there any concerns that KERNEL_VERSION(4, 4, 256)
> > matches KERNEL_VERSION(4, 5. 0),
> 
> As that "release" did nothing, no, I'm not too worried about it, are
> you?
> 
There are lots (35) of "KERNEL_VERSION(4, 5, 0)" in chromeos-4.4.
That should not matter with the clamped LINUX_VERSION_CODE, but
I'd prefer to clamp KERNEL_VERSION as well just to be sure. On
top of that, some of the vendor code we carry along does check
SUBVERSION, but that is probably more of an academic concern.

> > and do you plan to send this patch upstream ?
> 
> See the series sent upstream here: https://lore.kernel.org/r/20210206035033.2036180-1-sashal@kernel.org
> 
I backported the relevant patch into chromeos-4.4, so we should
be fine.

Thanks!
Guenter
