Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5320C4B7
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 00:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgF0Wfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 18:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgF0Wf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jun 2020 18:35:29 -0400
Received: from syrinx.knorrie.org (syrinx.knorrie.org [IPv6:2001:888:2177::4d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E2C061794;
        Sat, 27 Jun 2020 15:35:29 -0700 (PDT)
Received: from [IPv6:2a02:a213:2b80:f000::12] (unknown [IPv6:2a02:a213:2b80:f000::12])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 48CB3609726BE;
        Sun, 28 Jun 2020 00:35:28 +0200 (CEST)
Subject: Re: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
From:   Hans van Kranenburg <hans@knorrie.org>
To:     dsterba@suse.cz, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
 <20200626200619.GI27795@twin.jikos.cz>
 <e59c3b69-d10c-198d-2f69-b3936f908a73@knorrie.org>
Autocrypt: addr=hans@knorrie.org; keydata=
 mQINBFo2pooBEADwTBe/lrCa78zuhVkmpvuN+pXPWHkYs0LuAgJrOsOKhxLkYXn6Pn7e3xm+
 ySfxwtFmqLUMPWujQYF0r5C6DteypL7XvkPP+FPVlQnDIifyEoKq8JZRPsAFt1S87QThYPC3
 mjfluLUKVBP21H3ZFUGjcf+hnJSN9d9MuSQmAvtJiLbRTo5DTZZvO/SuQlmafaEQteaOswme
 DKRcIYj7+FokaW9n90P8agvPZJn50MCKy1D2QZwvw0g2ZMR8yUdtsX6fHTe7Ym+tHIYM3Tsg
 2KKgt17NTxIqyttcAIaVRs4+dnQ23J98iFmVHyT+X2Jou+KpHuULES8562QltmkchA7YxZpT
 mLMZ6TPit+sIocvxFE5dGiT1FMpjM5mOVCNOP+KOup/N7jobCG15haKWtu9k0kPz+trT3NOn
 gZXecYzBmasSJro60O4bwBayG9ILHNn+v/ZLg/jv33X2MV7oYXf+ustwjXnYUqVmjZkdI/pt
 30lcNUxCANvTF861OgvZUR4WoMNK4krXtodBoEImjmT385LATGFt9HnXd1rQ4QzqyMPBk84j
 roX5NpOzNZrNJiUxj+aUQZcINtbpmvskGpJX0RsfhOh2fxfQ39ZP/0a2C59gBQuVCH6C5qsY
 rc1qTIpGdPYT+J1S2rY88AvPpr2JHZbiVqeB3jIlwVSmkYeB/QARAQABtCZIYW5zIHZhbiBL
 cmFuZW5idXJnIDxoYW5zQGtub3JyaWUub3JnPokCTgQTAQoAOBYhBOJv1o/B6NS2GUVGTueB
 VzIYDCpVBQJaNq7KAhsDBQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAAAoJEOeBVzIYDCpVgDMQ
 ANSQMebh0Rr6RNhfA+g9CKiCDMGWZvHvvq3BNo9TqAo9BC4neAoVciSmeZXIlN8xVALf6rF8
 lKy8L1omocMcWw7TlvZHBr2gZHKlFYYC34R2NvxS0xO8Iw5rhEU6paYaKzlrvxuXuHMVXgjj
 bM3zBiN8W4b9VW1MoynP9nvm1WaGtFI9GIyK9j6mBCU+N5hpvFtt4DBmuWjzdDkd3sWUufYd
 nQhGimWHEg95GWhQUiFvr4HRvYJpbjRRRQG3O/5Fm0YyTYZkI5CDzQIm5lhqKNqmuf2ENstS
 8KcBImlbwlzEpK9Pa3Z5MUeLZ5Ywwv+d11fyhk53aT9bipdEipvcGa6DrA0DquO4WlQR+RKU
 ywoGTgntwFu8G0+tmD8J1UE6kIzFwE5kiFWjM0rxv1tAgV9ZWqmp3sbI7vzbZXn+KI/wosHV
 iDeW5rYg+PdmnOlYXQIJO+t0KmF5zJlSe7daylKZKTYtk7w1Fq/Oh1Rps9h1C4sXN8OAUO7h
 1SAnEtehHfv52nPxwZiI6eqbvqV0uEEyLFS5pCuuwmPpC8AmOrciY2T8T+4pmkJNO2Nd3jOP
 cnJgAQrxPvD7ACp/85LParnoz5c9/nPHJB1FgbAa7N5d8ubqJgi+k9Q2lAL9vBxK67aZlFZ0
 Kd7u1w1rUlY12KlFWzxpd4TuHZJ8rwi7PUceuQINBFo2sK8BEADSZP5cKnGl2d7CHXdpAzVF
 6K4Hxwn5eHyKC1D/YvsY+otq3PnfLJeMf1hzv2OSrGaEAkGJh/9yXPOkQ+J1OxJJs9CY0fqB
 MvHZ98iTyeFAq+4CwKcnZxLiBchQJQd0dFPujtcoMkWgzp3QdzONdkK4P7+9XfryPECyCSUF
 ib2aEkuU3Ic4LYfsBqGR5hezbJqOs96ExMnYUCEAS5aeejr3xNb8NqZLPqU38SQCTLrAmPAX
 glKVnYyEVxFUV8EXXY6AK31lRzpCqmPxLoyhPAPda9BXchRluy+QOyg+Yn4Q2DSwbgCYPrxo
 HTZKxH+E+JxCMfSW35ZE5ufvAbY3IrfHIhbNnHyxbTRgYMDbTQCDyN9F2Rvx3EButRMApj+v
 OuaMBJF/fWfxL3pSIosG9Q7uPc+qJvVMHMRNnS0Y1QQ5ZPLG0zI5TeHzMnGmSTbcvn/NOxDe
 6EhumcclFS0foHR78l1uOhUItya/48WCJE3FvOS3+KBhYvXCsG84KVsJeen+ieX/8lnSn0d2
 ZvUsj+6wo+d8tcOAP+KGwJ+ElOilqW29QfV4qvqmxnWjDYQWzxU9WGagU3z0diN97zMEO4D8
 SfUu72S5O0o9ATgid9lEzMKdagXP94x5CRvBydWu1E5CTgKZ3YZv+U3QclOG5p9/4+QNbhqH
 W4SaIIg90CFMiwARAQABiQRsBBgBCgAgFiEE4m/Wj8Ho1LYZRUZO54FXMhgMKlUFAlo2sK8C
 GwICQAkQ54FXMhgMKlXBdCAEGQEKAB0WIQRJbJ13A1ob3rfuShiywd9yY2FfbAUCWjawrwAK
 CRCywd9yY2FfbMKbEACIGLdFrD5j8rz/1fm8xWTJlOb3+o5A6fdJ2eyPwr5njJZSG9i5R28c
 dMmcwLtVisfedBUYLaMBmCEHnj7ylOgJi60HE74ZySX055hKECNfmA9Q7eidxta5WeXeTPSb
 PwTQkAgUZ576AO129MKKP4jkEiNENePMuYugCuW7XGR+FCEC2efYlVwDQy24ZfR9Q1dNK2ny
 0gH1c+313l0JcNTKjQ0e7M9KsQSKUr6Tk0VGTFZE2dp+dJF1sxtWhJ6Ci7N1yyj3buFFpD9c
 kj5YQFqBkEwt3OGtYNuLfdwR4d47CEGdQSm52n91n/AKdhRDG5xvvADG0qLGBXdWvbdQFllm
 v47TlJRDc9LmwpIqgtaUGTVjtkhw0SdiwJX+BjhtWTtrQPbseDe2pN3gWte/dPidJWnj8zzS
 ggZ5otY2reSvM+79w/odUlmtaFx+IyFITuFnBVcMF0uGmQBBxssew8rePQejYQHz0bZUDNbD
 VaZiXqP4njzBJu5+nzNxQKzQJ0VDF6ve5K49y0RpT4IjNOupZ+OtlZTQyM7moag+Y6bcJ7KK
 8+MRdRjGFFWP6H/RCSFAfoOGIKTlZHubjgetyQhMwKJQ5KnGDm+XUkeIWyevPfCVPNvqF2q3
 viQm0taFit8L+x7ATpolZuSCat5PSXtgx1liGjBpPKnERxyNLQ/erRNcEACwEJliFbQm+c2i
 6ccpx2cdtyAI1yzWuE0nr9DqpsEbIZzTCIVyry/VZgdJ27YijGJWesj/ie/8PtpDu0Cf1pty
 QOKSpC9WvRCFGJPGS8MmvzepmX2DYQ5MSKTO5tRJZ8EwCFfd9OxX2g280rdcDyCFkY3BYrf9
 ic2PTKQokx+9sLCHAC/+feSx/MA/vYpY1EJwkAr37mP7Q8KA9PCRShJziiljh5tKQeIG4sz1
 QjOrS8WryEwI160jKBBNc/M5n2kiIPCrapBGsL58MumrtbL53VimFOAJaPaRWNSdWCJSnVSv
 kCHMl/1fRgzXEMpEmOlBEY0Kdd1Ut3S2cuwejzI+WbrQLgeps2N70Ztq50PkfWkj0jeethhI
 FqIJzNlUqVkHl1zCWSFsghxiMyZmqULaGcSDItYQ+3c9fxIO/v0zDg7bLeG9Zbj4y8E47xqJ
 6brtAAEJ1RIM42gzF5GW71BqZrbFFoI0C6AzgHjaQP1xfj7nBRSBz4ObqnsuvRr7H6Jme5rl
 eg7COIbm8R7zsFjF4tC6k5HMc1tZ8xX+WoDsurqeQuBOg7rggmhJEpDK2f+g8DsvKtP14Vs0
 Sn7fVJi87b5HZojry1lZB2pXUH90+GWPF7DabimBki4QLzmyJ/ENH8GspFulVR3U7r3YYQ5K
 ctOSoRq9pGmMi231Q+xx9LkCDQRaOtArARAA50ylThKbq0ACHyomxjQ6nFNxa9ICp6byU9Lh
 hKOax0GB6l4WebMsQLhVGRQ8H7DT84E7QLRYsidEbneB1ciToZkL5YFFaVxY0Hj1wKxCFcVo
 CRNtOfoPnHQ5m/eDLaO4o0KKL/kaxZwTn2jnl6BQDGX1Aak0u4KiUlFtoWn/E/NIv5QbTGSw
 IYuzWqqYBIzFtDbiQRvGw0NuKxAGMhwXy8VP05mmNwRdyh/CC4rWQPBTvTeMwr3nl8/G+16/
 cn4RNGhDiGTTXcX03qzZ5jZ5N7GLY5JtE6pTpLG+EXn5pAnQ7MvuO19cCbp6Dj8fXRmI0SVX
 WKSo0A2C8xH6KLCRfUMzD7nvDRU+bAHQmbi5cZBODBZ5yp5CfIL1KUCSoiGOMpMin3FrarIl
 cxhNtoE+ya23A+JVtOwtM53ESra9cJL4WPkyk/E3OvNDmh8U6iZXn4ZaKQTHaxN9yvmAUhZQ
 iQi/sABwxCcQQ2ydRb86Vjcbx+FUr5OoEyQS46gc3KN5yax9D3H9wrptOzkNNMUhFj0oK0fX
 /MYDWOFeuNBTYk1uFRJDmHAOp01rrMHRogQAkMBuJDMrMHfolivZw8RKfdPzgiI500okLTzH
 C0wgSSAOyHKGZjYjbEwmxsl3sLJck9IPOKvqQi1DkvpOPFSUeX3LPBIav5UUlXt0wjbzInUA
 EQEAAYkCNgQYAQoAIBYhBOJv1o/B6NS2GUVGTueBVzIYDCpVBQJaOtArAhsMAAoJEOeBVzIY
 DCpV4kgP+wUh3BDRhuKaZyianKroStgr+LM8FIUwQs3Fc8qKrcDaa35vdT9cocDZjkaGHprp
 mlN0OuT2PB+Djt7am2noV6Kv1C8EnCPpyDBCwa7DntGdGcGMjH9w6aR4/ruNRUGS1aSMw8sR
 QgpTVWEyzHlnIH92D+k+IhdNG+eJ6o1fc7MeC0gUwMt27Im+TxVxc0JRfniNk8PUAg4kvJq7
 z7NLBUcJsIh3hM0WHQH9AYe/mZhQq5oyZTsz4jo/dWFRSlpY7zrDS2TZNYt4cCfZj1bIdpbf
 SpRi9M3W/yBF2WOkwYgbkqGnTUvr+3r0LMCH2H7nzENrYxNY2kFmDX9bBvOWsWpcMdOEo99/
 Iayz5/q2d1rVjYVFRm5U9hG+C7BYvtUOnUvSEBeE4tnJBMakbJPYxWe61yANDQubPsINB10i
 ngzsm553yqEjLTuWOjzdHLpE4lzD416ExCoZy7RLEHNhM1YQSI2RNs8umlDfZM9Lek1+1kgB
 vT3RH0/CpPJgveWV5xDOKuhD8j5l7FME+t2RWP+gyLid6dE0C7J03ir90PlTEkMEHEzyJMPt
 OhO05Phy+d51WPTo1VSKxhL4bsWddHLfQoXW8RQ388Q69JG4m+JhNH/XvWe3aQFpYP+GZuzO
 hkMez0lHCaVOOLBSKHkAHh9i0/pH+/3hfEa4NsoHCpyy
Message-ID: <b43e807b-97f8-3b46-b29d-46318398a215@knorrie.org>
Date:   Sun, 28 Jun 2020 00:35:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e59c3b69-d10c-198d-2f69-b3936f908a73@knorrie.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ah,

On 6/27/20 11:01 PM, Hans van Kranenburg wrote:
> On 6/26/20 10:06 PM, David Sterba wrote:
>> On Sat, Jun 27, 2020 at 12:01:07AM +0900, Johannes Thumshirn wrote:
>>> With the recent addition of filesystem checksum types other than CRC32c,
>>> it is not anymore hard-coded which checksum type a btrfs filesystem uses.
>>>
>>> Up to now there is no good way to read the filesystem checksum, apart from
>>> reading the filesystem UUID and then query sysfs for the checksum type.
>>>
>>> Add a new csum_type field to the BTRFS_IOC_FS_INFO ioctl command which
>>> usually is used to query filesystem features. Also add a flags member
>>> indicating that the kernel responded with a set csum_type field.
>>>
>>> To simplify further additions to the ioctl, also switch the padding to a
>>> u8 array. Pahole was used to verify the result of this switch:
>>>
>>> pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
>>> struct btrfs_ioctl_fs_info_args {
>>>         __u64                      max_id;               /*     0     8 */
>>>         __u64                      num_devices;          /*     8     8 */
>>>         __u8                       fsid[16];             /*    16    16 */
>> g         __u32                      nodesize;             /*    32     4 */
>>>         __u32                      sectorsize;           /*    36     4 */
>>>         __u32                      clone_alignment;      /*    40     4 */
>>>         __u32                      flags;                /*    44     4 */
>>>         __u16                      csum_type;            /*    48     2 */
>>>         __u16                      csum_size;            /*    50     2 */
>>>         __u8                       reserved[972];        /*    52   972 */
>>>
>>>         /* size: 1024, cachelines: 16, members: 10 */
>>> };
>>>
>>> Fixes: 3951e7f050ac ("btrfs: add xxhash64 to checksumming algorithms")
>>> Fixes: 3831bf0094ab ("btrfs: add sha256 to checksumming algorithm")
>>> Cc: stable@vger.kernel.org
>>
>> CC: stable@vger.kernel.org # 5.5+
>>
>> it'll not compile otherwise.
>>
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3217,6 +3217,9 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>>>  	fi_args->nodesize = fs_info->nodesize;
>>>  	fi_args->sectorsize = fs_info->sectorsize;
>>>  	fi_args->clone_alignment = fs_info->sectorsize;
>>> +	fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
>>> +	fi_args->csum_size = btrfs_super_csum_size(fs_info->super_copy);
>>> +	fi_args->flags |= BTRFS_FS_INFO_FLAG_CSUM_TYPE_SIZE;
>>>  
>>>  	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
>>>  		ret = -EFAULT;
>>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>>> index e6b6cb0f8bc6..2de3ef3c5c71 100644
>>> --- a/include/uapi/linux/btrfs.h
>>> +++ b/include/uapi/linux/btrfs.h
>>> @@ -250,10 +250,20 @@ struct btrfs_ioctl_fs_info_args {
>>>  	__u32 nodesize;				/* out */
>>>  	__u32 sectorsize;			/* out */
>>>  	__u32 clone_alignment;			/* out */
>>> -	__u32 reserved32;
>>> -	__u64 reserved[122];			/* pad to 1k */
>>> +	__u32 flags;				/* out */
>>
>> After the discussion under v2 with Hans, I think he has a point that
>> future extension could be problematic as it was with the LOGICAL_INO.
>> It's similar, once we'd want to do the input flags, there's no way to
>> make the behaviour safe.
>>
>> If all ioctl users would zero the buffer it's all fine, but I don't know
>> how to make that more than a convention
> 
> At least for all new code, check and demand that the buffer is zeroed
> (except for input fields, of course). This is typically something from
> the 'been-there-done-that-oops' category. It's not realized that it's
> necessary until running into these issues when it's too late. :)
> 
>> and given that this is not well
>> documented we can't blame users/programs when this is not honored.
> 
> The fun of maintaining stable APIs :)
> 
>> So, my suggestion is to make the flags also input,
> 
> If we think that with whatever being added in the future the output will
> still only contain a bunch of values that are very cheap to collect when
> filling the response buffer, then why would you still want to have this?
> 
>> where the valid value
>> is 0, meaning 'return everything you have'. In this case it's a no-op,
>> but allows future extensions and fine grained data retrieval.
> 
> This will work right now when 0 means return everything and when
> uninitialized data in the field (with 1s somewhere) returns or does not
> return extra stuff. The old calling code will not look at those parts of
> the response anyway.
> 
> But this does not allow you to signal that requested data that is not
> implemented is not available with ENOENT (e.g. with the unavailable
> flags set in the response) or anything. Ever. Or am I missing something?

Ah, I think what I'm missing is that this can work without ever sending
an error code if something is requested that the currently running
kernel does not support, since the flag can be reset in the response, so
the caller can (must) look at that and see it's not available.

Clever :)

However, then I would propose to implement that right now. So, tell the
users that "hey! there are new fields, if you want to see them just flip
all bits to 1 in the flags input". I mean, the calling code has to be
touched anyway to do something with it, so adding some ones in the
buffer is a small extra change.

Current calling code following best practices will send a zeroed buffer,
and does not get any new goodies, but that old code doesn't do anything
with it anyway. (So, that means *not* mapping the all zeroes to all
ones. All zero means no new features!)

Caller with uninitialized memory will get what they accidentally ask
for, with unavailable bits cleared in the output, but noone cares, since
the calling code doesn't look at that part of the buffer anyway.

:O

The BIG difference for this case vs. LOGICAL_INO_V2 is that for
LOGICAL_INO it would change the behavior of the called function, which
is a totally different cup of tea than just messing around in a part of
the buffer that's ignored anyway.

So, the same thing as done here could be done when extending
GET_DEV_STATS because I see users are asking about counters for repaired
errors to be added, so they can be used for early warning alerts of
failing disks.

>> There's effectively no change in the implementation, other than
>> documenting the 'in' semantics.
>>
>> Although this is basically the same situation as in the LOGICAL_INO v1
>> and v2, the number of users of FS_INFO ioctl is presumably not high and
>> the buffer has been write-only so far, there's no existing logic that
>> would had to be tweaked.
>>
>> Once the flags are there, all new implementations should take the
>> semantics into account. Therefore I think this is a safe plan, but feel
>> free to poke more holes to that.
> 
> In the V2 thread you mentioned generation, metadata_uuid, total_bytes as
> interesting missing ones. What about adding them just right now directly?
> 
> K
