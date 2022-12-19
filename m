Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5F2650B4F
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiLSMTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiLSMT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:19:26 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D62BC3;
        Mon, 19 Dec 2022 04:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1671452342; bh=IwceTt8tQkxF+Kusp4dyW7vLif+FlKFoH8SDEXZ9LeU=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Kk7BYjJvkA0flMJ1VLAhP+hY9ob9bNZeWigqh8RGyo96UBtRyiUms6ZcWvavJqw4E
         wn8zhLylpse1gWIPOz+ROaNfGTPA73ir9lmYYAufJkeETWNnK3LIdUn3bmbzPbRK0k
         N6w+O2gyfULYW4z8RorTXjcFzliPWOvJXUCLQvSy/co5N9a3kS9ARPbizpoD63rIIN
         9YDhIbmRgwF3HaumJLAB7uw/Kh86KECdwgXhFmnP0/KblaFVgkwaDesD/k7hPQksTp
         lG9SVlWgT8MNCyH2/KD+n7jN/5L/9BmAuqoaJ9oJewEuAPySxZra0W3Zt1gZsbNiIn
         3yaaVj1iGI7/A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.151.196]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbRfv-1oafNf2DE1-00btLm; Mon, 19
 Dec 2022 13:19:02 +0100
Message-ID: <d4eb5a9d-c2d3-08bf-6a9a-014e2d625a2e@gmx.de>
Date:   Mon, 19 Dec 2022 13:19:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: matroxfb: cannot determine memory size
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Z. Liu" <liuzx@knownsec.com>, linux-fbdev@vger.kernel.org,
        it+linux-fbdev@molgen.mpg.de, regressions@lists.linux.dev,
        stable@vger.kernel.org
References: <5da53ec5-3a9c-ec87-da20-69f140aaaa6b@molgen.mpg.de>
 <6ef71be5-def9-4578-3f73-c43c35d7e4a9@gmx.de>
 <dc0b1487-04f9-5a2f-e0f8-d157a74b6bcb@molgen.mpg.de> <Y5zhUl7r9z0lFJxc@p100>
 <48e83fa7-00a6-ba11-0db3-a165ce3c0699@molgen.mpg.de>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <48e83fa7-00a6-ba11-0db3-a165ce3c0699@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+dYkq1Fjbg6kdQ6/GU7LOac7RLcIsd2pDNfLwJ7+wfmLb2tUHkv
 UqQ+FHHxAX8O44ABxu0mrBr/zjQGZP1fnTBQlXo6YxBO1yMnZcjRQQ+xLsVF/oNg1La22tZ
 yrCZXLReq+0pTg0/4ieku+/BugWU+I3DDQX2uEqMzYLuS/G1AFyDuPLKzwtFtkHV9zdVI9y
 h/OU9hBa1CxeZm8Jy8mzg==
UI-OutboundReport: notjunk:1;M01:P0:JoRRLq0488o=;zrYhF8BuqHVABNQgmbuJeLB9RWK
 ZEsj7/jNQsmLEUvvAPTleL9zB4ONCFAyieTr9gx1ubLtKGH6gRY6cILnQMZPlOyjEAhhqYWQy
 /tzUYR9ZyiJgApBG4gk8WTraY+bPA530SSaAKQ+uxt6btfLFikK8UFBk+jrkBboVyRUCyPeAd
 c5GbUaxxN0xVfQOS1yHBB0/CSifK1kMWE8brCESDeXyRvF7Q9v17H2nJD8fi7Ah+h0gBJEEt9
 l1+g39/Bg7KLgGw4RXws28F/gx1Z4hxkQHawDZyxQatxd+VYLo3waaPeulYnZGHLERRWvvOof
 14tJNogytwsnBXSLsWvn/cNvKFp+i0rmoRaBeYwT7MH9RkazpF4wKS+9Icwl69jFO75fXK7fv
 kDBg+aTjyVFamQ5a84JnTkxQG5lLbmFG0ih70JsiQNM8phnYYLB5mIVdttc/5K1sYuEmQ6LZs
 cs4FNTilCbDGWJSqdx81TRGByspLe5AzNIxryUxDZ0J5BFt9Ec3c499sqMS+rFHvxtbOQ8zVI
 241Lkalx736fzdW2GBo0p8eafpK6Uz5nsTvAVUrwzwGlLKnxzEHJxrmSEuulai1bvrObbLfdL
 upCUHPWhuOwDmnCpm+xNm4tBri9Fw5Bnmv3mPRrcv/Pw02TrkaOxWvrrIint6Zfs4peWWpMti
 xaV7qLo8VXMv1ibXJajEAqXPnHyE2MxXCWPiuw4+5slwMi+IToLpG5BTAdrc6Zeqj6eQTESzf
 6/ZYZBYMZHvLd7X1wZXKlZdQs/pbEqTT2IAR+V8rWqPqx+duJPcEY6AL0dUXiP7RAxupfeR+y
 B0RGE9nyCnD+xM24bdtlcuiny0aCkb93oeHhrH4wxaLQZQKEb0mOP94j+3gZHnuOnlfW/O+Tx
 Y68pg269jr75Uj/+5snXjZb4UAd0iCZ+yjAb/+6NpJ9FOu/Ki+gBC79sgJrHpSsELtlPfvAlP
 sJl+kTEnj2Dc070sOsIq62nnr+M=
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 12:58, Paul Menzel wrote:
>
> Dear Helge,
>
>
> Am 16.12.22 um 22:21 schrieb Helge Deller:
>> * Paul Menzel <pmenzel@molgen.mpg.de>:
>>> [Cc: +regressions@, +stable@]
>>>
>>> #regzbot ^introduced: 62d89a7d49afe46e6b9bbe9e23b004ad848dbde4
>
>>> Am 16.12.22 um 00:02 schrieb Helge Deller:
>>>> On 12/15/22 17:39, Paul Menzel wrote:
>>>
>>>>> Between Linux 5.10.103 and 5.10.110/5.15.77, matrixfb fails to load.
>
> [=E2=80=A6]
>
>>>>> ### 5.15.77
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Linux v=
ersion 5.15.77.mx64.440 (root@theinternet.molgen.mpg.de) (gcc (GCC) 10.4.0=
, GNU ld (GNU Binutils) 2.37) #1 SMP Tue Nov 8 15:42:33 CET 2022
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Command=
 line: root=3DLABEL=3Droot ro crashkernel=3D64G-:256M console=3DttyS0,1152=
00n8 console=3Dtty0 init=3D/bin/systemd audit=3D0 random.trust_cpu=3Don sy=
stemd.unified_cgroup_hierarchy
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] DMI: De=
ll Inc. PowerEdge R715/0G2DP3, BIOS 1.5.2 04/19/2011
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 9.436420] matroxf=
b: Matrox MGA-G200eW (PCI) detected
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 9.444502] matroxf=
b: cannot determine memory size
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 9.449316] matroxf=
b: probe of 0000:0a:03.0 failed with error -1
>>>>>
>>>>> We see it on several systems:
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 $ lspci -nn -s 0a:03.0 # Dell PowerEd=
ge R715
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0a:03.0 VGA compatible controller [03=
00]: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0=
a)
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 $ lspci -nn -s 09:03.0 # Dell PowerEd=
ge R910
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 09:03.0 VGA compatible controller [03=
00]: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0=
a)
>
> Also Dell PowerEdge R815.
>
> [=E2=80=A6]
>
>>> I tested Linus=E2=80=99 master with commit 84e57d292203 (Merge tag
>>> 'exfat-for-6.2-rc1' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat) and th=
e
>>> error is still there. Reverting commit fixes the issue.
>>>
>>> Tested on:
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 DMI: Dell Inc. PowerEdge R910/0KYD3D, BIOS 2.=
10.0 08/29/2013
>>>
>>> Current master:
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 36.221595] matroxfb 0000:09:03.=
0: vgaarb: deactivate vga console
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 36.228355] Console: switching t=
o colour dummy device 80x25
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 36.234069] matroxfb: Matrox MGA=
-G200eW (PCI) detected
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 36.239316] PInS memtype =3D 7
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 36.242198] matroxfb: cannot det=
ermine memory size
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 36.242209] matroxfb: probe of 0=
000:09:03.0 failed with error -1
>>>
>>> After reverting 62d89a7d49af (video: fbdev: matroxfb: set maxvram of
>>> vbG200eW to the same as vbG200 to avoid black screen):
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 38.140763] matroxfb 0000:09:03.=
0: vgaarb: deactivate vga console
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 38.148057] Console: switching t=
o colour dummy device 80x25
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 38.153789] matroxfb: Matrox MGA=
-G200eW (PCI) detected
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 38.159042] PInS memtype =3D 7
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 38.161953] matroxfb: 640x480x8b=
pp (virtual: 640x13107)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 38.167175] matroxfb: framebuffe=
r at 0xC5000000, mapped to 0x000000006f41c38c, size 8388608
>>>
>>>>> The master commit 62d89a7d49a was added to v5.18-rc1, and was also
>>>>> backported to the Linux 5.15 series in 5.15.33.
>>
>> Good.
>>
>> Could you test if the patch below works for you as well (on top of
>> git master) ? I believe the commit f8bf19f7f311 (video: fbdev:
>> matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid
>> black screen) changed the wrong value...
>
>> diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video=
/fbdev/matrox/matroxfb_base.c
>> index 0d3cee7ae726..5192c7ac459a 100644
>> --- a/drivers/video/fbdev/matrox/matroxfb_base.c
>> +++ b/drivers/video/fbdev/matrox/matroxfb_base.c
>> @@ -1378,8 +1378,8 @@ static struct video_board vbG200 =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .lowlevel =3D &matrox_G100
>> =C2=A0 };
>> =C2=A0 static struct video_board vbG200eW =3D {
>> -=C2=A0=C2=A0=C2=A0 .maxvram =3D 0x100000,
>> -=C2=A0=C2=A0=C2=A0 .maxdisplayable =3D 0x800000,
>> +=C2=A0=C2=A0=C2=A0 .maxvram =3D 0x800000,
>> +=C2=A0=C2=A0=C2=A0 .maxdisplayable =3D 0x100000,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .accelID =3D FB_ACCEL_MATROX_MGAG200,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .lowlevel =3D &matrox_G100
>> =C2=A0 };
>
> Thank you. That worked.
>
>  =C2=A0=C2=A0=C2=A0 $ dmesg | grep -e matroxfb -e "Linux version" -e "DM=
I:"
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Linux version 6.1.0.mx=
64.440-13147-gfa99506bedb1 (pmenzel@dontpanic.molgen.mpg.de) (gcc (GCC) 11=
.1.0, GNU ld (GNU Binutils) 2.37) #1 SMP PREEMPT_DYNAMIC Mon Dec 19 12:13:=
21 CET 2022
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] DMI: Dell Inc. PowerEd=
ge R815/04Y8PT, BIOS 3.4.0 03/23/2018
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 29.033666] matroxfb 0000:0a:03.0: vgaa=
rb: deactivate vga console
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 29.046608] matroxfb: Matrox MGA-G200eW=
 (PCI) detected
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 29.054769] matroxfb: 640x480x8bpp (vir=
tual: 640x1638)
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 29.059901] matroxfb: framebuffer at 0x=
E4000000, mapped to 0x00000000d36c9776, size 8388608
>  =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 34.917829] matroxfb: Pixel PLL not loc=
ked after 5 secs
>  =C2=A0=C2=A0=C2=A0 $ lspci -nn -s 0a:03.0
>  =C2=A0=C2=A0=C2=A0 0a:03.0 VGA compatible controller [0300]: Matrox Ele=
ctronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)
>
>> If it works, can you send a patch?
>
> Will do.

Great.

> If you have some explanation though, I could add to the commit message, =
that=E2=80=99d be great.

Look at the comment in the code, a few lines further down, for the vbG400 =
card:

/* from doc it looks like that accelerator can draw only to low 16MB :-( D=
irect accesses & displaying are OK for
    whole 32MB */
static struct video_board vbG400 =3D {
         .maxvram =3D 0x2000000,
         .maxdisplayable =3D 0x1000000,

it makes sense to have maxdisplayable smaller than maxvram.
But Z Liu made maxvram lower than maxdisplayable.

Helge
