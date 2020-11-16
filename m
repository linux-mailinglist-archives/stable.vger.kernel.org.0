Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398AD2B507E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 20:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgKPTDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 14:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgKPTDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 14:03:49 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547CDC0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 11:03:49 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r17so19997415wrw.1
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 11:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iNwxjqSrgiXzl2m208Xnk/1phrwjDGwCyGS3mClS8JU=;
        b=ddoqmiDcbq36yCPjyOee1bOwrIBait9p1dwtDG/2ny/53gyvC9Wf3w+NTJv0Q3j1Bw
         l0c+XxwJmB8gVPEiTRHBjIdDxVZ5LJQNuas4+16yVynR5BcElH85YoigDAwMN70do+kD
         XSTI/0/mWbuxYlQQ5oI+CWSjCT6PWrjS/6cx+MI+C06mFrS7TpoglSX/fMrzjj1LFPBs
         fXewhCDKOid4OHVhxPha/DjaukcYx8beNsWDyBXW4fWmrZOjn143US/d4EkI6hcadxrZ
         d8oWuwXHzsdZ1hY015v/38y4PhimHwAM1qVIiAAFmqRgCgsMEuVVjEHC0K3FiL4+87+h
         ox+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iNwxjqSrgiXzl2m208Xnk/1phrwjDGwCyGS3mClS8JU=;
        b=V0yB8OOgGRfdec/H1Aj8B+gTNACEemO681kDp2UKpiQd3Bm6V3HSfGA1Ppy/bp5RnJ
         KntqdwzmAd1sI5J7MWO+YvstDsxjIOGlsosaW2dPboHJvEBGgx/sTlXd3+CQ4PeJ0q7P
         PrZf7feN+ChLE9rARU1XWGTpFLwfsm9p0AigifIMcL3UilNdWeCWFQrkKFfNkNbW6X1D
         kdqes4MqGqcjxYsXxVXMIA6LJ8HbuvybWUV5GvnnUHdWHoRK74XXfxhgoU/TxyTnWuxp
         042CvMre8mlJp59NcfRiL1AY6Ds8m7G1JbX6O92g4OXwbjNzBiEIspFDwvs4OTpDZ3y6
         3xEA==
X-Gm-Message-State: AOAM530oNWundLTic6TolOMAuogplzhn6n6K79+rjTBQkipngDuVYgk1
        h0EBceJTkUuTMAMrTf1o7Os=
X-Google-Smtp-Source: ABdhPJy50ADg115kJa4SH/nHQabgB+66oUVyJuUd5iOPIdMCCOFFWFYT2kDJg/2x2VXBLnFGmVhalA==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr21172051wrq.294.1605553428141;
        Mon, 16 Nov 2020 11:03:48 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id f17sm290527wmh.10.2020.11.16.11.03.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Nov 2020 11:03:47 -0800 (PST)
Date:   Mon, 16 Nov 2020 19:03:45 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, keescook@chromium.org, linux@roeck-us.net,
        pasha.tatashin@soleen.com, pmladek@suse.com, robinmholt@gmail.com,
        rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] reboot: fix overflow parsing reboot cpu
 number" failed to apply to 4.19-stable tree
Message-ID: <20201116190345.ecoqav2ldelmovhf@debian>
References: <1605543227116199@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="p2z25eca4lzhz34s"
Content-Disposition: inline
In-Reply-To: <1605543227116199@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p2z25eca4lzhz34s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 16, 2020 at 05:13:47PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. This will apply to v4.19.y, v4.14.y, v4.9.y and
also v4.4.y. This needs to be applied after applying the backport of
8b92c4ff4423 ("Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"")
which is in a separate mail.

--
Regards
Sudip

--p2z25eca4lzhz34s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-reboot-fix-overflow-parsing-reboot-cpu-number.patch"

From 9e7e484249401216cbdd4d0f7328f30d0b8b6577 Mon Sep 17 00:00:00 2001
From: Matteo Croce <mcroce@microsoft.com>
Date: Fri, 13 Nov 2020 22:52:07 -0800
Subject: [PATCH] reboot: fix overflow parsing reboot cpu number

commit df5b0ab3e08a156701b537809914b339b0daa526 upstream

Limit the CPU number to num_possible_cpus(), because setting it to a
value lower than INT_MAX but higher than NR_CPUS produces the following
error on reboot and shutdown:

    BUG: unable to handle page fault for address: ffffffff90ab1bb0
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1c09067 P4D 1c09067 PUD 1c0a063 PMD 0
    Oops: 0000 [#1] SMP
    CPU: 1 PID: 1 Comm: systemd-shutdow Not tainted 5.9.0-rc8-kvm #110
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
    RIP: 0010:migrate_to_reboot_cpu+0xe/0x60
    Code: ea ea 00 48 89 fa 48 c7 c7 30 57 f1 81 e9 fa ef ff ff 66 2e 0f 1f 84 00 00 00 00 00 53 8b 1d d5 ea ea 00 e8 14 33 fe ff 89 da <48> 0f a3 15 ea fc bd 00 48 89 d0 73 29 89 c2 c1 e8 06 65 48 8b 3c
    RSP: 0018:ffffc90000013e08 EFLAGS: 00010246
    RAX: ffff88801f0a0000 RBX: 0000000077359400 RCX: 0000000000000000
    RDX: 0000000077359400 RSI: 0000000000000002 RDI: ffffffff81c199e0
    RBP: ffffffff81c1e3c0 R08: ffff88801f41f000 R09: ffffffff81c1e348
    R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
    R13: 00007f32bedf8830 R14: 00000000fee1dead R15: 0000000000000000
    FS:  00007f32bedf8980(0000) GS:ffff88801f480000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffff90ab1bb0 CR3: 000000001d057000 CR4: 00000000000006a0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
      __do_sys_reboot.cold+0x34/0x5b
      do_syscall_64+0x2d/0x40

Fixes: 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201103214025.116799-3-mcroce@linux.microsoft.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[sudip: use reboot_mode instead of mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/reboot.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index db0eed5916d5..45bea54f9aee 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -546,6 +546,13 @@ static int __init reboot_setup(char *str)
 				reboot_cpu = simple_strtoul(str+3, NULL, 0);
 			else
 				reboot_mode = REBOOT_SOFT;
+			if (reboot_cpu >= num_possible_cpus()) {
+				pr_err("Ignoring the CPU number in reboot= option. "
+				       "CPU %d exceeds possible cpu number %d\n",
+				       reboot_cpu, num_possible_cpus());
+				reboot_cpu = 0;
+				break;
+			}
 			break;
 
 		case 'g':
-- 
2.11.0


--p2z25eca4lzhz34s--
