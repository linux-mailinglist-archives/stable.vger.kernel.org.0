Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5FE6DC39D
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 08:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDJGnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 02:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDJGnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 02:43:05 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F25271E;
        Sun,  9 Apr 2023 23:43:03 -0700 (PDT)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N7QxL-1qSHZE2rc5-017n6M; Mon, 10
 Apr 2023 08:42:58 +0200
Message-ID: <d2de6696-3aa5-df0f-edb6-064e66d9e26f@gmx.com>
Date:   Mon, 10 Apr 2023 14:42:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH pre-6.4] btrfs: dev-replace: error out if we have
 unrepaired metadata error during
To:     Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
 <e3d8c926-d4a4-cc3b-b845-211c40fe99a2@oracle.com>
Content-Language: en-US
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <e3d8c926-d4a4-cc3b-b845-211c40fe99a2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:eJB5BAUacCl/wagIpBUIVtDXZzKF0z5RkLVH+ZE+z9/4KFSOFy/
 vjDukJNdBh1xvu+sr3L9O+AmMToI/DGD7Qi+UR9fUkvICJgmPwIb8pv9YmS+OGV+wbYczGv
 zR5CMqUy7aGHhghCBTBRNi2W0B0zzWvh8e7C2HbfB4pqpCjKEVs3IFO85WCdECP6ty1yHtK
 nUaHmCKnTU+n50bf+YDrQ==
UI-OutboundReport: notjunk:1;M01:P0:Xp8SoFAoRio=;r1iH5nHjewnHDeUlSFIvUJSoS6W
 xLo3sh3mR+WIf1tkn+OkGuT2rpYEipiprlkUSH2PY9EqzlSUlYegxgJE5zEu3WhRybLDBoYF5
 2LnoHPSWG+cPDaygTflYd9sBt8Q6k4421Leah/ZKSdXgt6MUY8WHJuNRSd8nCi8f3mlZ8Fi8Y
 5UK8D6gy7n6C+YHgBTwDUFnb8jNcjKZ9qx0/ueebCqoDhdp0l2bgckGio7Xk9al5sNiCr6JKn
 vcoQ63lvRUaofY8eQhgICdFH5+gSEh8BkYRWw9oSyWgof+u/Qrh+Lu3eAnlyLAm9zBOvy9Xyp
 2LX2isH148fpmEv8jU40oKt2GXqqhfLAvglK4nKwOLNt7KSPXX+NqiYHCghkFBnZI9v5GHjP3
 fqRtK0IUMBZbtvaPi44WIfkUdZCFwQQFYGe9mlWFQCT4WrDlgOoolAMzN30pJbFCUswEh0+ZO
 +KLVyVWCezlKNPOZTsruxjjjO3ce8cqg6iEgeXPUScsy1q/Ff/1E/hPyfKRAaG5JC/rUfLAiO
 w5v4u5K/zDjEeNMq/ZPOf5b6jK6lWhcaAy/vuWRoAQepVKPTjdNdLMdDI29unldMM0ie5/lVM
 7dfdQ6YcWf7yCW1PmInrlSFVQG1Yp2bZ6b/MXD+Q6IXhPe/E4ZThEAmUE2urFOOJNCOgQjPLg
 C5+MgHUH9eOb+Bc5bqbI6MLLcRpKNvfD9CB3Dm638QiXQJNqr/l3YB8EU9ZH3Dwkw+NyOKxIe
 MzcCmILtN43sDY8qQ2yA9zn9k0VPLyND67ERWvKDUWfXDbPOCI4ScIOBrf8z9xnB/sD2+Z34K
 /DV1X0B+9avSBMzocruZ9fTfwVlUe2ZIAMaKl++/f8E4M7ON0QvjhzzV+eH36hbcNIxtar40F
 gah5YoW/ME3Iwg6aF2u4TG7TzJxapD75om/ykPf3lMtW4ehAgWQGziwitJEBFZ8DhXSUQsRYQ
 DFV9LtfDxIxvenDcViYzY4dgaXY=
X-Spam-Status: No, score=-3.6 required=5.0 tests=FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/4/10 12:20, Anand Jain wrote:
> On 10/4/23 10:22, Qu Wenruo wrote:
>> This is for pre-6.4 kernels, as scrub code goes through a huge rework.
>>
>> [BUG]
>> Even before the scrub rework, if we have some corrupted metadata failed
>> to be repaired during replace, we still continue replace and let it
>> finish just as there is nothing wrong:
>>
>>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 
>> (devid 1) to /dev/mapper/test-scratch2 started
>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>> csum, has 0x00000000 want 0xade80ca1
>>   BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad 
>> csum, has 0x00000000 want 0xade80ca1
>>   BTRFS warning (device dm-4): checksum error at logical 5578752 on 
>> dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 
>> 0) in tree 5
>>   BTRFS warning (device dm-4): checksum error at logical 5578752 on 
>> dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 
>> 0) in tree 5
>>   BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 
>> 0, rd 0, flush 0, corrupt 1, gen 0
>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>> bytenr, has 0 want 5578752
>>   BTRFS error (device dm-4): unable to fixup (regular) error at 
>> logical 5578752 on dev /dev/mapper/test-scratch1
>>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 
>> (devid 1) to /dev/mapper/test-scratch2 finished
>>
>> This can lead to unexpected problems for the result fs.
>>
>> [CAUSE]
>> Btrfs reuses scrub code path for dev-replace to iterate all dev extents.
>>
>> But unlike scrub, dev-replace doesn't really bother to check the scrub
>> progress, which records all the errors found during replace.
>>
>> And even if we checks the progress, we can not really determine which
>> errors are minor, which are critical just by the plain numbers.
>> (remember we don't treat metadata/data checksum error differently).
>>
>> This behavior is there from the very beginning.
>>
>> [FIX]
>> Instead of continue the replace, just error out if we hit an unrepaired
>> metadata sector.
>>
>> Now the dev-replace would be rejected with -EIO, to inform the user.
>> Although it also means, the fs has some metadata error which can not be
>> repaired, the user would be super upset anyway.
> 
> IMO, the original design is fair as it does not capture scrub errors
> during the replace. Because the purpose of the scrub is different from
> the replace from the user POV.

The problem is, after such replace, the corrupted metadata would have 
different content (we just don't do the writeback at all).
Even worse, the end user is not even aware of the problem, unless dmesg 
is manually checked.

This means we changed the result fs during the replace, which removes 
the tiny chance to do a manual repair (aka, manually re-generate the 
checksum).

> However, after the replace, if scrubbed it will still capture any
> errors? No?

It's not about scrub after scrub. Such replace should not even finish.

Thanks,
Qu
> 
> Thanks, Anand
> 
> 
>>
>> The new dmesg would look like this:
>>
>>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 
>> (devid 1) to /dev/mapper/test-scratch2 started
>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>> csum, has 0x00000000 want 0xade80ca1
>>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad 
>> csum, has 0x00000000 want 0xade80ca1
>>   BTRFS error (device dm-4): unable to fixup (regular) error at 
>> logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
>>   BTRFS warning (device dm-4): header error at logical 5570560 on dev 
>> /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) 
>> in tree 5
>>   BTRFS warning (device dm-4): header error at logical 5570560 on dev 
>> /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) 
>> in tree 5
>>   BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata 
>> sector at 5578752
>>   BTRFS error (device dm-4): 
>> btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, 
>> /dev/mapper/test-scratch2) failed -5
>>
>> CC: stable@vger.kernel.org
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> I'm not sure how should we merge this patch.
>>
>> The misc-next is already merging the new scrub code, but the problem is
>> there for all old kernels thus we need such fixes.
>>
>> Maybe we can merge this fix before the scrub rework, then the rework,
>> and finally the better fix using reworked interface?
>> ---
>>   fs/btrfs/scrub.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index ef4046a2572c..71f64b9bcd9f 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -195,6 +195,7 @@ struct scrub_ctx {
>>       struct mutex            wr_lock;
>>       struct btrfs_device     *wr_tgtdev;
>>       bool                    flush_all_writes;
>> +    bool            has_meta_failed;
>>       /*
>>        * statistics
>> @@ -1380,6 +1381,8 @@ static int scrub_handle_errored_block(struct 
>> scrub_block *sblock_to_check)
>>           btrfs_err_rl_in_rcu(fs_info,
>>               "unable to fixup (regular) error at logical %llu on dev 
>> %s",
>>               logical, btrfs_dev_name(dev));
>> +        if (is_metadata)
>> +            sctx->has_meta_failed = true;
>>       }
>>   out:
>> @@ -3838,6 +3841,12 @@ static noinline_for_stack int 
>> scrub_stripe(struct scrub_ctx *sctx,
>>       blk_finish_plug(&plug);
>> +    /*
>> +     * If we have metadata unable to be repaired, we should error
>> +     * out the dev-replace.
>> +     */
>> +    if (sctx->is_dev_replace && sctx->has_meta_failed && ret >= 0)
>> +        ret = -EIO;
>>       if (sctx->is_dev_replace && ret >= 0) {
>>           int ret2;
> 
