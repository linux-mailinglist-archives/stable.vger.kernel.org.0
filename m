Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524D2631BD4
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 09:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiKUIsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 03:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKUIsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 03:48:36 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4C563EE;
        Mon, 21 Nov 2022 00:48:35 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id e11so5835322wru.8;
        Mon, 21 Nov 2022 00:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0xMSkrp2QCMbpWdX9ZXZNxy3sLf1xmTJq6HXuT+6fqY=;
        b=HcsEhi7TopMkZF1xL+/iZzqn1nWtEEoh+vQqmZSFPDN24LzzVw46vI0Jej7V+cGp4a
         ODMHsK8L7geAAIz+yRj+w0j6y4wryy/5leNYUIapwWbZ4cSXU3Z+N2akGBGdzp5y8d/I
         6cadOcDZ/Uq/rrPXcpcIWxXWtfv4Fzd/wjUN4kPqtLBMgBrys/WbZOjeZqqk1xFiYjo2
         zcikZJOWFJqgj3M85Hx0DSs8IvOZK6CaggjbUb0cAjc94fBBuFt5by3ST5v1VtQNZQnI
         ej5MNqEhnwYhanI6YNHoeKuBt/ysjo6kJxynSvUsymGkJgzQj/L9qcYrMRg9YFYlm8eN
         U8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0xMSkrp2QCMbpWdX9ZXZNxy3sLf1xmTJq6HXuT+6fqY=;
        b=vXlHonlFjAdA47VPgCTrqtTKJ+4y4+IyWrHByaqyi6uKzTax3d10FinBZtlnl7ef5r
         Mz3PG5DaVSvtwC91XRE2dhMIBQuUA/hiMgHu/KivndQpexcyEQkJHUOagG3zACkXLMKb
         ygdbkYAgv2miu/T5j/6MoW0CZvx1t/bwdEoj5LPMvpEncg//QqmeTrZPnUFSWSJ+4d+j
         905I1YH4XjC6BQyCnsoUCEM/x+o8qf2eWSoqcF6+pY/ARnBrpX4Sa/78PjaBx2Y4Kebt
         po/8xX0Jt7Z0Zk3kLr2zis2XqWkHVIeIdt/ggIY8sEuOgT8whaZV73EFkspw/j7zk4L1
         61Qg==
X-Gm-Message-State: ANoB5plF107T1RT6vn+37KtOYCcBjY14x2N9+mh/QDxglm9IFY/iQBDM
        cAX5bP0cH5Natq2PIQAWRk5t6zQOUzmw/29LZqF4rj8g
X-Google-Smtp-Source: AA0mqf7VxUnDzI1HPOPjBMz9bylTLSmANdy4gdhleGHwooCvFbBB91Rufzr67GaAWG47TA0FL5vonOh7EA0q/qLlBzw=
X-Received: by 2002:a5d:5684:0:b0:236:61bb:c79d with SMTP id
 f4-20020a5d5684000000b0023661bbc79dmr10082348wrv.632.1669020513969; Mon, 21
 Nov 2022 00:48:33 -0800 (PST)
MIME-Version: 1.0
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
 <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com>
 <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com> <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
 <35670b32-1337-04be-0269-f7f0f845833c@huawei.com>
In-Reply-To: <35670b32-1337-04be-0269-f7f0f845833c@huawei.com>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Mon, 21 Nov 2022 17:48:15 +0900
Message-ID: <CAKFNMokLfPLGZQetnXzf2Q4MWVtYOcdujdyYPBMsJgWoW2AMKA@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Nov 21, 2022 at 4:45 PM Chen Zhongjin wrote:
> On 2022/11/21 14:48, Ryusuke Konishi wrote:
> > On Mon, Nov 21, 2022 at 11:16 AM Chen Zhongjin wrote:
> >> Hi,
> >>
> >> On 2022/11/19 22:09, Ryusuke Konishi wrote:
> >>> On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
> >>>> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> >>>> nilfs_segment_usage is not set dirty, which makes it can be found by
> >>>> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> >>> The body of the patch looks OK, but this part of the commit log is a
> >>> bit misleading.
> >>> Could you please modify the expression so that we can understand this
> >>> patch fixes the issue when the disk image is corrupted and the leak
> >>> wasn't always there ?
> >> Makes sense. I'm going to fix the message as this:
> > Thank you for responding to my comment.
> >
> >> When extending segment, the current segment is allocated and set dirty
> >> by previous nilfs_sufile_alloc().
> >> But for some special cases such as corrupted image it can be unreliable,
> >> so nilfs_sufile_mark_dirty()
> >> is called to promise that current segment is dirty.
> > This sentence is a little different because nilfs_sufile_mark_dirty()
> > is originally called to dirty the buffer to include it as a part of
> > the log of nilfs ahead, where the completed usage data will be stored
> > later.
> >
> > And, unlike the dirty state of buffers and inodes, the dirty state of
> > segments is persistent and resides on disk until it's freed by
> > nilfs_sufile_free() unless it's destroyed on disk.
> >
> >> However, nilfs_sufile_mark_dirty() only sets buffer and inode dirty
> >> while nilfs_segment_usage can
> >> still be clean an used by following nilfs_sufile_alloc() because it
> >> checks nilfs_segment_usage_clean(su).
> >>
> >> This will cause the problem reported...
> > So, how about a description like this:
> >
> > When extending segments, nilfs_sufile_alloc() is called to get an
> > unassigned segment.
> > nilfs_sufile_alloc() then marks it as dirty to avoid accidentally
> > allocating the same segment in the future.
> > But for some special cases such as a corrupted image it can be unreliable.
> >
> > If such corruption of the dirty state of the segment occurs, nilfs2
> > may reallocate a segment that is in use and pick the same segment for
> > writing twice at the same time.
> > ...
> > This will cause the reported problem.
> > ...
> > Fix the problem by setting usage as dirty every time in
> > nilfs_sufile_mark_dirty() which is called for the current segment
> > before allocating additional segments during constructing segments to
> > be written out.
>
> Thanks for your explanation!
>
> I made some simplification, so everything looks like:
>
>
> When extending segments, nilfs_sufile_alloc() is called to get an
> unassigned segment, then mark it as dirty to avoid accidentally
> allocating the same segment in the future.
>
> But for some special cases such as a corrupted image it can be
> unreliable.
> If such corruption of the dirty state of the segment occurs, nilfs2 may
> reallocate a segment that is in use and pick the same segment for
> writing twice at the same time.
>
> This will cause the problem reported by syzkaller:
> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
>
> This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
> It supposed segment 4 has already been allocated and marked as dirty.
>
> However the dirty state was corrupted and segment 4 usage was not dirty.
> For the first time nilfs_segctor_extend_segments() segment 4 was
> allocated again, which made segbuf2 and next segbuf3 had same segment 4.
>
> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> added to both buffer lists of two segbuf. It makes the lists broken
> which causes NULL pointer dereference.
>
> Fix the problem by setting usage as dirty every time in
> nilfs_sufile_mark_dirty(), which is called during constructing current
> segment to be written out and before allocating next segment.
>

> Also add lock in it to protect the usage modification.

You don't have to say this because this lock is needed to complete
your modification and not the original.
If you want to mention it, how about saying like this:

Along with this change, this also adds a lock in it to protect the
usage modification.

> If it looks good, I'll sent the v3 patch for it.
>
> Best,
> Chen

I think the rest is OK as an overall description.

Thanks,
Ryusuke Konishi
