Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E278F36A61D
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 11:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhDYJkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 05:40:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhDYJkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 05:40:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619343568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jFqYsc5HFttvC3yqjzTzG/Y0Uyoz4req0+7wzQFZgFY=;
        b=UpHX7u7x63btdAma6VwZ8lsqtTa1UgKoNdmq+1GI7Y9dYJ+7FRP+BgyOX4/GKcVBpjbqeE
        QudnminFbxJKo6a4kL/3HUj1HmVc+lcQp6G0XPvgBjvOn8Hx5FA24f6sECJgpPAyt07Z2V
        CzoOlYrp5vcWf5cpxRGRXe6I4hnZu1I=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-I0Z5LYYUPQWCGrsJyhgJtg-1; Sun, 25 Apr 2021 05:39:25 -0400
X-MC-Unique: I0Z5LYYUPQWCGrsJyhgJtg-1
Received: by mail-pl1-f198.google.com with SMTP id q12-20020a170902edccb02900e6b86717d2so22877913plk.18
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 02:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jFqYsc5HFttvC3yqjzTzG/Y0Uyoz4req0+7wzQFZgFY=;
        b=FcW30B1s/YHIFgIB+7ONQF6Cue1YpfqqQU/qYy812C45xHN/XdKFTuaisxk6dyITNE
         TxM60toO+7sEmvEyU7SwRFzxR24TueoftWGQn21ovguJ7/rYDLLyjikplqIzzdRcSoUC
         XcCM1E4KCs7iHn+k5eigsIoU/Ougnxlr1wOd+bVNj8yAB01R0xljtlHGXYeMJs8UKZzB
         LuRqrYQf2Nu5nTPY47cIHeUEU3m+AnmOmnfSQvBlRk6rkSONE2ij//1fJ+55C4b2CjS1
         HF8r2AmeG6DGbwTucJVXDXC0Cdb5HA85hapAyLnCS693IC5bRJ4u5NoQ7fgZV8ShFZ+v
         pZmA==
X-Gm-Message-State: AOAM530hIR0jtxOcpcqLRHNExsjT8oXSMVrJ6gYqT+Az1CP1JvtfP40N
        Tu4BVH+tSRzcbGmk0PpZqQu7C1dQNm1tnuF0q98Tm24nNMjmC8WAqBvRUq3PaEAAmNKno/UMi84
        3vg+Z8htCQ/HiQcC7
X-Received: by 2002:a17:90b:78d:: with SMTP id l13mr16149355pjz.182.1619343564384;
        Sun, 25 Apr 2021 02:39:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp0kyrDOqF9k4bIB2ZS3BtI9GzeJ4Vs4OzFDyQJkXrJqCdHzL0HKBYwqy/nCNlpac4RGuCFQ==
X-Received: by 2002:a17:90b:78d:: with SMTP id l13mr16149337pjz.182.1619343564085;
        Sun, 25 Apr 2021 02:39:24 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e6sm8476654pgh.17.2021.04.25.02.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 02:39:23 -0700 (PDT)
Date:   Sun, 25 Apr 2021 17:39:13 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, yuchao0@huawei.com
Subject: Re: FAILED: patch "[PATCH] erofs: fix extended inode could cross
 boundary" failed to apply to 4.19-stable tree
Message-ID: <20210425093913.GA3813581@xiangao.remote.csb>
References: <159766792693116@kroah.com>
 <20200818025546.GA6339@xiangao.remote.csb>
 <YIUtxiWzOjRzsDHm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YIUtxiWzOjRzsDHm@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Apr 25, 2021 at 10:52:22AM +0200, Greg KH wrote:
> On Tue, Aug 18, 2020 at 10:55:46AM +0800, Gao Xiang wrote:
> > On Mon, Aug 17, 2020 at 02:38:46PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 4.19-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > From 0dcd3c94e02438f4a571690e26f4ee997524102a Mon Sep 17 00:00:00 2001
> > > From: Gao Xiang <hsiangkao@redhat.com>
> > > Date: Thu, 30 Jul 2020 01:58:01 +0800
> > > Subject: [PATCH] erofs: fix extended inode could cross boundary
> > > 
> > > Each ondisk inode should be aligned with inode slot boundary
> > > (32-byte alignment) because of nid calculation formula, so all
> > > compact inodes (32 byte) cannot across page boundary. However,
> > > extended inode is now 64-byte form, which can across page boundary
> > > in principle if the location is specified on purpose, although
> > > it's hard to be generated by mkfs due to the allocation policy
> > > and rarely used by Android use case now mainly for > 4GiB files.
> > > 
> > > For now, only two fields `i_ctime_nsec` and `i_nlink' couldn't
> > > be read from disk properly and cause out-of-bound memory read
> > > with random value.
> > > 
> > > Let's fix now.
> > > 
> > > Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> > > Cc: <stable@vger.kernel.org> # 4.19+
> > > Link: https://lore.kernel.org/r/20200729175801.GA23973@xiangao.remote.csb
> > > Reviewed-by: Chao Yu <yuchao0@huawei.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Yeah, due to code difference, will manually backport this later...
> 
> What ever happened to this backport?  Did I miss it somewhere?

Thanks for your reminder, since the codebase was cleaned up and 4.19
codebase is somewhat different from the current codebase.

Sorry for forgeting it, and I will try to pick it up and send it out soon.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 

