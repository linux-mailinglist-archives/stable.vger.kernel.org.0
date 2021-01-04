Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D982E9216
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 09:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhADIoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 03:44:04 -0500
Received: from relay5.mymailcheap.com ([159.100.241.64]:51579 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbhADIoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 03:44:04 -0500
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 98B5B200FE;
        Mon,  4 Jan 2021 08:43:10 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id A761A3ECDA;
        Mon,  4 Jan 2021 09:41:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id EE97F2A17D;
        Mon,  4 Jan 2021 03:41:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609749697;
        bh=02pZoPxGUkGGlnpsUzwf2J9rJXsJFhlWP+4v3O/yUSc=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=krEQ3M3UeoGAZbJOxuJj3IJ6WGTdRLU9nC3rUznPfEzEC1VbW1ZUGYTemCRCHXDa7
         G99UdpPzqbGhOMllkLXry3TJfVC/g4SmdhEpmo5zYfNpZKw5/bNy++R38CzrKGtd7I
         7ywcXpR259BTO627UFqjJnq3wlM6Vpox7vG6fjB8=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HmPz50ySWFyc; Mon,  4 Jan 2021 03:41:36 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Mon,  4 Jan 2021 03:41:36 -0500 (EST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 05C1B41F21;
        Mon,  4 Jan 2021 08:41:35 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="kq0Fpzcy";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [10.172.12.132] (unknown [112.96.173.123])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id AF50941F21;
        Mon,  4 Jan 2021 08:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609749689; bh=02pZoPxGUkGGlnpsUzwf2J9rJXsJFhlWP+4v3O/yUSc=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=kq0Fpzcy61K8wu+y13LBIPrDDTKDUXyr+uldVtz1PAg/VACSiTP1RIBDomeztTRaQ
         SYJGSY1epOInYaNne0kwETuNENJu3z3DjTO2BEhVgy8LCGymLAKMDnnSCUn6Az7Xhq
         GQNyzx9PDCf1ra4MiTHjvKoWkkyjLGXvl7xdtvS0=
Date:   Mon, 04 Jan 2021 16:14:12 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20210104072835.147843-1-icenowy@aosc.io>
References: <20210104072835.147843-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] ovl: use a dedicated semaphore for dir upperfile caching
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
CC:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   Icenowy Zheng <icenowy@aosc.io>
Message-ID: <41A054BA-B955-4A17-BC19-31F8A0B2F1B3@aosc.io>
X-Spamd-Result: default: False [-0.10 / 10.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[112.96.173.123:received];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[aosc.io:+];
         FREEMAIL_TO(0.00)[szeredi.hu,gmail.com,cn.fujitsu.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Queue-Id: 05C1B41F21
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



=E4=BA=8E 2021=E5=B9=B41=E6=9C=884=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=883:=
28:35, Icenowy Zheng <icenowy@aosc=2Eio> =E5=86=99=E5=88=B0:
>The function ovl_dir_real_file() currently uses the semaphore of the
>inode to synchronize write to the upperfile cache field=2E
>
>However, this function will get called by ovl_ioctl_set_flags(), which
>utilizes the inode semaphore too=2E In this case ovl_dir_real_file() will
>try to claim a lock that is owned by a function in its call stack,
>which
>won't get released before ovl_dir_real_file() returns=2E
>
>Define a dedicated semaphore for the upperfile cache, so that the
>deadlock won't happen=2E
>
>Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR
>ioctls for directories")
>Cc: stable@vger=2Ekernel=2Eorg # v5=2E10
>Signed-off-by: Icenowy Zheng <icenowy@aosc=2Eio>
>---

Sorry for lack of changelog=2E

A missing replacement of inode_lock() is added in v2=2E

> fs/overlayfs/readdir=2Ec | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/fs/overlayfs/readdir=2Ec b/fs/overlayfs/readdir=2Ec
>index 01620ebae1bd=2E=2Efa1844ff8db4 100644
>--- a/fs/overlayfs/readdir=2Ec
>+++ b/fs/overlayfs/readdir=2Ec
>@@ -56,6 +56,7 @@ struct ovl_dir_file {
> 	struct list_head *cursor;
> 	struct file *realfile;
> 	struct file *upperfile;
>+	struct semaphore upperfile_sem;
> };
>=20
>static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node
>*n)
>@@ -874,8 +875,6 @@ struct file *ovl_dir_real_file(const struct file
>*file, bool want_upper)
>	 * Need to check if we started out being a lower dir, but got copied
>up
> 	 */
> 	if (!od->is_upper) {
>-		struct inode *inode =3D file_inode(file);
>-
> 		realfile =3D READ_ONCE(od->upperfile);
> 		if (!realfile) {
> 			struct path upperpath;
>@@ -883,10 +882,10 @@ struct file *ovl_dir_real_file(const struct file
>*file, bool want_upper)
> 			ovl_path_upper(dentry, &upperpath);
> 			realfile =3D ovl_dir_open_realfile(file, &upperpath);
>=20
>-			inode_lock(inode);
>+			down(&od->upperfile_sem);
> 			if (!od->upperfile) {
> 				if (IS_ERR(realfile)) {
>-					inode_unlock(inode);
>+					up(&od->upperfile_sem);
> 					return realfile;
> 				}
> 				smp_store_release(&od->upperfile, realfile);
>@@ -896,7 +895,7 @@ struct file *ovl_dir_real_file(const struct file
>*file, bool want_upper)
> 					fput(realfile);
> 				realfile =3D od->upperfile;
> 			}
>-			inode_unlock(inode);
>+			up(&od->upperfile_sem);
> 		}
> 	}
>=20
>@@ -959,6 +958,7 @@ static int ovl_dir_open(struct inode *inode, struct
>file *file)
> 	od->realfile =3D realfile;
> 	od->is_real =3D ovl_dir_is_real(file->f_path=2Edentry);
> 	od->is_upper =3D OVL_TYPE_UPPER(type);
>+	sema_init(&od->upperfile_sem, 1);
> 	file->private_data =3D od;
>=20
> 	return 0;
