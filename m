Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E13277F7
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfEWIaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:30:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45554 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfEWIaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:30:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id b18so5192819wrq.12
        for <stable@vger.kernel.org>; Thu, 23 May 2019 01:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CWRQ0EYJjfxMbJnmKcTI7ZG0fOWBb9XCDQzcnCHm0dk=;
        b=ab15QBgCx0Q1cdYfe/azNEfujud37wvKO/QjSgnTFVRKW8FQCv4j3HFI6ob+hKLDsu
         dKiIHDHhQBPT/N3J44Eesz9o9jfESxiznCGA4rzGg1FQX7UTouFMJ7Ca45N/QCYCAfMc
         ImnuUxTy+ZuY6lXykGMoA9Zi0XYGG7QCApeh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CWRQ0EYJjfxMbJnmKcTI7ZG0fOWBb9XCDQzcnCHm0dk=;
        b=MqpDGiEjwh9Ik5T2yQTc1wAUAVtkc8x/5o4sW1mwbiQKjRP8bjLtRQ/dwTxyuH4p+K
         xmBSUmFpaiBsneARF9ScCiGmtkrwq0zrpFMie+EIubs9dPvDmkvx8D75glTZ6aHqD4MV
         iIAHbr8CHWm3bseDyk55nDFR1p9is+LiniZt123UgSg+j5QjHtTr5hFJhyKQJP9EKddy
         HEOuiJLy8hkVpy6VV0qZQbRh0QxLvQG2TnKhEJ6f520bMa9NEynM+8Jr1lGuX+4kpGua
         NFlpxgXvTIYpPol868mwPMGG9IUCLU5N7LimD1Tn1UqeMU/+wgpOa7dlMIDBtP1zmmBn
         ifCg==
X-Gm-Message-State: APjAAAXr83Cpy8aDW8vIrEH7EzGjLVkHynopjMny6pATv3fqvbng1k1k
        k+Xsj3X+nLWUEIak4IHs5Cqc+w==
X-Google-Smtp-Source: APXvYqwek6Tl0tiKwDs0xQJs11UWCKfT0GBtpbpuH2Rtwvb8IKmaXLyamsDRFPj5dEubkjO1mx22Qw==
X-Received: by 2002:adf:f7d1:: with SMTP id a17mr110557wrq.64.1558600222084;
        Thu, 23 May 2019 01:30:22 -0700 (PDT)
Received: from andrea (86.100.broadband17.iol.cz. [109.80.100.86])
        by smtp.gmail.com with ESMTPSA id m10sm9287874wmf.40.2019.05.23.01.30.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 01:30:21 -0700 (PDT)
Date:   Thu, 23 May 2019 10:30:13 +0200
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
Message-ID: <20190523083013.GA4616@andrea>
References: <20190522132250.26499-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark,

On Wed, May 22, 2019 at 02:22:32PM +0100, Mark Rutland wrote:
> Currently architectures return inconsistent types for atomic64 ops. Some return
> long (e..g. powerpc), some return long long (e.g. arc), and some return s64
> (e.g. x86).

(only partially related, but probably worth asking:)

While reading the series, I realized that the following expression:

	atomic64_t v;
        ...
	typeof(v.counter) my_val = atomic64_set(&v, VAL);

is a valid expression on some architectures (in part., on architectures
which #define atomic64_set() to WRITE_ONCE()) but is invalid on others.
(This is due to the fact that WRITE_ONCE() can be used as an rvalue in
the above assignment; TBH, I ignore the reasons for having such rvalue?)

IIUC, similar considerations hold for atomic_set().

The question is whether this is a known/"expected" inconsistency in the
implementation of atomic64_set() or if this would also need to be fixed
/addressed (say in a different patchset)?

Thanks,
  Andrea
