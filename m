Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38984EFCEE
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 00:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352621AbiDAXAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 19:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiDAXAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 19:00:12 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845911037;
        Fri,  1 Apr 2022 15:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1648853883;
        bh=rEwbnzA7y5go1R83gZ81JCcwNi/lzBlUr1wv6FJe6zM=;
        h=X-UI-Sender-Class:Date:To:References:From:Subject:In-Reply-To;
        b=iTaf6/KJSq7E++xx8Citi6d+fpsWoSKDGHErB/CkfMQeiJOshd2qRGnID+xlHNRsC
         JdIdSH1IyAHb9HLkiiAaYwv9YYoyThnB9Cm8N6u4KCyeQC48EnMoslmpbIdZV2Yf1S
         cgxPyLejX2WM58j3GuEIxzMu1W2Zw1EYGFgKFjEg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MiJVG-1oCFfY3C6A-00fS0L; Sat, 02
 Apr 2022 00:58:03 +0200
Message-ID: <b9b41fbd-e60d-6698-53f6-545a320acf1a@gmx.com>
Date:   Sat, 2 Apr 2022 06:57:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        stable@vger.kernel.org
References: <1f622305ee7ecb3b6ec09f878c26ad0446e18311.1648798164.git.wqu@suse.com>
 <20220401163954.GM15609@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH] btrfs: force v2 space cache usage for subpage mount
In-Reply-To: <20220401163954.GM15609@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nMNBkjLq9aEwykYrVVXH0JZuoN5hnMM37ZjoxkYZ5gcIHrUYdMd
 GiVN9oSVmke5IiWDn1lsj9zhvFiv1Xm+iHdThZ5MC7h8eboBo6bmBEqr7EHIuXJmjW8m7d9
 bPycDt/fDMxsVAFGJvV+71FOpZ+nRcNafIderPnG8am8gOwhLmupOiZeAd1Qbjb/RSXKntC
 sVTs0ebequgQ3jgLYgL7g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fzgU9CwD+T0=:RyqKPTf1gEQFByY66eVE3N
 0POgkSX2YSN1ro+rs5kkFdekYkJLinR4CWEoPrUxl2JLOonzymDue5c7VZ5Mi3nXHEDoJWxVx
 Yffno8mWcu64UCPoZrRr6tqAPL84tObGvOKzomF8++kO6lsFygXBHtHTDD+bIvcbX+MBs0hBa
 SEBw+/gPNi03y4xgsErePnmfE+uQG74GFKiXeNbFa2wKFDuSuBpG2TMf9yYUVglee+YrqkVMI
 0wyej5HYu1d461bjrX+Je4E+HYPNbpmqCidY1T7tHrb1tZ8k5CnwfOXiRM2nwvIe2psW6jv4A
 E4NLedjVUHdkzRpiNGsTEIENtU87RmMY/oOBggBdAdn+5Aq8e4ijpX54iQrVMw2ivd53qLUXS
 eKOwci62WWkH176wiu98dwkyNgxKeJOQcUEXlHRnMue+xLQ+kzqNwQnsREmWbDtXE+jo7z5gx
 n3oBY/Bhbzfly2/Hmvx4tP8pXNZ13/VHZ4dQru29VDYlqxnUD4SF3bcXs+cVX4r7mmPtEWNt4
 q3/solBjUq4Q4BvkbvQUg2Q9KTDMJMvmXI9ck7qaWGWBbF2rtp5cuN7L0JWjWSG89dCFtheGj
 cetLQc3cexwrmXSn3+n9H2ZFVr/ByNsbP2/PsOgAMRUTbfHxjKZCkoJjCI6pU11B/Q4SxSC3D
 kPOg52gqFmPlXG0as/9uFwPDY2AM3S1gvxT/uKSX/tiKHKeqOnRw1PAm74glB1B6hx5lqoQH1
 XOQFtQfB8qDOZH1ELdMSex7w8gddw0GV9uyTamXFdim7oBgB6HeBseejwVN+5Ey90IuJOMFp6
 +a1v0dGBthTUBHdFPB2S+S7esoBJ/e2SjM6EZW0g12MwNtmKPW7AAORaOOdsFHoc4YZEyNY/8
 VRpXfnZwyNS7IlaRg/rheeiZSy2gYiziBXJdoDLuM33RF5T4wTqcButbd2ffXtstQCyzqfYkF
 YNL1ZHWoicpc5bUVc1JdIvQ28koXMdlPkND1w7UJjCM/QErVO3xBmWD5InmYVVbTqOVwpEoK/
 21xWH+idpkIAdaEWkJVpVxNJXtWUaJcKqGwoOm5Qtqy+BPz5Y26seps/x5CO6lJNjP8u4ooRS
 mQsc3OPAxkvEv0=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/2 00:39, David Sterba wrote:
> On Fri, Apr 01, 2022 at 03:29:37PM +0800, Qu Wenruo wrote:
>> [BUG]
>> For a 4K sector sized btrfs with v1 cache enabled and only mounted on
>> systems with 4K page size, if it's mounted on subpage (64K page size)
>> systems, it can cause the following warning on v1 space cache:
>>
>>   BTRFS error (device dm-1): csum mismatch on free space cache
>>   BTRFS warning (device dm-1): failed to load free space cache for bloc=
k group 84082688, rebuilding it now
>>
>> Although not a big deal, as kernel can rebuild it without problem, such
>> warning will bother end users, especially if they want to switch the
>> same btrfs seamlessly between different page sized systems.
>>
>> [CAUSE]
>> V1 free space cache is still using fixed PAGE_SIZE for various bitmap,
>> like BITS_PER_BITMAP.
>>
>> Such hard-coded PAGE_SIZE usage will cause various mismatch, from v1
>> cache size to checksum.
>>
>> Thus kernel will always reject v1 cache with a different PAGE_SIZE with
>> csum mismatch.
>>
>> [FIX]
>> Although we should fix v1 cache, it's already going to be marked
>> deprecated soon.
>>
>> And we have v2 cache based on metadata (which is already fully subpage
>> compatible), and it has almost everything superior than v1 cache.
>>
>> So just force subpage mount to use v2 cache on mount.
>>
>> Reported-by: Matt Corallo <blnxfsl@bluematt.me>
>> CC: stable@vger.kernel.org # 5.15+
>> Link: https://lore.kernel.org/linux-btrfs/61aa27d1-30fc-c1a9-f0f4-9df54=
4395ec3@bluematt.me/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/disk-io.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index d456f426924c..34eb6d4b904a 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3675,6 +3675,17 @@ int __cold open_ctree(struct super_block *sb, st=
ruct btrfs_fs_devices *fs_device
>>   	if (sectorsize < PAGE_SIZE) {
>>   		struct btrfs_subpage_info *subpage_info;
>>
>> +		/*
>> +		 * V1 space cache has some hardcoded PAGE_SIZE usage, and is
>> +		 * going to be deprecated.
>> +		 *
>> +		 * Force to use v2 cache for subpage case.
>> +		 */
>> +		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
>> +		btrfs_set_and_info(fs_info, FREE_SPACE_TREE,
>> +			"forcing free space tree for sector size %u with page size %lu",
>> +			sectorsize, PAGE_SIZE);
>
> I'm not sure this is implemented the right way. Why is it unconditional?

Isn't the same thing we do when parsing the mount options for switch
v1->v2 cache?

> Does any subsequent mount have to clear and set the bits after it has
> been already? Or what if the free space tree is set at mkfs time, which
> is now the default.

The function btrfs_set_and_info() will only inform the end users if the
bit is not set.

>
> Next, remounting v1->v2 does more things, like removing the v1 tree if
> it exists. And due to some bugs there are more bits for free space tree
> to be set like FREE_SPACE_TREE_VALID.  So I don't thing this patch
> covers all cases for the v2.

You're right on remounting, but in the opposite way.
There is nothing prevent the users from re-enabling v1 cache.

I should also prevent user from setting v1 cache.

Another concern is, I didn't see code cleaning up v1 cache when we do
the v1->v2 switch.
The only code doing such cleanup is cleanup_free_space_cache_v1() in
free-space-cache.c, but it only gets called in
btrfs_set_free_space_cache_v1_active().

Or did I miss something?

Thanks,
Qu

