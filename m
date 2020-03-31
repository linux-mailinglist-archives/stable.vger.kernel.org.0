Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9B199EE4
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 21:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgCaTZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 15:25:20 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46401 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgCaTZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 15:25:20 -0400
Received: by mail-ot1-f65.google.com with SMTP id 111so23290257oth.13;
        Tue, 31 Mar 2020 12:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=7LqlyO0sBVCp3qqMELPy+Cw9S+9K5Fr/pLVqCZqCgbk=;
        b=f9amOu6KnOtlbqoKEiOkcUpnIbMt66RBX6/qcUZLLU4p4/EkyxV/F+66E2YEdVxM5B
         q9ljZzKFngBVKFEr4xCr5JmqIWT6S6fxIQCuIdL5+B0PPAyP4nIcbPLu2/G6Zvl9OE/g
         jKb+HT/TfYm2POSEKPDVP+6OZeq8PohjlSsM9sOXlSHfjCT1yqsIowaO4HQ5sIhb2rNS
         kVkehDM3bwjYFW/BMBiMSAfHfEAMm4dKjGnHFyOEFExCmRaQhqU2r0maO7iK2TIlKSOT
         OpTvY0GEIOtE1c7WAP1JHnzbMjkCM7vqkJB2Pf5C4Wvmy5HC6BfPrx7WPICGrrrQfi/8
         anlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7LqlyO0sBVCp3qqMELPy+Cw9S+9K5Fr/pLVqCZqCgbk=;
        b=TQc8XMin5NpCyjZSqYOhKPbe8XqURF+/EuzfgFIAgqfIIMh8zGZq2xp/h/9l+kalFc
         w1JRgJQfBJMTC3OT6ADX+GWP6/CEAWDfy9kAPrm5axafq42358hXLnbTbQQKnoEFlgTW
         Nce4DgP3ywS8D7MFy5r8a+BfNRYy+gXd/8338weHu7buivarIiK2RJrTi301woJNMsdk
         mP/zF74OY/BECfSKBNzXYN/f7Uq2tixZjdTCds8fdsZc+i7l1yRcw5OohnyAyyzo9bY1
         V1nY8AIxSifwQ8eFJLZT5VxcsELcmEr2Tn86N/E0SnCR2Mvfbd6h/VG2jR294WoTYWyB
         F6dQ==
X-Gm-Message-State: ANhLgQ29EBvWfyj6tozfPFJdPWPkk7jfCObanGGa4NaWsg5TD1XkZQcf
        x5RnTwUk34VymncFeYCjX6/3IKFmDpU=
X-Google-Smtp-Source: ADFU+vt1lSToLejZ0FodgvfZBT0DKmAYzVGkrt/D1UDkhlQ/9V5Q6msKtCKILbO/n58tByc5/x5j4A==
X-Received: by 2002:a9d:5545:: with SMTP id h5mr14690011oti.323.1585682718048;
        Tue, 31 Mar 2020 12:25:18 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id d185sm289221oob.16.2020.03.31.12.25.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Mar 2020 12:25:16 -0700 (PDT)
Date:   Tue, 31 Mar 2020 12:25:15 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dirk =?iso-8859-1?Q?M=FCller?= <dmueller@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200331192515.GA39354@ubuntu-m2-xlarge-x86>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
 <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
 <20200331100238.GA1204199@kroah.com>
 <5B6493BE-F9FE-41A4-A88A-5E4DF5BCE098@suse.com>
 <20200331120917.GA1617997@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200331120917.GA1617997@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 31, 2020 at 02:09:17PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Mar 31, 2020 at 01:45:09PM +0200, Dirk Müller wrote:
> > Hi Greg,
> > 
> > >> $ sed -i 's;scripts/dtc/dtc-lexer.l;scripts/dtc/dtc-lexer.lex.c_shipped;g' \
> > >> queue-{4.4,4.9,4.14}/scripts-dtc-remove-redundant-yyloc-global-declaration.patch
> > >> If you would prefer a set of patches, let me know.
> > > Should I just drop the patch from 4.4, 4.9, and 4.14 instead?
> > 
> > as the original author of the patch, I am not sure why it was backported to the LTS releases (unless enablement for gcc 10.x or
> > other new toolchains is a requirement, which I'm not aware of). 

The reason I am commenting on this is that Clang 11 is matching GCC's
-fno-common change. Google will run into this when they do their
toolchain uprev on Android (sooner rather than later) so it'd be good
to deal with this now:

https://android.googlesource.com/kernel/build/+/refs/heads/master/build.sh#226

Their devices back to 4.4 see builds with newer and newer toolchains so
we need this back to 4.4. I am sure Chrome OS will also run into this
shortly as well.

> > However I think the sed above on the *patch* means that the patch will *only* modify the generated sources, not the input sources. I think
> > it would be better to patch both *input* and *generated* sources, or backport the generate-at-runtime patch as well (which might be
> > even further outside the stable policy). 
> 
> What do you mean by "input sources" here?

dtc-lexer.l is the input source for dtc-lexer.lex.c, which was then
copied to dtc-lexer.lex.c_shipped prior to e039139be8c2 ("scripts/dtc:
generate lexer and parser during build instead of shipping"). In other
words, prior to 4.17, dtc-lexer.l is not used at all in the build
system.

However, I agree with Dirk that it would be most proper to apply the fix
to both dtc-lexer.l and dtc-lexer.lex.c_shipped so I have attached a
backport for 4.4, 4.9, and 4.14 that has does just that.

> > Not knowing why it was backported, I would suggest to just dequeue the patch from the older trees. 
> 
> If I drop it for now, I'll have to add it back when gcc10 is pushed out
> to my build systems and laptops :(
> 
> thanks,
> 
> greg k-h

Hope this makes sense/isn't confusing.

Cheers,
Nathan

--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="4.4-0001-scripts-dtc-Remove-redundant-YYLOC-global-declaratio.patch"

From c5607dedb1e9636e76c8d026b5209c54a52087d2 Mon Sep 17 00:00:00 2001
From: Dirk Mueller <dmueller@suse.com>
Date: Tue, 14 Jan 2020 18:53:41 +0100
Subject: [PATCH 4.4] scripts/dtc: Remove redundant YYLOC global declaration

commit e33a814e772cdc36436c8c188d8c42d019fda639 upstream.

gcc 10 will default to -fno-common, which causes this error at link
time:

  (.text+0x0): multiple definition of `yylloc'; dtc-lexer.lex.o (symbol from plugin):(.text+0x0): first defined here

This is because both dtc-lexer as well as dtc-parser define the same
global symbol yyloc. Before with -fcommon those were merged into one
defintion. The proper solution would be to to mark this as "extern",
however that leads to:

  dtc-lexer.l:26:16: error: redundant redeclaration of 'yylloc' [-Werror=redundant-decls]
   26 | extern YYLTYPE yylloc;
      |                ^~~~~~
In file included from dtc-lexer.l:24:
dtc-parser.tab.h:127:16: note: previous declaration of 'yylloc' was here
  127 | extern YYLTYPE yylloc;
      |                ^~~~~~
cc1: all warnings being treated as errors

which means the declaration is completely redundant and can just be
dropped.

Signed-off-by: Dirk Mueller <dmueller@suse.com>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
[robh: cherry-pick from upstream]
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
[nc: Also apply to dtc-lexer.lex.c_shipped due to a lack of
     e039139be8c2, where dtc-lexer.l started being used]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 scripts/dtc/dtc-lexer.l             | 1 -
 scripts/dtc/dtc-lexer.lex.c_shipped | 1 -
 2 files changed, 2 deletions(-)

diff --git a/scripts/dtc/dtc-lexer.l b/scripts/dtc/dtc-lexer.l
index 790fbf6cf2d7..e4e0f6a8d07b 100644
--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -38,7 +38,6 @@ LINECOMMENT	"//".*\n
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
diff --git a/scripts/dtc/dtc-lexer.lex.c_shipped b/scripts/dtc/dtc-lexer.lex.c_shipped
index ba525c2f9fc2..750f7a4e3ece 100644
--- a/scripts/dtc/dtc-lexer.lex.c_shipped
+++ b/scripts/dtc/dtc-lexer.lex.c_shipped
@@ -637,7 +637,6 @@ char *yytext;
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
-- 
2.26.0


--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="4.9-0001-scripts-dtc-Remove-redundant-YYLOC-global-declaratio.patch"

From c5607dedb1e9636e76c8d026b5209c54a52087d2 Mon Sep 17 00:00:00 2001
From: Dirk Mueller <dmueller@suse.com>
Date: Tue, 14 Jan 2020 18:53:41 +0100
Subject: [PATCH 4.9] scripts/dtc: Remove redundant YYLOC global declaration

commit e33a814e772cdc36436c8c188d8c42d019fda639 upstream.

gcc 10 will default to -fno-common, which causes this error at link
time:

  (.text+0x0): multiple definition of `yylloc'; dtc-lexer.lex.o (symbol from plugin):(.text+0x0): first defined here

This is because both dtc-lexer as well as dtc-parser define the same
global symbol yyloc. Before with -fcommon those were merged into one
defintion. The proper solution would be to to mark this as "extern",
however that leads to:

  dtc-lexer.l:26:16: error: redundant redeclaration of 'yylloc' [-Werror=redundant-decls]
   26 | extern YYLTYPE yylloc;
      |                ^~~~~~
In file included from dtc-lexer.l:24:
dtc-parser.tab.h:127:16: note: previous declaration of 'yylloc' was here
  127 | extern YYLTYPE yylloc;
      |                ^~~~~~
cc1: all warnings being treated as errors

which means the declaration is completely redundant and can just be
dropped.

Signed-off-by: Dirk Mueller <dmueller@suse.com>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
[robh: cherry-pick from upstream]
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
[nc: Also apply to dtc-lexer.lex.c_shipped due to a lack of
     e039139be8c2, where dtc-lexer.l started being used]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 scripts/dtc/dtc-lexer.l             | 1 -
 scripts/dtc/dtc-lexer.lex.c_shipped | 1 -
 2 files changed, 2 deletions(-)

diff --git a/scripts/dtc/dtc-lexer.l b/scripts/dtc/dtc-lexer.l
index 790fbf6cf2d7..e4e0f6a8d07b 100644
--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -38,7 +38,6 @@ LINECOMMENT	"//".*\n
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
diff --git a/scripts/dtc/dtc-lexer.lex.c_shipped b/scripts/dtc/dtc-lexer.lex.c_shipped
index ba525c2f9fc2..750f7a4e3ece 100644
--- a/scripts/dtc/dtc-lexer.lex.c_shipped
+++ b/scripts/dtc/dtc-lexer.lex.c_shipped
@@ -637,7 +637,6 @@ char *yytext;
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
-- 
2.26.0


--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="4.14-0001-scripts-dtc-Remove-redundant-YYLOC-global-declaratio.patch"

From c5607dedb1e9636e76c8d026b5209c54a52087d2 Mon Sep 17 00:00:00 2001
From: Dirk Mueller <dmueller@suse.com>
Date: Tue, 14 Jan 2020 18:53:41 +0100
Subject: [PATCH 4.14] scripts/dtc: Remove redundant YYLOC global declaration

commit e33a814e772cdc36436c8c188d8c42d019fda639 upstream.

gcc 10 will default to -fno-common, which causes this error at link
time:

  (.text+0x0): multiple definition of `yylloc'; dtc-lexer.lex.o (symbol from plugin):(.text+0x0): first defined here

This is because both dtc-lexer as well as dtc-parser define the same
global symbol yyloc. Before with -fcommon those were merged into one
defintion. The proper solution would be to to mark this as "extern",
however that leads to:

  dtc-lexer.l:26:16: error: redundant redeclaration of 'yylloc' [-Werror=redundant-decls]
   26 | extern YYLTYPE yylloc;
      |                ^~~~~~
In file included from dtc-lexer.l:24:
dtc-parser.tab.h:127:16: note: previous declaration of 'yylloc' was here
  127 | extern YYLTYPE yylloc;
      |                ^~~~~~
cc1: all warnings being treated as errors

which means the declaration is completely redundant and can just be
dropped.

Signed-off-by: Dirk Mueller <dmueller@suse.com>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
[robh: cherry-pick from upstream]
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
[nc: Also apply to dtc-lexer.lex.c_shipped due to a lack of
     e039139be8c2, where dtc-lexer.l started being used]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 scripts/dtc/dtc-lexer.l             | 1 -
 scripts/dtc/dtc-lexer.lex.c_shipped | 1 -
 2 files changed, 2 deletions(-)

diff --git a/scripts/dtc/dtc-lexer.l b/scripts/dtc/dtc-lexer.l
index 790fbf6cf2d7..e4e0f6a8d07b 100644
--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -38,7 +38,6 @@ LINECOMMENT	"//".*\n
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
diff --git a/scripts/dtc/dtc-lexer.lex.c_shipped b/scripts/dtc/dtc-lexer.lex.c_shipped
index ba525c2f9fc2..750f7a4e3ece 100644
--- a/scripts/dtc/dtc-lexer.lex.c_shipped
+++ b/scripts/dtc/dtc-lexer.lex.c_shipped
@@ -637,7 +637,6 @@ char *yytext;
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
 
-YYLTYPE yylloc;
 extern bool treesource_error;
 
 /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
-- 
2.26.0


--17pEHd4RhPHOinZp--
