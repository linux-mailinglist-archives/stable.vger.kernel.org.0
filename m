Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0054C9F6
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 15:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348757AbiFONiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 09:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242679AbiFONiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 09:38:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B4B31DCA;
        Wed, 15 Jun 2022 06:38:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DEFAA21C44;
        Wed, 15 Jun 2022 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655300331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRf509T1oRK4yAOPZ+TH87cWnsf7bqUhAO6sxp3Z7Zo=;
        b=X1S4Mz1monIEhnTtE3x88V5SVsE69r9OWioCNaGfHuO1FH+mnzMStVf+pOrMWHhDZnxazQ
        QCoUiCNJ9u5XI78g/1gfJx5X4SsK+T2ErCBWP2eejjIsYNqbXAsLWspLf4Z3FZZ+tNPmMp
        3qxGm1PnKritPJJ0o+XgSDDoYNcOXDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655300331;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRf509T1oRK4yAOPZ+TH87cWnsf7bqUhAO6sxp3Z7Zo=;
        b=NIAAOy1v2YauB5LGrIoivNNpjoGUmuQJt9B02jRf2xN6ETIWJxkousWtqmX5eWEY++Qu+3
        yMEcVJY11LIMohCQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9B2672C141;
        Wed, 15 Jun 2022 13:38:51 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id BAF43A062E; Wed, 15 Jun 2022 15:38:45 +0200 (CEST)
Date:   Wed, 15 Jun 2022 15:38:45 +0200
From:   Jan Kara <jack@suse.cz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, Jan Kara <jack@suse.cz>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220615133845.o2lzfe5s4dzdfvtg@quack3.lan>
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
 <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
 <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
 <20220615110022.yifrsvzxjsz2wky5@quack3.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3vfcndmpumrrlvst"
Content-Disposition: inline
In-Reply-To: <20220615110022.yifrsvzxjsz2wky5@quack3.lan>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3vfcndmpumrrlvst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 15-06-22 13:00:22, Jan Kara wrote:
> On Tue 14-06-22 12:00:22, Linus Torvalds wrote:
> > On Tue, Jun 14, 2022 at 11:51 AM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Or just make sure that noop_backing_dev_info is fully initialized
> > > before it's used.
> > 
> > I don't see any real reason why that
> > 
> >     err = bdi_init(&noop_backing_dev_info);
> > 
> > couldn't just be done very early. Maybe as the first call in
> > driver_init(), before the whole devtmpfs_init() etc.
> 
> I've checked the dependencies and cgroups (which are the only non-trivial
> dependency besides per-CPU infrastructure) are initialized early enough so
> it should work fine. So let's try that.

Attached patch boots for me. Guys, who was able to reproduce the failure: Can
you please confirm this patch fixes your problem?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--3vfcndmpumrrlvst
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-init-Initialized-noop_backing_dev_info-early.patch"

From 8f998b182be7563fc92aa8914cc7d21f75a3c20e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 15 Jun 2022 15:22:29 +0200
Subject: [PATCH] init: Initialized noop_backing_dev_info early

noop_backing_dev_info is used by superblocks of various
pseudofilesystems such as kdevtmpfs. Initialize it before the
filesystems get mounted.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/base/init.c         |  2 ++
 include/linux/backing-dev.h |  2 ++
 mm/backing-dev.c            | 11 ++---------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/base/init.c b/drivers/base/init.c
index d8d0fe687111..397eb9880cec 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/memory.h>
 #include <linux/of.h>
+#include <linux/backing-dev.h>
 
 #include "base.h"
 
@@ -20,6 +21,7 @@
 void __init driver_init(void)
 {
 	/* These are the core pieces */
+	bdi_init(&noop_backing_dev_info);
 	devtmpfs_init();
 	devices_init();
 	buses_init();
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2bd073fa6bb5..f0baef68f90f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -119,6 +119,8 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 extern struct backing_dev_info noop_backing_dev_info;
 
+extern int bdi_init(struct backing_dev_info *bdi);
+
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @wb: bdi_writeback of interest
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ff60bd7d74e0..95550b8fa7fe 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -231,20 +231,13 @@ static __init int bdi_class_init(void)
 }
 postcore_initcall(bdi_class_init);
 
-static int bdi_init(struct backing_dev_info *bdi);
-
 static int __init default_bdi_init(void)
 {
-	int err;
-
 	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_UNBOUND |
 				 WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
-
-	err = bdi_init(&noop_backing_dev_info);
-
-	return err;
+	return 0;
 }
 subsys_initcall(default_bdi_init);
 
@@ -781,7 +774,7 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-static int bdi_init(struct backing_dev_info *bdi)
+int bdi_init(struct backing_dev_info *bdi)
 {
 	int ret;
 
-- 
2.35.3


--3vfcndmpumrrlvst--
