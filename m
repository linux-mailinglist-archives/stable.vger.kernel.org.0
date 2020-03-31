Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439B0199F14
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 21:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgCaT3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 15:29:53 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:39775 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgCaT3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 15:29:53 -0400
Received: by mail-qv1-f67.google.com with SMTP id v38so11518687qvf.6;
        Tue, 31 Mar 2020 12:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SyIKYkGeatT+MuZFG5h4NuY6d7XLvO3kWO59jmOsKRY=;
        b=f1Pw7vrfZsX8Cv79jiXYL32Y5WCreBvYDMd73i+B2UauR/AVqIZxXOoT4g9D2/bYJQ
         bpoxezFZq01n9PyStLBazhW77TeCvJ8d9ERg6SjkTkp6tDhKx68hId7+wfiFGDTVMQPh
         6zfwCEos1FEmj0BTuN67f/VExFI7gefFvYbOi/JdOwLI2DXHX5RqpmXNvpRQJeT1QGO0
         cjswqSBZ3JVeIOxdNeDu88tJk88FNLWBfzfveYLA8r67f+Jl4xAWNMRKB2gAj6MEv09T
         kfWZE9tehlbvsgqfSbd/e9Ph0/lPkD1WzzJ54s27ssgcTrFBHDarv7CXgrR5yy7d+vHY
         Ob0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SyIKYkGeatT+MuZFG5h4NuY6d7XLvO3kWO59jmOsKRY=;
        b=egXDQ8MEYjnTDij9n8nvJrxp9tLnRDFnusep8HiD7J3PnIrJIpdqHKea94Rpf8v1up
         BmJfgRuQgjznn4KtqAlhGXNo2APqUgGpDF23d7Emx2MY/+nWBys69CQKiflFAWTO6Xqu
         fXarPnB3njlSmfRar5lm9A5VGa9aupkUEyVhoOvb9/cjSTcvtr2qmbKB5clku2H0uiw/
         UxEWkR8FAosn5EQIe2RY1KrD6HSLeR6Lf6KVXPw0O1KJUyLY7VWAOXdigstuT0T9BrMt
         wA+/UL0wLyLGVCgsGp0M4V/euF5asI73Z9qOmyE4SxzODOKlc9vux+2+zB81jvuveEBn
         oWww==
X-Gm-Message-State: ANhLgQ1AWHDxRZvR/WVk6z9tf4QF879/5ajP2asKn64Ks1xd9lqswSn3
        irx9m97sNO69GmSE4LzFwHY=
X-Google-Smtp-Source: ADFU+vt518MDg+02HSClej4LHtMCej2ETg7tZeU6oG6MABxAJgR9DDKqg5K3LPh5vPjnIcXhSXPzWw==
X-Received: by 2002:a05:6214:1552:: with SMTP id t18mr17568922qvw.113.1585682992831;
        Tue, 31 Mar 2020 12:29:52 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id w18sm13113985qkw.130.2020.03.31.12.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:29:51 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D7BA7409A3; Tue, 31 Mar 2020 16:29:49 -0300 (-03)
Date:   Tue, 31 Mar 2020 16:29:49 -0300
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200331192949.GN9917@kernel.org>
References: <20200331085308.098696461@linuxfoundation.org>
 <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
 <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Tue, Mar 31, 2020 at 11:20:37AM -0700, Linus Torvalds escreveu:
> On Tue, Mar 31, 2020 at 11:08 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > Perf build broken on Linux next and mainline and now on stable-rc-5.6 branch.
> 
> Strange. What is it that triggers the problem for you? It works fine
> here.. The error looks like some kind of command line quoting error,
> but I don't see the direct cause.
> 
> Have you bisected the failure? Build failures should be particularly
> easy and quick to bisect.

Naresh, can you try with the patch below? There was some back and forth
about a second patch in a series and this fell thru the cracks.

And also, BTW, can you please send me instructions on how to get hold of
the toolchain you use to crossbuild perf, so that I can add it to my set
of test build containers?

- Arnaldo

---

From: He Zhe <zhe.he@windriver.com>

The $(CC) passed to arch_errno_names.sh may include a series of parameters
along with gcc itself. To avoid overwriting the following parameters of
arch_errno_names.sh and break the build like below, we just pick up the
first word of the $(CC).

find: unknown predicate `-m64/arch'
x86_64-wrs-linux-gcc: warning: '-x c' after last input file has no effect
x86_64-wrs-linux-gcc: error: unrecognized command line option '-m64/include/uapi/asm-generic/errno.h'
x86_64-wrs-linux-gcc: fatal error: no input files

Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 tools/perf/Makefile.perf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3eda9d4..7114c11 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -573,7 +573,7 @@ arch_errno_hdr_dir := $(srctree)/tools
 arch_errno_tbl := $(srctree)/tools/perf/trace/beauty/arch_errno_names.sh
 
 $(arch_errno_name_array): $(arch_errno_tbl)
-	$(Q)$(SHELL) '$(arch_errno_tbl)' $(CC) $(arch_errno_hdr_dir) > $@
+	$(Q)$(SHELL) '$(arch_errno_tbl)' $(firstword $(CC)) $(arch_errno_hdr_dir) > $@
 
 sync_file_range_arrays := $(beauty_outdir)/sync_file_range_arrays.c
 sync_file_range_tbls := $(srctree)/tools/perf/trace/beauty/sync_file_range.sh
-- 
2.7.4

