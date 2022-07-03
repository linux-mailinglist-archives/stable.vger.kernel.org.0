Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E6564544
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiGCFIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiGCFIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:08:00 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2B7AE7D;
        Sat,  2 Jul 2022 22:07:59 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id s4so2314293uad.0;
        Sat, 02 Jul 2022 22:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bWMQeQCfVrU36HijvQCkWTCeD2Xa/KiB3aRnlOcQeD8=;
        b=HA1OIvwEitFccUZz+MDvmDWo0sRx6jt49wi7Onnkd/4ahBaIMqrxMhSE/tTf9IsmPo
         zWP4Ta00lj2986PUN1omQabJFP7lIbjD4u8/FwMlmJTLTmyuZfu2CuLR3wRLIDsXJf8M
         0GunXLTZLvmMmOtBtp3t7lxaJbH5/U1vYSmBVfxTxgVpkZauw9txsIMXXNGag6FWRBFk
         i+usSiUBFy3uDdEZNuWwDOe7+daLVNbkkjAZsPnFlQ966PIt2Xjo/loS7lvtoOKRPsfx
         VElEvtSvlUYjDTD+Z5aNGp3xS3U50By6B6rSPEjjLeuYUFNcWnsVuqUBQzM1neMlvWTo
         JaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWMQeQCfVrU36HijvQCkWTCeD2Xa/KiB3aRnlOcQeD8=;
        b=BEhFYidxlTny1Zg1fuRakWgutK++l0kEnc/45Wzeg1LMCTPTJA070zg4hAR8gNsSrS
         Qm5CqvOtu8Cp2C2BK0PpuktkVnovUwV1/NUCTgYE2NuhULUJOOOiMvwFU806bfN0c4Q8
         g/D7XHeraFcimZcXVnMAXUKB6jAd1qJfasFTzjR9lFemQUHfgruyTG2GLc0GmnEe6Xom
         lKbVl/f1yazThqFOLpArehoU7oyzXjD0VC7FQvrVjjVCqV0allkq3hBEO93FO/ZSyf1O
         MXJFyzwr6XeJS1XgRwlYYo0BCNsSwzuD5YAxGsPREYpxacmBLR7zlXpbe4joFK7lzbuc
         dFdQ==
X-Gm-Message-State: AJIora9+Cw6PVKD74jWY1LR42PaMLu7V5as+0C09TBo4HnSbyoWvuXIK
        PDiAJcXjDqnJd/dZio2jVIc4JSlPWR7pdEKsu6XST4cu
X-Google-Smtp-Source: AGRyM1tKBycstcRabMvUEAVRrHv3+dsoEENZdYsHR7GxQznzOZPHMeF/CNEWefjKsojNF2r4k2xLsoBHmITpGhfSAIw=
X-Received: by 2002:a05:6130:21a:b0:37f:2ab2:879a with SMTP id
 s26-20020a056130021a00b0037f2ab2879amr11712887uac.9.1656824878400; Sat, 02
 Jul 2022 22:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220703050456.3222610-1-amir73il@gmail.com>
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 3 Jul 2022 08:07:46 +0300
Message-ID: <CAOQ4uxgcejZHq0MQ6xCjahZLVjUs5unw3oqEm5A1Kkux70kqgg@mail.gmail.com>
Subject: Re: [PATCH 5.10 v3 0/7] xfs stable patches for 5.10.y (from v5.13)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 3, 2022 at 8:05 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi Greg,
>
> Following the 5.10.y/5.15.y common series, this is another small
> "5.10.y only" update.
>
> I have two more of these (from v5.14 and v5.15) and after that,
> 5.10.y should be mostly following 5.15.y.
>
> The backports from v5.14 are a little more involved, so the next
> "5.10.y only" update is going to take a while longer.
>

Forgot to say:

Changes from v2:
- Acked-by Darrick
- CC stable

Changes from v1:
- None

> Thanks,
> Amir.
>
> Anthony Iliopoulos (1):
>   xfs: fix xfs_trans slab cache name
>
> Darrick J. Wong (1):
>   xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
>
> Dave Chinner (2):
>   xfs: use current->journal_info for detecting transaction recursion
>   xfs: update superblock counters correctly for !lazysbcount
>
> Gao Xiang (1):
>   xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
>
> Pavel Reichl (2):
>   xfs: rename variable mp to parsing_mp
>   xfs: Skip repetitive warnings about mount options
>
>  fs/iomap/buffered-io.c    |   7 ---
>  fs/xfs/libxfs/xfs_btree.c |  12 +++-
>  fs/xfs/libxfs/xfs_sb.c    |  16 ++++-
>  fs/xfs/xfs_aops.c         |  17 +++++-
>  fs/xfs/xfs_error.c        |   2 +
>  fs/xfs/xfs_reflink.c      |   3 +-
>  fs/xfs/xfs_super.c        | 120 +++++++++++++++++++++-----------------
>  fs/xfs/xfs_trans.c        |  23 +++-----
>  fs/xfs/xfs_trans.h        |  30 ++++++++++
>  9 files changed, 148 insertions(+), 82 deletions(-)
>
> --
> 2.25.1
>
