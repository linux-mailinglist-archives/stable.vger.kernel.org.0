Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD91BFD07
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgD3OJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgD3OJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 10:09:56 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC64EC035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 07:09:55 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id j3so6623025ljg.8
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 07:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gqs6/WoFCiYvtJs2NOyJ4iHVgMuqbT1GqHeEFPhOPPQ=;
        b=O8t7ysvn4JbuCgfHB0iclVfyXqKjhyJMADH7fryiwgDIaikCUb2xUHFTGkfrv/kOGT
         ChdTR92r6FB9qFSdR0QPOufTNyG3cZsWdSpf9JRI7IcOooSDszEv4yLEcFZtwKJToURL
         x34EdQwoyAhaLyKmaBh1g7sFR+CWi6lGqj6Xo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gqs6/WoFCiYvtJs2NOyJ4iHVgMuqbT1GqHeEFPhOPPQ=;
        b=fKThl1PIW+cmspM4dIzF0q8Lo/p5VJPKb8OhE2vsIqiNIaCgBh6WR4phckJfG9VjRP
         bDsyJinpormq2S4ye0xITHI2KgPLkjvuvvwvf4EFs5BAFGOoD7SMPR8+072hrhOi5tPo
         IUsg53ml51wStvQH77tNefZ4TaFSgilhCa37UrRhQOLS7jDAbCOzyiIKvjq7HtVyFMfr
         qDpCYU77v/nrLDyuDrCmpeLU24ZhgM3NDCgmSMHGLDKDdU/pKrqFyR+Jl/3WYzGetj/C
         SMWUVy8Tf6ZVKEKj9/Y8O+1JuoZUF8U35HwN2t7DyPKkahh3TRRcYp2GTab/Si5smXQt
         +R1w==
X-Gm-Message-State: AGi0PuYr8R4O3Pz3ixH51qd/AVfL2zZ6iC9Q3DbmFzzQRdDqf6BDAlQN
        l3PCHbu8tytcEaYlNha/OSf7ZjpAdb4=
X-Google-Smtp-Source: APiQypI/+e9YDdbrA4kS3yXkkx2HvfS756ocOiLvI6Wy9D8PlyD3/YjUqeCaE7wV0aogTKaD0BQXlg==
X-Received: by 2002:a2e:5855:: with SMTP id x21mr2299832ljd.75.1588255794061;
        Thu, 30 Apr 2020 07:09:54 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id m132sm1343556lfa.94.2020.04.30.07.09.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 07:09:53 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id j3so6622955ljg.8
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 07:09:53 -0700 (PDT)
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr2483575ljj.265.1588255391241;
 Thu, 30 Apr 2020 07:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Apr 2020 07:02:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
Message-ID: <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 1:41 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> With the above realizations the name "mcsafe" is no longer accurate and
> copy_safe() is proposed as its replacement. x86 grows a copy_safe_fast()
> implementation as a default implementation that is independent of
> detecting the presence of x86-MCA.

How is this then different from "probe_kernel_read()" and
"probe_kernel_write()"? Other than the obvious "it does it for both
reads and writes"?

IOW, wouldn't it be sensible to try to match the naming and try to
find some unified model for all these things?

"probe_kernel_copy()"?

              Linus
