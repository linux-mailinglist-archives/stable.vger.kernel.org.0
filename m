Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1331D6CC0C0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjC1N2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 09:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjC1N2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 09:28:36 -0400
Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAF81B6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 06:28:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680010110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xuo0gAe+uNfOVnxmsvixNUAwD6uYZpf6yc19i8ADTPg=;
        b=EvNMwYwLUDTq5urSLN/8u9tdFuV3spqW6AFj2ViFa9QX2XsUZKe1KFafbQfUh6TiPps4gu
        xGDav1kW/Jbn0j8r1snQJyybwB5Pvea9DCiCMPwVBNWGZz3ZGlxwGaGYWNVpLyXasXgVeI
        pOWI7vKoAPyMhXCYPGg9fzekJdr8DiU=
From:   Muchun Song <muchun.song@linux.dev>
Message-Id: <F3961306-A6F5-4B3A-A7D3-23A1838E87ED@linux.dev>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_65CCB859-9116-4065-A85E-18FE1BCC2552"
MIME-Version: 1.0
Subject: Re: FAILED: patch "[PATCH] mm: kfence: fix using kfence_metadata
 without initialization" failed to apply to 5.15-stable tree
Date:   Tue, 28 Mar 2023 21:27:54 +0800
In-Reply-To: <ZCLpfES07kMJv_rh@kroah.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, dvyukov@google.com,
        Marco Elver <elver@google.com>, glider@google.com,
        jannh@google.com, sjpark@amazon.de,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
To:     Greg KH <gregkh@linuxfoundation.org>
References: <16800049118459@kroah.com>
 <90d1ad90-028c-7fa2-70dd-09737eece60c@linux.dev> <ZCLpfES07kMJv_rh@kroah.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_65CCB859-9116-4065-A85E-18FE1BCC2552
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Mar 28, 2023, at 21:19, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Tue, Mar 28, 2023 at 09:02:27PM +0800, Muchun Song wrote:
>>=20
>>=20
>> On 2023/3/28 20:01, gregkh@linuxfoundation.org wrote:
>>> The patch below does not apply to the 5.15-stable tree.
>>> If someone wants it applied there, or to any other stable or =
longterm
>>> tree, then please email the backport, including the original git =
commit
>>> id to <stable@vger.kernel.org>.
>>>=20
>>> To reproduce the conflict and resubmit, you may use the following =
commands:
>>>=20
>>> git fetch =
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ =
linux-5.15.y
>>> git checkout FETCH_HEAD
>>> git cherry-pick -x 1c86a188e03156223a34d09ce290b49bd4dd0403
>>> # <resolve conflicts, build, test, etc.>
>>> git commit -s
>>> git send-email --to '<stable@vger.kernel.org>' --in-reply-to =
'16800049118459@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..
>>>=20
>>> Possible dependencies:
>>>=20
>>> 1c86a188e031 ("mm: kfence: fix using kfence_metadata without =
initialization in show_object()")
>>> b33f778bba5e ("kfence: alloc kfence_pool after system startup")
>>> 698361bca2d5 ("kfence: allow re-enabling KFENCE after system =
startup")
>>> 07e8481d3c38 ("kfence: always use static branches to guard =
kfence_alloc()")
>>> 08f6b10630f2 ("kfence: limit currently covered allocations when pool =
nearly full")
>>> a9ab52bbcb52 ("kfence: move saving stack trace of allocations into =
__kfence_alloc()")
>>> 9a19aeb56650 ("kfence: count unexpectedly skipped allocations")
>>>=20
>>> thanks,
>>>=20
>>> greg k-h
>>>=20
>>> ------------------ original commit in Linus's tree =
------------------
>>>=20
>>> =46rom 1c86a188e03156223a34d09ce290b49bd4dd0403 Mon Sep 17 00:00:00 =
2001
>>> From: Muchun Song <muchun.song@linux.dev>
>>> Date: Wed, 15 Mar 2023 11:44:41 +0800
>>> Subject: [PATCH] mm: kfence: fix using kfence_metadata without =
initialization
>>>  in show_object()
>>>=20
>>> The variable kfence_metadata is initialized in kfence_init_pool(), =
then,
>>> it is not initialized if kfence is disabled after booting.  In this =
case,
>>> kfence_metadata will be used (e.g.  ->lock and ->state fields) =
without
>>> initialization when reading /sys/kernel/debug/kfence/objects.  There =
will
>>> be a warning if you enable CONFIG_DEBUG_SPINLOCK.  Fix it by =
creating
>>> debugfs files when necessary.
>>>=20
>>> Link: =
https://lkml.kernel.org/r/20230315034441.44321-1-songmuchun@bytedance.com
>>> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Tested-by: Marco Elver <elver@google.com>
>>> Reviewed-by: Marco Elver <elver@google.com>
>>> Cc: Alexander Potapenko <glider@google.com>
>>> Cc: Dmitry Vyukov <dvyukov@google.com>
>>> Cc: Jann Horn <jannh@google.com>
>>> Cc: SeongJae Park <sjpark@amazon.de>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>=20
>>> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
>>> index 5349c37a5dac..79c94ee55f97 100644
>>> --- a/mm/kfence/core.c
>>> +++ b/mm/kfence/core.c
>>> @@ -726,10 +726,14 @@ static const struct seq_operations =
objects_sops =3D {
>>>  };
>>>  DEFINE_SEQ_ATTRIBUTE(objects);
>>> -static int __init kfence_debugfs_init(void)
>>> +static int kfence_debugfs_init(void)
>>>  {
>>> - struct dentry *kfence_dir =3D debugfs_create_dir("kfence", NULL);
>>> + struct dentry *kfence_dir;
>>> + if (!READ_ONCE(kfence_enabled))
>>> + return 0;
>>> +
>>> + kfence_dir =3D debugfs_create_dir("kfence", NULL);
>>>   debugfs_create_file("stats", 0444, kfence_dir, NULL, &stats_fops);
>>>   debugfs_create_file("objects", 0400, kfence_dir, NULL, =
&objects_fops);
>>>   return 0;
>>> @@ -883,6 +887,8 @@ static int kfence_init_late(void)
>>>   }
>>>   kfence_init_enable();
>>> + kfence_debugfs_init();
>>> +
>>>   return 0;
>>>  }
>>=20
>> I have implemented a following patch based on v5.15 branch.
>>=20
>> =46rom ba26f344fa3e477456a3cc60488a7b8e5af0e88d Mon Sep 17 00:00:00 =
2001
>> From: Muchun Song <songmuchun@bytedance.com>
>> Date: Wed, 15 Mar 2023 11:44:41 +0800
>> Subject: [PATCH] mm: kfence: fix using kfence_metadata without
>> initialization
>>  in show_object()
>>=20
>> The variable kfence_metadata is initialized in kfence_init_pool(), =
then,
>> it is not initialized if kfence is disabled after booting.  In this =
case,
>> kfence_metadata will be used (e.g.  ->lock and ->state fields) =
without
>> initialization when reading /sys/kernel/debug/kfence/objects.  There =
will
>> be a warning if you enable CONFIG_DEBUG_SPINLOCK.  Fix it by creating
>> debugfs files when necessary.
>>=20
>> Link:
>> =
https://lkml.kernel.org/r/20230315034441.44321-1-songmuchun@bytedance.com
>> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Tested-by: Marco Elver <elver@google.com>
>> Reviewed-by: Marco Elver <elver@google.com>
>> Cc: Alexander Potapenko <glider@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: SeongJae Park <sjpark@amazon.de>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  mm/kfence/core.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
>> index 39a6c434e355..573f34e6af0b 100644
>> --- a/mm/kfence/core.c
>> +++ b/mm/kfence/core.c
>> @@ -678,10 +678,14 @@ static const struct file_operations =
objects_fops =3D {
>>      .release =3D seq_release,
>>  };
>>=20
>=20
> Patch is corrupted with the whitespace eaten by your email client.  =
Can
> you resend this in a format that it can be applied?

I attach it here. Could you apply it? Thanks.


--Apple-Mail=_65CCB859-9116-4065-A85E-18FE1BCC2552
Content-Disposition: attachment;
	filename=0001-mm-kfence-fix-using-kfence_metadata-without-initiali.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-mm-kfence-fix-using-kfence_metadata-without-initiali.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20ba26f344fa3e477456a3cc60488a7b8e5af0e88d=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Muchun=20Song=20<songmuchun@bytedance.com>=0A=
Date:=20Wed,=2015=20Mar=202023=2011:44:41=20+0800=0ASubject:=20[PATCH]=20=
mm:=20kfence:=20fix=20using=20kfence_metadata=20without=20initialization=0A=
=20in=20show_object()=0A=0AThe=20variable=20kfence_metadata=20is=20=
initialized=20in=20kfence_init_pool(),=20then,=0Ait=20is=20not=20=
initialized=20if=20kfence=20is=20disabled=20after=20booting.=20=20In=20=
this=20case,=0Akfence_metadata=20will=20be=20used=20(e.g.=20=20->lock=20=
and=20->state=20fields)=20without=0Ainitialization=20when=20reading=20=
/sys/kernel/debug/kfence/objects.=20=20There=20will=0Abe=20a=20warning=20=
if=20you=20enable=20CONFIG_DEBUG_SPINLOCK.=20=20Fix=20it=20by=20creating=0A=
debugfs=20files=20when=20necessary.=0A=0ALink:=20=
https://lkml.kernel.org/r/20230315034441.44321-1-songmuchun@bytedance.com=0A=
Fixes:=200ce20dd84089=20("mm:=20add=20Kernel=20Electric-Fence=20=
infrastructure")=0ASigned-off-by:=20Muchun=20Song=20=
<songmuchun@bytedance.com>=0ATested-by:=20Marco=20Elver=20=
<elver@google.com>=0AReviewed-by:=20Marco=20Elver=20<elver@google.com>=0A=
Cc:=20Alexander=20Potapenko=20<glider@google.com>=0ACc:=20Dmitry=20=
Vyukov=20<dvyukov@google.com>=0ACc:=20Jann=20Horn=20<jannh@google.com>=0A=
Cc:=20SeongJae=20Park=20<sjpark@amazon.de>=0ACc:=20=
<stable@vger.kernel.org>=0ASigned-off-by:=20Andrew=20Morton=20=
<akpm@linux-foundation.org>=0A---=0A=20mm/kfence/core.c=20|=208=20=
++++++--=0A=201=20file=20changed,=206=20insertions(+),=202=20=
deletions(-)=0A=0Adiff=20--git=20a/mm/kfence/core.c=20b/mm/kfence/core.c=0A=
index=2039a6c434e355..573f34e6af0b=20100644=0A---=20a/mm/kfence/core.c=0A=
+++=20b/mm/kfence/core.c=0A@@=20-678,10=20+678,14=20@@=20static=20const=20=
struct=20file_operations=20objects_fops=20=3D=20{=0A=20=09.release=20=3D=20=
seq_release,=0A=20};=0A=20=0A-static=20int=20__init=20=
kfence_debugfs_init(void)=0A+static=20int=20kfence_debugfs_init(void)=0A=20=
{=0A-=09struct=20dentry=20*kfence_dir=20=3D=20=
debugfs_create_dir("kfence",=20NULL);=0A+=09struct=20dentry=20=
*kfence_dir;=0A=20=0A+=09if=20(!READ_ONCE(kfence_enabled))=0A+=09=09=
return=200;=0A+=0A+=09kfence_dir=20=3D=20debugfs_create_dir("kfence",=20=
NULL);=0A=20=09debugfs_create_file("stats",=200444,=20kfence_dir,=20=
NULL,=20&stats_fops);=0A=20=09debugfs_create_file("objects",=200400,=20=
kfence_dir,=20NULL,=20&objects_fops);=0A=20=09return=200;=0A--=20=0A=
2.11.0=0A=0A=

--Apple-Mail=_65CCB859-9116-4065-A85E-18FE1BCC2552
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> 
> thanks,
> 
> greg k-h



--Apple-Mail=_65CCB859-9116-4065-A85E-18FE1BCC2552--
