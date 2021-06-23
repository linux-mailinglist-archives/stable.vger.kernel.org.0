Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56F13B1E7A
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFWQVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 12:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWQVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 12:21:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C102FC061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 09:18:46 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v12so1424551plo.10
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 09:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rhZzXtsZWfzXc61E37Y58HMAKueOCl1cxiUTemZwhBU=;
        b=dH3chPBBa5s/c/kTTWhH9cTfQGuIHgt6buqYxYnwEqzVCEmuavirXgMY0jnzWzrhpf
         FK8uGYEmwOjOuasjcAutd5ga7BMVZDFtJrfwPCEPGoiBq+FnZRea4SQmaQyFa+0CNfrF
         sIjbKxy0LAM5hoYzEP2pje/v101mH4cfysi68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rhZzXtsZWfzXc61E37Y58HMAKueOCl1cxiUTemZwhBU=;
        b=dmvxh5Q3+sntywpiEgR2dV3rU/BqK2zG8iyQQwU+DPprYmuMtU6ctAiTXhhz+Fk5T7
         CWcwoFqx5JYzE2t+F0ZJqdxvaTEbA6W+sICFGssQqEfWNyGuCyXHq6ZffPHAiDa+g4dR
         UCdPXiyQOEJdI5Flt+OYnBTW8I1jY9/OL38HT+xV4RDjaDIvtX8B2tXKN0wcFA6qEMFv
         Oe2aIo1TmSFT5m/FZdnJfUSfTx3rSnXk2n9z8dngBapxtt/VZBrYofKuXu8cnmld85if
         q6Xqgr2IMiHwIW9zsObqf13hWz004W2JpEL60TmsPSQIPrVFpoySk6lvgfLo/+1bJK1C
         yQ/A==
X-Gm-Message-State: AOAM531AK2eGBrQe53VevjJQGRtcXQSboOYAD5sl9vPItVcm+9803PRl
        r2JNFlvVXW1f1Mieh9ydo2cb+g==
X-Google-Smtp-Source: ABdhPJzJ3D51ZkBeHYvydc2W7dqjMYmITjtDsX4GrfAXwNVMqd3U784KX/6bYsXi1F1SSe7WN/1Jgw==
X-Received: by 2002:a17:90a:c002:: with SMTP id p2mr10127839pjt.132.1624465126002;
        Wed, 23 Jun 2021 09:18:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id lp1sm133183pjb.44.2021.06.23.09.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:18:45 -0700 (PDT)
Date:   Wed, 23 Jun 2021 09:18:44 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Guillaume Tucker' <guillaume.tucker@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Message-ID: <202106230917.FE2F587@keescook>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
 <42f26361db6f481e980ac349bf0079ef@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42f26361db6f481e980ac349bf0079ef@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 01:43:04PM +0000, David Laight wrote:
> From: Guillaume Tucker
> > Sent: 23 June 2021 13:40
> ...
> > > diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
> > > index bb7a1775307b..0f9f22ac004b 100755
> > > --- a/tools/testing/selftests/lkdtm/run.sh
> > > +++ b/tools/testing/selftests/lkdtm/run.sh
> > > @@ -78,8 +78,9 @@ dmesg > "$DMESG"
> > >
> > >  # Most shells yell about signals and we're expecting the "cat" process
> > >  # to usually be killed by the kernel. So we have to run it in a sub-shell
> > > -# and silence errors.
> > > -($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
> > > +# to avoid terminating this script. Leave stderr alone, just in case
> > > +# something _else_ happens.
> > > +(/bin/sh -c '(echo '"$test"') | cat >'"$TRIGGER") || true
> 
> I was having trouble parsing that command - and I'm good
> at shell scripts.
> I think the extra subshell the 'echo' is in doesn't help.
> In fact, is either subshell needed?
> Surely:
> /bin/sh -c "echo '$test' | cat >$trigger" || true
> will work just as well?

Ah yeah, and I just tested it to double check, it can be even simpler:

echo "$test" | /bin/sh -c "cat >$TRIGGER" || true

I'll adjust and resend...

-Kees

-- 
Kees Cook
