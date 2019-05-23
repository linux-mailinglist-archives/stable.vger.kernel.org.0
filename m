Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2696227B8F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfEWLUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 07:20:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34830 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbfEWLUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 07:20:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id q15so5373057wmj.0
        for <stable@vger.kernel.org>; Thu, 23 May 2019 04:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TSU8XlJEMK+KpQjqT+wKCWosXAXefjk73b4VzzoBmws=;
        b=DOyuxxCqspOt3cSWF1wpAKD57vDkx064yFDRmD+HdF5x1UUC8AMynQLy3b8yeJzxTU
         t3GKAaiBkG03shVf7En4dFXk2OJZN/jzJV/07Jm9mRiRqydU23p/IsIcNghogpPnWstI
         tB9I9j8TUMhhRM2qaxs77EVMXjQ2dkDzDjET0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TSU8XlJEMK+KpQjqT+wKCWosXAXefjk73b4VzzoBmws=;
        b=UGR0HJWynCWjcmF/TvWhUQ60KZb9qUfe78aUN863wjRgxlvWd3eQkKaBW17O4k8IXX
         7SgsYRdLzE0AUh/XxTQy+c0UbCTNSpICOELa//y5g5T8dh6C2GVEnyZ3Usj52OsGWwYI
         u1FsR/q/w/zLVmA4Fr805Aj4XaJ19MmQmOgBdThkKXT9gZnU2Cu4H2saO8FPkKlhtyfP
         BSjb6g1tPZLss/njDyIlkhLHwopjwHiEwhOCkUlVbUx5+0+5O1VZFIosKCEXMYkHiEGe
         SfOVmACEOWJa94Z23OJhc1k5/2WYTaC7mVGLTp400JR+7djsNUq2bFP0aZNcKMp+8DfE
         z1eQ==
X-Gm-Message-State: APjAAAWomLWsRtx0pJ5p5Rr+7F2HxRK9qXvE7sA1833ySkRQ87eAU87T
        7nqWoJmo87AofIeNamVywNtB3Q==
X-Google-Smtp-Source: APXvYqxx/e7d1yyDuR1wKw7Y6+trebNMbp76KzUBRwegvbG3ftEtbeB1AhBBf7UCuxakMuTqVLWx7A==
X-Received: by 2002:a1c:3cc2:: with SMTP id j185mr10979151wma.26.1558610420174;
        Thu, 23 May 2019 04:20:20 -0700 (PDT)
Received: from andrea (86.100.broadband17.iol.cz. [109.80.100.86])
        by smtp.gmail.com with ESMTPSA id d20sm5195243wra.68.2019.05.23.04.20.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 04:20:19 -0700 (PDT)
Date:   Thu, 23 May 2019 13:20:13 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        will.deacon@arm.com, aou@eecs.berkeley.edu, arnd@arndb.de,
        bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        fenghua.yu@intel.com, heiko.carstens@de.ibm.com,
        herbert@gondor.apana.org.au, ink@jurassic.park.msu.ru,
        jhogan@kernel.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mingo@kernel.org, mpe@ellerman.id.au, palmer@sifive.com,
        paul.burton@mips.com, paulus@samba.org, ralf@linux-mips.org,
        rth@twiddle.net, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, vgupta@synopsys.com
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190523112013.GA14035@andrea>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523101926.GA3370@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > While reading the series, I realized that the following expression:
> > 
> > 	atomic64_t v;
> >         ...
> > 	typeof(v.counter) my_val = atomic64_set(&v, VAL);
> > 
> > is a valid expression on some architectures (in part., on architectures
> > which #define atomic64_set() to WRITE_ONCE()) but is invalid on others.
> > (This is due to the fact that WRITE_ONCE() can be used as an rvalue in
> > the above assignment; TBH, I ignore the reasons for having such rvalue?)
> > 
> > IIUC, similar considerations hold for atomic_set().
> > 
> > The question is whether this is a known/"expected" inconsistency in the
> > implementation of atomic64_set() or if this would also need to be fixed
> > /addressed (say in a different patchset)?
> 
> In either case, I don't think the intent is that they should be used that way,
> and from a quick scan, I can only fine a single relevant instance today:
> 
> [mark@lakrids:~/src/linux]% git grep '\(return\|=\)\s\+atomic\(64\)\?_set'
> include/linux/vmw_vmci_defs.h:  return atomic_set((atomic_t *)var, (u32)new_val);
> include/linux/vmw_vmci_defs.h:  return atomic64_set(var, new_val);
> 
> 
> [mark@lakrids:~/src/linux]% git grep '=\s+atomic_set' | wc -l
> 0
> [mark@lakrids:~/src/linux]% git grep '=\s+atomic64_set' | wc -l
> 0
> 
> Any architectures implementing arch_atomic_* will have both of these functions
> returning void. Currently that's x86 and arm64, but (time permitting) I intend
> to migrate other architectures, so I guess we'll have to fix the above up as
> required.
> 
> I think it's best to avoid the construct above.

Thank you for the clarification, Mark.  I agree with you that it'd be
better to avoid such constructs.  (FWIW, it is not currently possible
to use them in litmus tests for the LKMM...)

Thanks,
  Andrea
