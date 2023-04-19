Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B88E6E85A8
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 01:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjDSXH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 19:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjDSXH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 19:07:58 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30BA1BD6;
        Wed, 19 Apr 2023 16:07:55 -0700 (PDT)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MzQkK-1qBK1z3ynQ-00vQmg; Thu, 20
 Apr 2023 01:07:48 +0200
Message-ID: <aab28979-0e54-2a02-6641-e23e9e525f90@gmx.com>
Date:   Thu, 20 Apr 2023 07:07:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH pre-6.4] btrfs: dev-replace: error out if we have
 unrepaired metadata error during
To:     Torstein Eide <torsteine@gmail.com>, anand.jain@oracle.com
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>
References: <CAL5DHTEcqoUnbMLVgEEPr21zLqj+FSVckPepxxL-Gg9yhkGNvA@mail.gmail.com>
Content-Language: en-US
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <CAL5DHTEcqoUnbMLVgEEPr21zLqj+FSVckPepxxL-Gg9yhkGNvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:YfQwZx/pIaw9+dB9V6FHFzOln07y9c6YJmniRzUnxmD3OZS2POS
 +ou2H6bBgBbOcz9E8u/Wlr1/2LU+PriH4icMdZNpfzjN+Y9lxoZbPYYsoPoHZSnah5H20Dm
 X035chf3HVzKy5FI2avvkO+WlHm1TaD63A7X7DSYhJrvkR8HKfKXp4cncOjm/yeVk4ZoptY
 Yivb2Upb3HTR2NEOhvfsQ==
UI-OutboundReport: notjunk:1;M01:P0:l8MWzbRWLc8=;4f6l0FGEdJ5+sF3BBD2VpDGbkO7
 FJJGyDcoJA5nrc9dLz5AauTrQUTAN/iRyH3dEJrtledc2FP3FAmGmzD1t88jzLpRW83kG/mpI
 0L6sJ/LEc5hmlXlnqvEB14JT0zEuz6FDf1ypKqjpWoSq0YSdeVpjy/m166ajtpFJ94lR/Q02g
 16BxrClJslBXtsJVpMOsPWY23R6QEVb8jlcxsxntK7OptPnuBMhBDT0WWArPeIpGvmRmlcTKG
 N0yYTm/LmQSIxzfjmBcAexDZQNY6fibY7irI28/RV0OI0fBlzfPDNCztno9LTIB6Gr8d0z1im
 XngdR2Q03PzcD8h3VyuDz53rMe3ukO5wVhpSc7fI30LE+shMJoMtO1SIZogtnSk2x+oLSVMkj
 Wp58imN2gHgbNckREqAAmyp4xqhbUUmxeJJzfWjDBkuRjwXv1W9UcYHLff/Qex9py+h6LTFeu
 HZWpEbnSyTdLsGYHWi7DB7y7M2QLeHs4T+JRIdIgWy0DwOsXsOUzGLYxb0jj2+MAwc5f0l1cS
 pqQoh/VMO8ViA5aWNIBO4nl/N1y6w/OaOxq7YwmrWlRWVeMRXSNJIp1paPwrfyiVelC5iWk5R
 PsafI2s/WxoZETroHyGYj0iWijE10bxMGubewKDRol4teIz76gyM6UXXG7CaNL9wd8D8Aqxow
 fEYlN2TnUKr7BNhpm5ANbliXVi8iI1GhD6mQMN2XNm9Ti0/gvQH/1mPDvZ5mOI24Coo8R/iqY
 IUNrA6zJ6uYq5zzF79zK9dnrxDvnaTUyRb3iUEE/g2X+n0lBGSurL/eTuFkw7j3vB81xufnPR
 bYCXifcAAieeyE305a+f5mBL+fjlJ15558wk0IZfU2J+jD7FgZBzpTTSuOxQVtGW7jSZKrLen
 jmr1Alk4+yE4pkrM+3nHy1BV8sl1mIFvXO0zgkSQ7j8fQDy8ALWNPLVD/eT28KM7uOX7MLTNc
 g7dQs+UC84GkyLg47h07VoY4B2A=
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/4/20 04:23, Torstein Eide wrote:
>> This is for pre-6.4 kernels, as scrub code goes through a huge rework.
>>
>> [BUG]
>> Even before the scrub rework, if we have some corrupted metadata failed
>> to be repaired during replace, we still continue replace and let it
>> finish just as there is nothing wrong:
>>
>>    BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>>    BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>>    BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad csum, has 0x00000000 want 0xade80ca1
>>    BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>>    BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>>    BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>    BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad bytenr, has 0 want 5578752
>>    BTRFS error (device dm-4): unable to fixup (regular) error at logical 5578752 on dev /dev/mapper/test-scratch1
>>    BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 finished
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
> If one sector is bad in metadata how much secondary data is damaged?

If it's metadata, it's highly possible the metadata has extra copy by 
default.
(Single disk btrfs goes DUP for meta, while multi-disk one goes RAID1 by 
default).

And if it's a metadata corruption, good luck it's not a critical one, or 
this would be your last time to mount the fs.

> 
> As someone who recently had to remove, and currently replace a disk.
> it is upsetting, if it stopped if we stopped because 0,01% of data is
> unrepairable, if we can save the other 99,99%. Can we have it
> continue, print an error message to standard out, and a way for the
> user to delete or copy it (with som option like -force-delete or
> --force-copy) with the error to the new disk?
> "Metadata at block 5578752 is damaged and unrepaired. Skipping. Read
> `man btrfs-replace` for more info. "
> At the end if possible, list files affected by the damaged metadata blocks.
> 
> In man answer:
> How can the user know what files are connected to the metadata?
> How can a user decide what to do with the damaged metadata?
> 
> 
> At minimum,  can there be some useful info to the info to the error output? like
> "Replace has stopped, due to reading unrepaired metadata block, was
> working on block 5578752, se `dmesg` for more details. (\s Sorry but
> you are currently f..k)"

I'd say, if your metadata is already corrupted, you don't want a 
"generic" solution, but ask for a developer to guide you how to recover.

Thanks,
Qu

> 
> 
> 
>>
>> The new dmesg would look like this:
>>
>>    BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>>    BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>>    BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>>    BTRFS error (device dm-4): unable to fixup (regular) error at logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
>>    BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>>    BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>>    BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata sector at 5578752
>>    BTRFS error (device dm-4): btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, /dev/mapper/test-scratch2) failed -5
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
>>    fs/btrfs/scrub.c | 9 +++++++++
>>    1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index ef4046a2572c..71f64b9bcd9f 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -195,6 +195,7 @@ struct scrub_ctx {
>>    struct mutex            wr_lock;
>>    struct btrfs_device     *wr_tgtdev;
>>    bool                    flush_all_writes;
>> + bool has_meta_failed;
>>
>>    /*
>>    * statistics
>> @@ -1380,6 +1381,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>>    btrfs_err_rl_in_rcu(fs_info,
>>    "unable to fixup (regular) error at logical %llu on dev %s",
>>    logical, btrfs_dev_name(dev));
>> + if (is_metadata)
>> + sctx->has_meta_failed = true;
>>    }
>>
>>    out:
>> @@ -3838,6 +3841,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>>
>>    blk_finish_plug(&plug);
>>
>> + /*
>> + * If we have metadata unable to be repaired, we should error
>> + * out the dev-replace.
>> + */
>> + if (sctx->is_dev_replace && sctx->has_meta_failed && ret >= 0)
>> + ret = -EIO;
>>    if (sctx->is_dev_replace && ret >= 0) {
>>    int ret2;
>>
> 
> 
