Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B21D052
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 22:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfENUOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 16:14:12 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39927 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfENUOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 16:14:11 -0400
Received: by mail-ed1-f67.google.com with SMTP id e24so663984edq.6
        for <stable@vger.kernel.org>; Tue, 14 May 2019 13:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tMyJpViyUekS9HUPsqgFn75mFJnyLhJLwiZnuAi0JuM=;
        b=lbsKeJWtIbL4WeGT0IYteb3PmbnJPJBGu7VAPX1GO5RTIpyjNLUHeBAfYzL+PvdGGd
         0AO9d7eIgoQKybsnWzxPct2gh1BGpgWZqt1etlq+BTWnf+sTXcYnUmzqM/NwI0nw+JAU
         e8cq4NBKmQFGuXjEMdcyDRHmocc84j3qtWvjvaOk5E5CAii53hiDSGzRjqui+dN5xDH/
         0Rpdwm/huVn582GsL2Wmuf83A+2bTxD1WqUxgAN/k4kJWr0+aZtON6EYZtJpSr5eBbAG
         vAA1xm/qhAeNH0rUt2dMuUGaFHkjWHNzdpDPVekGAxFeA7ElBLG/0H9cqL4ZFSlUqA0x
         /WJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tMyJpViyUekS9HUPsqgFn75mFJnyLhJLwiZnuAi0JuM=;
        b=dDz8cQ1r0zKdmW9Tx002e/pCagfOVokzL1dyZdcL8qrJuXTskTPL/t6Ihihtp660XC
         0zH1SHiSXyS1sY93bTHkX4pXXQgjWwlGP7Pu7Lt7ao7eIw/wUL04bAcKdI0Cqg+8Ucdv
         sIPmOFd988ooKZdhxXelpixdUhJXQPL5bLpMacyXwZQiZH2s07Jbqf0qRsWsLv2RbNEr
         6h7qRtqkpHgm1ZkmVUI8+YnAF07HoBnjbMKCRUY4LYoF14Ap18V02dluMi4EdUyN9zEC
         HvGR2P5JBc6FidfBidxhrHz0g2O6faopQRTpHePhXzelVwwngsG6PErff7K5klS3fE3p
         k8OQ==
X-Gm-Message-State: APjAAAWoTRRFD9o66WnBTEqAIxKJ8GW+MfA1u8vcC0Quql36vSOpHbwa
        kN3BQC8AazoPspmZpdqOLGE=
X-Google-Smtp-Source: APXvYqwKl+pyEavJAqMMf03fEy1wzDgVKfdEGh2nOwDx5/Hm7MretfBkDkvFKS6/lWipC/aLADTN6g==
X-Received: by 2002:a17:906:e8c:: with SMTP id p12mr28687102ejf.18.1557864850024;
        Tue, 14 May 2019 13:14:10 -0700 (PDT)
Received: from archlinux-i9 ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id e43sm4844712edb.38.2019.05.14.13.14.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 13:14:09 -0700 (PDT)
Date:   Tue, 14 May 2019 13:14:07 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Major Hayden <major@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 4.19.44-rc1-f1f5cdf.cki (stable)
Message-ID: <20190514201407.GA13424@archlinux-i9>
References: <cki.2A0764DDE0.XWP9Z2MJYF@redhat.com>
 <20190514194511.GA22244@kroah.com>
 <15c477fa-7246-a1fe-a175-612f2f6be85b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15c477fa-7246-a1fe-a175-612f2f6be85b@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 03:09:17PM -0500, Major Hayden wrote:
> On 5/14/19 2:45 PM, Greg KH wrote:
> >> We attempted to compile the kernel for multiple architectures, but the compile
> >> failed on one or more architectures:
> >>
> >>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> > Is everything failing now?  Has this ever worked?
> 
> This has worked before, but it appears to be failing on ppc64le as of today. The relevant failure is here:
> 
> > 00:00:20   CC [M]  sound/core/oss/pcm_oss.o
> > 00:00:20 arch/powerpc/kernel/security.c: In function 'setup_barrier_nospec':
> > 00:00:20 arch/powerpc/kernel/security.c:59:21: error: implicit declaration of function 'cpu_mitigations_off' [-Werror=implicit-function-declaration]
> > 00:00:20   if (!no_nospec && !cpu_mitigations_off())
> > 00:00:20                      ^~~~~~~~~~~~~~~~~~~
> > 00:00:20 cc1: some warnings being treated as errors
> > 00:00:20 make[3]: *** [scripts/Makefile.build:303: arch/powerpc/kernel/security.o] Error 1
> > 00:00:20 make[2]: *** [Makefile:1051: arch/powerpc/kernel] Error 2
> > 00:00:20 make[2]: *** Waiting for unfinished jobs....
> 
> We haven't seen this same problem in mainline recently.
> 
> --
> Major Hayden

I bet this would be fixed by commit 42e2acde1237 ("powerpc/64s: Include
cpu header") upstream.

Cheers,
Nathan
