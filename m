Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B377C55761F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiFWI7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 04:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiFWI7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 04:59:21 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F13F65;
        Thu, 23 Jun 2022 01:59:21 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h192so18556053pgc.4;
        Thu, 23 Jun 2022 01:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=PZqL3nImpxdufaOwqet7SR9Z+NkTikarvBkFeRnT+2I=;
        b=Y5KS4zXn7ur6b4E8fuA3TbU8g8dxuW/AgKiB7Wj8gs9cEyR+arGeu9skqOEq16L9OS
         Bitan0gbgM1UuggXMCi2yTlk1ljFQOqucEoOj8Jty4kInZF8cW39DeCjsZ6RNhdK2iqV
         1vy8tH9bTqKQorqbo26I7sTxYl56mPICRNWVkZHmoLUF8SwybYUWScE0npABVn/wc+vH
         ugvpoCTHZWlcEXNucd4OHk3VEHeUpfFUp/H1mz5AAyhLJbbnRdvqstD8EmtbeS0cbySx
         GCDM3okbT3ATnTIoVI5GF9Ahm3eNecFY6UG5OMGXBJ+seVIZy5WVQsxkBRjCdK75m9EK
         Czsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=PZqL3nImpxdufaOwqet7SR9Z+NkTikarvBkFeRnT+2I=;
        b=ZT5lLyaGba0Pmeer3mLU1ccl1arqCwvTLwvPIOt22406p5LO+YB3Lwazwa0WJVY8cE
         5z4pAdXKdgeAoc8/+CXblHg8TnXTuOnZfZ4AT846pEP9DvdAAVd0TqlmoyZfUjzxz7Zb
         kLknyv4kU4O+VjSZUzbO8o01B/c7uJ2bEWN3sYJ/VTNf2ni8DUkrUlFLY6yffaFlUx/0
         mzxZrZXt5+C27M2Wrr3B64Pq5zkWvQnfcNrGwyyRNY+Uhd+J8sl4uBWPGYt0joL8upW+
         l66QEzpX0ikt2CN57BWqSXevVz6xWOauA1Nejud4IiFu8ckcZJoewY2ig+7/bQaTTM8i
         +8xA==
X-Gm-Message-State: AJIora9z2WZMcO0J4za53FbjyYwVtBs4d3lEZAvsUg558w66F4WX3pID
        jExc/tdPvbEVXYsTdzVcero=
X-Google-Smtp-Source: AGRyM1vKmXk/uLI5dSeZfcXv16Z9wUccj2R6DJyUdHx7ZMvSxDwPoZabxYlZN0NUpy61Zt7pnNEW8Q==
X-Received: by 2002:a63:4c:0:b0:408:c003:a45c with SMTP id 73-20020a63004c000000b00408c003a45cmr6692392pga.252.1655974760833;
        Thu, 23 Jun 2022 01:59:20 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b0016357fd0fd1sm14182078pln.69.2022.06.23.01.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 01:59:20 -0700 (PDT)
Message-ID: <62b42b68.1c69fb81.9dc0f.49bb@mx.google.com>
X-Google-Original-Message-ID: <20220623085918.GB976022@cgel.zte@gmail.com>
Date:   Thu, 23 Jun 2022 08:59:18 +0000
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
 <YrQc8xq+QezRcLi7@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrQc8xq+QezRcLi7@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 09:57:39AM +0200, Greg KH wrote:
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
> > --- a/fs/ntfs/aops.c
> > +++ b/fs/ntfs/aops.c
> > @@ -183,7 +183,11 @@ static int ntfs_read_block(struct page *page)
> >  	vol = ni->vol;
> >  
> >  	/* $MFT/$DATA must have its complete runlist in memory at all times. */
> > -	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
> > +	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
> > +		WARN(1, "NTFS: ni->runlist.rl, ni->mft_no, and NInoAttr(ni) is null!\n");
> > +		unlock_page(page);
> > +		return -EINVAL;
> > +	}
> >  
> >  	blocksize = vol->sb->s_blocksize;
> >  	blocksize_bits = vol->sb->s_blocksize_bits;
> > -- 
> > 2.25.1
> > 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>

Sorry. I'll rewrite a patch to fix it. 

Thanks.

> </formletter>
