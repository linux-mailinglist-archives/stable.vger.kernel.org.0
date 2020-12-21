Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8502DFF5C
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgLUSJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgLUSJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:09:29 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3B2C061282
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:08:48 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id y19so25716345lfa.13
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/C4L9+Hg8fMH16IL3/DdaIgWYfK1esakj801gxabCso=;
        b=FGozS/TLr/YGktRyrqOOWi9EX+ax7H7RkAZBoGBAnYy8a2/Wqv1VQOWORMvwhI5iHP
         2yF8Sw9cD70E1eo3kyLINwnIaATBsTFArx0x7oRYtr8ZfgIcDaTaagUe2kkAFM4qixvL
         dSqWCixoj+1roY24iHYiVZk4PQvCPQbyZm7O4w7bGFFVKZrCi/Fo00gqN+psGwzj1ru5
         aRvOEzzkBTzbtw/3O5TsRSnAF+7IGvYe8Vao559UBqH8gc0bPAVjHyW+6z5aQABguPFP
         GPkXsx5VKGcDV83UiVnRPXchNatkqvMexV5w4aCwvwgVt1lmdDamE7SlET6ga86WS9Mj
         5ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/C4L9+Hg8fMH16IL3/DdaIgWYfK1esakj801gxabCso=;
        b=Wuz/k4mi34t3LDiXqx0bz90yLKvezjTWAF3kJa1oFrRD/ZPvpPMnTcKQjDR/+O815E
         bkjKiN2AUUywDZqNkh8oecl9o71aB60SyXOa/4Wsj/R1l/DLjf7zZK6O25/qgsfxkTag
         UTU+NC/TgPGdpaQooom6owIO6W04xyVhU6/yNAZkE9d7TYb0Yx8lJzSSaCfUEVFe1m3c
         J7dF3Cenv0cdU9c3Klkut9XZ9YLh06mBAJQi1kW9AdJ/YqBkltZ1gSq3Be2KDkqQrSSy
         nYTF4jEOOlE/GUepsprgm5vQHsihBZ3RHoR0xg+jKLoG0ibZE01ZIWOpGIeAC8G0F1B4
         LuPg==
X-Gm-Message-State: AOAM5304fakKHROGJPN7euDtIe5X5nXFLNBbsjF56b6Yehzx/+EcobTi
        EQUJ/wv2YiVipqmYgzIBnZoiAXKj4/Uwc/t3
X-Google-Smtp-Source: ABdhPJx7HbI28BQtzFewpE/qDT3etiH6cId40Ax4R+DQFDWyyjjVHdIyNt/QvMrDjwzg/ZsdfQgMpA==
X-Received: by 2002:adf:8285:: with SMTP id 5mr18723801wrc.289.1608566599020;
        Mon, 21 Dec 2020 08:03:19 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id a65sm23380520wmc.35.2020.12.21.08.03.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Dec 2020 08:03:18 -0800 (PST)
Date:   Mon, 21 Dec 2020 16:03:16 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Pavel Machek <pavel@denx.de>,
        Nikolay Borisov <nborisov@suse.com>
Subject: missing btrfs fixes for 4.14-stable, 4.9-stable and 4.4-stable
Message-ID: <20201221160316.ftczjtpmva6rtw74@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ksr7pa5b2fozhklk"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ksr7pa5b2fozhklk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

Few missing btrfs fixes for 4.14-stable, 4.9-stable and 4.4-stable.
Only one of them was marked for stable but looks like they should be.

6f7de19ed3d4 ("btrfs: quota: Set rescan progress to (u64)-1 if we hit
last leaf")

665d4953cde6 ("btrfs: scrub: Don't use inode page cache in
scrub_handle_errored_block()")

9f7fec0ba891 ("Btrfs: fix selftests failure due to uninitialized i_mode
in test inodes")

881a3a11c2b8 ("btrfs: fix return value mixup in btrfs_get_extent")



--
Regards
Sudip

--ksr7pa5b2fozhklk
Content-Type: application/mbox
Content-Disposition: attachment; filename="btrfs_4.14-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 0c98e0213a067a404985be0872f740d4a18ea2eb Mon Sep 17 00:00:00 2001=0A=
=46rom: Filipe Manana <fdmanana@suse.com>=0ADate: Wed, 18 Sep 2019 13:08:52=
 +0100=0ASubject: [PATCH 1/2] Btrfs: fix selftests failure due to uninitial=
ized i_mode=0A in test inodes=0A=0Acommit 9f7fec0ba89108b9385f1b9fb16786122=
4912a4a upstream=0A=0ASome of the self tests create a test inode, setup som=
e extents and then do=0Acalls to btrfs_get_extent() to test that the corres=
ponding extent maps=0Aexist and are correct. However btrfs_get_extent(), si=
nce the 5.2 merge=0Awindow, now errors out when it finds a regular or preal=
loc extent for an=0Ainode that does not correspond to a regular file (its -=
>i_mode is not=0AS_IFREG). This causes the self tests to fail sometimes, sp=
ecially when=0AKASAN, slub_debug and page poisoning are enabled:=0A=0A  $ m=
odprobe btrfs=0A  modprobe: ERROR: could not insert 'btrfs': Invalid argume=
nt=0A=0A  $ dmesg=0A  [ 9414.691648] Btrfs loaded, crc32c=3Dcrc32c-intel, d=
ebug=3Don, assert=3Don, integrity-checker=3Don, ref-verify=3Don=0A  [ 9414.=
692655] BTRFS: selftest: sectorsize: 4096  nodesize: 4096=0A  [ 9414.692658=
] BTRFS: selftest: running btrfs free space cache tests=0A  [ 9414.692918] =
BTRFS: selftest: running extent only tests=0A  [ 9414.693061] BTRFS: selfte=
st: running bitmap only tests=0A  [ 9414.693366] BTRFS: selftest: running b=
itmap and extent tests=0A  [ 9414.696455] BTRFS: selftest: running space st=
ealing from bitmap to extent tests=0A  [ 9414.697131] BTRFS: selftest: runn=
ing extent buffer operation tests=0A  [ 9414.697133] BTRFS: selftest: runni=
ng btrfs_split_item tests=0A  [ 9414.697564] BTRFS: selftest: running exten=
t I/O tests=0A  [ 9414.697583] BTRFS: selftest: running find delalloc tests=
=0A  [ 9415.081125] BTRFS: selftest: running find_first_clear_extent_bit te=
st=0A  [ 9415.081278] BTRFS: selftest: running extent buffer bitmap tests=
=0A  [ 9415.124192] BTRFS: selftest: running inode tests=0A  [ 9415.124195]=
 BTRFS: selftest: running btrfs_get_extent tests=0A  [ 9415.127909] BTRFS: =
selftest: running hole first btrfs_get_extent test=0A  [ 9415.128343] BTRFS=
 critical (device (efault)): regular/prealloc extent found for non-regular =
inode 256=0A  [ 9415.131428] BTRFS: selftest: fs/btrfs/tests/inode-tests.c:=
904 expected a real extent, got 0=0A=0AThis happens because the test inodes=
 are created without ever initializing=0Athe i_mode field of the inode, and=
 neither VFS's new_inode() nor the btrfs=0Acallback btrfs_alloc_inode() ini=
tialize the i_mode. Initialization of the=0Ai_mode is done through the vari=
ous callbacks used by the VFS to create=0Anew inodes (regular files, direct=
ories, symlinks, tmpfiles, etc), which=0Aall call btrfs_new_inode() which i=
n turn calls inode_init_owner(), which=0Asets the inode's i_mode. Since the=
 tests only uses new_inode() to create=0Athe test inodes, the i_mode was ne=
ver initialized.=0A=0AThis always happens on a VM I used with kasan, slub_d=
ebug and many other=0Adebug facilities enabled. It also happened to someone=
 who reported this=0Aon bugzilla (on a 5.3-rc).=0A=0AFix this by setting i_=
mode to S_IFREG at btrfs_new_test_inode().=0A=0AFixes: 6bf9e4bd6a2778 ("btr=
fs: inode: Verify inode mode to avoid NULL pointer dereference")=0ABugzilla=
: https://bugzilla.kernel.org/show_bug.cgi?id=3D204397=0ASigned-off-by: Fil=
ipe Manana <fdmanana@suse.com>=0AReviewed-by: Qu Wenruo <wqu@suse.com>=0ASi=
gned-off-by: David Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0A---=0A fs/btrfs/tests/btrfs-tests.c | 8 +=
++++++-=0A 1 file changed, 7 insertions(+), 1 deletion(-)=0A=0Adiff --git a=
/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c=0Aindex 6c9210=
1e8092..eb6ae2450fed 100644=0A--- a/fs/btrfs/tests/btrfs-tests.c=0A+++ b/fs=
/btrfs/tests/btrfs-tests.c=0A@@ -51,7 +51,13 @@ static struct file_system_t=
ype test_type =3D {=0A =0A struct inode *btrfs_new_test_inode(void)=0A {=0A=
-	return new_inode(test_mnt->mnt_sb);=0A+	struct inode *inode;=0A+=0A+	inod=
e =3D new_inode(test_mnt->mnt_sb);=0A+	if (inode)=0A+		inode_init_owner(ino=
de, NULL, S_IFREG);=0A+=0A+	return inode;=0A }=0A =0A static int btrfs_init=
_test_fs(void)=0A-- =0A2.11.0=0A=0A=0AFrom 4738caf3f6af9b8a67ddbd281e5864cc=
d5dc3f5f Mon Sep 17 00:00:00 2001=0AFrom: Pavel Machek <pavel@denx.de>=0ADa=
te: Mon, 3 Aug 2020 11:35:06 +0200=0ASubject: [PATCH 2/2] btrfs: fix return=
 value mixup in btrfs_get_extent=0A=0Acommit 881a3a11c2b858fe9b69ef79ac5ee9=
978a266dc9 upstream=0A=0Abtrfs_get_extent() sets variable ret, but out: err=
or path expect error=0Ato be in variable err so the error code is lost.=0A=
=0AFixes: 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL poin=
ter dereference")=0ACC: stable@vger.kernel.org # 5.4+=0AReviewed-by: Nikola=
y Borisov <nborisov@suse.com>=0ASigned-off-by: Pavel Machek (CIP) <pavel@de=
nx.de>=0AReviewed-by: David Sterba <dsterba@suse.com>=0ASigned-off-by: Davi=
d Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0A---=0A fs/btrfs/inode.c | 2 +-=0A 1 file changed, 1 insert=
ion(+), 1 deletion(-)=0A=0Adiff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c=
=0Aindex c5ae2f4a7ec3..9769a5db7d5e 100644=0A--- a/fs/btrfs/inode.c=0A+++ b=
/fs/btrfs/inode.c=0A@@ -7179,7 +7179,7 @@ struct extent_map *btrfs_get_exte=
nt(struct btrfs_inode *inode,=0A 	    found_type =3D=3D BTRFS_FILE_EXTENT_P=
REALLOC) {=0A 		/* Only regular file could have regular/prealloc extent */=
=0A 		if (!S_ISREG(inode->vfs_inode.i_mode)) {=0A-			ret =3D -EUCLEAN;=0A+	=
		err =3D -EUCLEAN;=0A 			btrfs_crit(fs_info,=0A 		"regular/prealloc extent=
 found for non-regular inode %llu",=0A 				   btrfs_ino(inode));=0A-- =0A2.=
11.0=0A=0A
--ksr7pa5b2fozhklk
Content-Type: application/mbox
Content-Disposition: attachment; filename="btrfs_4.9-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 8b57e807809473a95930502712ed1261aff0b30c Mon Sep 17 00:00:00 2001=0A=
=46rom: Qu Wenruo <wqu@suse.com>=0ADate: Wed, 27 Jun 2018 18:19:55 +0800=0A=
Subject: [PATCH 1/4] btrfs: quota: Set rescan progress to (u64)-1 if we hit=
=0A last leaf=0A=0Acommoit 6f7de19ed3d4d3526ca5eca428009f97cf969c2f upstrea=
m=0A=0ACommit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last=
 leaf=0Aof extent tree") added a new exit for rescan finish.=0A=0AHowever a=
fter finishing quota rescan, we set=0Afs_info->qgroup_rescan_progress to (u=
64)-1 before we exit through the=0Aoriginal exit path.=0AWhile we missed th=
at assignment of (u64)-1 in the new exit path.=0A=0AThe end result is, the =
quota status item doesn't have the same value.=0A(-1 vs the last bytenr + 1=
)=0AAlthough it doesn't affect quota accounting, it's still better to keep=
=0Athe original behavior.=0A=0AReported-by: Misono Tomohiro <misono.tomohir=
o@jp.fujitsu.com>=0AFixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when=
 hit the last leaf of extent tree")=0ASigned-off-by: Qu Wenruo <wqu@suse.co=
m>=0AReviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>=0ASigned=
-off-by: David Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0A---=0A fs/btrfs/qgroup.c | 4 +++-=0A 1 file c=
hanged, 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/fs/btrfs/qgroup.c =
b/fs/btrfs/qgroup.c=0Aindex 154008e245a2..d6795c6fdd66 100644=0A--- a/fs/bt=
rfs/qgroup.c=0A+++ b/fs/btrfs/qgroup.c=0A@@ -2340,8 +2340,10 @@ qgroup_resc=
an_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,=0A 	}=0A 	b=
trfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);=0A =0A-	if (done && !re=
t)=0A+	if (done && !ret) {=0A 		ret =3D 1;=0A+		fs_info->qgroup_rescan_prog=
ress.objectid =3D (u64)-1;=0A+	}=0A 	return ret;=0A }=0A =0A-- =0A2.11.0=0A=
=0A=0AFrom a4bc512f737d6041a1d7f633534ca4d399712a02 Mon Sep 17 00:00:00 200=
1=0AFrom: Qu Wenruo <wqu@suse.com>=0ADate: Wed, 11 Jul 2018 13:41:21 +0800=
=0ASubject: [PATCH 2/4] btrfs: scrub: Don't use inode page cache in=0A scru=
b_handle_errored_block()=0A=0Acommit 665d4953cde6d9e75c62a07ec8f4f8fd7d396a=
de upstream=0A=0AIn commit ac0b4145d662 ("btrfs: scrub: Don't use inode pag=
es for device=0Areplace") we removed the branch of copy_nocow_pages() to av=
oid=0Acorruption for compressed nodatasum extents.=0A=0AHowever above commi=
t only solves the problem in scrub_extent(), if=0Aduring scrub_pages() we f=
ailed to read some pages,=0Asctx->no_io_error_seen will be non-zero and we =
go to fixup function=0Ascrub_handle_errored_block().=0A=0AIn scrub_handle_e=
rrored_block(), for sctx without csum (no matter if=0Awe're doing replace o=
r scrub) we go to scrub_fixup_nodatasum() routine,=0Awhich does the similar=
 thing with copy_nocow_pages(), but does it=0Awithout the extra check in co=
py_nocow_pages() routine.=0A=0ASo for test cases like btrfs/100, where we e=
mulate read errors during=0Areplace/scrub, we could corrupt compressed exte=
nt data again.=0A=0AThis patch will fix it just by avoiding any "optimizati=
on" for=0Anodatasum, just falls back to the normal fixup routine by try rea=
d from=0Aany good copy.=0A=0AThis also solves WARN_ON() or dead lock caused=
 by lame backref iteration=0Ain scrub_fixup_nodatasum() routine.=0A=0AThe d=
eadlock or WARN_ON() won't be triggered before commit ac0b4145d662=0A("btrf=
s: scrub: Don't use inode pages for device replace") since=0Acopy_nocow_pag=
es() have better locking and extra check for data extent,=0Aand it's alread=
y doing the fixup work by try to read data from any good=0Acopy, so it won'=
t go scrub_fixup_nodatasum() anyway.=0A=0AThis patch disables the faulty co=
de and will be removed completely in a=0Afollowup patch.=0A=0AFixes: ac0b41=
45d662 ("btrfs: scrub: Don't use inode pages for device replace")=0ASigned-=
off-by: Qu Wenruo <wqu@suse.com>=0ASigned-off-by: David Sterba <dsterba@sus=
e.com>=0A[sudip: adjust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0A---=0A fs/btrfs/scrub.c | 17 +++++++++--------=0A 1 f=
ile changed, 9 insertions(+), 8 deletions(-)=0A=0Adiff --git a/fs/btrfs/scr=
ub.c b/fs/btrfs/scrub.c=0Aindex 16c0585cd81c..9fd7bc699aae 100644=0A--- a/f=
s/btrfs/scrub.c=0A+++ b/fs/btrfs/scrub.c=0A@@ -919,11 +919,6 @@ static int =
scrub_handle_errored_block(struct scrub_block *sblock_to_check)=0A 	have_cs=
um =3D sblock_to_check->pagev[0]->have_csum;=0A 	dev =3D sblock_to_check->p=
agev[0]->dev;=0A =0A-	if (sctx->is_dev_replace && !is_metadata && !have_csu=
m) {=0A-		sblocks_for_recheck =3D NULL;=0A-		goto nodatasum_case;=0A-	}=0A-=
=0A 	/*=0A 	 * read all mirrors one after the other. This includes to=0A 	 =
* re-read the extent or metadata block that failed (that was=0A@@ -1036,13 =
+1031,19 @@ static int scrub_handle_errored_block(struct scrub_block *sbloc=
k_to_check)=0A 		goto out;=0A 	}=0A =0A-	if (!is_metadata && !have_csum) {=
=0A+	/*=0A+	 * NOTE: Even for nodatasum case, it's still possible that it's=
 a=0A+	 * compressed data extent, thus scrub_fixup_nodatasum(), which write=
=0A+	 * inode page cache onto disk, could cause serious data corruption.=0A=
+	 *=0A+	 * So here we could only read from disk, and hope our recovery cou=
ld=0A+	 * reach disk before the newer write.=0A+	 */=0A+	if (0 && !is_metad=
ata && !have_csum) {=0A 		struct scrub_fixup_nodatasum *fixup_nodatasum;=0A=
 =0A 		WARN_ON(sctx->is_dev_replace);=0A =0A-nodatasum_case:=0A-=0A 		/*=0A=
 		 * !is_metadata and !have_csum, this means that the data=0A 		 * might n=
ot be COWed, that it might be modified=0A-- =0A2.11.0=0A=0A=0AFrom c7521ca1=
89bb52a191be8ee6b67b68c37adb441e Mon Sep 17 00:00:00 2001=0AFrom: Filipe Ma=
nana <fdmanana@suse.com>=0ADate: Wed, 18 Sep 2019 13:08:52 +0100=0ASubject:=
 [PATCH 3/4] Btrfs: fix selftests failure due to uninitialized i_mode=0A in=
 test inodes=0A=0Acommit 9f7fec0ba89108b9385f1b9fb167861224912a4a upstream=
=0A=0ASome of the self tests create a test inode, setup some extents and th=
en do=0Acalls to btrfs_get_extent() to test that the corresponding extent m=
aps=0Aexist and are correct. However btrfs_get_extent(), since the 5.2 merg=
e=0Awindow, now errors out when it finds a regular or prealloc extent for a=
n=0Ainode that does not correspond to a regular file (its ->i_mode is not=
=0AS_IFREG). This causes the self tests to fail sometimes, specially when=
=0AKASAN, slub_debug and page poisoning are enabled:=0A=0A  $ modprobe btrf=
s=0A  modprobe: ERROR: could not insert 'btrfs': Invalid argument=0A=0A  $ =
dmesg=0A  [ 9414.691648] Btrfs loaded, crc32c=3Dcrc32c-intel, debug=3Don, a=
ssert=3Don, integrity-checker=3Don, ref-verify=3Don=0A  [ 9414.692655] BTRF=
S: selftest: sectorsize: 4096  nodesize: 4096=0A  [ 9414.692658] BTRFS: sel=
ftest: running btrfs free space cache tests=0A  [ 9414.692918] BTRFS: selft=
est: running extent only tests=0A  [ 9414.693061] BTRFS: selftest: running =
bitmap only tests=0A  [ 9414.693366] BTRFS: selftest: running bitmap and ex=
tent tests=0A  [ 9414.696455] BTRFS: selftest: running space stealing from =
bitmap to extent tests=0A  [ 9414.697131] BTRFS: selftest: running extent b=
uffer operation tests=0A  [ 9414.697133] BTRFS: selftest: running btrfs_spl=
it_item tests=0A  [ 9414.697564] BTRFS: selftest: running extent I/O tests=
=0A  [ 9414.697583] BTRFS: selftest: running find delalloc tests=0A  [ 9415=
=2E081125] BTRFS: selftest: running find_first_clear_extent_bit test=0A  [ =
9415.081278] BTRFS: selftest: running extent buffer bitmap tests=0A  [ 9415=
=2E124192] BTRFS: selftest: running inode tests=0A  [ 9415.124195] BTRFS: s=
elftest: running btrfs_get_extent tests=0A  [ 9415.127909] BTRFS: selftest:=
 running hole first btrfs_get_extent test=0A  [ 9415.128343] BTRFS critical=
 (device (efault)): regular/prealloc extent found for non-regular inode 256=
=0A  [ 9415.131428] BTRFS: selftest: fs/btrfs/tests/inode-tests.c:904 expec=
ted a real extent, got 0=0A=0AThis happens because the test inodes are crea=
ted without ever initializing=0Athe i_mode field of the inode, and neither =
VFS's new_inode() nor the btrfs=0Acallback btrfs_alloc_inode() initialize t=
he i_mode. Initialization of the=0Ai_mode is done through the various callb=
acks used by the VFS to create=0Anew inodes (regular files, directories, sy=
mlinks, tmpfiles, etc), which=0Aall call btrfs_new_inode() which in turn ca=
lls inode_init_owner(), which=0Asets the inode's i_mode. Since the tests on=
ly uses new_inode() to create=0Athe test inodes, the i_mode was never initi=
alized.=0A=0AThis always happens on a VM I used with kasan, slub_debug and =
many other=0Adebug facilities enabled. It also happened to someone who repo=
rted this=0Aon bugzilla (on a 5.3-rc).=0A=0AFix this by setting i_mode to S=
_IFREG at btrfs_new_test_inode().=0A=0AFixes: 6bf9e4bd6a2778 ("btrfs: inode=
: Verify inode mode to avoid NULL pointer dereference")=0ABugzilla: https:/=
/bugzilla.kernel.org/show_bug.cgi?id=3D204397=0ASigned-off-by: Filipe Manan=
a <fdmanana@suse.com>=0AReviewed-by: Qu Wenruo <wqu@suse.com>=0ASigned-off-=
by: David Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A fs/btrfs/tests/btrfs-tests.c | 8 +++++++-=
=0A 1 file changed, 7 insertions(+), 1 deletion(-)=0A=0Adiff --git a/fs/btr=
fs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c=0Aindex 9edc2674b8a7.=
=2Eace3209f3a39 100644=0A--- a/fs/btrfs/tests/btrfs-tests.c=0A+++ b/fs/btrf=
s/tests/btrfs-tests.c=0A@@ -51,7 +51,13 @@ static struct file_system_type t=
est_type =3D {=0A =0A struct inode *btrfs_new_test_inode(void)=0A {=0A-	ret=
urn new_inode(test_mnt->mnt_sb);=0A+	struct inode *inode;=0A+=0A+	inode =3D=
 new_inode(test_mnt->mnt_sb);=0A+	if (inode)=0A+		inode_init_owner(inode, N=
ULL, S_IFREG);=0A+=0A+	return inode;=0A }=0A =0A static int btrfs_init_test=
_fs(void)=0A-- =0A2.11.0=0A=0A=0AFrom 70886333966fd6471f1c3e61cbc2341b945f6=
47b Mon Sep 17 00:00:00 2001=0AFrom: Pavel Machek <pavel@denx.de>=0ADate: M=
on, 3 Aug 2020 11:35:06 +0200=0ASubject: [PATCH 4/4] btrfs: fix return valu=
e mixup in btrfs_get_extent=0A=0Acommit 881a3a11c2b858fe9b69ef79ac5ee9978a2=
66dc9 upstream=0A=0Abtrfs_get_extent() sets variable ret, but out: error pa=
th expect error=0Ato be in variable err so the error code is lost.=0A=0AFix=
es: 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer de=
reference")=0ACC: stable@vger.kernel.org # 5.4+=0AReviewed-by: Nikolay Bori=
sov <nborisov@suse.com>=0ASigned-off-by: Pavel Machek (CIP) <pavel@denx.de>=
=0AReviewed-by: David Sterba <dsterba@suse.com>=0ASigned-off-by: David Ster=
ba <dsterba@suse.com>=0A[sudip: adjust context]=0ASigned-off-by: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0A---=0A fs/btrfs/inode.c | 2 +-=0A 1 fi=
le changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/fs/btrfs/inode.=
c b/fs/btrfs/inode.c=0Aindex 6f8f37e37abb..4b671e5c33ce 100644=0A--- a/fs/b=
trfs/inode.c=0A+++ b/fs/btrfs/inode.c=0A@@ -7000,7 +7000,7 @@ struct extent=
_map *btrfs_get_extent(struct inode *inode, struct page *page,=0A 	    foun=
d_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {=0A 		/* Only regular file could=
 have regular/prealloc extent */=0A 		if (!S_ISREG(inode->i_mode)) {=0A-			=
ret =3D -EUCLEAN;=0A+			err =3D -EUCLEAN;=0A 			btrfs_crit(root->fs_info,=
=0A 		"regular/prealloc extent found for non-regular inode %llu",=0A 				  =
 btrfs_ino(inode));=0A-- =0A2.11.0=0A=0A
--ksr7pa5b2fozhklk
Content-Type: application/mbox
Content-Disposition: attachment; filename="btrfs_4.4-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 6ebefadcd7d237bd80799466feda4564eada133a Mon Sep 17 00:00:00 2001=0A=
=46rom: Qu Wenruo <wqu@suse.com>=0ADate: Wed, 27 Jun 2018 18:19:55 +0800=0A=
Subject: [PATCH 1/4] btrfs: quota: Set rescan progress to (u64)-1 if we hit=
=0A last leaf=0A=0Acommoit 6f7de19ed3d4d3526ca5eca428009f97cf969c2f upstrea=
m=0A=0ACommit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last=
 leaf=0Aof extent tree") added a new exit for rescan finish.=0A=0AHowever a=
fter finishing quota rescan, we set=0Afs_info->qgroup_rescan_progress to (u=
64)-1 before we exit through the=0Aoriginal exit path.=0AWhile we missed th=
at assignment of (u64)-1 in the new exit path.=0A=0AThe end result is, the =
quota status item doesn't have the same value.=0A(-1 vs the last bytenr + 1=
)=0AAlthough it doesn't affect quota accounting, it's still better to keep=
=0Athe original behavior.=0A=0AReported-by: Misono Tomohiro <misono.tomohir=
o@jp.fujitsu.com>=0AFixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when=
 hit the last leaf of extent tree")=0ASigned-off-by: Qu Wenruo <wqu@suse.co=
m>=0AReviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>=0ASigned=
-off-by: David Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0A---=0A fs/btrfs/qgroup.c | 4 +++-=0A 1 file c=
hanged, 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/fs/btrfs/qgroup.c =
b/fs/btrfs/qgroup.c=0Aindex 18e667fbd054..bc4cc417e7ab 100644=0A--- a/fs/bt=
rfs/qgroup.c=0A+++ b/fs/btrfs/qgroup.c=0A@@ -2288,8 +2288,10 @@ out:=0A 	}=
=0A 	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);=0A =0A-	if (done =
&& !ret)=0A+	if (done && !ret) {=0A 		ret =3D 1;=0A+		fs_info->qgroup_resca=
n_progress.objectid =3D (u64)-1;=0A+	}=0A 	return ret;=0A }=0A =0A-- =0A2.1=
1.0=0A=0A=0AFrom 742efd0c01e6b8b445f3eef10d118bd8652adcc7 Mon Sep 17 00:00:=
00 2001=0AFrom: Qu Wenruo <wqu@suse.com>=0ADate: Wed, 11 Jul 2018 13:41:21 =
+0800=0ASubject: [PATCH 2/4] btrfs: scrub: Don't use inode page cache in=0A=
 scrub_handle_errored_block()=0A=0Acommit 665d4953cde6d9e75c62a07ec8f4f8fd7=
d396ade upstream=0A=0AIn commit ac0b4145d662 ("btrfs: scrub: Don't use inod=
e pages for device=0Areplace") we removed the branch of copy_nocow_pages() =
to avoid=0Acorruption for compressed nodatasum extents.=0A=0AHowever above =
commit only solves the problem in scrub_extent(), if=0Aduring scrub_pages()=
 we failed to read some pages,=0Asctx->no_io_error_seen will be non-zero an=
d we go to fixup function=0Ascrub_handle_errored_block().=0A=0AIn scrub_han=
dle_errored_block(), for sctx without csum (no matter if=0Awe're doing repl=
ace or scrub) we go to scrub_fixup_nodatasum() routine,=0Awhich does the si=
milar thing with copy_nocow_pages(), but does it=0Awithout the extra check =
in copy_nocow_pages() routine.=0A=0ASo for test cases like btrfs/100, where=
 we emulate read errors during=0Areplace/scrub, we could corrupt compressed=
 extent data again.=0A=0AThis patch will fix it just by avoiding any "optim=
ization" for=0Anodatasum, just falls back to the normal fixup routine by tr=
y read from=0Aany good copy.=0A=0AThis also solves WARN_ON() or dead lock c=
aused by lame backref iteration=0Ain scrub_fixup_nodatasum() routine.=0A=0A=
The deadlock or WARN_ON() won't be triggered before commit ac0b4145d662=0A(=
"btrfs: scrub: Don't use inode pages for device replace") since=0Acopy_noco=
w_pages() have better locking and extra check for data extent,=0Aand it's a=
lready doing the fixup work by try to read data from any good=0Acopy, so it=
 won't go scrub_fixup_nodatasum() anyway.=0A=0AThis patch disables the faul=
ty code and will be removed completely in a=0Afollowup patch.=0A=0AFixes: a=
c0b4145d662 ("btrfs: scrub: Don't use inode pages for device replace")=0ASi=
gned-off-by: Qu Wenruo <wqu@suse.com>=0ASigned-off-by: David Sterba <dsterb=
a@suse.com>=0A[sudip: adjust context]=0ASigned-off-by: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0A---=0A fs/btrfs/scrub.c | 17 +++++++++--------=
=0A 1 file changed, 9 insertions(+), 8 deletions(-)=0A=0Adiff --git a/fs/bt=
rfs/scrub.c b/fs/btrfs/scrub.c=0Aindex cc9ccc42f469..0b41a88ef9e9 100644=0A=
--- a/fs/btrfs/scrub.c=0A+++ b/fs/btrfs/scrub.c=0A@@ -918,11 +918,6 @@ stat=
ic int scrub_handle_errored_block(struct scrub_block *sblock_to_check)=0A 	=
have_csum =3D sblock_to_check->pagev[0]->have_csum;=0A 	dev =3D sblock_to_c=
heck->pagev[0]->dev;=0A =0A-	if (sctx->is_dev_replace && !is_metadata && !h=
ave_csum) {=0A-		sblocks_for_recheck =3D NULL;=0A-		goto nodatasum_case;=0A=
-	}=0A-=0A 	/*=0A 	 * read all mirrors one after the other. This includes t=
o=0A 	 * re-read the extent or metadata block that failed (that was=0A@@ -1=
035,13 +1030,19 @@ static int scrub_handle_errored_block(struct scrub_block=
 *sblock_to_check)=0A 		goto out;=0A 	}=0A =0A-	if (!is_metadata && !have_c=
sum) {=0A+	/*=0A+	 * NOTE: Even for nodatasum case, it's still possible tha=
t it's a=0A+	 * compressed data extent, thus scrub_fixup_nodatasum(), which=
 write=0A+	 * inode page cache onto disk, could cause serious data corrupti=
on.=0A+	 *=0A+	 * So here we could only read from disk, and hope our recove=
ry could=0A+	 * reach disk before the newer write.=0A+	 */=0A+	if (0 && !is=
_metadata && !have_csum) {=0A 		struct scrub_fixup_nodatasum *fixup_nodatas=
um;=0A =0A 		WARN_ON(sctx->is_dev_replace);=0A =0A-nodatasum_case:=0A-=0A 	=
	/*=0A 		 * !is_metadata and !have_csum, this means that the data=0A 		 * m=
ight not be COW'ed, that it might be modified=0A-- =0A2.11.0=0A=0A=0AFrom a=
caba5361bc19d3320534fa58cffa5a457b4eae0 Mon Sep 17 00:00:00 2001=0AFrom: Fi=
lipe Manana <fdmanana@suse.com>=0ADate: Wed, 18 Sep 2019 13:08:52 +0100=0AS=
ubject: [PATCH 3/4] Btrfs: fix selftests failure due to uninitialized i_mod=
e=0A in test inodes=0A=0Acommit 9f7fec0ba89108b9385f1b9fb167861224912a4a up=
stream=0A=0ASome of the self tests create a test inode, setup some extents =
and then do=0Acalls to btrfs_get_extent() to test that the corresponding ex=
tent maps=0Aexist and are correct. However btrfs_get_extent(), since the 5.=
2 merge=0Awindow, now errors out when it finds a regular or prealloc extent=
 for an=0Ainode that does not correspond to a regular file (its ->i_mode is=
 not=0AS_IFREG). This causes the self tests to fail sometimes, specially wh=
en=0AKASAN, slub_debug and page poisoning are enabled:=0A=0A  $ modprobe bt=
rfs=0A  modprobe: ERROR: could not insert 'btrfs': Invalid argument=0A=0A  =
$ dmesg=0A  [ 9414.691648] Btrfs loaded, crc32c=3Dcrc32c-intel, debug=3Don,=
 assert=3Don, integrity-checker=3Don, ref-verify=3Don=0A  [ 9414.692655] BT=
RFS: selftest: sectorsize: 4096  nodesize: 4096=0A  [ 9414.692658] BTRFS: s=
elftest: running btrfs free space cache tests=0A  [ 9414.692918] BTRFS: sel=
ftest: running extent only tests=0A  [ 9414.693061] BTRFS: selftest: runnin=
g bitmap only tests=0A  [ 9414.693366] BTRFS: selftest: running bitmap and =
extent tests=0A  [ 9414.696455] BTRFS: selftest: running space stealing fro=
m bitmap to extent tests=0A  [ 9414.697131] BTRFS: selftest: running extent=
 buffer operation tests=0A  [ 9414.697133] BTRFS: selftest: running btrfs_s=
plit_item tests=0A  [ 9414.697564] BTRFS: selftest: running extent I/O test=
s=0A  [ 9414.697583] BTRFS: selftest: running find delalloc tests=0A  [ 941=
5.081125] BTRFS: selftest: running find_first_clear_extent_bit test=0A  [ 9=
415.081278] BTRFS: selftest: running extent buffer bitmap tests=0A  [ 9415.=
124192] BTRFS: selftest: running inode tests=0A  [ 9415.124195] BTRFS: self=
test: running btrfs_get_extent tests=0A  [ 9415.127909] BTRFS: selftest: ru=
nning hole first btrfs_get_extent test=0A  [ 9415.128343] BTRFS critical (d=
evice (efault)): regular/prealloc extent found for non-regular inode 256=0A=
  [ 9415.131428] BTRFS: selftest: fs/btrfs/tests/inode-tests.c:904 expected=
 a real extent, got 0=0A=0AThis happens because the test inodes are created=
 without ever initializing=0Athe i_mode field of the inode, and neither VFS=
's new_inode() nor the btrfs=0Acallback btrfs_alloc_inode() initialize the =
i_mode. Initialization of the=0Ai_mode is done through the various callback=
s used by the VFS to create=0Anew inodes (regular files, directories, symli=
nks, tmpfiles, etc), which=0Aall call btrfs_new_inode() which in turn calls=
 inode_init_owner(), which=0Asets the inode's i_mode. Since the tests only =
uses new_inode() to create=0Athe test inodes, the i_mode was never initiali=
zed.=0A=0AThis always happens on a VM I used with kasan, slub_debug and man=
y other=0Adebug facilities enabled. It also happened to someone who reporte=
d this=0Aon bugzilla (on a 5.3-rc).=0A=0AFix this by setting i_mode to S_IF=
REG at btrfs_new_test_inode().=0A=0AFixes: 6bf9e4bd6a2778 ("btrfs: inode: V=
erify inode mode to avoid NULL pointer dereference")=0ABugzilla: https://bu=
gzilla.kernel.org/show_bug.cgi?id=3D204397=0ASigned-off-by: Filipe Manana <=
fdmanana@suse.com>=0AReviewed-by: Qu Wenruo <wqu@suse.com>=0ASigned-off-by:=
 David Sterba <dsterba@suse.com>=0ASigned-off-by: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0A---=0A fs/btrfs/tests/btrfs-tests.c | 8 +++++++-=0A 1=
 file changed, 7 insertions(+), 1 deletion(-)=0A=0Adiff --git a/fs/btrfs/te=
sts/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c=0Aindex 69255148f0c8..2825=
cbe3ea8d 100644=0A--- a/fs/btrfs/tests/btrfs-tests.c=0A+++ b/fs/btrfs/tests=
/btrfs-tests.c=0A@@ -48,7 +48,13 @@ static struct file_system_type test_typ=
e =3D {=0A =0A struct inode *btrfs_new_test_inode(void)=0A {=0A-	return new=
_inode(test_mnt->mnt_sb);=0A+	struct inode *inode;=0A+=0A+	inode =3D new_in=
ode(test_mnt->mnt_sb);=0A+	if (inode)=0A+		inode_init_owner(inode, NULL, S_=
IFREG);=0A+=0A+	return inode;=0A }=0A =0A int btrfs_init_test_fs(void)=0A--=
 =0A2.11.0=0A=0A=0AFrom 59ed1fb8c81c44d0716d31087611f16dd4cf51a2 Mon Sep 17=
 00:00:00 2001=0AFrom: Pavel Machek <pavel@denx.de>=0ADate: Mon, 3 Aug 2020=
 11:35:06 +0200=0ASubject: [PATCH 4/4] btrfs: fix return value mixup in btr=
fs_get_extent=0A=0Acommit 881a3a11c2b858fe9b69ef79ac5ee9978a266dc9 upstream=
=0A=0Abtrfs_get_extent() sets variable ret, but out: error path expect erro=
r=0Ato be in variable err so the error code is lost.=0A=0AFixes: 6bf9e4bd6a=
27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")=0A=
CC: stable@vger.kernel.org # 5.4+=0AReviewed-by: Nikolay Borisov <nborisov@=
suse.com>=0ASigned-off-by: Pavel Machek (CIP) <pavel@denx.de>=0AReviewed-by=
: David Sterba <dsterba@suse.com>=0ASigned-off-by: David Sterba <dsterba@su=
se.com>=0A[sudip: adjust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0A---=0A fs/btrfs/inode.c | 2 +-=0A 1 file changed, 1 =
insertion(+), 1 deletion(-)=0A=0Adiff --git a/fs/btrfs/inode.c b/fs/btrfs/i=
node.c=0Aindex 9e1f9910bdf2..6d846ff696fb 100644=0A--- a/fs/btrfs/inode.c=
=0A+++ b/fs/btrfs/inode.c=0A@@ -6923,7 +6923,7 @@ again:=0A 	    found_type=
 =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {=0A 		/* Only regular file could have =
regular/prealloc extent */=0A 		if (!S_ISREG(inode->i_mode)) {=0A-			ret =
=3D -EUCLEAN;=0A+			err =3D -EUCLEAN;=0A 			btrfs_crit(root->fs_info,=0A 		=
"regular/prealloc extent found for non-regular inode %llu",=0A 				   btrfs=
_ino(inode));=0A-- =0A2.11.0=0A=0A
--ksr7pa5b2fozhklk--
