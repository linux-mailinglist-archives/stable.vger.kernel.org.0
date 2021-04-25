Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E197536A685
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 12:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhDYKOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 06:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhDYKOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 06:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619345651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jrR1DLTcjPB8KVXqL6GuRHQU6CQs1iijDnho+Pvr7QI=;
        b=LCFP0A1U4mD0K27dG2P0Ds7lcnXn/U0J/SN/rh0wYg20DAfudmBoXjF1BJDEDZeRJR/odO
        CwiwXueikp6C6Isb/0fWTVge+9/irUMwdXzGVsRtRGLbU3A3RWByksm1M/E2ANTOW1wP6V
        iazxan1Br+zmgQkJyXb5seG2gdRhr5s=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-i9-b-G31NbCn1KmFVEFT3Q-1; Sun, 25 Apr 2021 06:14:10 -0400
X-MC-Unique: i9-b-G31NbCn1KmFVEFT3Q-1
Received: by mail-pj1-f70.google.com with SMTP id a18-20020a17090a4812b02900fc63fabd38so4886740pjh.0
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 03:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jrR1DLTcjPB8KVXqL6GuRHQU6CQs1iijDnho+Pvr7QI=;
        b=q0s3vUakEntYLbNH6sDuuy4fBdoT78lJQ65yuLzc4cr6ai0FYQPn1RHhIEyF/4pCNa
         eqdc1LhEIDb5tXmUuwCrCZzTMzwjEzc5l0Xu0mvs2hGcb5/vjtLWl4NSo+q6digs8O0f
         8T+9fXF+gUHpMhE92iRkeFgdM99D3BRhwpcHcS0M9Km5hDTC854cLlFaxn7hCGcEHjuu
         U3eOtgIu/UBg2l8ioi6CC6CoVGXHAc/ICrl2cc6t4df5GwL3PRnNsxsE48th2oJW/RyN
         4IO+kDal5Wwsh1TnJlkpiWJElCAkXLYBdOPlTfT3N4FiC1WFqvwrsnmBo7kUWjcfxHjI
         EaPg==
X-Gm-Message-State: AOAM531JAIDPrF61ZdxRs/NzJakG+0gMQzofi9q042YWfYnZynSBmycT
        FaTuyMFh8N6i/JK3pvbjln+8d+ShW4HGsm3KOS7jIYrK3Ef9dj8LS2jSbdbKpPYDKMj8Nk8Eqc9
        mQCZnI/PEumt4yoSb
X-Received: by 2002:aa7:88c5:0:b029:24e:8807:e4f1 with SMTP id k5-20020aa788c50000b029024e8807e4f1mr12122776pff.9.1619345648956;
        Sun, 25 Apr 2021 03:14:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfGyjyKmFivTnXxagbV/OwC0xpjCI/o8Sp7Q9BoV+Z2Ddwrf0b7cPbEnYisdqCt5gwqt0REg==
X-Received: by 2002:aa7:88c5:0:b029:24e:8807:e4f1 with SMTP id k5-20020aa788c50000b029024e8807e4f1mr12122763pff.9.1619345648704;
        Sun, 25 Apr 2021 03:14:08 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22sm9088685pgx.19.2021.04.25.03.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 03:14:08 -0700 (PDT)
Date:   Sun, 25 Apr 2021 18:13:57 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, yuchao0@huawei.com
Subject: Re: FAILED: patch "[PATCH] erofs: fix extended inode could cross
 boundary" failed to apply to 4.19-stable tree
Message-ID: <20210425101357.GB3813581@xiangao.remote.csb>
References: <159766792693116@kroah.com>
 <20200818025546.GA6339@xiangao.remote.csb>
 <YIUtxiWzOjRzsDHm@kroah.com>
 <20210425093913.GA3813581@xiangao.remote.csb>
 <YIU7vZSdsH7L55wD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YIU7vZSdsH7L55wD@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 25, 2021 at 11:51:57AM +0200, Greg KH wrote:
> On Sun, Apr 25, 2021 at 05:39:13PM +0800, Gao Xiang wrote:
> > Hi Greg,
> > 
> > On Sun, Apr 25, 2021 at 10:52:22AM +0200, Greg KH wrote:
> > > On Tue, Aug 18, 2020 at 10:55:46AM +0800, Gao Xiang wrote:
> > > > On Mon, Aug 17, 2020 at 02:38:46PM +0200, gregkh@linuxfoundation.org wrote:
> > > > > 
> > > > > The patch below does not apply to the 4.19-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > > 
> > > > > ------------------ original commit in Linus's tree ------------------
> > > > > 
> > > > > From 0dcd3c94e02438f4a571690e26f4ee997524102a Mon Sep 17 00:00:00 2001
> > > > > From: Gao Xiang <hsiangkao@redhat.com>
> > > > > Date: Thu, 30 Jul 2020 01:58:01 +0800
> > > > > Subject: [PATCH] erofs: fix extended inode could cross boundary
> > > > > 
> > > > > Each ondisk inode should be aligned with inode slot boundary
> > > > > (32-byte alignment) because of nid calculation formula, so all
> > > > > compact inodes (32 byte) cannot across page boundary. However,
> > > > > extended inode is now 64-byte form, which can across page boundary
> > > > > in principle if the location is specified on purpose, although
> > > > > it's hard to be generated by mkfs due to the allocation policy
> > > > > and rarely used by Android use case now mainly for > 4GiB files.
> > > > > 
> > > > > For now, only two fields `i_ctime_nsec` and `i_nlink' couldn't
> > > > > be read from disk properly and cause out-of-bound memory read
> > > > > with random value.
> > > > > 
> > > > > Let's fix now.
> > > > > 
> > > > > Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> > > > > Cc: <stable@vger.kernel.org> # 4.19+
> > > > > Link: https://lore.kernel.org/r/20200729175801.GA23973@xiangao.remote.csb
> > > > > Reviewed-by: Chao Yu <yuchao0@huawei.com>
> > > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > 
> > > > Yeah, due to code difference, will manually backport this later...
> > > 
> > > What ever happened to this backport?  Did I miss it somewhere?
> > 
> > Thanks for your reminder, since the codebase was cleaned up and 4.19
> > codebase is somewhat different from the current codebase.
> > 
> > Sorry for forgeting it, and I will try to pick it up and send it out soon.
> 
> No worries, just ran across this and wanted to make sure that I didn't
> drop it on my end somewhere.

Nope, that was my fault. :)

Due to 4.19 erofs staging version was quite an early version (1st upstreaming
version), more non-trivial conflicts occur in this patch. But it needs to be
fixed with careness if users would like to use 4.19 staging erofs and use
extended inode. I'm addressing this now.

Yet, I've suggested all Android vendors / users use 5.4+ LTS fs/erofs versions,
since in-place decompression has been supported since linux 5.3 which is great
for performance. And the 5.4 erofs codebase is already shipped for many other
SoC vendors with their in-market products.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 

