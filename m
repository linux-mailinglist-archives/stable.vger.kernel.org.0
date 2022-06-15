Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9D654D23E
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 22:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiFOUCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 16:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344041AbiFOUCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 16:02:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FB1117A9C
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655323361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x2obIkpwLjj751vXqO0eIYHnZ7aq+BYmEY3+k9xv0Tw=;
        b=HzBOiJi5BdbD1WGPOYduRMWZxGNQoBRm/dXZBpUSWYTcjEWl2ObVZhuNAYorSNVuM7lr2x
        METFjiu3t6iWNhm6PAfFEJr/lB5FgAVHoxIqbE+H2DZECFe0Nddjj+N78F7OX4lN7y5FUn
        ahNHLVhoT/uR/l6B9sScMA7OarRn+WU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-cDVNS5lQOZyj5ecKIerO1w-1; Wed, 15 Jun 2022 16:02:40 -0400
X-MC-Unique: cDVNS5lQOZyj5ecKIerO1w-1
Received: by mail-qv1-f71.google.com with SMTP id 4-20020a05621420e400b0046e37432292so7136551qvk.7
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 13:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x2obIkpwLjj751vXqO0eIYHnZ7aq+BYmEY3+k9xv0Tw=;
        b=Y6PwApnMScuSt0abeY/M+9IJzf1iPAoJF8fnPG/NWv3DcVxv+aubjJYgRz9UgBLE0X
         1OYH3feyEUISkdxj8eYa00jLrSC02C5+v79puLYReK5eO/hMsRtdfcNgSZU9qQwV4MHK
         Xubrk3AStPk4TNnGp4sWGahhVTsM+IjsmZWoBmpvUeYCYFiWusup1GrS8D9RF1GGjLFW
         UkW1jLirGSCyDJALrQ8i+EUROunpX73x4idFThxy4tF/ZCxWPcP//68AqgaTMI0PL3rC
         udwId0xBbYCOk4RK666ENvmz3mBFebv+K9SbL8r/XIKDkSMvj8ZGnr56wmgEPU+KWXB3
         WufQ==
X-Gm-Message-State: AJIora9rlka7w9ZtlJd1tjGe9Nbc+NNpcLcODqKV3wx3khHZw2y2WByP
        j3tnDsblotCbWH9pkaRQzxwnhAWUoOzmlibbJerNYvklkRWE1dCeVAxBnFpx5PErxsBimFzJYzh
        CTnrFhCp8Wh1JlAs=
X-Received: by 2002:a05:620a:8088:b0:6a7:1ab:6f01 with SMTP id ef8-20020a05620a808800b006a701ab6f01mr1149388qkb.250.1655323358886;
        Wed, 15 Jun 2022 13:02:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/KvWDh9GqJrZlp2XnPIqpaJ/0z3G1RS/XnAFDu/8Fh32Ym3POx7jmBvncdb7xy2cYgLfvbg==
X-Received: by 2002:a05:620a:8088:b0:6a7:1ab:6f01 with SMTP id ef8-20020a05620a808800b006a701ab6f01mr1149358qkb.250.1655323358575;
        Wed, 15 Jun 2022 13:02:38 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id f12-20020a05620a280c00b0069fe1dfbeffsm12853923qkp.92.2022.06.15.13.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 13:02:37 -0700 (PDT)
Date:   Wed, 15 Jun 2022 16:02:36 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Mike Snitzer <snitzer@kernel.org>, keescook@chromium.org,
        sarthakkukreti@google.com, Greg KH <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksandr Tymoshenko <ovt@google.com>,
        dm-devel@redhat.com, regressions@lists.linux.dev
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <Yqo63CvFpTDFnH3x@redhat.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15 2022 at  1:50P -0400,
Guenter Roeck <linux@roeck-us.net> wrote:

> On 6/15/22 08:29, Mike Snitzer wrote:
> > On Wed, Jun 15 2022 at 10:36P -0400,
> > Guenter Roeck <linux@roeck-us.net> wrote:
> > 
> > > On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> > > > On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > > > > On Fri, Jun 10 2022 at  1:15P -0400,
> > > > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > 
> > > > > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > > > > I believe this commit introduced a regression in dm verity on systems
> > > > > > > where data device is an NVME one. Loading table fails with the
> > > > > > > following diagnostics:
> > > > > > > 
> > > > > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > > > > 
> > > > > > > The same kernel works with the same data drive on the SCSI interface.
> > > > > > > NVME-backed dm verity works with just this commit reverted.
> > > > > > > 
> > > > > > > I believe the presence of the immutable partition is used as an indicator
> > > > > > > of special case NVME configuration and if the data device's name starts
> > > > > > > with "nvme" the code tries to switch the target type to
> > > > > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > > > > 
> > > > > > > The special NVME optimization case was removed in
> > > > > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > > > > affected.
> > > > > > > 
> > > > > > 
> > > > > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > > > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > > > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > > > > have you tested this and verified that it worked?
> > > > > 
> > > > > Sorry for the unforeseen stable@ troubles here!
> > > > > 
> > > > > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > > > > properly would require also making sure commits that remove
> > > > > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > > > > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > > > > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > > > > be removed.
> > > > > 
> > > > > The commit header for 8d47e65948dd documents what
> > > > > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > > > > "nvme" mode really never got used by any userspace that I'm aware of.
> > > > > 
> > > > > Sadly I currently don't have the time to do this backport for all N
> > > > > stable kernels... :(
> > > > > 
> > > > > But if that backport gets out of control: A simpler, albeit stable@
> > > > > unicorn, way to resolve this is to simply revert 9c37de297f65 and make
> > > 
> > > 9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
> > > and trying to apply it results in conflicts which at least I can not
> > > resolve.
> > > 
> > > > > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > > > > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > > > > 
> > > > > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > > > > 
> > > > >                          if (!strcasecmp(queue_mode_name, "bio"))
> > > > >                                  m->queue_mode = DM_TYPE_BIO_BASED;
> > > > > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > > > > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > > > > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> > > > >                          else if (!strcasecmp(queue_mode_name, "rq"))
> > > > >                                  m->queue_mode = DM_TYPE_REQUEST_BASED;
> > > > >                          else if (!strcasecmp(queue_mode_name, "mq"))
> > > > > 
> > > > > Mike
> > > > > 
> > > > 
> > > > Ok, please submit a working patch for the kernels that need it so that
> > > > we can review and apply it to solve this regression.
> > > > 
> > > 
> > > So, effectively, v5.4.y and older are broken right now for use cases
> > > with dm on NVME drives.
> > > 
> > > Given that the regression does affect older branches, and given that we
> > > have to revert this patch to avoid regressions in ChromeOS, would it be
> > > possible to revert it from v5.4.y and older until a fix is found ?
> > 
> > I obviously would prefer to not have this false-start.
> > 
> The false start has already happened since we had to revert the patch
> from chromeos-5.4 and older branches.

OK, well this is pretty easy to fix in general.  If there are slight
differences across older trees they are easily resolved.  Fact that
stable@ couldn't cope with backporting 9c37de297f65 is.. what it is.

But this will fix the issue on 5.4.y:

From: Mike Snitzer <snitzer@kernel.org>
Date: Wed, 15 Jun 2022 14:07:09 -0400
Subject: [5.4.y PATCH] dm: remove special-casing of bio-based immutable singleton target on NVMe

Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.

There is no benefit to DM special-casing NVMe. Remove all code used to
establish DM_TYPE_NVME_BIO_BASED.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c         | 32 ++----------------
 drivers/md/dm.c               | 64 +++--------------------------------
 include/linux/device-mapper.h |  1 -
 3 files changed, 7 insertions(+), 90 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 06b382304d92..81bc36a43b32 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -872,8 +872,7 @@ EXPORT_SYMBOL(dm_consume_args);
 static bool __table_type_bio_based(enum dm_queue_mode table_type)
 {
 	return (table_type == DM_TYPE_BIO_BASED ||
-		table_type == DM_TYPE_DAX_BIO_BASED ||
-		table_type == DM_TYPE_NVME_BIO_BASED);
+		table_type == DM_TYPE_DAX_BIO_BASED);
 }
 
 static bool __table_type_request_based(enum dm_queue_mode table_type)
@@ -929,8 +928,6 @@ bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
-static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
-
 static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
@@ -960,7 +957,6 @@ static int dm_table_determine_type(struct dm_table *t)
 			goto verify_bio_based;
 		}
 		BUG_ON(t->type == DM_TYPE_DAX_BIO_BASED);
-		BUG_ON(t->type == DM_TYPE_NVME_BIO_BASED);
 		goto verify_rq_based;
 	}
 
@@ -999,15 +995,6 @@ static int dm_table_determine_type(struct dm_table *t)
 		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
 		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
 			t->type = DM_TYPE_DAX_BIO_BASED;
-		} else {
-			/* Check if upgrading to NVMe bio-based is valid or required */
-			tgt = dm_table_get_immutable_target(t);
-			if (tgt && !tgt->max_io_len && dm_table_does_not_support_partial_completion(t)) {
-				t->type = DM_TYPE_NVME_BIO_BASED;
-				goto verify_rq_based; /* must be stacked directly on NVMe (blk-mq) */
-			} else if (list_empty(devices) && live_md_type == DM_TYPE_NVME_BIO_BASED) {
-				t->type = DM_TYPE_NVME_BIO_BASED;
-			}
 		}
 		return 0;
 	}
@@ -1024,8 +1011,7 @@ static int dm_table_determine_type(struct dm_table *t)
 	 * (e.g. request completion process for partial completion.)
 	 */
 	if (t->num_targets > 1) {
-		DMERR("%s DM doesn't support multiple targets",
-		      t->type == DM_TYPE_NVME_BIO_BASED ? "nvme bio-based" : "request-based");
+		DMERR("request-based DM doesn't support multiple targets");
 		return -EINVAL;
 	}
 
@@ -1714,20 +1700,6 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static int device_is_partial_completion(struct dm_target *ti, struct dm_dev *dev,
-					sector_t start, sector_t len, void *data)
-{
-	char b[BDEVNAME_SIZE];
-
-	/* For now, NVMe devices are the only devices of this class */
-	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) != 0);
-}
-
-static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
-{
-	return !dm_table_any_dev_attr(t, device_is_partial_completion, NULL);
-}
-
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
 					 sector_t start, sector_t len, void *data)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 37b8bb4d80f0..3c45c389ded9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1000,7 +1000,7 @@ static void clone_endio(struct bio *bio)
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
+	if (unlikely(error == BLK_STS_TARGET)) {
 		if (bio_op(bio) == REQ_OP_DISCARD &&
 		    !bio->bi_disk->queue->limits.max_discard_sectors)
 			disable_discard(md);
@@ -1340,10 +1340,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone->bi_disk->queue, clone,
 				      bio_dev(io->orig_bio), sector);
-		if (md->type == DM_TYPE_NVME_BIO_BASED)
-			ret = direct_make_request(clone);
-		else
-			ret = generic_make_request(clone);
+		ret = generic_make_request(clone);
 		break;
 	case DM_MAPIO_KILL:
 		if (unlikely(swap_bios_limit(ti, clone))) {
@@ -1732,51 +1729,6 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 	return ret;
 }
 
-/*
- * Optimized variant of __split_and_process_bio that leverages the
- * fact that targets that use it do _not_ have a need to split bios.
- */
-static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
-			      struct bio *bio, struct dm_target *ti)
-{
-	struct clone_info ci;
-	blk_qc_t ret = BLK_QC_T_NONE;
-	int error = 0;
-
-	init_clone_info(&ci, md, map, bio);
-
-	if (bio->bi_opf & REQ_PREFLUSH) {
-		struct bio flush_bio;
-
-		/*
-		 * Use an on-stack bio for this, it's safe since we don't
-		 * need to reference it after submit. It's just used as
-		 * the basis for the clone(s).
-		 */
-		bio_init(&flush_bio, NULL, 0);
-		flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
-		ci.bio = &flush_bio;
-		ci.sector_count = 0;
-		error = __send_empty_flush(&ci);
-		bio_uninit(ci.bio);
-		/* dec_pending submits any data associated with flush */
-	} else {
-		struct dm_target_io *tio;
-
-		ci.bio = bio;
-		ci.sector_count = bio_sectors(bio);
-		if (__process_abnormal_io(&ci, ti, &error))
-			goto out;
-
-		tio = alloc_tio(&ci, ti, 0, GFP_NOIO);
-		ret = __clone_and_map_simple_bio(&ci, tio, NULL);
-	}
-out:
-	/* drop the extra reference count */
-	dec_pending(ci.io, errno_to_blk_status(error));
-	return ret;
-}
-
 static blk_qc_t dm_process_bio(struct mapped_device *md,
 			       struct dm_table *map, struct bio *bio)
 {
@@ -1807,8 +1759,6 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 		/* regular IO is split by __split_and_process_bio */
 	}
 
-	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
-		return __process_bio(md, map, bio, ti);
 	return __split_and_process_bio(md, map, bio);
 }
 
@@ -2200,12 +2150,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	if (request_based)
 		dm_stop_queue(q);
 
-	if (request_based || md->type == DM_TYPE_NVME_BIO_BASED) {
+	if (request_based) {
 		/*
-		 * Leverage the fact that request-based DM targets and
-		 * NVMe bio based targets are immutable singletons
-		 * - used to optimize both dm_request_fn and dm_mq_queue_rq;
-		 *   and __process_bio.
+		 * Leverage the fact that request-based DM targets are
+		 * immutable singletons - used to optimize dm_mq_queue_rq.
 		 */
 		md->immutable_target = dm_table_get_immutable_target(t);
 	}
@@ -2334,7 +2282,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		break;
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-	case DM_TYPE_NVME_BIO_BASED:
 		dm_init_congested_fn(md);
 		break;
 	case DM_TYPE_NONE:
@@ -3070,7 +3017,6 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-	case DM_TYPE_NVME_BIO_BASED:
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 		io_front_pad = roundup(front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a53d7d2c2d95..60631f3abddb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -28,7 +28,6 @@ enum dm_queue_mode {
 	DM_TYPE_BIO_BASED	 = 1,
 	DM_TYPE_REQUEST_BASED	 = 2,
 	DM_TYPE_DAX_BIO_BASED	 = 3,
-	DM_TYPE_NVME_BIO_BASED	 = 4,
 };
 
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
-- 
2.30.0

