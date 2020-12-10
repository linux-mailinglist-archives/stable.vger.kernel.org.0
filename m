Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66012D5C5A
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgLJNvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgLJNvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 08:51:47 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C908C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:51:07 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id y23so5403530wmi.1
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JR3gn0ZQBDUTTYM97tfuvaF4h/67IAtG9iDjWe36kwg=;
        b=aIOmIhG4gcboBLAYSDN62ZmJ4HclG34tw6t08jE0ZXn+8hXcNO8RaDgpQciu1dUgGD
         epba/sTEX908553vw+BhsMQ9hCZm6aXJQz6MoXlU/izpzfYW0EZGNpkTe7QfP/TIwoQ3
         dol/cEzhN9GuTVkh/UMKi4neYMDtcmh3VU5IuteFQNe6oYtoN47znu0evUc2pfPM0vrI
         eFy75HBP2Fz1B6U7SuETm5H2qACqybBNZd9B5MyannYK4Ckh95nwTZt4o6o3qd8mJSQK
         mR/hOPgzn2hLtFp14S8tycp8Ejm9yhMjaELP1p3XoylU6rWLM9kBHkwzM9NgnZk4NBez
         cjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JR3gn0ZQBDUTTYM97tfuvaF4h/67IAtG9iDjWe36kwg=;
        b=IUY0DwhinyTPCCjRoXnqX9vqKAUTHgQ36FV3M4tE8jiaicNUxZ4xo4nx1gV/4XbTZT
         vvZrNp8JsIPNBtYcJQ+OLSRJTjoK09umOeN/iHkXFjc+82sUesKIKkqBwuLacV258Q//
         UV2dPO7UwfKezAzyEM1yNUutSsbV4ReGM7qK1oHCFnPr4nFBM6VoAupqN498jNqclNR7
         SalLdj4DJtUr+3CO7NThxOaMM+5fboQDG5Fw7hJ8dUtPS3hWeh0FGhaScdBV41U0Byxf
         36FuXRBshVFsIOa0Y3gYZOnXTDlkWiIhGZE2qtJGiZckg5LKQF5puAeZbiftE8dF0tcP
         HjgA==
X-Gm-Message-State: AOAM533lxXbMY+34zenQ4+vy7AfAm2dGJ/NGemtvcEFO8ypAcWY9Pg2/
        Fqz5ilQSSDtFUz7kjB9Y2c8=
X-Google-Smtp-Source: ABdhPJw4qEdTMDhpdMiqcgpQOiCzL8ehE/lK3Rtwsg4guY/8DE+r7WUyOKRog0/wUudcHxVYe5HFXA==
X-Received: by 2002:a1c:bc41:: with SMTP id m62mr8475561wmf.46.1607608265765;
        Thu, 10 Dec 2020 05:51:05 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id z11sm9177783wmc.39.2020.12.10.05.51.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 05:51:05 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:51:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/insn-eval: Use new
 for_each_insn_prefix() macro to loop" failed to apply to 5.9-stable tree
Message-ID: <20201210135103.hwvk6inj4t3bqinq@debian>
References: <1607503687153242@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ayhc2pty574gm73c"
Content-Disposition: inline
In-Reply-To: <1607503687153242@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ayhc2pty574gm73c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Dec 09, 2020 at 09:48:07AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will apply to all branches till 4.19-stable.

--
Regards
Sudip

--ayhc2pty574gm73c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-insn-eval-Use-new-for_each_insn_prefix-macro-to-.patch"

From 948726feb2ca94059d75f09ee5b4f78343f9d2d8 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 3 Dec 2020 13:50:50 +0900
Subject: [PATCH] x86/insn-eval: Use new for_each_insn_prefix() macro to loop over prefixes bytes

commit 12cb908a11b2544b5f53e9af856e6b6a90ed5533 upstream

Since insn.prefixes.nbytes can be bigger than the size of
insn.prefixes.bytes[] when a prefix is repeated, the proper check must
be

  insn.prefixes.bytes[i] != 0 and i < 4

instead of using insn.prefixes.nbytes. Use the new
for_each_insn_prefix() macro which does it correctly.

Debugged by Kees Cook <keescook@chromium.org>.

 [ bp: Massage commit message. ]

Fixes: 32d0b95300db ("x86/insn-eval: Add utility functions to get segment selector")
Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/160697104969.3146288.16329307586428270032.stgit@devnote2
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/lib/insn-eval.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 5e69603ff63f..694f32845116 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -70,14 +70,15 @@ static int get_seg_reg_override_idx(struct insn *insn)
 {
 	int idx = INAT_SEG_REG_DEFAULT;
 	int num_overrides = 0, i;
+	insn_byte_t p;
 
 	insn_get_prefixes(insn);
 
 	/* Look for any segment override prefixes. */
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
+	for_each_insn_prefix(insn, i, p) {
 		insn_attr_t attr;
 
-		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		attr = inat_get_opcode_attribute(p);
 		switch (attr) {
 		case INAT_MAKE_PREFIX(INAT_PFX_CS):
 			idx = INAT_SEG_REG_CS;
-- 
2.11.0


--ayhc2pty574gm73c--
