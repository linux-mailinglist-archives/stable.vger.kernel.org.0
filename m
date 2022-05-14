Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD275527101
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 14:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiENMOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 08:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiENMOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 08:14:45 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D249624F28;
        Sat, 14 May 2022 05:14:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c14so9969115pfn.2;
        Sat, 14 May 2022 05:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1aSGY0h+9mFG07V/uGzLZko6mgSx1gaXsXLrsGCI9XA=;
        b=N7Hmhn5Lg9cczfQn3yUsdZ/KhteBfYV4DxaXQX1ynP/EGQpy1xkmF+CaY3zyG4wE7z
         cJ5wLDs/g7UBXXQkfGMJ8cdc+nIeq5VDRakjMfmf4n4SP4dSmd5SG8w9C6VtIo06SwSf
         4lEgvYhUn3Zd4IMaaO8OgKlt3xGvuIJkWg7lotceD53JQnQjtDMtC5wdVR7iNgs+Vmj7
         1lKDKT31aU+zjUBFGCHqZED2HctANq+UrVqRDEYt3qJgS0SBtQZ0+i/4c/jOKHdw9+Fw
         Rzu9HiEH2oBuEkMwL3WMSWQmXUDqwrx8bWn9srrM994bF3ygOWrd0SMSe97JYeFOpqBZ
         7vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1aSGY0h+9mFG07V/uGzLZko6mgSx1gaXsXLrsGCI9XA=;
        b=nl9WQ65ePSo9U2BxajpmaAMTVkbSG+l9/DBrG9Nivob23aanF46LQ+h3YFyFTeC8Ui
         SOggAUCT247uUur95kNjYXEmjK6oew0J3i8V8QJtRzOZt2L8l4wQt9X42wVLyRDRxAlb
         TXh9Rg9Udr7bec6QAFKV7eFzsXoDAIrc7jQzyOymQyFlZL+E4mCso5/ILCa18Z1lcpvG
         MeGT01qDJ2FoNqYWR7OCX+W+BEDWdLZZEv6Uw/4Qt2yzBDFWIsh4yfd4GdSJwSYwyU1C
         p6CZ4QVe8FFPnYQ8Is2VsBzvRK/kcSMt/SQu5y5ccG0I5DauoFrfV28N7lu2QwF2ey46
         dTmw==
X-Gm-Message-State: AOAM531tAd0twcHLYo79NRd1PgqEC7f82OG3sHAnr7PJ4uW0FgScQF43
        AhEiocrjHd7Rizp13SlWQkA=
X-Google-Smtp-Source: ABdhPJyvXfa3aO808JTEoNWi/aJttupdVwqAH0ymCcC/qYyTZhZFgrfYarrbc+e6gIxYXNXz2KeiyQ==
X-Received: by 2002:a63:1e1d:0:b0:3c6:a36f:7b13 with SMTP id e29-20020a631e1d000000b003c6a36f7b13mr7785413pge.447.1652530482317;
        Sat, 14 May 2022 05:14:42 -0700 (PDT)
Received: from localhost (subs09a-223-255-225-65.three.co.id. [223.255.225.65])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0050dc76281b1sm3430254pff.139.2022.05.14.05.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 05:14:41 -0700 (PDT)
Date:   Sat, 14 May 2022 19:14:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Chao Yu <chao@kernel.org>
Cc:     jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
Subject: Re: [PATCH v2] f2fs: fix to do sanity check for inline inode
Message-ID: <Yn+dLtxsy6LwVIBQ@debian.me>
References: <20220514080102.2246-1-chao@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220514080102.2246-1-chao@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 14, 2022 at 04:01:02PM +0800, Chao Yu wrote:
> As Yanming reported in bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=215895
> 
> I have encountered a bug in F2FS file system in kernel v5.17.
> 
> The kernel message is shown below:
> 
> kernel BUG at fs/inode.c:611!
> Call Trace:
>  evict+0x282/0x4e0
>  __dentry_kill+0x2b2/0x4d0
>  dput+0x2dd/0x720
>  do_renameat2+0x596/0x970
>  __x64_sys_rename+0x78/0x90
>  do_syscall_64+0x3b/0x90
> 
> The root cause is: fuzzed inode has both inline_data flag and encrypted
> flag, so after it was deleted by rename(), during f2fs_evict_inode(),
> it will cause inline data conversion due to flags confilction, then
> page cache will be polluted and trigger panic in clear_inode().
> 
> This patch tries to fix the issue by do more sanity checks for inline
> data inode in sanity_check_inode().
> 
> Cc: stable@vger.kernel.org
> Reported-by: Ming Yan <yanming@tju.edu.cn>
> Signed-off-by: Chao Yu <chao.yu@oppo.com>

Hi Chao,

I think the patch message can be reworked , like below:

Yanming reported a kernel bug in Bugzilla kernel, which can be reproduced.
The bug message is:

kernel BUG at fs/inode.c:611!
Call Trace:
 evict+0x282/0x4e0
 __dentry_kill+0x2b2/0x4d0
 dput+0x2dd/0x720
 do_renameat2+0x596/0x970
 __x64_sys_rename+0x78/0x90
 do_syscall_64+0x3b/0x90

The bug is due to fuzzed inode has both inline_data and encrypted flags.
During f2fs_evict_inode(), after the inode was deleted by rename(), it
will cause inline data conversion due to conflicting flags. The page
cache will be polluted and the panic will be triggered in clear_inode().

Try fixing the bug by doing more sanity checks for inline data inode in
sanity_check_inode().

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
