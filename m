Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E57D21B2F6
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGJKKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:10:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:58896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgGJKKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:10:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8490AC79;
        Fri, 10 Jul 2020 10:10:26 +0000 (UTC)
Subject: Re: [PATCH] btrfs: add missing check for nocow and compression inode
 flags
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200710100553.13567-1-dsterba@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 xsFNBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABzSJOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuZGU+wsF4BBMBAgAiBQJYijkSAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRBxvoJG5T8oV/B6D/9a8EcRPdHg8uLEPywuJR8URwXzkofT5bZE
 IfGF0Z+Lt2ADe+nLOXrwKsamhweUFAvwEUxxnndovRLPOpWerTOAl47lxad08080jXnGfYFS
 Dc+ew7C3SFI4tFFHln8Y22Q9075saZ2yQS1ywJy+TFPADIprAZXnPbbbNbGtJLoq0LTiESnD
 w/SUC6sfikYwGRS94Dc9qO4nWyEvBK3Ql8NkoY0Sjky3B0vL572Gq0ytILDDGYuZVo4alUs8
 LeXS5ukoZIw1QYXVstDJQnYjFxYgoQ5uGVi4t7FsFM/6ykYDzbIPNOx49Rbh9W4uKsLVhTzG
 BDTzdvX4ARl9La2kCQIjjWRg+XGuBM5rxT/NaTS78PXjhqWNYlGc5OhO0l8e5DIS2tXwYMDY
 LuHYNkkpMFksBslldvNttSNei7xr5VwjVqW4vASk2Aak5AleXZS+xIq2FADPS/XSgIaepyTV
 tkfnyreep1pk09cjfXY4A7qpEFwazCRZg9LLvYVc2M2eFQHDMtXsH59nOMstXx2OtNMcx5p8
 0a5FHXE/HoXz3p9bD0uIUq6p04VYOHsMasHqHPbsMAq9V2OCytJQPWwe46bBjYZCOwG0+x58
 fBFreP/NiJNeTQPOa6FoxLOLXMuVtpbcXIqKQDoEte9aMpoj9L24f60G4q+pL/54ql2VRscK
 d87BTQRYigc+ARAAyJSq9EFk28++SLfg791xOh28tLI6Yr8wwEOvM3wKeTfTZd+caVb9gBBy
 wxYhIopKlK1zq2YP7ZjTP1aPJGoWvcQZ8fVFdK/1nW+Z8/NTjaOx1mfrrtTGtFxVBdSCgqBB
 jHTnlDYV1R5plJqK+ggEP1a0mr/rpQ9dFGvgf/5jkVpRnH6BY0aYFPprRL8ZCcdv2DeeicOO
 YMobD5g7g/poQzHLLeT0+y1qiLIFefNABLN06Lf0GBZC5l8hCM3Rpb4ObyQ4B9PmL/KTn2FV
 Xq/c0scGMdXD2QeWLePC+yLMhf1fZby1vVJ59pXGq+o7XXfYA7xX0JsTUNxVPx/MgK8aLjYW
 hX+TRA4bCr4uYt/S3ThDRywSX6Hr1lyp4FJBwgyb8iv42it8KvoeOsHqVbuCIGRCXqGGiaeX
 Wa0M/oxN1vJjMSIEVzBAPi16tztL/wQtFHJtZAdCnuzFAz8ue6GzvsyBj97pzkBVacwp3/Mw
 qbiu7sDz7yB0d7J2tFBJYNpVt/Lce6nQhrvon0VqiWeMHxgtQ4k92Eja9u80JDaKnHDdjdwq
 FUikZirB28UiLPQV6PvCckgIiukmz/5ctAfKpyYRGfez+JbAGl6iCvHYt/wAZ7Oqe/3Cirs5
 KhaXBcMmJR1qo8QH8eYZ+qhFE3bSPH446+5oEw8A9v5oonKV7zMAEQEAAcLBXwQYAQIACQUC
 WIoHPgIbDAAKCRBxvoJG5T8oV1pyD/4zdXdOL0lhkSIjJWGqz7Idvo0wjVHSSQCbOwZDWNTN
 JBTP0BUxHpPu/Z8gRNNP9/k6i63T4eL1xjy4umTwJaej1X15H8Hsh+zakADyWHadbjcUXCkg
 OJK4NsfqhMuaIYIHbToi9K5pAKnV953xTrK6oYVyd/Rmkmb+wgsbYQJ0Ur1Ficwhp6qU1CaJ
 mJwFjaWaVgUERoxcejL4ruds66LM9Z1Qqgoer62ZneID6ovmzpCWbi2sfbz98+kW46aA/w8r
 7sulgs1KXWhBSv5aWqKU8C4twKjlV2XsztUUsyrjHFj91j31pnHRklBgXHTD/pSRsN0UvM26
 lPs0g3ryVlG5wiZ9+JbI3sKMfbdfdOeLxtL25ujs443rw1s/PVghphoeadVAKMPINeRCgoJH
 zZV/2Z/myWPRWWl/79amy/9MfxffZqO9rfugRBORY0ywPHLDdo9Kmzoxoxp9w3uTrTLZaT9M
 KIuxEcV8wcVjr+Wr9zRl06waOCkgrQbTPp631hToxo+4rA1jiQF2M80HAet65ytBVR2pFGZF
 zGYYLqiG+mpUZ+FPjxk9kpkRYz61mTLSY7tuFljExfJWMGfgSg1OxfLV631jV1TcdUnx+h3l
 Sqs2vMhAVt14zT8mpIuu2VNxcontxgVr1kzYA/tQg32fVRbGr449j1gw57BV9i0vww==
Message-ID: <c564eb4a-c798-ccd1-2fc9-d365cf5ba3a1@suse.com>
Date:   Fri, 10 Jul 2020 13:10:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200710100553.13567-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10.07.20 г. 13:05 ч., David Sterba wrote:
> User Forza reported on IRC that some invalid combinations of file
> attributes are accepted by chattr.
> 
> The NODATACOW and compression file flags/attributes are mutually
> exclusive, but they could be set by 'chattr +c +C' on an empty file. The
> nodatacow will be in effect because it's checked first in
> btrfs_run_delalloc_range.
> 
> Extend the flag validation to catch the following cases:
> 
>   - input flags are conflicting
>   - old and new flags are conflicting
>   - initialize the local variable with inode flags after inode ls locked
> 
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3a566cf71fc6..0c13bb38425b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -164,8 +164,11 @@ static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
>  	return 0;
>  }
>  
> -/* Check if @flags are a supported and valid set of FS_*_FL flags */
> -static int check_fsflags(unsigned int flags)
> +/*
> + * Check if @flags are a supported and valid set of FS_*_FL flags and that
> + * the old and new flags are not conflicting
> + */
> +static int check_fsflags(unsigned int old_flags, unsigned int flags)
>  {
>  	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
>  		      FS_NOATIME_FL | FS_NODUMP_FL | \
> @@ -174,9 +177,19 @@ static int check_fsflags(unsigned int flags)
>  		      FS_NOCOW_FL))
>  		return -EOPNOTSUPP;
>  
> +	/* COMPR and NOCOMP on new/old are valid */
>  	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
>  		return -EINVAL;
>  
> +	if ((flags & FS_COMPR_FL) && (flags & FS_NOCOW_FL))
> +		return -EINVAL;
> +
> +	/* NOCOW and compression options are mutually exclusive */
> +	if ((old_flags & FS_NOCOW_FL) && (flags & (FS_COMPR_FL | FS_NOCOMP_FL)))

Why is NOCOW and setting NOCOMP (which would really be a NOOP) an
invalid combination?

> +		return -EINVAL;
> +	if ((flags & FS_NOCOW_FL) && (old_flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
> +		return -EINVAL;

Same thing here, just inverted?

> +
>  	return 0;
>  }
>  
> @@ -190,7 +203,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	unsigned int fsflags, old_fsflags;
>  	int ret;
>  	const char *comp = NULL;
> -	u32 binode_flags = binode->flags;
> +	u32 binode_flags;
>  
>  	if (!inode_owner_or_capable(inode))
>  		return -EPERM;
> @@ -201,22 +214,23 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	if (copy_from_user(&fsflags, arg, sizeof(fsflags)))
>  		return -EFAULT;
>  
> -	ret = check_fsflags(fsflags);
> -	if (ret)
> -		return ret;
> -
>  	ret = mnt_want_write_file(file);
>  	if (ret)
>  		return ret;
>  
>  	inode_lock(inode);
> -
>  	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
>  	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
> +
>  	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
>  	if (ret)
>  		goto out_unlock;
>  
> +	ret = check_fsflags(old_fsflags, fsflags);
> +	if (ret)
> +		goto out_unlock;
> +
> +	binode_flags = binode->flags;
>  	if (fsflags & FS_SYNC_FL)
>  		binode_flags |= BTRFS_INODE_SYNC;
>  	else
> 
