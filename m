Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A74B0A61
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbiBJKQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:16:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbiBJKQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:16:39 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BF9FD5
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 02:16:39 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id d14-20020a05600c34ce00b0037bf4d14dc7so2903223wmq.3
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 02:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=p2L2JMGAHF/fA4cXJq0+NeV9Ap/R7fib8dscPh33vcg=;
        b=F27+3Ao6twgPUQ/BOE7bCH1y1UIIqmAONzGU3oxFPBf0mAFdO1zuL2KUYM1O++g2kx
         0QthHn6iinSXUj64X8vvdhOqtR+XWYwn5E/Gw+bJlWic6yenGNohxjvoICKo1CA/v5wh
         dZGA4pMay8u5aQAVuBZJ9srKDSwgWE/ddXN47oMMFEcWNd53Fe5zwF8cdwre7J051wLF
         ItDcXZiEPwC7ClNhh568QmdIVrjuPnmTtWwlVTn3hykOQGuNeu6OtXK7BEc5b2gRMv6/
         7r1aC+tQNy80dt1ZZUiEtUXIHLwa4b8xT03cNBWZKJQJ3w+AQX5CpSGRsTrvE9geY6Nj
         P3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=p2L2JMGAHF/fA4cXJq0+NeV9Ap/R7fib8dscPh33vcg=;
        b=CAOfDT//ZF51EKoAMsEpVL0Kvclzkk35BjV8NieZWhj/t0oyVsS/xAaDUHM/q5FB5/
         rft7th8+7TwNlUcJ2aZSYUoCaSkpq6G2QFcg3YEGWLeXbnF63/MtHmadxJ9MuDxsqzyk
         5O+I0Mv4nAKwYKovgWXJjZTmpDQSYR/CcJ2tPZ7zJirPbnO+5Zwy2/X0zzToCKgh2xCJ
         6whOUW8HRLTz2fzjuSs2OOLG9Z8bJNSnctMAHskqD/5/OGac8Td7fX7PqTU995+083Mu
         V00NGjpdAS9mC9EoQtYQO8Cb77YAqAJ0qK5FEv4BucSBK4mCRN3PS7dEGGqZrpM1WQno
         NIww==
X-Gm-Message-State: AOAM531KwvYC7ycQsvAnNEhCUyui8yitjx93vi+aaT8RgR5RMeGB3cS8
        qw4+eyu+cZwwKvePUrs2HCIfMg==
X-Google-Smtp-Source: ABdhPJyqF2XvTy7u6DWP/6ivautdkeYnX0LG3m5hhXZW9KBraONCYgZP5/iwGcxiCbFl24LtFFh+PA==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr1538504wmg.3.1644488197579;
        Thu, 10 Feb 2022 02:16:37 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id y1sm1328053wmi.36.2022.02.10.02.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 02:15:55 -0800 (PST)
Date:   Thu, 10 Feb 2022 10:15:52 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgTl2Lm9Vk50WNSj@google.com>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220210045911.GF8338@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220210045911.GF8338@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022, Darrick J. Wong wrote:

> On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> > 
> > Reverting since this commit opens a potential avenue for abuse.
> 
> What kind of abuse?  Did you conclude there's an avenue solely because
> some combination of userspace rigging produced a BUG warning?  Or is
> this a real problem that someone found?

Genuine question: Is the ability for userspace to crash the kernel
not enough to cause concern?  I would have thought that we'd want to
prevent this.

If by 'real problem' you mean; privilege escalation, memory corruption
or data leakage, then no, I haven't found any evidence of that.
However, that's not to say these aren't possible as a result of this
issue, just that I do not have the skills or knowledge to be able to
turn this into a demonstrable attack vector.

However, if you say there is no issue, I'm happy to take your word.

> > The C-reproducer and more information can be found at the link below.
> 
> No.  Post the information and your analysis here.  I'm not going to dig
> into some Google site to find out what happened, and I'm not going to
> assume that future developers will be able to access that URL to learn
> why this patch was created.

The link provided doesn't contain any further analysis.  Only the
reproducer and kernel configuration used, which are both too large to
enter into a Git commit.

> >   kernel BUG at fs/ext4/inode.c:2647!
> >   invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> >   CPU: 0 PID: 459 Comm: syz-executor359 Tainted: G        W         5.10.93-syzkaller-01028-g0347b1658399 #0
> 
> What BUG on fs/ext4/inode.c:2647?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/ext4/inode.c?h=v5.10.93#n2647
> 
> All I see is a call to pagevec_release()?  There's a BUG_ON further up
> if we wait for page writeback but then it still has Writeback set.  But
> I don't see anything in pagevec_release that would actually result in a
> BUG warning.

Right, this BUG back-trace was taken from the kernel I received the
bug report for.  I should have used the one I triggered in Mainline,
apologies for that.

The real source of the BUG is in the inlined call to page_buffers().

Here is the link for the latest release kernel:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/ext4/inode.c?h=v5.16#n2620

#define page_buffers(page)                                      \
        ({                                                      \
                BUG_ON(!PagePrivate(page));                     \
                ((struct buffer_head *)page_private(page));     \
        })

> Oh, right, this is one of those inscrutable syzkaller things, where a
> person can spend hours figuring out what the hell it set up.

A link to the config used (again too big to enter into a commit
message), can be easily sourced from the link provided.

> Yeah...no, you don't get to submit patches to core kernel code, claim
> it's not your responsibility to know anything about a subsystem that you
> want to patch, and then expect us to do the work for you.  If you pick
> up a syzkaller report, you get to figure out what broke, why, and how to
> fix it in a reasonable manner.
> 
> You're a maintainer, would you accept a patch like this?

No.  I would share my knowledge to provide a helpful review and work
with the contributor to find a solution (if applicable).

> OH WAIT, you're running this on the Android 5.10 kernel, aren't you?
> The BUG report came from page_buffers failing to find any buffer heads
> attached to the page.
> https://android.googlesource.com/kernel/common/+/refs/heads/android12-5.10-2022-02/fs/ext4/inode.c#2647

Yes, the H/W I have to prototype these on is a phone and the report
that came in was specifically built against the aforementioned
kernel.

> Yeah, don't care.

"There is nothing to worry about, as it's intended behaviour"?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
