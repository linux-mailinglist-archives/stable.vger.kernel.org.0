Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620AF20EA2A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 02:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgF3AZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 20:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgF3AZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 20:25:07 -0400
Received: from syrinx.knorrie.org (syrinx.knorrie.org [IPv6:2001:888:2177::4d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97BCC061755;
        Mon, 29 Jun 2020 17:25:05 -0700 (PDT)
Received: from [IPv6:2a02:a213:2b80:f000::12] (unknown [IPv6:2a02:a213:2b80:f000::12])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 53CDE60976A70;
        Tue, 30 Jun 2020 02:25:01 +0200 (CEST)
Subject: Re: [PATCH v4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20200629075329.36969-1-johannes.thumshirn@wdc.com>
From:   Hans van Kranenburg <hans@knorrie.org>
Autocrypt: addr=hans@knorrie.org; keydata=
 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
Message-ID: <c9145a96-95ba-6f6d-c22a-8ba0d324e39e@knorrie.org>
Date:   Tue, 30 Jun 2020 02:25:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200629075329.36969-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Ok, this is more complicated than I thought, again.

On 6/29/20 9:53 AM, Johannes Thumshirn wrote:
> With the recent addition of filesystem checksum types other than CRC32c,
> it is not anymore hard-coded which checksum type a btrfs filesystem uses.
> 
> Up to now there is no good way to read the filesystem checksum, apart from
> reading the filesystem UUID and then query sysfs for the checksum type.
> 
> Add a new csum_type and csum_size fields to the BTRFS_IOC_FS_INFO ioctl
> command which usually is used to query filesystem features. Also add a
> flags member indicating that the kernel responded with a set csum_type and
> csum_size field.
> 
> For compatibility reasons, only return the csum_type and csum_size if the
> BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE flag was passed to the kernel.

No, that's not for 'compatibility reasons'. It's to allow "fine grained
data retrieval".

My question for David is still relevant: "If we think that with whatever
being added in the future the output will still only contain a bunch of
values that are very cheap to collect when filling the response buffer,
then why would you still want to have this?"

(The 'for compatibility reason' is about the V1 and V2 of the patch
behavior, that sets the very useful flags output field so that the
caller knows which parts of the result actually have a meaning.)

---- 8< ----

The thing is that accepting input opens cans (tm) of worms (tm).

First of all, there is the issue of the lack of checking for a zeroed
buffer from user space.

As we found out, that's actually a bigger problem for an ioctl where the
flags (and garbage in them - possibly silently) modify behavior of
execution and subsequent result (LOGICAL_INO case) than in the case of
just a data collecting ioctl which returns a bunch of values: garbage
in, garbage out, and the (old) calling code is probably ignoring both
input and output fields.

However, demanding unused fields (and unused input flags) to be zero
(like LOGICAL_INO_V2 does now) has an interesting side effect... If I
ask for flags 11110011011101111, and I get -EINVAL, then apparently I'm
running some kernel that is missing support for one of the bits...
¯\_(ツ)_/¯ Good luck finding out which one of the 1s is problematic. Try
all permutations? Try them one by one? Or was there any other path in
the code that returned the -EINVAL?

(We had a discussion about this on IRC earlier this evening.)

So, to help user space a bit, you could then use a flags /* out */ field
that, in combination with -EINVAL will contain the flags of all
functionality that the running kernel can actually support. Then the
calling code can decide if there's something acceptable in there, or to
error out and tell the user to upgrade. This needs to be there from the
early days of the ioctl of course, or when starting to use more
previously unused fields that were properly zeroed out in the output before.

Also, using the same flags field for input as well as for output seems
to be clever because it saves some bytes which can be used for other
stuff in the future, but an interesting remark made was that if anyone
ever wants to write support for a tool like strace for the ioctl, then
it would be oh so nice if that could be stateless, so it can tell you
something like "ha! the user requested features WXYZ and it was reported
back that only X and Z are supported", instead of having to jump through
inconvenient hoops trying to save state from earlier data seen flying by.

I know that in general ioctl stuff is a big mess already, but it would
be fun to think of things that can be done to decrease the rate in which
it's getting even worse, for example by collecting some best practices
and been-there-done-that-oops examples in some guide or whatever... "Ok,
I have this input buffer which was never checked, what options do I have
left before having to do _V+1?". And I do not think that should be done
in a hurry while we want to have this patch in now.

---- >8 ----

So, (apologies if I'm already causing you a headache right at the
beginning of the week), I'd say... Let's for now park everything I just
wrote and drop the whole idea of using input flags for FS_INFO, and keep
it output-only and just properly document the output values that have a
meaning with the flags bits. Because at least we know that the unused
output fields were zeroed before (phew!!).

> Also
> clear any unknown flags so we don't pass false positives to user-space
> newer than the kernel.

^^ about the /* in/out */

> To simplify further additions to the ioctl, also switch the padding to a
> u8 array. Pahole was used to verify the result of this switch:
> 
> pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
> struct btrfs_ioctl_fs_info_args {
>         __u64                      max_id;               /*     0     8 */
>         __u64                      num_devices;          /*     8     8 */
>         __u8                       fsid[16];             /*    16    16 */
>         __u32                      nodesize;             /*    32     4 */
>         __u32                      sectorsize;           /*    36     4 */
>         __u32                      clone_alignment;      /*    40     4 */
>         __u32                      flags;                /*    44     4 */
>         __u16                      csum_type;            /*    48     2 */
>         __u16                      csum_size;            /*    50     2 */
>         __u8                       reserved[972];        /*    52   972 */
> 
>         /* size: 1024, cachelines: 16, members: 10 */
> };
> 
> Fixes: 3951e7f050ac ("btrfs: add xxhash64 to checksumming algorithms")
> Fixes: 3831bf0094ab ("btrfs: add sha256 to checksumming algorithm")
> CC: stable@vger.kernel.org # 5.5+
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v3:
> * make flags in/out (David)
> * make csum return opt-in (Hans)
> 
> Changes to v2:
> * add additional csum_size (David)
> * rename flag value to BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE to reflect
>   additional size
> 
> Changes to v1:
> * add 'out' comment to be consistent (Hans)
> * remove le16_to_cpu() (kbuild robot)
> * switch padding to be all u8 (David)
> ---
>  fs/btrfs/ioctl.c           | 16 +++++++++++++---
>  include/uapi/linux/btrfs.h | 14 ++++++++++++--
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b3e4c632d80c..4d70b918f656 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3198,11 +3198,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>  	struct btrfs_ioctl_fs_info_args *fi_args;
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	u32 inflags;
>  	int ret = 0;
>  
> -	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
> -	if (!fi_args)
> -		return -ENOMEM;
> +	fi_args = memdup_user(arg, sizeof(*fi_args));
> +	if (IS_ERR(fi_args))
> +		return PTR_ERR(fi_args);
> +
> +	inflags = fi_args->flags;
> +	fi_args->flags = 0;

Now you got the flags, but the user provided contents are still present
in parts of fi_args that are not going to be overwritten. I don't think
that's what you would have wanted.

What about zeroing the whole fi_args again after getting the input args
out? At least in the past all unused output was zeroed out. Now it's
garbage in, garbage out.

But if we go back to out-only, that's not relevant any more. :)

>  	rcu_read_lock();
>  	fi_args->num_devices = fs_devices->num_devices;
> @@ -3218,6 +3222,12 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>  	fi_args->sectorsize = fs_info->sectorsize;
>  	fi_args->clone_alignment = fs_info->sectorsize;
>  
> +	if (inflags & BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE) {
> +		fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
> +		fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
> +		fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
> +	}
> +
>  	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
>  		ret = -EFAULT;
>  
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index e6b6cb0f8bc6..c130eaea416e 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
>  	__u32 nodesize;				/* out */
>  	__u32 sectorsize;			/* out */
>  	__u32 clone_alignment;			/* out */
> -	__u32 reserved32;
> -	__u64 reserved[122];			/* pad to 1k */
> +	__u32 flags;				/* in/out */
> +	__u16 csum_type;			/* out */
> +	__u16 csum_size;			/* out */
> +	__u8 reserved[972];			/* pad to 1k */
>  };
>  
> +/*
> + * fs_info ioctl flags
> + *
> + * Used by:
> + * struct btrfs_ioctl_fs_info_args
> + */
> +#define BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE		(1 << 0)
> +
>  /*
>   * feature flags
>   *
> 

K
