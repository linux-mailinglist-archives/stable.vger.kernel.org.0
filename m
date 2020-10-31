Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F702A14EE
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 10:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgJaJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 05:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgJaJpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 05:45:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6419FC0613D5;
        Sat, 31 Oct 2020 02:45:03 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i16so3569174wrv.1;
        Sat, 31 Oct 2020 02:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iqutb4Kx0sLM07VcPq81cNN+p8mmxY4ZnBeIeag3PtY=;
        b=livc3eYPiczPJEHxVRAlXoTp92ucaBOhGkKZJhhHWHIWSnHuDztQciFg4RmoZVV6IH
         x9GtsjetSk2FuJriQWJ68ItXuKppen8cZlB+mHxvBC4ujRF72KxdAMHu6XZF/Gcf7QJx
         b5JksOcZm5NaPXYVmM80xb6QeSLcD2hwxrKeL2nJCgVCYnZGcvMt5zWGhs7hDhlFMjQC
         C9meqWTKmYbksHfKFQT7UgqV7RxDLqPOXnt6cgIsk5MezzrTyWnLcNIN17DWdna3NMxF
         YG0w83jdJXVyjnATJvZkcPINlhQlkSw/9czLI5+RfZtR/uaQ8rDIc25jzAYmVnpHmL/x
         XjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iqutb4Kx0sLM07VcPq81cNN+p8mmxY4ZnBeIeag3PtY=;
        b=W/C4lKme7lxRAXLUC8seY00seILvpsbx6V5TbuZghcbuTnIVhZiW8wDpUtWR5XPuTv
         0ffC9ywegu6tTr+uRVw9hX8XyC1KtSVYoCQnlqD4rLNlrITtdZlQO8KJ0qGq/oU3tEXt
         Z7strc+2mDzd+jpgYgDiHs5sLKE+CpYJ7L00I/6KGDBA4eX56hcAcVn0msICmhN7EKEY
         AxSZisyXLXEl2e07MdXXDUrnjgdyKfXWdGu/sQCQ/wsGBRi4l48delN3/Toa69vlbt4u
         Ep3+cLVSVFwOOqc+Ido+4A1+tpyqw4WdhRl8988BNH5uz2+6GQ/u7mDihXKo27a4hre5
         rKyA==
X-Gm-Message-State: AOAM530nfNQoD++WiLhPZUcD253elOpEt7PfANZt256NrHSNR5Qn8T7n
        6TeuhH+PsrcOuuORdLhI/JnFKxqR3PoswA==
X-Google-Smtp-Source: ABdhPJzGB7PtcqF0Iel/asqLs/1j9735+bvIoK1zrHTIouQucQ+OH2jAQfWLM2wipwyfAqkzthqn2Q==
X-Received: by 2002:a5d:6ca6:: with SMTP id a6mr8352135wra.348.1604137501797;
        Sat, 31 Oct 2020 02:45:01 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id a185sm7819719wmf.24.2020.10.31.02.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 02:45:00 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 31 Oct 2020 10:45:00 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201031094500.GA271135@eldamar.lan>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028195619.GC124982@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Oct 28, 2020 at 12:56:19PM -0700, Guenter Roeck wrote:
> Retry.
> 
> On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
> > On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.153 release.
> > > There are 264 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 152 fail: 3
> > Failed builds:
> > 	i386:tools/perf
> > 	powerpc:ppc6xx_defconfig
> > 	x86_64:tools/perf
> > Qemu test results:
> > 	total: 417 pass: 417 fail: 0
> > 
> > perf failures are as usual. powerpc:

Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
cs-etm: Move definition of 'traceid_list' global variable from header
file") included in 4.19.152 or is a bugfix underway?

Regards,
Salvatore
