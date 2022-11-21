Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A807C631C58
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKUJGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKUJGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:06:38 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F27131346;
        Mon, 21 Nov 2022 01:06:37 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v7so7995182wmn.0;
        Mon, 21 Nov 2022 01:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/g7tdUKpMLQr11oIOFeI44OcDD56VSJn5Rj01iy3iwY=;
        b=kaxrmS+jV349NXio1VBR/t2aJ33uIid0NxZP6rvhA60YD50a6uGWxBuhKE7XunwhgF
         5rGXDzQlwSbyb+HOuyPDF6K0/U6BcpBpXbJrSwy+jqognXWlf4yDS+TLiMSMbX7d5h+U
         N6QyfeNkyTG9g92YX15QSX7hSKO9WvapaTu753yQN6cbCNGAr9Pycu6kfIlKANPEjyNt
         IOToqpAdeaB5wftQRMcY9m9pAwbOWt+lLVbpcYkbvzyPOXlQ0Bl3b5JlNwLBpZ2OQYnj
         XvasldYzHx3rQGkIztnAMOObeYoncFLeNFTcPtLvB2+FxuMGO5D0Ab94RPTDC944sZxR
         2G0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/g7tdUKpMLQr11oIOFeI44OcDD56VSJn5Rj01iy3iwY=;
        b=lJYWFhtnwgSTFY6fFq5sR5yxdeluGF3/VxGnV1F3W7Y6abdHiNYnG3xjlWTwY2Fj1C
         aAioE68obDZB8LLSuIgmhGZAhbtA54HGmarcFIAoS7JjlpIvYN0myuFOI1iqKd3llCvf
         qR6SO6GN9/tL5mZPPrBforzqsm9I/hu0XEI/6MfVphdZmpp9ZIm/8thuR09HT9OlvIWm
         H6ngePcwoILt7jMNfyRR5robjgSheSapSb8EZvyuL6eORI9Aa1JghUuM4h66vXsY/u0l
         P1Yojhlh8bTgN+aJslp/Hm1QJhnFDgH9QCTSq5HRFLbcLLkvqSVpiHIlpAPxLtvnp9LL
         xmgQ==
X-Gm-Message-State: ANoB5pkm7eguHRGPKuWGodKZSK1RazZcjJymy6Dby5FC9v00ijra17cj
        loEx9IA5SgjhhTeeRw7NXg7zfIm3tGwaBQYdLWkDR8KU
X-Google-Smtp-Source: AA0mqf5+mc7GUhFtLfAFvnwgvMmVYb5Gy49x+6lhWzsLJFJjm1fiXEBjR1fvZSwUeWPclXZ3ED4vr+WMpmdfGPtjTKw=
X-Received: by 2002:a7b:cb83:0:b0:3cf:96da:3846 with SMTP id
 m3-20020a7bcb83000000b003cf96da3846mr14827224wmi.10.1669021595181; Mon, 21
 Nov 2022 01:06:35 -0800 (PST)
MIME-Version: 1.0
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
 <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com>
 <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com> <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
 <35670b32-1337-04be-0269-f7f0f845833c@huawei.com> <CAKFNMokLfPLGZQetnXzf2Q4MWVtYOcdujdyYPBMsJgWoW2AMKA@mail.gmail.com>
In-Reply-To: <CAKFNMokLfPLGZQetnXzf2Q4MWVtYOcdujdyYPBMsJgWoW2AMKA@mail.gmail.com>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Mon, 21 Nov 2022 18:06:17 +0900
Message-ID: <CAKFNMo=ccYHUq5J10QR7-_JD9T634FV23QgMzeJ1m6NWRC4b9Q@mail.gmail.com>
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

On Mon, Nov 21, 2022 at 5:48 PM Ryusuke Konishi wrote:
>
> Hi,
>
> On Mon, Nov 21, 2022 at 4:45 PM Chen Zhongjin wrote:
> > On 2022/11/21 14:48, Ryusuke Konishi wrote:
> > > On Mon, Nov 21, 2022 at 11:16 AM Chen Zhongjin wrote:
> > >> Hi,
> > >>
> > >> On 2022/11/19 22:09, Ryusuke Konishi wrote:
> > >>> On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
> > >>>> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> > >>>> nilfs_segment_usage is not set dirty, which makes it can be found by
> > >>>> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> > >>> The body of the patch looks OK, but this part of the commit log is a
> > >>> bit misleading.
> > >>> Could you please modify the expression so that we can understand this
> > >>> patch fixes the issue when the disk image is corrupted and the leak
> > >>> wasn't always there ?
> > >> Makes sense. I'm going to fix the message as this:
> > > Thank you for responding to my comment.
> > >
> > >> When extending segment, the current segment is allocated and set dirty
> > >> by previous nilfs_sufile_alloc().
> > >> But for some special cases such as corrupted image it can be unreliable,
> > >> so nilfs_sufile_mark_dirty()
> > >> is called to promise that current segment is dirty.
> > > This sentence is a little different because nilfs_sufile_mark_dirty()
> > > is originally called to dirty the buffer to include it as a part of
> > > the log of nilfs ahead, where the completed usage data will be stored
> > > later.
> > >
> > > And, unlike the dirty state of buffers and inodes, the dirty state of
> > > segments is persistent and resides on disk until it's freed by
> > > nilfs_sufile_free() unless it's destroyed on disk.
> > >
> > >> However, nilfs_sufile_mark_dirty() only sets buffer and inode dirty
> > >> while nilfs_segment_usage can
> > >> still be clean an used by following nilfs_sufile_alloc() because it
> > >> checks nilfs_segment_usage_clean(su).
> > >>
> > >> This will cause the problem reported...
> > > So, how about a description like this:
> > >
> > > When extending segments, nilfs_sufile_alloc() is called to get an
> > > unassigned segment.
> > > nilfs_sufile_alloc() then marks it as dirty to avoid accidentally
> > > allocating the same segment in the future.
> > > But for some special cases such as a corrupted image it can be unreliable.
> > >
> > > If such corruption of the dirty state of the segment occurs, nilfs2
> > > may reallocate a segment that is in use and pick the same segment for
> > > writing twice at the same time.
> > > ...
> > > This will cause the reported problem.
> > > ...
> > > Fix the problem by setting usage as dirty every time in
> > > nilfs_sufile_mark_dirty() which is called for the current segment
> > > before allocating additional segments during constructing segments to
> > > be written out.
> >
> > Thanks for your explanation!
> >
> > I made some simplification, so everything looks like:
> >
> >
> > When extending segments, nilfs_sufile_alloc() is called to get an
> > unassigned segment, then mark it as dirty to avoid accidentally
> > allocating the same segment in the future.
> >
> > But for some special cases such as a corrupted image it can be
> > unreliable.
> > If such corruption of the dirty state of the segment occurs, nilfs2 may
> > reallocate a segment that is in use and pick the same segment for
> > writing twice at the same time.
> >
> > This will cause the problem reported by syzkaller:
> > https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
> >
> > This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
> > It supposed segment 4 has already been allocated and marked as dirty.
> >
> > However the dirty state was corrupted and segment 4 usage was not dirty.
> > For the first time nilfs_segctor_extend_segments() segment 4 was
> > allocated again, which made segbuf2 and next segbuf3 had same segment 4.
> >
> > sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> > added to both buffer lists of two segbuf. It makes the lists broken
> > which causes NULL pointer dereference.
> >
> > Fix the problem by setting usage as dirty every time in
> > nilfs_sufile_mark_dirty(), which is called during constructing current
> > segment to be written out and before allocating next segment.
> >
>
> > Also add lock in it to protect the usage modification.
>
> You don't have to say this because this lock is needed to complete
> your modification and not the original.
> If you want to mention it, how about saying like this:
>
> Along with this change, this also adds a lock in it to protect the
> usage modification.

Come to think of it, this was also a misleading expression because the
patch doesn't add a new lock, but adds a use of an existing lock.
Either way, I'll leave it up to you.

Thanks,
Ryusuke Konishi

>
> > If it looks good, I'll sent the v3 patch for it.
> >
> > Best,
> > Chen
>
> I think the rest is OK as an overall description.
>
> Thanks,
> Ryusuke Konishi
