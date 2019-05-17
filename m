Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B22212C4
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 06:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfEQEJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 00:09:10 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35515 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfEQEJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 00:09:10 -0400
Received: by mail-ed1-f66.google.com with SMTP id p26so8509710edr.2
        for <stable@vger.kernel.org>; Thu, 16 May 2019 21:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jfFKXhOnkiykJ+MAf5Zb6Ek7Ns8pTr5qBTpn7ZCIaYY=;
        b=t6uRF1W30Yr993kHyJktuRNMc50p7JYDa+ts53qE7ZGgGjc5seNiE8h4ppImtQQt2A
         NPE1p3IyZca/vc3hhnAYbFsTQukqfT7JRSOyf6KaO+0YAxr6xqQ2QYVvsSVWu2MjoL6l
         4FGhWXLGPd9pFxeVPHPRsnfuzSkTFrYhtY49qttc0M2ZRyUNSXHblsYCqDR5gpIC3ZZv
         kah7JCVACHFQOkN04A0RmFdg7l0PNY9A0U6dzgcrxpUE9C5VyZjAPrA9opszwBWbis+Q
         F8e556d8prLxOyFir759c7QQpUMKZQq60h0GjYRX3iZTTzI/OGczgGR43Nb4Uxw7Ae5L
         6odw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jfFKXhOnkiykJ+MAf5Zb6Ek7Ns8pTr5qBTpn7ZCIaYY=;
        b=ZRQp+/oEBYtjvptWlAb+QUYDcMA15FOmMG1ZkqpFL5LKik+HU8S/I2yzAfjY4MzVHM
         6B1Z17GSM2uA0Y3AEIm0VG8K/axwTvEsA5NFC/oeAz8cGCKq6gNIelwWWpYeDbzvfKXe
         EiC9o5+AyjszjhiWtDh2KmmY7n/3qo2KqHx9cVwYb45T2aB+Z0oyyVxLayvTPbBzqisu
         g+9yClSV30S4YJMYLukoFZxotBzg02TCt+BQeyOmPIDKMponFnsjAnNc4Z/6kP9AZUeh
         RCsO1Kr0AsvTFIisrqYXwRa/06jAZqgxyhob+Ky98RGe8KoittNc1NCwZiF5URSP5mql
         C1aQ==
X-Gm-Message-State: APjAAAXNc+3BNgoYbLSRc7oujw/Zo1R4C/VJVgoSJ8nP2fhUAszSViyG
        wA0X/GGRTVqJ/7secy84yrg=
X-Google-Smtp-Source: APXvYqx3bjAspXNYlWyUBdLY4bCYTwTnUCRWkdf1JQ6sTl4Q7UszdBPWZVaikYi64PPlNo+d5J5iHA==
X-Received: by 2002:a17:906:7c42:: with SMTP id g2mr1418729ejp.168.1558066147792;
        Thu, 16 May 2019 21:09:07 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id y5sm1338298ejc.41.2019.05.16.21.09.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 21:09:07 -0700 (PDT)
Date:   Thu, 16 May 2019 21:09:05 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        gregkh@linuxfoundation.org, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] lkdtm: support llvm-objcopy
Message-ID: <20190517040905.GA14524@archlinux-epyc>
References: <20190515182441.30990-1-ndesaulniers@google.com>
 <20190517001002.D1A262084A@mail.kernel.org>
 <20190517040613.GA13981@archlinux-epyc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20190517040613.GA13981@archlinux-epyc>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2019 at 09:06:13PM -0700, Nathan Chancellor wrote:
> On Fri, May 17, 2019 at 12:10:02AM +0000, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: all
> 
> Nick, the stable tag should probably specify 4.8+ since the commit it
> fixes came in during 4.8-rc1.
> 
> Cc: stable@vger.kernel.org # 4.8+
> 
> Might also help to add:
> 
> Fixes: 9a49a528dcf3 ("lkdtm: add function for testing .rodata section")
> 
> > 
> > The bot has tested the following trees: v5.1.2, v5.0.16, v4.19.43, v4.14.119, v4.9.176, v4.4.179, v3.18.140.
> > 
> > v5.1.2: Build OK!
> > v5.0.16: Build OK!
> > v4.19.43: Build OK!
> > v4.14.119: Failed to apply! Possible dependencies:
> >     039a1c42058d ("lkdtm: Relocate code to subdirectory")
> 
> However, it will still need a manual backport because of the lack of
> this commit. I've attached the current patch backported for reference,

Would help if I actually did this... :^)

> the git am flags '-3 -p4 --directory=drivers/misc' help get it proper
> then the conflict is rather easy to resolve.
> 
> Thanks,
> Nathan

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-lkdtm-support-llvm-objcopy.patch"

From 10c0a74a8d92669b91b66efe6b72550fc24e8e7d Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 15 May 2019 11:24:41 -0700
Subject: [PATCH] lkdtm: support llvm-objcopy

With CONFIG_LKDTM=y and make OBJCOPY=llvm-objcopy, llvm-objcopy errors:
llvm-objcopy: error: --set-section-flags=.text conflicts with
--rename-section=.text=.rodata

Rather than support setting flags then renaming sections vs renaming
then setting flags, it's simpler to just change both at the same time
via --rename-section. Adding the load flag is required for GNU objcopy
to mark .rodata Type as PROGBITS after the rename.

This can be verified with:
$ readelf -S drivers/misc/lkdtm/rodata_objcopy.o
...
Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
...
  [ 1] .rodata           PROGBITS         0000000000000000  00000040
       0000000000000004  0000000000000000   A       0     0     4
...

Which shows that .text is now renamed .rodata, the alloc flag A is set,
the type is PROGBITS, and the section is not flagged as writeable W.

Cc: stable@vger.kernel.org
Link: https://sourceware.org/bugzilla/show_bug.cgi?id=24554
Link: https://github.com/ClangBuiltLinux/linux/issues/448
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Alan Modra <amodra@gmail.com>
Suggested-by: Jordan Rupprect <rupprecht@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/misc/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c3c8624f4d95..805835c2b99b 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -70,8 +70,7 @@ KCOV_INSTRUMENT_lkdtm_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
-			--set-section-flags .text=alloc,readonly \
-			--rename-section .text=.rodata
+			--rename-section .text=.rodata,alloc,readonly,load
 targets += lkdtm_rodata.o lkdtm_rodata_objcopy.o
 $(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o FORCE
 	$(call if_changed,objcopy)
-- 
2.22.0.rc0


--M9NhX3UHpAaciwkO--
