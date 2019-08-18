Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3DB91993
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 22:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHRUol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 16:44:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37536 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfHRUol (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 16:44:41 -0400
Received: by mail-ed1-f68.google.com with SMTP id f22so9545358edt.4
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 13:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VCXL+lYvIbh8hZl+hUzgk+iPnS2VL7R4px9EDMflcGE=;
        b=E2zKH6pPbBU1sXzLrdJE8kSSqQWgylb3J/0ahiIEyFFq5AgVMQ5nibiB6fd2EQkPDm
         R7hGCR+31Ins2mc/0kb6ZAMjbAZXpoL76Tba9MgcHHUIylW3nwhXaqvYVa5h+myfNXjN
         brq6MylO7ECrgwIDZ6QC6plMmBsdblJsMLK+s31mcICicsLa4fBEswlV5RpdESFACiUI
         /0s6vsgec6cek8r4sszsxvFaPwrui+ESv9Unv/SHnx/ngH/13kB/a8grubMkuh8zqSmB
         P5N4tGAtX8NP3mVENdA0qaClKeaOLU/NSDDruBHHHtnIBmjNhP7COP3xajPurl+LIU0x
         k4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VCXL+lYvIbh8hZl+hUzgk+iPnS2VL7R4px9EDMflcGE=;
        b=laOEdVST5XLXz3VkXc9oB+UPM780F//EKC5SKLD2xFjsXdvKn4CWz73eWA6/wVXL/q
         vot6miuZS0RNrYWDbNJGwwFwD9epwMjiV5A/2jQsQ5LI8ofk/qOvJNzE5A786K19TtIr
         /EmBINfD2HbMXAJik/lRsTKHAZxVZkfu5B1mWDS+t6B0kxJ28Giaa26FGATmLRpigMGU
         7ynlMiVDZFWCDlILABtV2qi9UIP558MQqKgbh3oMkaxIyoMGxjAulM4iihGDypBxQEpW
         eUyPXTweqvSENieVYJsm4SrCc9E4eGz+D2uuzjR7ZrbypraarS0SfboTPDtltzs16jUm
         YR/g==
X-Gm-Message-State: APjAAAVNPzPVpG/Ih0Ve4klQk4fPi5+3Y8dOB1umrrZuzaWKJmY5z+Ls
        mJHFqD8hCdGUAMwi8or4YQ6R15OR0RA=
X-Google-Smtp-Source: APXvYqwRYx4aLeQfao88urJZzn0G9x06mJjJrBDsQZ4cebRqxjPNEo7Z6tY/KoSnrJivEcyEE1h3tA==
X-Received: by 2002:a05:6402:168f:: with SMTP id a15mr21804963edv.5.1566161078955;
        Sun, 18 Aug 2019 13:44:38 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id w19sm2360877edt.41.2019.08.18.13.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 13:44:37 -0700 (PDT)
Date:   Sun, 18 Aug 2019 22:44:36 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>,
        David Jeffery <djeffery@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Message-ID: <20190818204436.GA27437@eldamar.local>
References: <20190818155941.GA26766@eldamar.local>
 <20190818183305.GA1181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818183305.GA1181@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi Greg,

On Sun, Aug 18, 2019 at 08:33:05PM +0200, Greg Kroah-Hartman wrote:
> On Sun, Aug 18, 2019 at 05:59:41PM +0200, Salvatore Bonaccorso wrote:
> > Hi
> > 
> > In Debian bug https://bugs.debian.org/934331 ran into issues which
> > match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
> > underlying storage no longer supports it").
> > 
> > This commit was CC'ed to stable, but only got applied in v5.0.8 (and
> > later on backported by Ben Hutchings to v3.16.72).
> > 
> > Mike, I have not checked how easily that would be for older stable
> > versions, but can the backport be considered for versions down to 4.9?
> > Apparently Ben did succeed with some changes needed. To 4.19 it should
> > apply with a small conflict in drivers/md/dm-core.h AFAICS.
> 
> If someone sends the backports to the list, I will be glad to queue them
> up.

Here is the one for 4.19 on top of 4.19.67. It's my first contribution
on this regard. Given the change to be applied was only about the
context change in drivers/md/dm-core.h I'm unsure if the Signed-off-by
is the right addition to do as well.

Regards,
Salvatore

From 614c17258f0d952e1b979276c8a553893d3cd826 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 3 Apr 2019 12:23:11 -0400
Subject: [PATCH] dm: disable DISCARD if the underlying storage no longer
 supports it

commit bcb44433bba5eaff293888ef22ffa07f1f0347d6 upstream.

Storage devices which report supporting discard commands like
WRITE_SAME_16 with unmap, but reject discard commands sent to the
storage device.  This is a clear storage firmware bug but it doesn't
change the fact that should a program cause discards to be sent to a
multipath device layered on this buggy storage, all paths can end up
failed at the same time from the discards, causing possible I/O loss.

The first discard to a path will fail with Illegal Request, Invalid
field in cdb, e.g.:
 kernel: sd 8:0:8:19: [sdfn] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
 kernel: sd 8:0:8:19: [sdfn] tag#0 Sense Key : Illegal Request [current]
 kernel: sd 8:0:8:19: [sdfn] tag#0 Add. Sense: Invalid field in cdb
 kernel: sd 8:0:8:19: [sdfn] tag#0 CDB: Write same(16) 93 08 00 00 00 00 00 a0 08 00 00 00 80 00 00 00
 kernel: blk_update_request: critical target error, dev sdfn, sector 10487808

The SCSI layer converts this to the BLK_STS_TARGET error number, the sd
device disables its support for discard on this path, and because of the
BLK_STS_TARGET error multipath fails the discard without failing any
path or retrying down a different path.  But subsequent discards can
cause path failures.  Any discards sent to the path which already failed
a discard ends up failing with EIO from blk_cloned_rq_check_limits with
an "over max size limit" error since the discard limit was set to 0 by
the sd driver for the path.  As the error is EIO, this now fails the
path and multipath tries to send the discard down the next path.  This
cycle continues as discards are sent until all paths fail.

Fix this by training DM core to disable DISCARD if the underlying
storage already did so.

Also, fix branching in dm_done() and clone_endio() to reflect the
mutually exclussive nature of the IO operations in question.

Cc: stable@vger.kernel.org
Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[Salvatore Bonaccorso: backported to 4.19: Adjust for context changes in
drivers/md/dm-core.h]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 drivers/md/dm-core.h |  1 +
 drivers/md/dm-rq.c   | 11 +++++++----
 drivers/md/dm.c      | 20 ++++++++++++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 7d480c930eaf..7e426e4d1352 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -130,6 +130,7 @@ struct mapped_device {
 };
 
 int md_in_flight(struct mapped_device *md);
+void disable_discard(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 6e547b8dd298..264b84e274aa 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -295,11 +295,14 @@ static void dm_done(struct request *clone, blk_status_t error, bool mapped)
 	}
 
 	if (unlikely(error == BLK_STS_TARGET)) {
-		if (req_op(clone) == REQ_OP_WRITE_SAME &&
-		    !clone->q->limits.max_write_same_sectors)
+		if (req_op(clone) == REQ_OP_DISCARD &&
+		    !clone->q->limits.max_discard_sectors)
+			disable_discard(tio->md);
+		else if (req_op(clone) == REQ_OP_WRITE_SAME &&
+			 !clone->q->limits.max_write_same_sectors)
 			disable_write_same(tio->md);
-		if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
-		    !clone->q->limits.max_write_zeroes_sectors)
+		else if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
+			 !clone->q->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(tio->md);
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 42768fe92b41..c9860e3b04dd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -910,6 +910,15 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 	}
 }
 
+void disable_discard(struct mapped_device *md)
+{
+	struct queue_limits *limits = dm_get_queue_limits(md);
+
+	/* device doesn't really support DISCARD, disable it */
+	limits->max_discard_sectors = 0;
+	blk_queue_flag_clear(QUEUE_FLAG_DISCARD, md->queue);
+}
+
 void disable_write_same(struct mapped_device *md)
 {
 	struct queue_limits *limits = dm_get_queue_limits(md);
@@ -935,11 +944,14 @@ static void clone_endio(struct bio *bio)
 	dm_endio_fn endio = tio->ti->type->end_io;
 
 	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
-		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-		    !bio->bi_disk->queue->limits.max_write_same_sectors)
+		if (bio_op(bio) == REQ_OP_DISCARD &&
+		    !bio->bi_disk->queue->limits.max_discard_sectors)
+			disable_discard(md);
+		else if (bio_op(bio) == REQ_OP_WRITE_SAME &&
+			 !bio->bi_disk->queue->limits.max_write_same_sectors)
 			disable_write_same(md);
-		if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
-		    !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
+		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
+			 !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(md);
 	}
 
-- 
2.23.0.rc1
