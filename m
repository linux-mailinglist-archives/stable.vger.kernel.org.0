Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9C515887E
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 04:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgBKDDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 22:03:01 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:40291 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgBKDDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 22:03:01 -0500
Received: by mail-yb1-f196.google.com with SMTP id f130so2794589ybc.7
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 19:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=wtvHezJGvk+xyK8pUoLlXh79qYxTN268QxaQBQkiS/k=;
        b=Jp5H0vaPHPokHDh0wImQrAXBfpvTrWVyn56QRE0IarWiG+3IEDyNhF1cNVYms0B6xM
         /t7uVDUVlWKMgRoYCfvW3sTtpGdKXUu2Jw2hMEjByykGVVqE0PReQg3HNHmtnw/cGrfq
         AUPXEN9lYTijy+ALr7faJEZUMox8uYKBRM3/e//zwNFofg17mKnBcvkJTiM9QWr3SZU8
         fC9AB02balfk9Pfp5T7ecWxV4+7lWYr7kLgDtKutCkWFNqQqJbZlxql3TSiTUH9yRAqw
         trft+3lvydhMc7ns7VQDqvLanmSCYleJq3j0e4RYqBowbJNfIcKvlnQ+b/wipiNOLYqd
         X0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=wtvHezJGvk+xyK8pUoLlXh79qYxTN268QxaQBQkiS/k=;
        b=Mz/2i+atdGTfn2petMXMcvnc9CO02Hq8euza4pm2DS3eK5i7wjrmAHEWkPF6OWNNHp
         D94hx9KkMDCsEo5MuECZ+qP5pzNNi7yygTRmWKkRjynqxRsrtZxcjbYoox91tUN2lGnf
         Ljc2PRDXpPk1xpo7ZZnAsH/Wxgmeby1YSPuQ1vpLz3+tMlQmg8xz3LPkAcbA9Ehk3Ful
         Kj6tZGU+tGmttX9S07P7OK9lLIh6+clJnt2S8Jj3PzW7RWqe+s5roMrdr1nOS4xQJZlG
         RnAIxHL3yW9MOhQX9x8RFCkuDmOR3yXlBwTG+8vfUBojm3aHxsNLi+2obdzA1M+9XYIw
         fARQ==
X-Gm-Message-State: APjAAAUC9A2k3a7Fv+87GNm2Lwmvrcql75i1r09y4JNSV+eW/k63uiyT
        K84sR6GGPFo973eneu2+DDKGmw==
X-Google-Smtp-Source: APXvYqzJaBpJ131bQJuzoTF4C/xbvaR0j4815iosyl2RClo3JaXMiMPwjIHY9oXh3q88mGkah+ncyw==
X-Received: by 2002:a25:f203:: with SMTP id i3mr3978314ybe.272.1581390178383;
        Mon, 10 Feb 2020 19:02:58 -0800 (PST)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id j11sm1065926ywg.37.2020.02.10.19.02.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Feb 2020 19:02:57 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <0457097B-863F-44F7-A1D3-C2C867B6DB36@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_11FB26B4-89A2-47A5-8D2A-5D39B046064F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext4: Fix checksum errors with indexed dirs
Date:   Mon, 10 Feb 2020 20:02:50 -0700
In-Reply-To: <20200210144316.22081-1-jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
To:     Jan Kara <jack@suse.cz>
References: <20200210144316.22081-1-jack@suse.cz>
X-Mailer: Apple Mail (2.3273)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_11FB26B4-89A2-47A5-8D2A-5D39B046064F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 10, 2020, at 7:43 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> DIR_INDEX has been introduced as a compat ext4 feature. That means =
that
> even kernels / tools that don't understand the feature may modify the
> filesystem. This works because for kernels not understanding indexed =
dir
> format, internal htree nodes appear just as empty directory entries.
> Index dir aware kernels then check the htree structure is still
> consistent before using the data. This all worked reasonably well =
until
> metadata checksums were introduced. The problem is that these
> effectively made DIR_INDEX only ro-compatible because internal htree
> nodes store checksums in a different place than normal directory =
blocks.
> Thus any modification ignorant to DIR_INDEX (or just clearing
> EXT4_INDEX_FL from the inode) will effectively cause checksum mismatch
> and trigger kernel errors. So we have to be more careful when dealing
> with indexed directories on filesystems with checksumming enabled.
>=20
> 1) We just disallow loading any directory inodes with EXT4_INDEX_FL =
when
> DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> means someone disabled DIR_INDEX on existing filesystem and didn't run
> e2fsck), e2fsck can fix the problem, and we don't want to answer the
> difficult question: "Should we rather corrupt the directory more or
> should we ignore that DIR_INDEX feature is not set?"
>=20
> 2) When we find out htree structure is corrupted (but the filesystem =
and
> the directory should in support htrees), we continue just ignoring =
htree
> information for reading but we refuse to add new entries to the
> directory to avoid corrupting it more.
>=20
> CC: stable@vger.kernel.org
> Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree =
nodes")
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/dir.c   | 14 ++++++++------
> fs/ext4/ext4.h  |  5 ++++-
> fs/ext4/inode.c | 12 ++++++++++++
> fs/ext4/namei.c |  7 +++++++
> 4 files changed, 31 insertions(+), 7 deletions(-)
>=20
> Changes since v1:
> - fixed some style nits spotted by Andreas
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 9f00fc0bf21d..cb9ea593b544 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -129,12 +129,14 @@ static int ext4_readdir(struct file *file, =
struct dir_context *ctx)
> 		if (err !=3D ERR_BAD_DX_DIR) {
> 			return err;
> 		}
> -		/*
> -		 * We don't set the inode dirty flag since it's not
> -		 * critical that it get flushed back to the disk.
> -		 */
> -		ext4_clear_inode_flag(file_inode(file),
> -				      EXT4_INODE_INDEX);
> +		/* Can we just clear INDEX flag to ignore htree =
information? */
> +		if (!ext4_has_metadata_csum(sb)) {
> +			/*
> +			 * We don't set the inode dirty flag since it's =
not
> +			 * critical that it gets flushed back to the =
disk.
> +			 */
> +			ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
> +		}
> 	}
>=20
> 	if (ext4_has_inline_data(inode)) {
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f8578caba40d..1fd6c1e2ce2a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2482,8 +2482,11 @@ void ext4_insert_dentry(struct inode *inode,
> 			struct ext4_filename *fname);
> static inline void ext4_update_dx_flag(struct inode *inode)
> {
> -	if (!ext4_has_feature_dir_index(inode->i_sb))
> +	if (!ext4_has_feature_dir_index(inode->i_sb)) {
> +		/* ext4_iget() should have caught this... */
> +		=
WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
> 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
> +	}
> }
> static const unsigned char ext4_filetype_table[] =3D {
> 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, =
DT_LNK
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 629a25d999f0..25191201ccdc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4615,6 +4615,18 @@ struct inode *__ext4_iget(struct super_block =
*sb, unsigned long ino,
> 		ret =3D -EFSCORRUPTED;
> 		goto bad_inode;
> 	}
> +	/*
> +	 * If dir_index is not enabled but there's dir with INDEX flag =
set,
> +	 * we'd normally treat htree data as empty space. But with =
metadata
> +	 * checksumming that corrupts checksums so forbid that.
> +	 */
> +	if (!ext4_has_feature_dir_index(sb) && =
ext4_has_metadata_csum(sb) &&
> +	    ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) {
> +		ext4_error_inode(inode, function, line, 0,
> +			 "iget: Dir with htree data on filesystem =
without dir_index feature.");
> +		ret =3D -EFSCORRUPTED;
> +		goto bad_inode;
> +	}
> 	ei->i_disksize =3D inode->i_size;
> #ifdef CONFIG_QUOTA
> 	ei->i_reserved_quota =3D 0;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 1cb42d940784..deb9f7a02976 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2207,6 +2207,13 @@ static int ext4_add_entry(handle_t *handle, =
struct dentry *dentry,
> 		retval =3D ext4_dx_add_entry(handle, &fname, dir, =
inode);
> 		if (!retval || (retval !=3D ERR_BAD_DX_DIR))
> 			goto out;
> +		/* Can we just ignore htree data? */
> +		if (ext4_has_metadata_csum(sb)) {
> +			EXT4_ERROR_INODE(dir,
> +				"Directory has corrupted htree index.");
> +			retval =3D -EFSCORRUPTED;
> +			goto out;
> +		}
> 		ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
> 		dx_fallback++;
> 		ext4_mark_inode_dirty(handle, dir);
> --
> 2.16.4
>=20


Cheers, Andreas






--Apple-Mail=_11FB26B4-89A2-47A5-8D2A-5D39B046064F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl5CGVsACgkQcqXauRfM
H+DY8Q//T14gFJJaJji0jCf2agaq5CjldOOP09O8BzpiLXs+L5d007H3CkzLoLJe
6uN3urEew4y0KKYzRFCJB8jrIUMeQs72m+HU2td2Sp7Ks7E02p+mSkMvz0sbFD69
LASMf4TkVYhepGSFW9VC8rqFOYvgzUurNu8gPrummR2pt6rn+hHnySTZQnSNLiPe
xJ/3lCdx042GerNj1gdYFM+xXu5PcpL6dAF2wJy4hV5NPJ9KQusvshvhgdIOaVrB
ET/s7mxiPXSlocowJBOb5WvTbsd1wIeGu+QLUjgJ66ZQdDMkBWTidcZE7r3fJ5Tn
rEoOaQRag4X5WISaXUymkW1qNe9hiyoLacoUrjEBlyR8W3pV4PbrgqqULLe4bu5R
m5K8RKhw9T05AuYe0nMaEw890xhBNUwQPMxCdezuPQQpwQ4TzXkGfA8rWOJw2T2p
3arQ95AJ10sFk+D5ji6tKfllv/pe//i+B3LeCt2V012vk8tnALogxl3SrJqkjk4L
x+w3KRLamswfWxGvhykIRJmu11eQiZwxN0jYM1R+6oCcNxaMB8xoMC5HJJIMARTi
Iv67vj2KEMudcvWCXAdEhiTm7MXGkYZ6/AdlcoOyQ/tzSbze0IbDTKWoV28h9RVk
iXMEjkWuwTSvA3ISQkth4PI4mjnzPbqdl6j8YYAJL/CtZZleXLE=
=tSej
-----END PGP SIGNATURE-----

--Apple-Mail=_11FB26B4-89A2-47A5-8D2A-5D39B046064F--
