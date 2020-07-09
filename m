Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7A921A4A6
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgGIQUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 12:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIQUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 12:20:52 -0400
Received: from syrinx.knorrie.org (syrinx.knorrie.org [IPv6:2001:888:2177::4d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46155C08C5CE;
        Thu,  9 Jul 2020 09:20:52 -0700 (PDT)
Received: from [IPv6:2a02:a213:2b80:f000::12] (unknown [IPv6:2a02:a213:2b80:f000::12])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 2965D609908DA;
        Thu,  9 Jul 2020 18:20:48 +0200 (CEST)
Subject: Re: [PATCH v5] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
To:     dsterba@suse.cz, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
 <20200709145211.GA3533@twin.jikos.cz>
From:   Hans van Kranenburg <hans@knorrie.org>
Autocrypt: addr=hans@knorrie.org; keydata=
 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
Message-ID: <3a9bc1b2-a780-1ba9-eba0-7fca2198e5c3@knorrie.org>
Date:   Thu, 9 Jul 2020 18:20:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709145211.GA3533@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/20 4:52 PM, David Sterba wrote:
> On Tue, Jul 07, 2020 at 12:09:24AM +0900, Johannes Thumshirn wrote:
>> With the recent addition of filesystem checksum types other than CRC32c,
>> it is not anymore hard-coded which checksum type a btrfs filesystem uses.
>>
>> Up to now there is no good way to read the filesystem checksum, apart from
>> reading the filesystem UUID and then query sysfs for the checksum type.
>>
>> Add a new csum_type and csum_size fields to the BTRFS_IOC_FS_INFO ioctl
>> command which usually is used to query filesystem features. Also add a
>> flags member indicating that the kernel responded with a set csum_type and
>> csum_size field.
>>
>> For compatibility reasons, only return the csum_type and csum_size if the
>> BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE flag was passed to the kernel. Also
>> clear any unknown flags so we don't pass false positives to user-space
>> newer than the kernel.
>>
>> To simplify further additions to the ioctl, also switch the padding to a
>> u8 array. Pahole was used to verify the result of this switch:
>>
>> pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
>> struct btrfs_ioctl_fs_info_args {
>>         __u64                      max_id;               /*     0     8 */
>>         __u64                      num_devices;          /*     8     8 */
>>         __u8                       fsid[16];             /*    16    16 */
>>         __u32                      nodesize;             /*    32     4 */
>>         __u32                      sectorsize;           /*    36     4 */
>>         __u32                      clone_alignment;      /*    40     4 */
>>         __u32                      flags;                /*    44     4 */
>>         __u16                      csum_type;            /*    48     2 */
>>         __u16                      csum_size;            /*    50     2 */
>>         __u8                       reserved[972];        /*    52   972 */
>>
>>         /* size: 1024, cachelines: 16, members: 10 */
>> };
>>
>> Fixes: 3951e7f050ac ("btrfs: add xxhash64 to checksumming algorithms")
>> Fixes: 3831bf0094ab ("btrfs: add sha256 to checksumming algorithm")
>> CC: stable@vger.kernel.org # 5.5+
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changes to v4:
>> * zero all data passed in from user-space
>>   (I've chosen this variant as I think it is the most complete)

Yes, I think that's a good choice.

We still have to remember that the specifics of what's being done here
is only applicable for this scenario:

* ioctl did never check incoming data to be zeroed
* we take advantage of that missing check (pfew), so that we can add a
new flags-in field
* setting requested flags will not lead to an error on an older running
kernel, and the returned values will by accident cleanly signal that
none of the new features are supported (less developer annoyance at the
calling side)
* kernel code resets the requested flags to what is understood and
returned, so it does not matter if a buffer full of garbage was provided
* the flags are *only* used to request additional buffer contents, they
are *NOT* used to change the behavior of the functionality. this is a
key thing that allows the whole thing to work out.

What I tried to say in earlier messages is, that, it turns out that best
practices might not be as simple as "for a new ioctl always check
incoming buffer to be zeroed and refuse otherwise!"... because being
able to do the above is actually pretty convenient. :)

So each time a new one or an extension happens, it's good to really
think through about what's 'at stake'.

>> Changes to v3:
>> * make flags in/out (David)
>> * make csum return opt-in (Hans)
>>
>> Changes to v2:
>> * add additional csum_size (David)
>> * rename flag value to BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE to reflect
>>   additional size
>>
>> Changes to v1:
>> * add 'out' comment to be consistent (Hans)
>> * remove le16_to_cpu() (kbuild robot)
>> * switch padding to be all u8 (David)
>> ---
>>  fs/btrfs/ioctl.c           | 16 +++++++++++++---
>>  include/uapi/linux/btrfs.h | 14 ++++++++++++--
>>  2 files changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index ab34179d7cbc..df8a6ba91055 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>>  	struct btrfs_ioctl_fs_info_args *fi_args;
>>  	struct btrfs_device *device;
>>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>> +	u32 inflags;
>>  	int ret = 0;
>>  
>> -	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
>> -	if (!fi_args)
>> -		return -ENOMEM;
>> +	fi_args = memdup_user(arg, sizeof(*fi_args));
>> +	if (IS_ERR(fi_args))
>> +		return PTR_ERR(fi_args);
>> +
>> +	inflags = fi_args->flags;
>> +	memset(fi_args, 0, sizeof(*fi_args));
>>  
>>  	rcu_read_lock();
>>  	fi_args->num_devices = fs_devices->num_devices;
>> @@ -3237,6 +3241,12 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>>  	fi_args->sectorsize = fs_info->sectorsize;
>>  	fi_args->clone_alignment = fs_info->sectorsize;
>>  
>> +	if (inflags & BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE) {
>> +		fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
>> +		fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
>> +		fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
>> +	}
> 
> That's safe, but we'll have to add a new flag for all new members and we
> have already 2 ready (generation, metadata_uuid) and ioctl user has to
> set the bits. Minor inconvenience, in exchange for future extensions, so
> let it be.

I think I'm just gonna send a buffer set to all ones for FS_INFO from
now on. :) It will automatically get me all new future stuff.

>> +
>>  	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
>>  		ret = -EFAULT;
>>  
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index e6b6cb0f8bc6..c130eaea416e 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
>>  	__u32 nodesize;				/* out */
>>  	__u32 sectorsize;			/* out */
>>  	__u32 clone_alignment;			/* out */
>> -	__u32 reserved32;
>> -	__u64 reserved[122];			/* pad to 1k */
>> +	__u32 flags;				/* in/out */
>> +	__u16 csum_type;			/* out */
>> +	__u16 csum_size;			/* out */
>> +	__u8 reserved[972];			/* pad to 1k */
>>  };
>>  
>> +/*
>> + * fs_info ioctl flags
>> + *
>> + * Used by:
>> + * struct btrfs_ioctl_fs_info_args
>> + */
>> +#define BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE		(1 << 0)
> 
> Flags should be defined before the structure, but that I can fix up.
> 

Next task is to write changes for strace:

https://btrfs.wiki.kernel.org/index.php/Development_notes#Adding_a_new_ioctl.2C_extending_an_existing_one


K
