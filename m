Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B08A677FBC
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjAWP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjAWP2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:28:44 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829EA2A15D
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:28:31 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mg12so31474938ejc.5
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLLzIZMG8rGAzz1UctD7Vp4EvQHTycS7tZMKakHdtjU=;
        b=olGyPzcz9vE2FcveWwyP4UTWADRXrEBTfZcW1HQMMNu73FkK1zN+Ltn8fTwawXQ6Wv
         HSLxSETw1DLXbZFaHeZY2No7cfjx5dHLzErJxwToW5MCIF+u8Q4U53Jlr/NIoeLo7dwU
         wXDpxKPn/uyl743m6lNUfST3OZc0FiUbLMQvGEP7vdeDcWmHFOqji20LfAUqyEOs6OVJ
         HfwCStSbhSsj6dcxC4l+MidH8k8GH9SO0ilECzp7WrRaqKRpizD4dsXZnY9SZQdTv8K9
         9oE+mimYZxHjMEjmAtrNGcpU3QBjPCcYtWqMbwmlS2ykjA3RYFTSmPAIVf1TIrH9m70A
         jMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLLzIZMG8rGAzz1UctD7Vp4EvQHTycS7tZMKakHdtjU=;
        b=1ak7ljsW9zcWqjIKAeXmjQNuA7OLdcd2Dhl47xhx14AR5m19qjWNmY8UlOLcY53KsO
         5lfoJOzSgGl/Aljoo29fbNd5e2p4vCDBTAEk5YmOEwguXFEF2LZDWRyCOwyJbFfWVjoT
         IRR3dxLojU4Xk+QougtOpB720EIkNTarYzGBLQ4Gkzb9xr/R9NDFJLcI00qk4UqEc39p
         T0R/52nEKoK2mIKU+ZJA0sAwxTKxtVBDmtnkYki2xsULg7Rykwz9gzlCCIoMoDh5i4/5
         Uyg/DxLpyPnRlNi/I9oOm5vOrKTMt+SrFAfDj/DP4w/0ZpW/2tqAckoesWOFW7fR3QnP
         iZUg==
X-Gm-Message-State: AFqh2kpGOktIMGq9oRwE+KzTsxJvW4NGDwI6wip3Wo2xAG0ee0HdYeD8
        m9VvfXDubvrMJJzoer1y1RxqvQKRcuDldLcO
X-Google-Smtp-Source: AMrXdXtzyETs5J/O0KoXzsamMUEg/ibG0CfZbPrZ9Vu3kQwDFJSVL65iOU40WMMH740uvVkhe6Y1cg==
X-Received: by 2002:a17:907:8b08:b0:860:c12c:14fd with SMTP id sz8-20020a1709078b0800b00860c12c14fdmr29377384ejc.76.1674487709867;
        Mon, 23 Jan 2023 07:28:29 -0800 (PST)
Received: from marvin.internal.lan (193.92.101.37.dsl.dyn.forthnet.gr. [193.92.101.37])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906301500b007c0985aa6b0sm22274876ejz.191.2023.01.23.07.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 07:28:29 -0800 (PST)
From:   Nikos Tsironis <ntsironis@arrikto.com>
To:     stable@vger.kernel.org
Cc:     bfields@fieldses.org, chuck.lever@oracle.com,
        ntsironis@arrikto.com, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com
Subject: [PATCH 5.4 1/1] nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted
Date:   Mon, 23 Jan 2023 17:28:22 +0200
Message-Id: <20230123152822.868326-2-ntsironis@arrikto.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230123152822.868326-1-ntsironis@arrikto.com>
References: <20230123152822.868326-1-ntsironis@arrikto.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c6c7f2a84da459bcc3714044e74a9cb66de31039 upstream.

In order to ensure that knfsd threads don't linger once the nfsd
pseudofs is unmounted (e.g. when the container is killed) we let
nfsd_umount() shut down those threads and wait for them to exit.

This also should ensure that we don't need to do a kernel mount of
the pseudofs, since the thread lifetime is now limited by the
lifetime of the filesystem.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 fs/nfsd/netns.h     |  6 +++---
 fs/nfsd/nfs4state.c |  8 +-------
 fs/nfsd/nfsctl.c    | 14 ++------------
 fs/nfsd/nfsd.h      |  3 +--
 fs/nfsd/nfssvc.c    | 35 ++++++++++++++++++++++++++++++++++-
 5 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index ed53e206a299..82329b5102c6 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -42,9 +42,6 @@ struct nfsd_net {
 	bool grace_ended;
 	time_t boot_time;
 
-	/* internal mount of the "nfsd" pseudofilesystem: */
-	struct vfsmount *nfsd_mnt;
-
 	struct dentry *nfsd_client_dir;
 
 	/*
@@ -121,6 +118,9 @@ struct nfsd_net {
 	wait_queue_head_t ntf_wq;
 	atomic_t ntf_refcnt;
 
+	/* Allow umount to wait for nfsd state cleanup */
+	struct completion nfsd_shutdown_complete;
+
 	/*
 	 * clientid and stateid data for construction of net unique COPY
 	 * stateids.
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index de2c3809d15a..5922eceb0176 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7754,14 +7754,9 @@ nfs4_state_start_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	int ret;
 
-	ret = get_nfsdfs(net);
-	if (ret)
-		return ret;
 	ret = nfs4_state_create_net(net);
-	if (ret) {
-		mntput(nn->nfsd_mnt);
+	if (ret)
 		return ret;
-	}
 	locks_start_grace(net, &nn->nfsd4_manager);
 	nfsd4_client_tracking_init(net);
 	if (nn->track_reclaim_completes && nn->reclaim_str_hashtbl_size == 0)
@@ -7830,7 +7825,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	mntput(nn->nfsd_mnt);
 }
 
 void
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 055cc0458f27..a2454739b1cf 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1417,6 +1417,8 @@ static void nfsd_umount(struct super_block *sb)
 {
 	struct net *net = sb->s_fs_info;
 
+	nfsd_shutdown_threads(net);
+
 	kill_litter_super(sb);
 	put_net(net);
 }
@@ -1429,18 +1431,6 @@ static struct file_system_type nfsd_fs_type = {
 };
 MODULE_ALIAS_FS("nfsd");
 
-int get_nfsdfs(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct vfsmount *mnt;
-
-	mnt =  vfs_kern_mount(&nfsd_fs_type, SB_KERNMOUNT, "nfsd", NULL);
-	if (IS_ERR(mnt))
-		return PTR_ERR(mnt);
-	nn->nfsd_mnt = mnt;
-	return 0;
-}
-
 #ifdef CONFIG_PROC_FS
 static int create_proc_exports_entry(void)
 {
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 4ff0c5318a02..3ae9811c0bb9 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -84,11 +84,10 @@ int		nfsd_get_nrthreads(int n, int *, struct net *);
 int		nfsd_set_nrthreads(int n, int *, struct net *);
 int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
+void		nfsd_shutdown_threads(struct net *net);
 
 void		nfsd_destroy(struct net *net);
 
-int get_nfsdfs(struct net *);
-
 struct nfsdfs_client {
 	struct kref cl_ref;
 	void (*cl_release)(struct kref *kref);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 70684c7ae94b..969a227186fa 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -594,6 +594,37 @@ static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_module		= THIS_MODULE,
 };
 
+static void nfsd_complete_shutdown(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	WARN_ON(!mutex_is_locked(&nfsd_mutex));
+
+	nn->nfsd_serv = NULL;
+	complete(&nn->nfsd_shutdown_complete);
+}
+
+void nfsd_shutdown_threads(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
+
+	mutex_lock(&nfsd_mutex);
+	serv = nn->nfsd_serv;
+	if (serv == NULL) {
+		mutex_unlock(&nfsd_mutex);
+		return;
+	}
+
+	svc_get(serv);
+	/* Kill outstanding nfsd threads */
+	serv->sv_ops->svo_setup(serv, NULL, 0);
+	nfsd_destroy(net);
+	mutex_unlock(&nfsd_mutex);
+	/* Wait for shutdown of nfsd_serv to complete */
+	wait_for_completion(&nn->nfsd_shutdown_complete);
+}
+
 int nfsd_create_serv(struct net *net)
 {
 	int error;
@@ -611,11 +642,13 @@ int nfsd_create_serv(struct net *net)
 						&nfsd_thread_sv_ops);
 	if (nn->nfsd_serv == NULL)
 		return -ENOMEM;
+	init_completion(&nn->nfsd_shutdown_complete);
 
 	nn->nfsd_serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(nn->nfsd_serv, net);
 	if (error < 0) {
 		svc_destroy(nn->nfsd_serv);
+		nfsd_complete_shutdown(net);
 		return error;
 	}
 
@@ -664,7 +697,7 @@ void nfsd_destroy(struct net *net)
 		svc_shutdown_net(nn->nfsd_serv, net);
 	svc_destroy(nn->nfsd_serv);
 	if (destroy)
-		nn->nfsd_serv = NULL;
+		nfsd_complete_shutdown(net);
 }
 
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
-- 
2.30.2

