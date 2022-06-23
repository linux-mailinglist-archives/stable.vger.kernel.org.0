Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B4F55760B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 10:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiFWI5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 04:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiFWI5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 04:57:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D74247AE6;
        Thu, 23 Jun 2022 01:57:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cv13so15522294pjb.4;
        Thu, 23 Jun 2022 01:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=XuNmdMIPTwgFRn+KXfNoshLUyGzQ84uByLpqYdBwMbo=;
        b=U/ubG/f6T+EUydId86UG4ca9OLcoHD5k4QQ+3eWunYtB5/55nD7030zV+fXBywy/N8
         rnIgSdfB+mbLoTBsYX+LF0KMiQc/tCvdbiOPBmGHEWYljqJ7+Ytp6ICBpcUlIxLwFszu
         Bd75dGeE3PfTsG7RxUMO+p9USOiA8uuUGemciMWT3XztxTLJfkA1W/KrDSzoBc3nKrUL
         Cwcfd75z6z36xyZzdLGXmsmBmNz77+sTdpo257ezhnuJkv+JyQ+dg5OeZZwzveFMgHSf
         WybOMRUVwz2uedWXTuGnCWlCv3haS3eK3HoXG8O+YXEigs7NNQE0yfgkxZHHJTzcQ1mN
         h3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=XuNmdMIPTwgFRn+KXfNoshLUyGzQ84uByLpqYdBwMbo=;
        b=TCE0grziqw8xmymDOobXTR/IqHrVLzKSAb8veJZS+lIfrTVo/VUCf/ROqlH/GF4V8Q
         O8QMhhKZPn+0CkGXm8NhhribBotk19MZsn/xADscv4leKLaoliPg89f47s8Nz9Y8DX9p
         6H95iBlvv9mXaIf5YeSR09QQ9oLGGxRb6nY8qfHx5bZ2IKinLH4y6xc6eMDNuFkJK4lU
         Z7VvWQKBeiNpFyG8Rz82OGio/I+pZp2DA8t+ubbNL+a5CQDMg/DedHnQWtg6ivPBPlxr
         7u84h7nB9XvTqNo8uKJacdL/aWWH4bJ72iA6SmyZEsmHg+u13sw4MlLiKzkEBJv6q6hK
         gv9w==
X-Gm-Message-State: AJIora9JLAI5CHH1dqV6pE75qh+QeiuuHt1FwifOLT3myTVlAbfl9rlm
        jotgvPgIv0l04ujkQl+tgCo=
X-Google-Smtp-Source: AGRyM1tmqcpLbADtd2gc4SGwWOE/T7MnAN+wXT6gAvIivgKm0kg/9B7WObW+jCA563pNquyOh73RBw==
X-Received: by 2002:a17:90b:3c0c:b0:1ec:c5b1:ce56 with SMTP id pb12-20020a17090b3c0c00b001ecc5b1ce56mr3017768pjb.102.1655974643009;
        Thu, 23 Jun 2022 01:57:23 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o12-20020a62f90c000000b0051be16492basm15178139pfh.195.2022.06.23.01.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 01:57:22 -0700 (PDT)
Message-ID: <62b42af2.1c69fb81.6e00c.63b1@mx.google.com>
X-Google-Original-Message-ID: <20220623085721.GA976022@cgel.zte@gmail.com>
Date:   Thu, 23 Jun 2022 08:57:21 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn, linux-fsdevel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>,
        syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Subject: Re: [PATCH] fs/ntfs: fix BUG_ON of ntfs_read_block()
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
 <20220623035131.974098-1-xu.xin16@zte.com.cn>
 <YrQc4ZOBGhmpvfaP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrQc4ZOBGhmpvfaP@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 09:57:21AM +0200, Greg KH wrote:
> On Thu, Jun 23, 2022 at 03:51:31AM +0000, cgel.zte@gmail.com wrote:
> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > As the bug description, attckers can use this bug to crash the system
> > When CONFIG_NTFS_FS is set.
> > 
> > So remove the BUG_ON, and use WARN and return instead until someone
> > really solve the bug.
> > 
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
> > Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
> > Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
> > Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
> > Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> > ---
> >  fs/ntfs/aops.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> > index 5f4fb6ca6f2e..b6fd7e711420 100644
> > --- a/fs/ntfs/aops.c
> > +++ b/fs/ntfs/aops.c
> > @@ -183,7 +183,11 @@ static int ntfs_read_block(struct page *page)
> >  	vol = ni->vol;
> >  
> >  	/* $MFT/$DATA must have its complete runlist in memory at all times. */
> > -	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
> > +	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
> > +		WARN(1, "NTFS: ni->runlist.rl, ni->mft_no, and NInoAttr(ni) is null!\n");
> 
> So for systems with panic-on-warn, you are still crashing?  Why is this
> WARN() line still needed here?
>

Sorry, I forgot about panic-on-warn. Use pr_warn() may be better.
I'll send a patch-v2 .

> thanks,
> 
> greg k-h
