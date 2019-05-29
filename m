Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD712E200
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE2QJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 12:09:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33603 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfE2QJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 12:09:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so4589271wmh.0
        for <stable@vger.kernel.org>; Wed, 29 May 2019 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:reply-to:to:subject:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=KcKhsPPPXFNuhAcbUhz+edyIE/IB7k/wW7fNdmpvqzU=;
        b=ZAQO8en2jOmX5kYZSS7jUqYG/qxR9hW+dA6uRavgqCF+hXqEhW2FS0qYWxmzwCrlb9
         bIG0zDlT4ijGcKDifgIYeE35QqHhIVW+nmNie/aBo4OT3IjpKMXxqaH4Xmv88H+ycDdh
         0cD1xzUGuB+aQ1mhWKtOCDOtPQdk30G4a3Prurj9/qp/2KWM0GVMNESkVC3qF/AmPX84
         JBdfJ64/Kk4j6qvSTwjfBnpMRDa/U20wG/V6OjY0MtTFykLhpJMVncbWC6vnO8W/wjWb
         KR593U/bUsTA4pYsrBcdGyjdztFrE9/trREwRrbo1wFw/Th9WO6Fe8G8dlcOfwM1DRZ+
         UPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:reply-to:to:subject:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=KcKhsPPPXFNuhAcbUhz+edyIE/IB7k/wW7fNdmpvqzU=;
        b=Miw57h/EGIWdiXJFIkXSDjJUiXBqyoSUQ1AQjz2GDPftRi007xW2i7x4xDFrb36sp8
         gzBkKN7f+v8hPsFyKDMS0j48U0xXSzImkVH2IaFTOMPOmEc0bRNeab5CRl9CChgit/FM
         EOZv5Q8t5bcjpOGWP+VO8c8A59a2+0+iPs61AQpQpFQG0FDrbzJD1ZV82IBGjzwTwhUV
         m5xMFvC8SIV8y57oKIHYix4ncTwvdBuD32Us7d5Zk9TjiMQvdPZp4W8Wk/VB6cNKCFEm
         /q0pK89u7NaPHgk9irbqiasWDQFTsRKPcJeVYI5Geuue6B071ZRCldCYCNuMR4ywc5DQ
         e7oA==
X-Gm-Message-State: APjAAAXBu397NgNKE2KBTptJotoiLa15vEPITQp5/7/jiJ6ELG4xnGXM
        p/WhbBZaVjWyye2tcpR7EghsLhgR
X-Google-Smtp-Source: APXvYqzCaX66eRjlvxJq8/JwV4kHN6JywynH/Cj+ALpVYJIzI7cjXHp9j3paErDeRGiiL1OKzEcdFQ==
X-Received: by 2002:a1c:1bc1:: with SMTP id b184mr1621709wmb.42.1559146161283;
        Wed, 29 May 2019 09:09:21 -0700 (PDT)
Received: from Duo2.localdomain (host-2-100-9-62.as13285.net. [2.100.9.62])
        by smtp.gmail.com with ESMTPSA id n4sm21037006wrp.61.2019.05.29.09.09.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 09:09:20 -0700 (PDT)
X-Google-Original-Sender: Alan Bartlett <ajb@elrepo.org>
Received: by Duo2.localdomain (Postfix, from userid 500)
        id 65D0512077F; Wed, 29 May 2019 17:09:18 +0100 (BST)
Date:   Wed, 29 May 2019 17:09:18 +0100
From:   Alan Bartlett <ajb@elrepo.org>
Reply-To: Alan Bartlett <ajb@elrepo.org>
To:     stable@vger.kernel.org
Subject: [PATCH] Tools: turbostat. Build Failure. Both -4.4.180 & -4.9.179
Message-ID: <5ceeaeae.HOKUUPqGXxKYyHox%ajb@elrepo.org>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Please CC me, as I am not subscribed to the list.]

Attempting to build the tools/power/x86/turbostat/ binary fails:

[linux-4.4.180]$ make -C tools/power/x86/turbostat/
make: Entering directory `/linux-stable/linux-4.4.180/tools/power/x86/turbostat'
gcc -Wall -I../../../include -DMSRHEADER='"../../../../arch/x86/include/asm/msr-index.h"' turbostat.c -o /linux-stable/linux-4.4.180/tools/power/x86/turbostat/turbostat
In file included from turbostat.c:23:0:
../../../../arch/x86/include/asm/msr-index.h:4:24: fatal error: linux/bits.h: No such file or directory
 #include <linux/bits.h>
                        ^
compilation terminated.
make: *** [turbostat] Error 1
make: Leaving directory `/linux-stable/linux-4.4.180/tools/power/x86/turbostat'
[linux-4.4.180]$ 

A bisection showed:

683f9fba8c27817b6c2f7320a4095ca353022651 is the first bad commit
commit 683f9fba8c27817b6c2f7320a4095ca353022651
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Feb 21 12:36:50 2019 +0100

    x86/msr-index: Cleanup bit defines
    
    commit d8eabc37310a92df40d07c5a8afc53cebf996716 upstream.
    
    Greg pointed out that speculation related bit defines are using (1 << N)
    format instead of BIT(N). Aside of that (1 << N) is wrong as it should use
    1UL at least.
    
    Clean it up.
    
    [ Josh Poimboeuf: Fix tools build ]
    
    Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Reviewed-by: Borislav Petkov <bp@suse.de>
    Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
    Reviewed-by: Jon Masters <jcm@redhat.com>
    Tested-by: Jon Masters <jcm@redhat.com>
    [bwh: Backported to 4.4:
     - Drop change to x86_energy_perf_policy, which doesn't use msr-index.h here
     - Drop changes to flush MSRs which we haven't defined]
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 0ce430a14e73eef1007bf1558693e75e95ffe39a 3ab5675ed0798fc61e7d67ade87ac58dbbf33756 M	arch
:040000 040000 d45f1a90570a44d8924711e56280cde7041328de c603a03d7801225fb15869d1386224f793f1ba1d M	tools

Fix by modifying the turbostat/Makefile CFLAGS
and one #include line of the turbostat.c file.

Signed-off-by: Alan Bartlett <ajb@elrepo.org>
Tested-by: Akemi Yagi <toracat@elrepo.org>
Reviewed-by: Philip J Perry <phil@elrepo.org>

---

diff -Npru a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
--- a/tools/power/x86/turbostat/Makefile	2019-05-16 13:45:18.000000000 -0400
+++ b/tools/power/x86/turbostat/Makefile	2019-05-21 10:19:21.580477034 -0400
@@ -8,8 +8,7 @@ ifeq ("$(origin O)", "command line")
 endif
 
 turbostat : turbostat.c
-CFLAGS +=	-Wall -I../../../include
-CFLAGS +=	-DMSRHEADER='"../../../../arch/x86/include/asm/msr-index.h"'
+CFLAGS +=	-Wall
 
 %: %.c
 	@mkdir -p $(BUILD_OUTPUT)
diff -Npru a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
--- a/tools/power/x86/turbostat/turbostat.c	2019-05-16 13:45:18.000000000 -0400
+++ b/tools/power/x86/turbostat/turbostat.c	2019-05-21 10:29:58.007236178 -0400
@@ -20,7 +20,7 @@
  */
 
 #define _GNU_SOURCE
-#include MSRHEADER
+#include <asm/msr-index.h>
 #include <stdarg.h>
 #include <stdio.h>
 #include <err.h>

