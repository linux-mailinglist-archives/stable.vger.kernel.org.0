Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3214036A6D0
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 12:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhDYK42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 06:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhDYK42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 06:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619348148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=633RqSMXm0fhVUQVWvUmIR+gN/VObYfRd1P/Bwm3gOw=;
        b=aMQUXGgiCuKA4XBjua9TM4vhWeBr6hHVqkqAFq8CqXiBoA5zpR9UGY6kSPL8BIUxjqE3y2
        8jDSN/UKn4rG8a0EX5XzZpeTzuWByKupwbm0FckzOkp79VAWeE8iHIHX4SgduTELCRbBpz
        2eym97AjsjuOrX4CSyAHyfXRUJyiP4k=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-6XDTJKB0M46BYDbfnVAl2A-1; Sun, 25 Apr 2021 06:55:46 -0400
X-MC-Unique: 6XDTJKB0M46BYDbfnVAl2A-1
Received: by mail-pf1-f200.google.com with SMTP id i188-20020a62c1c50000b0290261337d9ebfso12117612pfg.12
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 03:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=633RqSMXm0fhVUQVWvUmIR+gN/VObYfRd1P/Bwm3gOw=;
        b=Vcb2U0rya3hfEUliUqmoGa9KMNbtcsDSTpdlWafQNBDUVwH5yrctUY06kVDuHU4UH1
         PbxkpZlpZ5rB+pxLe/4IoRclZiVoWGgBIAiEf5hJ1UQOPFfFFZy18fWeYuCQUZacASG4
         Y96PHPycqBk+suaLkrJih0CBQrMKzFnPwrz93H3uGkogL0hERt0q6D/RX8bJnb8u5Qd1
         DbO/qtvZ849fOKgYwedVmIHLqVEGT4C+ZAQ6/lghrF3ERRiUQheAiyRs8+zIOvLWmzG1
         B3kWwHWnZbH4N6kBrMMBlyglTeYW4WtTpmZYBD/78cdn98nGeFek0h9c+VZx0plUNofM
         Z89g==
X-Gm-Message-State: AOAM5302LEHh5SdKJdmWXCIXGiPQhuSANn1oZhWEnGPMh+uyTePpTkdJ
        M+54RvmuTXhm2aSRtQFuZofTZZoJPN1JXQz4hzkSveDIvGeJDJDWl7quaC2sWGSNcDh3+aoZpNN
        1BEH19aqZz/oVH5oR
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr15911991pjp.232.1619348145281;
        Sun, 25 Apr 2021 03:55:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/Qk64jLqOgVxPqNBejK5n3djDdq/8D5dqCLsbXeV9JcqPWT2hM7G9UHD/6yTCvdFthXYHtQ==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr15911976pjp.232.1619348145021;
        Sun, 25 Apr 2021 03:55:45 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i63sm8855482pfg.112.2021.04.25.03.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 03:55:44 -0700 (PDT)
Date:   Sun, 25 Apr 2021 18:55:34 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, yuchao0@huawei.com
Subject: Re: FAILED: patch "[PATCH] erofs: fix extended inode could cross
 boundary" failed to apply to 4.19-stable tree
Message-ID: <20210425105534.GA3824039@xiangao.remote.csb>
References: <159766792693116@kroah.com>
 <20200818025546.GA6339@xiangao.remote.csb>
 <YIUtxiWzOjRzsDHm@kroah.com>
 <20210425093913.GA3813581@xiangao.remote.csb>
 <YIU7vZSdsH7L55wD@kroah.com>
 <20210425101357.GB3813581@xiangao.remote.csb>
 <YIVHXmitglDYJmKi@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YIVHXmitglDYJmKi@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 25, 2021 at 12:41:34PM +0200, Greg KH wrote:
> On Sun, Apr 25, 2021 at 06:13:57PM +0800, Gao Xiang wrote:
> > On Sun, Apr 25, 2021 at 11:51:57AM +0200, Greg KH wrote:
> > > On Sun, Apr 25, 2021 at 05:39:13PM +0800, Gao Xiang wrote:
> > > > Hi Greg,
> > > > 
> > > > On Sun, Apr 25, 2021 at 10:52:22AM +0200, Greg KH wrote:
> > > > > On Tue, Aug 18, 2020 at 10:55:46AM +0800, Gao Xiang wrote:
> > > > > > On Mon, Aug 17, 2020 at 02:38:46PM +0200, gregkh@linuxfoundation.org wrote:
> > > > > > > 
> > > > > > > The patch below does not apply to the 4.19-stable tree.
> > > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > > tree, then please email the backport, including the original git commit
> > > > > > > id to <stable@vger.kernel.org>.
> > > > > > > 
> > > > > > > thanks,
> > > > > > > 
> > > > > > > greg k-h
> > > > > > > 
> > > > > > > ------------------ original commit in Linus's tree ------------------
> > > > > > > 
> > > > > > > From 0dcd3c94e02438f4a571690e26f4ee997524102a Mon Sep 17 00:00:00 2001
> > > > > > > From: Gao Xiang <hsiangkao@redhat.com>
> > > > > > > Date: Thu, 30 Jul 2020 01:58:01 +0800
> > > > > > > Subject: [PATCH] erofs: fix extended inode could cross boundary
> > > > > > > 
> > > > > > > Each ondisk inode should be aligned with inode slot boundary
> > > > > > > (32-byte alignment) because of nid calculation formula, so all
> > > > > > > compact inodes (32 byte) cannot across page boundary. However,
> > > > > > > extended inode is now 64-byte form, which can across page boundary
> > > > > > > in principle if the location is specified on purpose, although
> > > > > > > it's hard to be generated by mkfs due to the allocation policy
> > > > > > > and rarely used by Android use case now mainly for > 4GiB files.
> > > > > > > 
> > > > > > > For now, only two fields `i_ctime_nsec` and `i_nlink' couldn't
> > > > > > > be read from disk properly and cause out-of-bound memory read
> > > > > > > with random value.
> > > > > > > 
> > > > > > > Let's fix now.
> > > > > > > 
> > > > > > > Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> > > > > > > Cc: <stable@vger.kernel.org> # 4.19+
> > > > > > > Link: https://lore.kernel.org/r/20200729175801.GA23973@xiangao.remote.csb
> > > > > > > Reviewed-by: Chao Yu <yuchao0@huawei.com>
> > > > > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > > > 
> > > > > > Yeah, due to code difference, will manually backport this later...
> > > > > 
> > > > > What ever happened to this backport?  Did I miss it somewhere?
> > > > 
> > > > Thanks for your reminder, since the codebase was cleaned up and 4.19
> > > > codebase is somewhat different from the current codebase.
> > > > 
> > > > Sorry for forgeting it, and I will try to pick it up and send it out soon.
> > > 
> > > No worries, just ran across this and wanted to make sure that I didn't
> > > drop it on my end somewhere.
> > 
> > Nope, that was my fault. :)
> > 
> > Due to 4.19 erofs staging version was quite an early version (1st upstreaming
> > version), more non-trivial conflicts occur in this patch. But it needs to be
> > fixed with careness if users would like to use 4.19 staging erofs and use
> > extended inode. I'm addressing this now.
> > 
> > Yet, I've suggested all Android vendors / users use 5.4+ LTS fs/erofs versions,
> > since in-place decompression has been supported since linux 5.3 which is great
> > for performance. And the 5.4 erofs codebase is already shipped for many other
> > SoC vendors with their in-market products.
> 
> I too would recommend that anyone using erofs use a newer version, but
> for those stuck on older kernels like 4.19, they don't seem to be able
> to want to do that.
> 
> Should we just mark the filesystem as "BROKEN" on the stable 4.19 tree
> to prevent anyone from using it there?  That feels drastic, but it's
> your call what would work best here.

4.19 staging erofs version is also workable with old mkfs (but lack of some
basic performance features compared with other actual in-market instances),
but I'm also saying "yes", it should be better to use Linux 5.4/5.10 LTS or
later codebase directly (or backporting such codebase to 4.19/4.14 manually
rather than directly use 4.19 in-tree staging erofs.)

I agree marking 4.19 staging erofs "BROKEN" may be a better choice here
and suggest them using 5.4/5.10 codebase instead if needed. But I'll still
mark stable patches for 4.19 in case of users using it (Also I will still
go on trying to backport this patch.)

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 

