Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198E0153733
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgBESEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 13:04:33 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43933 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgBESEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 13:04:32 -0500
Received: by mail-pl1-f194.google.com with SMTP id p11so1181452plq.10
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 10:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=+m2RHFAXRRxCPJhN/KtXdd5sFXEb3qJf0VUkaeLrcY0=;
        b=AvUgqhKWS2rKpKBgvQD94q+VtxUH3FQ8bVALdLrtvSvEIH48Xsq43/zmGI/6mCuZTP
         NeZWmrKV35Xca63DU2hQeJplELXzadG5Q0RdSng/Lpjhaz9a9XVf5gkDvx8GiZIrU0jX
         kNYsCSQ7eQ+OAy8JDTIUiJ+7XNEc3eud8n9NQde7SWOS3bfoqf+U6/7r5pprDv9y77zQ
         4qg3Az6XrVmOuVFGzj8CNrJRP7rQ/EfFORXzmeH+wOwKclSGW6KKbOT/QKUcuH8e9YOF
         2NpFyJyk1mReqVGgrGRmTCwqCRoFUSDhrwc8z9xRHfJfU/lw6WgouCDDPEpe0xfK54CV
         /JzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=+m2RHFAXRRxCPJhN/KtXdd5sFXEb3qJf0VUkaeLrcY0=;
        b=MIThUGdXZFfmQv5R3sIo2NtEbUVjvvYUEGTV4KyQvoEJ892CNYC6Vxu/YyEVFBIZOm
         DWs47UhErTnKS+nkBZRjdRpIbMtf6cfDx0fXWfF8I/T8Bg1kndlbt4Yqeu9ijTMhgIQm
         EK5A+Sg3qqEfHoWk53H3Uqjral8rXGyKvivfBGWGBPk3/MRWDgPxSEkbhlEJdFfISEnn
         hihG1/dp7SkZGpNwj+peCVRSd7/HuUaUcK6ETeV99n0AuNTAVPxpSzXwfq5Kc5Lw02LD
         gKKOHCZ2V6MeXXRMMrt9Pw550W+2v3lp/G17FqJloYh3WYW+xuD9up4/efQsEGJsUNjX
         fRQQ==
X-Gm-Message-State: APjAAAXNlN9Bgbl+kFQeNocJ1d1tY7S1O5rnceDIkPVkOTW8ZV7krR0j
        dFlH0HtTR9hrRyhsiENIincDBA==
X-Google-Smtp-Source: APXvYqwdWhlx93zRAwHdIzTShPg+1/ebfahWDWvHPSlwSD1yN3wtATWRXAG+CFLsvcOUALExxqymIg==
X-Received: by 2002:a17:902:7283:: with SMTP id d3mr31674666pll.118.1580925870568;
        Wed, 05 Feb 2020 10:04:30 -0800 (PST)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id fh24sm422302pjb.24.2020.02.05.10.04.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Feb 2020 10:04:29 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <BC1AA070-8C16-4399-B4D8-1E9F24D05D8D@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_03ECB88A-819D-47E2-8386-6BDB37DFB7D1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: Fix checksum errors with indexed dirs
Date:   Wed, 5 Feb 2020 11:04:23 -0700
In-Reply-To: <20200205173025.12221-1-jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
To:     Jan Kara <jack@suse.cz>
References: <20200205173025.12221-1-jack@suse.cz>
X-Mailer: Apple Mail (2.3273)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_03ECB88A-819D-47E2-8386-6BDB37DFB7D1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 5, 2020, at 10:30 AM, Jan Kara <jack@suse.cz> wrote:
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

> 1) We just disallow loading and directory inodes with EXT4_INDEX_FL =
when

s/and/any/ ?

> DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> means someone disabled DIR_INDEX on existing filesystem and didn't run
> e2fsck), e2fsck can fix the problem, and we don't want to answer the
> difficult question: "Should we rather corrupt the directory more or
> should we ignore that DIR_INDEX feature is not set?"

Wouldn't it be better to continue allowing the directory to be read, but
not modified?  Otherwise, essentially, metadata_csum is making the
filesystem _less_ robust rather than making it more robust.  We don't
_need_ the htree index to do a lookup in the directory.

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
> ---
> fs/ext4/dir.c   | 14 ++++++++------
> fs/ext4/ext4.h  |  5 ++++-
> fs/ext4/inode.c | 13 +++++++++++++
> fs/ext4/namei.c |  7 +++++++
> 4 files changed, 32 insertions(+), 7 deletions(-)
>=20
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 629a25d999f0..d33135308c1b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4615,6 +4615,19 @@ struct inode *__ext4_iget(struct super_block =
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
> +				 "iget: Dir with htree data on =
filesystem "
> +				 "without dir_index feature.");

Kernel style suggests error strings should not be line wrapped at 80 =
columns.


Cheers, Andreas






--Apple-Mail=_03ECB88A-819D-47E2-8386-6BDB37DFB7D1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl47A6cACgkQcqXauRfM
H+DOYQ/8Dbr+DrsK/m0cI3yBj5P1fa8ejugMbNoF73hb0f0a16y9LnyzP+wP0K7o
fb/8A8NUyGFpBgBsrtx3Qq0sRnjCnBI7znHK1g21U+PwL2A2eZWJQTYz0cCUSev/
3swqwPrbeOrharA2WvWOaZICr64vYwdchr9sxYOaRHd+w6HSYDBfag+5mPSKGr8r
3OPBJXuxQ/xUH1zrrfOnT2V3Nng1qSc3oevjucJae3bGgRC2dNbSF6jQx66ffpIg
j7uqspYk6DndL1Jru4x9G3y8r0Qvupu9r4/rYF1A4SDQNf4IqNqzZbmkUl0mrdBW
zHqKy93RhV5AyV4M5eIH5nAN0jhe2tnavwPG6PoBoE1gNvDOnRfhmpONWA3j4lPG
CkYBc7uEhNZNmw4/eNZV086pPKoOwVXtyU0m6BBzUARxBSTGt5R+tIqzLtRRaKFq
4YSVlYvgN0PgMGOVmX4GiNYLuYeDE/7dxZDDnnZgpAk8R1Uj929doMdIrLJ5xDTS
MQFkPgxt2VmDKI7yP2hKxb8fcU2QpbAZJwI+4o8RIB+TkZ+D1dzIFRQ/wIK/xuVi
6z9u5eUueDfrEf3CNtzUlyIp8r5ivw4X0cwgUrsPk3iiF1xEz/VuSepeavyWq+NR
/Id7N0z9i70LAQvqVsL4HDFWpcfrthwCAK3phAdM42yA9rLDDEc=
=7+La
-----END PGP SIGNATURE-----

--Apple-Mail=_03ECB88A-819D-47E2-8386-6BDB37DFB7D1--
