Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E886687356
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 03:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjBBCbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 21:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBBCbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 21:31:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D0668AC4
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 18:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675305054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nUW7NfurW5TLXyP/Ye6gdIDqDy7FnuMEGBOYABvVC/U=;
        b=AkRtyfS5bbBuK5e1zE6VNlgGpgQIcmSKHgotCb8Rar4WlYtpWtPIYbfMdpdr4AFZTakK3F
        LdQ7/zX7DeTpfJ0yAe9UXM54UlktARpUcULwqVWPH/Grn+36PB79T5i1KtH2KRF08sWvLt
        0i+U4JC/gZF9lHGgsBuKXA6ppnO9WgM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-2RKi2AJFOaaqk4a97qcubg-1; Wed, 01 Feb 2023 21:30:53 -0500
X-MC-Unique: 2RKi2AJFOaaqk4a97qcubg-1
Received: by mail-pf1-f200.google.com with SMTP id z14-20020a056a00240e00b0059395f5a701so213102pfh.13
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 18:30:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nUW7NfurW5TLXyP/Ye6gdIDqDy7FnuMEGBOYABvVC/U=;
        b=YLMjQuDtzVkoYMui+x3qJbP1zY+zYXm4ZgjCY4J/+eOasMI3hHwHXZ3QRfjUYFRmFd
         O9SI1WO0+YSgDCMmIJcg8xhLLoOILyWE3ezU02Wnee4sobvc9qt4wb4wRq8DN9hTB2F7
         njUOTl2qrPoTKh77CMq7Pi2BDNU989cevx0OHDZC9uyjWYSR3ijVcXliUhhcImMLkq28
         n6hNzMOm5cQqpd0vOPQ/LVypWZ0uUHco7QMD2SfK2FqgLy89bOKKe8Ujyyc1C9q+eE07
         zzIvF/Y7yhvI4CqROhhmi8z/LTVOVb0gCLiRLq8B/qG36nK2DFGwTxb0uJYB3YmoicZj
         3xWg==
X-Gm-Message-State: AO0yUKU2HycysRATATKKXcSuUpaI8aHN/xGJsPrEHoVXd9cc5fLXKs49
        y3ppvEtYJY22j739ILWEijDAinQFaJXbHd6U57yXPb3q0rPs4WLGHUE+DlfMn69anYLAhDQVX0a
        XiFSM304RpP1gJIyz
X-Received: by 2002:a17:902:c10c:b0:196:7da9:4b45 with SMTP id 12-20020a170902c10c00b001967da94b45mr3986932pli.68.1675305052185;
        Wed, 01 Feb 2023 18:30:52 -0800 (PST)
X-Google-Smtp-Source: AK7set86uBNhiVgX7NVzkO+IUzTYonGPusCl4ohJutEJL0z8u9uwETtmogJ9ADRIRJ/UNYvIz+cS3Q==
X-Received: by 2002:a17:902:c10c:b0:196:7da9:4b45 with SMTP id 12-20020a170902c10c00b001967da94b45mr3986915pli.68.1675305051795;
        Wed, 01 Feb 2023 18:30:51 -0800 (PST)
Received: from [10.72.13.217] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b00172fad607b3sm12451458plg.207.2023.02.01.18.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 18:30:50 -0800 (PST)
Message-ID: <b3abcaaf-f48a-5666-733d-073f2cf876bd@redhat.com>
Date:   Thu, 2 Feb 2023 10:30:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v7 2/2] ceph: blocklist the kclient when receiving
 corrupted snap trace
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com, lhenriques@suse.de,
        stable@vger.kernel.org
References: <20230201013645.404251-1-xiubli@redhat.com>
 <20230201013645.404251-3-xiubli@redhat.com>
 <CAOi1vP-4VF1XukTdhESgHHZbWK6A-p1yZ3_x3viSUfm_vu58rA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-4VF1XukTdhESgHHZbWK6A-p1yZ3_x3viSUfm_vu58rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/02/2023 21:12, Ilya Dryomov wrote:
> On Wed, Feb 1, 2023 at 2:37 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When received corrupted snap trace we don't know what exactly has
>> happened in MDS side. And we shouldn't continue IOs and metadatas
>> access to MDS, which may corrupt or get incorrect contents.
>>
>> This patch will just block all the further IO/MDS requests
>> immediately and then evict the kclient itself.
>>
>> The reason why we still need to evict the kclient just after
>> blocking all the further IOs is that the MDS could revoke the caps
>> faster.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Reviewed-by: Venky Shankar <vshankar@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c       | 17 +++++++++++++++--
>>   fs/ceph/caps.c       | 16 +++++++++++++---
>>   fs/ceph/file.c       |  9 +++++++++
>>   fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
>>   fs/ceph/snap.c       | 38 ++++++++++++++++++++++++++++++++++++--
>>   fs/ceph/super.h      |  1 +
>>   6 files changed, 99 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 8c74871e37c9..cac4083e387a 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -305,7 +305,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>          struct inode *inode = rreq->inode;
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>> -       struct ceph_osd_request *req;
>> +       struct ceph_osd_request *req = NULL;
>>          struct ceph_vino vino = ceph_vino(inode);
>>          struct iov_iter iter;
>>          struct page **pages;
>> @@ -313,6 +313,11 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>          int err = 0;
>>          u64 len = subreq->len;
>>
>> +       if (ceph_inode_is_shutdown(inode)) {
>> +               err = -EIO;
>> +               goto out;
>> +       }
>> +
>>          if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
>>                  return;
>>
>> @@ -563,6 +568,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>
>>          dout("writepage %p idx %lu\n", page, page->index);
>>
>> +       if (ceph_inode_is_shutdown(inode))
>> +               return -EIO;
>> +
>>          /* verify this is a writeable snap context */
>>          snapc = page_snap_context(page);
>>          if (!snapc) {
>> @@ -1643,7 +1651,7 @@ int ceph_uninline_data(struct file *file)
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>          struct ceph_osd_request *req = NULL;
>> -       struct ceph_cap_flush *prealloc_cf;
>> +       struct ceph_cap_flush *prealloc_cf = NULL;
>>          struct folio *folio = NULL;
>>          u64 inline_version = CEPH_INLINE_NONE;
>>          struct page *pages[1];
>> @@ -1657,6 +1665,11 @@ int ceph_uninline_data(struct file *file)
>>          dout("uninline_data %p %llx.%llx inline_version %llu\n",
>>               inode, ceph_vinop(inode), inline_version);
>>
>> +       if (ceph_inode_is_shutdown(inode)) {
>> +               err = -EIO;
>> +               goto out;
>> +       }
>> +
>>          if (inline_version == CEPH_INLINE_NONE)
>>                  return 0;
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index f75ad432f375..210e40037881 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4078,6 +4078,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>          void *p, *end;
>>          struct cap_extra_info extra_info = {};
>>          bool queue_trunc;
>> +       bool close_sessions = false;
>>
>>          dout("handle_caps from mds%d\n", session->s_mds);
>>
>> @@ -4215,9 +4216,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>                  realm = NULL;
>>                  if (snaptrace_len) {
>>                          down_write(&mdsc->snap_rwsem);
>> -                       ceph_update_snap_trace(mdsc, snaptrace,
>> -                                              snaptrace + snaptrace_len,
>> -                                              false, &realm);
>> +                       if (ceph_update_snap_trace(mdsc, snaptrace,
>> +                                                  snaptrace + snaptrace_len,
>> +                                                  false, &realm)) {
>> +                               up_write(&mdsc->snap_rwsem);
>> +                               close_sessions = true;
>> +                               goto done;
>> +                       }
>>                          downgrade_write(&mdsc->snap_rwsem);
>>                  } else {
>>                          down_read(&mdsc->snap_rwsem);
>> @@ -4277,6 +4282,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>          iput(inode);
>>   out:
>>          ceph_put_string(extra_info.pool_ns);
>> +
>> +       /* Defer closing the sessions after s_mutex lock being released */
>> +       if (close_sessions)
>> +               ceph_mdsc_close_sessions(mdsc);
>> +
>>          return;
>>
>>   flush_cap_releases:
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 764598e1efd9..3fbf4993d15d 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -943,6 +943,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>          dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>>               (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>
>> +       if (ceph_inode_is_shutdown(inode))
>> +               return -EIO;
> Hi Xiubo,
>
> ceph_sync_read() is called only from ceph_read_iter() which already
> checks for ceph_inode_is_shutdown() (although the generated error is
> ESTALE instead of EIO).  Is the new one in ceph_sync_read() actually
> needed?
>
> If the answer is yes, why hasn't a corresponding check been added to
> ceph_sync_write()?

Before I generated this patch based on the fscrypt patches,  this will 
be renamed to __ceph_sync_read() and also will be called by 
fill_fscrypt_truncate(). I just forgot this and after rebasing I didn't 
adjust it.

I have updated the 'wip-snap-trace-blocklist' branch by removing it from 
here and ceph_direct_read_write(). And I will fix this later in the 
fscrypt patches.


>> +
>>          if (!len)
>>                  return 0;
>>          /*
>> @@ -1287,6 +1290,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>>          bool write = iov_iter_rw(iter) == WRITE;
>>          bool should_dirty = !write && user_backed_iter(iter);
>>
>> +       if (ceph_inode_is_shutdown(inode))
>> +               return -EIO;
> Similarly, ceph_direct_read_write() is called from ceph_read_iter() and
> ceph_write_iter(), both of which check for ceph_inode_is_shutdown() at
> the top already.
>
>> +
>>          if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
>>                  return -EROFS;
>>
>> @@ -2011,6 +2017,9 @@ static int ceph_zero_partial_object(struct inode *inode,
>>          loff_t zero = 0;
>>          int op;
>>
>> +       if (ceph_inode_is_shutdown(inode))
>> +               return -EIO;
>> +
>>          if (!length) {
>>                  op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
>>                  length = &zero;
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 26a0a8b9975e..df78d30c1cce 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -806,6 +806,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>>   {
>>          struct ceph_mds_session *s;
>>
>> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
>> +               return ERR_PTR(-EIO);
>> +
>>          if (mds >= mdsc->mdsmap->possible_max_rank)
>>                  return ERR_PTR(-EINVAL);
>>
>> @@ -1478,6 +1481,9 @@ static int __open_session(struct ceph_mds_client *mdsc,
>>          int mstate;
>>          int mds = session->s_mds;
>>
>> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
>> +               return -EIO;
>> +
>>          /* wait for mds to go active? */
>>          mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
>>          dout("open_session to mds%d (%s)\n", mds,
>> @@ -2860,6 +2866,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>                  return;
>>          }
>>
>> +       if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
>> +               dout("do_request metadata corrupted\n");
>> +               err = -EIO;
>> +               goto finish;
>> +       }
>>          if (req->r_timeout &&
>>              time_after_eq(jiffies, req->r_started + req->r_timeout)) {
>>                  dout("do_request timed out\n");
>> @@ -3245,6 +3256,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>          u64 tid;
>>          int err, result;
>>          int mds = session->s_mds;
>> +       bool close_sessions = false;
>>
>>          if (msg->front.iov_len < sizeof(*head)) {
>>                  pr_err("mdsc_handle_reply got corrupt (short) reply\n");
>> @@ -3351,10 +3363,15 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>          realm = NULL;
>>          if (rinfo->snapblob_len) {
>>                  down_write(&mdsc->snap_rwsem);
>> -               ceph_update_snap_trace(mdsc, rinfo->snapblob,
>> +               err = ceph_update_snap_trace(mdsc, rinfo->snapblob,
>>                                  rinfo->snapblob + rinfo->snapblob_len,
>>                                  le32_to_cpu(head->op) == CEPH_MDS_OP_RMSNAP,
>>                                  &realm);
>> +               if (err) {
>> +                       up_write(&mdsc->snap_rwsem);
>> +                       close_sessions = true;
>> +                       goto out_err;
>> +               }
>>                  downgrade_write(&mdsc->snap_rwsem);
>>          } else {
>>                  down_read(&mdsc->snap_rwsem);
>> @@ -3412,6 +3429,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>                                       req->r_end_latency, err);
>>   out:
>>          ceph_mdsc_put_request(req);
>> +
>> +       /* Defer closing the sessions after s_mutex lock being released */
>> +       if (close_sessions)
>> +               ceph_mdsc_close_sessions(mdsc);
>>          return;
>>   }
>>
>> @@ -5011,7 +5032,7 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
>>   }
>>
>>   /*
>> - * called after sb is ro.
>> + * called after sb is ro or when metadata corrupted.
>>    */
>>   void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>>   {
>> @@ -5301,7 +5322,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>>          struct ceph_mds_client *mdsc = s->s_mdsc;
>>
>>          pr_warn("mds%d closed our session\n", s->s_mds);
>> -       send_mds_reconnect(mdsc, s);
>> +       if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO)
>> +               send_mds_reconnect(mdsc, s);
>>   }
>>
>>   static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index e4151852184e..e985e4e3ed85 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -1,6 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   #include <linux/ceph/ceph_debug.h>
>>
>> +#include <linux/fs.h>
>>   #include <linux/sort.h>
>>   #include <linux/slab.h>
>>   #include <linux/iversion.h>
>> @@ -766,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          struct ceph_snap_realm *realm;
>>          struct ceph_snap_realm *first_realm = NULL;
>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
>> +       struct ceph_client *client = mdsc->fsc->client;
>>          int rebuild_snapcs;
>>          int err = -ENOMEM;
>> +       int ret;
>>          LIST_HEAD(dirty_realms);
>>
>>          lockdep_assert_held_write(&mdsc->snap_rwsem);
>> @@ -884,6 +887,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          if (first_realm)
>>                  ceph_put_snap_realm(mdsc, first_realm);
>>          pr_err("%s error %d\n", __func__, err);
>> +
>> +       /*
>> +        * When receiving a corrupted snap trace we don't know what
>> +        * exactly has happened in MDS side. And we shouldn't continue
>> +        * writing to OSD, which may corrupt the snapshot contents.
>> +        *
>> +        * Just try to blocklist this kclient and then this kclient
>> +        * must be remounted to continue after the corrupted metadata
>> +        * fixed in the MDS side.
>> +        */
>> +       WRITE_ONCE(mdsc->fsc->mount_state, CEPH_MOUNT_FENCE_IO);
>> +       ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
>> +       if (ret)
>> +               pr_err("%s blocklist of %s failed: %d", __func__,
> A newline is missing at the end here, I have added it.
>
>> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
>> +
>> +       WARN(1, "%s: %s%sdo remount to continue%s",
>> +            __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),
>> +            ret ? "" : " was blocklisted, ",
>> +            err == -EIO ? " after corrupted snaptrace is fixed" : "");
>> +
>>          return err;
>>   }
>>
>> @@ -984,6 +1008,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>          __le64 *split_inos = NULL, *split_realms = NULL;
>>          int i;
>>          int locked_rwsem = 0;
>> +       bool close_sessions = false;
>>
>>          /* decode */
>>          if (msg->front.iov_len < sizeof(*h))
>> @@ -1092,8 +1117,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>           * update using the provided snap trace. if we are deleting a
>>           * snap, we can avoid queueing cap_snaps.
>>           */
>> -       ceph_update_snap_trace(mdsc, p, e,
>> -                              op == CEPH_SNAP_OP_DESTROY, NULL);
>> +       if (ceph_update_snap_trace(mdsc, p, e,
>> +                                  op == CEPH_SNAP_OP_DESTROY,
>> +                                  NULL)) {
>> +               close_sessions = true;
>> +               goto bad;
>> +       }
>>
>>          if (op == CEPH_SNAP_OP_SPLIT)
>>                  /* we took a reference when we created the realm, above */
>> @@ -1112,6 +1141,11 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>   out:
>>          if (locked_rwsem)
>>                  up_write(&mdsc->snap_rwsem);
>> +
>> +       /* Defer closing the sessions after s_mutex lock being released */
> s_mutex doesn't seem to be held here.  Did you mean snap_rwsem or does
> the locking not matter at all in this case?
>
> I assume it's the latter so I have removed this comment.  Let me know
> if it needs to be added back and mention snap_rwsem (or something else
> entirely) instead.

There are 3 places will do this and the other two will hold the s_mutex. 
But here it won't, so it's okay to remove it here.

Thanks

- Xiubo

> I have pushed the result to wip-snap-trace-blocklist branch for now,
> until the question of either redundant or missing checks in file.c is
> clarified.
>
> Thanks,
>
>                  Ilya
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

