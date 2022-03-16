Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9349A4DA771
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 02:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348684AbiCPBo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 21:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352984AbiCPBo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 21:44:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887FE33349;
        Tue, 15 Mar 2022 18:43:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so3767123pjb.3;
        Tue, 15 Mar 2022 18:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PgvEKtSkgtyBAX5y2qY434FN26syvKAAoFPbq7kCQ0I=;
        b=DIALkPivSyq9o3R0w9gglPAyk4v5XPNfDqzZMum4gZ6ww2O2cgjqv9srrtxbAxguFF
         3qt97DcBfWPgAXp4HlqCVwX4FuEa0DG4GfHsv3VeACObzc0fc6BJ7CmLCl5Vd/937hf8
         gwdzjofm7ybbBDIU/eXAA8cK5Hr5mpOlgUfogjEifS84GHzXsQGZwkkCcYoX7hCjgFk/
         3XEvhlPwUEAj2fEZ1A7ZWPm95SMh0H2o5XFQ/bbUjv+EP6J52KGnjom7TEqNPcqv18da
         fWv4C3nnd+k3YIODlQNYBRgtWLadPbhzxmAafV1rYnvxzEcddb8wHcKvPieges1K+dTN
         egww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=PgvEKtSkgtyBAX5y2qY434FN26syvKAAoFPbq7kCQ0I=;
        b=JWRCAilF7R8nTUajKdnj8PxCpvpV0HwFFV8vut1VaMdXFDwpRsEKtM5HPMHA5kS2wb
         PM0SnIuc9Si5bFsFpeSxbKmUogMh2TtCHM9s9NnwTopW14CLXYQfLPhX66D8jz7ISiYb
         JzcPmZoRMxHzbCFxR8RsfdS+qIoHMGfYtsowJRrN8UHBk94hLU+6k8NEj8KGNA/PI0nS
         jNZe2Cd5Ylt/6N/WOZSy4Xqcfk1feguGICkih+pn3SSYwGzbBxoq7jGDFmTeY3HPEcJl
         8TuYCUajiM0EpYp6BddhvH/Qg6DJpbcsTD7dBxKGqZva+OuRS5BAQfDpv58ODKexfVEc
         ZIFA==
X-Gm-Message-State: AOAM530ARs9iq972YFTewkFx6stGfIS/7gMI38aGf2bNYQRS70Sx4Pam
        gYkWK8IV0eiAlNHMT7CVj1M=
X-Google-Smtp-Source: ABdhPJx9tEkgSAWUDAlpuD2nqDFRS1YJVTNjt+TipDUs5PQk7tjBfQxgL2ZWLnCucLYyGwdDfYbFYQ==
X-Received: by 2002:a17:90b:1812:b0:1bf:2395:8d53 with SMTP id lw18-20020a17090b181200b001bf23958d53mr7669109pjb.178.1647395024992;
        Tue, 15 Mar 2022 18:43:44 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:7484:dc22:fe49:91cb])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm423778pfc.111.2022.03.15.18.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 18:43:44 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Tue, 15 Mar 2022 18:43:42 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Charan Teja Kalla <quic_charante@quicinc.com>, surenb@google.com,
        vbabka@suse.cz, rientjes@google.com, sfr@canb.auug.org.au,
        edgararriaga@google.com, nadav.amit@gmail.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjFAzuLKWw5eadtf@google.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 04:48:07PM -0700, Andrew Morton wrote:
> On Tue, 15 Mar 2022 15:58:28 -0700 Minchan Kim <minchan@kernel.org> wrote:
> 
> > On Fri, Mar 11, 2022 at 08:59:06PM +0530, Charan Teja Kalla wrote:
> > > The process_madvise() system call is expected to skip holes in vma
> > > passed through 'struct iovec' vector list. But do_madvise, which
> > > process_madvise() calls for each vma, returns ENOMEM in case of unmapped
> > > holes, despite the VMA is processed.
> > > Thus process_madvise() should treat ENOMEM as expected and consider the
> > > VMA passed to as processed and continue processing other vma's in the
> > > vector list. Returning -ENOMEM to user, despite the VMA is processed,
> > > will be unable to figure out where to start the next madvise.
> > > Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> > > Cc: <stable@vger.kernel.org> # 5.10+
> > 
> > Hmm, not sure whether it's stable material since it changes semantic of
> > API. It would be better to change the semantic from 5.19 with man page
> > update to specify the change.
> 
> It's a very desirable change and it makes the code match the manpage
> and it's cc:stable.  I think we should just absorb any transitory
> damage which this causes people.  I doubt if there will be much - if
> anyone was affected by this they would have already told us that it's
> broken?


process_madvise fails to return exact processed bytes at several cases
if it encounters the error, such as, -EINVAL, -EINTR, -ENOMEM in the
middle of processing vmas. And now we are trying to make exception for
change for only hole? IMO, it's worth to note in man page.

In addition, this change returns positive processes bytes even though
it didn't process anything if it couldn't find any vma for the first
iteration in madvise_walk_vmas.
