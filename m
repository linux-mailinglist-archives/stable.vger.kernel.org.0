Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B8F558F59
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 05:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiFXDz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 23:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiFXDz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 23:55:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F315159E;
        Thu, 23 Jun 2022 20:55:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d129so1253596pgc.9;
        Thu, 23 Jun 2022 20:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=aLjJG3wTDdhEgtq1ZKtCCF6LdFjXWGOjNdpJprykOdA=;
        b=ZM1bUECxFa2yoUSkcaJn1sj2GOOIwzyJ9lQP4IWIXeIoHFS2b1SqfE9M0yGKlL0S29
         FZWBnuXVNmCAgHYU7zhV7rd3panA+a5OVzPpNAwhg6qmRFnPYljgtZ/KcEEHyc3mQmwr
         bApTxzi2uUxj0+6etZ+FqXsmJso/hZhfYKJMaJ5Opp2ZiiPUAcmbbp8uGKgyNF+et1xS
         9bhDpUvdglGyneVlAraINvOaasl9nYYnEfaRiaME2q6iwm+/pRek09a+BjO5vEh6UcIx
         4KJCjaArPcGNAKrJ4eKCz17Eh2bsTSsgzdhfX4b66F/I9kPsCf1tQoy00DckBGTth7PY
         o5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=aLjJG3wTDdhEgtq1ZKtCCF6LdFjXWGOjNdpJprykOdA=;
        b=7AXzKOuzedt9gfXggQYeYbWE3ZPlj7wOzj+YU8+cKk0rvFrWkf93CRzxXxEdgJIOHi
         q81fXTXpXK+6pnuuWssSkFsjHDlHf449E/xGEb8ZGfW3F6jgAdgTIo2yYl/Z2HfuBLvB
         bnVoVKhcG1zCPTqF9eSsg0udEv2BlteK6tSTrGTO6GYcA+EaWoJrWbKXdTimHzE6/rEs
         lwm/3N528Vt47TfIQS0dvetQs3c42Y5ejDD6aSCvwa97/dRxuoCinCwiXUv0JMOmpR+o
         rSh3vgLH91kqxqYGWWh0RtnSAo3J+/qDaQn+3BfR5PBwXa6FkWwpTKl6Pvpyxgy9nguC
         yuPg==
X-Gm-Message-State: AJIora9hEsMz72f1GueG6yHWtX4iGOSrD2KIIdp7IACNisX28s7Kn0H8
        xs1L0HAk8YvMFcaAptTGxQTlegoldbg=
X-Google-Smtp-Source: AGRyM1tlRVFPuMu7yVFH++RQkdtWXolPU+PEGhyLqYRxXv0PonINvxdj8vPhSlV7RbbqORyIgKCG2w==
X-Received: by 2002:a63:3c12:0:b0:40d:66f:8241 with SMTP id j18-20020a633c12000000b0040d066f8241mr10181476pga.612.1656042955417;
        Thu, 23 Jun 2022 20:55:55 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902710400b0016a1c61c603sm588280pll.154.2022.06.23.20.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 20:55:54 -0700 (PDT)
Message-ID: <62b535ca.1c69fb81.b0647.1529@mx.google.com>
X-Google-Original-Message-ID: <20220624035553.GA980944@cgel.zte@gmail.com>
Date:   Fri, 24 Jun 2022 03:55:53 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, xu.xin16@zte.com.cn,
        anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Subject: Re: [PATCH v2] fs/ntfs: fix BUG_ON of ntfs_read_block()
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
 <20220623094956.977053-1-xu.xin16@zte.com.cn>
 <YrSeAGmk4GZndtdn@sol.localdomain>
 <CAKYAXd8qoLKbWGX7omYUfarSugRnose8X8o3Zhb1XctiUtamQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd8qoLKbWGX7omYUfarSugRnose8X8o3Zhb1XctiUtamQg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 24, 2022 at 11:33:28AM +0900, Namjae Jeon wrote:
> 2022-06-24 2:08 GMT+09:00, Eric Biggers <ebiggers@kernel.org>:
> > On Thu, Jun 23, 2022 at 09:49:56AM +0000, cgel.zte@gmail.com wrote:
> >> From: xu xin <xu.xin16@zte.com.cn>
> >>
> >> As the bug description at
> >> https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.cn/
> >> attckers can use this bug to crash the system.
> >>
> >> So to avoid panic, remove the BUG_ON, and use ntfs_warning to output a
> >> warning to the syslog and return instead until someone really solve
> >> the problem.
> >>
> >> Cc: stable@vger.kernel.org
> >> Reported-by: Zeal Robot <zealci@zte.com.cn>
> >> Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
> >> Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
> >> Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
> >> Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
> >> Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
> >> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> >> ---
> >>
> >> Change for v2:
> >>  - Use ntfs_warning instead of WARN().
> >>  - Add the tag Cc: stable@vger.kernel.org.
> >> ---
> >>  fs/ntfs/aops.c | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> >> index 5f4fb6ca6f2e..84d68efb4ace 100644
> >> --- a/fs/ntfs/aops.c
> >> +++ b/fs/ntfs/aops.c
> >> @@ -183,7 +183,12 @@ static int ntfs_read_block(struct page *page)
> >>  	vol = ni->vol;
> >>
> >>  	/* $MFT/$DATA must have its complete runlist in memory at all times. */
> >> -	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
> >> +	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
> >> +		ntfs_warning(vi->i_sb, "Error because ni->runlist.rl, ni->mft_no, "
> >> +				"and NInoAttr(ni) is null.");
> >> +		unlock_page(page);
> >> +		return -EINVAL;
> >> +	}
> >
> > A better warning message that doesn't rely on implementation details
> > (struct
> > field and macro names) would be "Runlist of $MFT/$DATA is not cached".
> > Also,
> > why does this situation happen in the first place?  Is there a way to
> > prevent
> > this situation in the first place?
> 
> ntfs_mapping_pairs_decompress() should return error pointer instead of NULL.
> Callers is checking error value using IS_ERR(). and the mapping pairs
> array of @MFT entry is empty, I think it's corrupted, it should cause
> mount failure.
> 
> I haven't checked if this patch fix the problem. Xu, Can you check it ?
> 

I have test it and it fixes the problem.

Thanks.

> diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
> index 97932fb5179c..31263fe0772f 100644
> --- a/fs/ntfs/runlist.c
> +++ b/fs/ntfs/runlist.c
> @@ -766,8 +766,11 @@ runlist_element
> *ntfs_mapping_pairs_decompress(const ntfs_volume *vol,
>                 return ERR_PTR(-EIO);
>         }
>         /* If the mapping pairs array is valid but empty, nothing to do. */
> -       if (!vcn && !*buf)
> +       if (!vcn && !*buf) {
> +               if (!old_rl)
> +                       return ERR_PTR(-EIO);
>                 return old_rl;
> +       }
>         /* Current position in runlist array. */
>         rlpos = 0;
>         /* Allocate first page and set current runlist size to one page. */
> 
> >
> > - Eric
> >
