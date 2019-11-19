Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0051024DA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfKSMvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:51:07 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727678AbfKSMvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:51:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574167865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QEDKMyayCUjPgIE9DPZezHt4FnuO8rXLJV/h7E1JGa4=;
        b=HLLgrLqDWVF4mjOoGELJFRArYOd2axkB2Y5AbhhMaqeXXXtnRnd8srymo6yeHnG1ExJ9CJ
        0lDEeDnPXfKatYgbg2yM+Q/cnVcIVDCBJukCds0g1VPjnEfxArYmxKqe59ZOaev0eozkhX
        C5ImMvdrJSjAf6XjjTq+jBgx5hHzcSQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-5qjGg8PFPfS6C1BCp1OmxA-1; Tue, 19 Nov 2019 07:50:59 -0500
Received: by mail-qk1-f197.google.com with SMTP id q14so5850604qkq.13
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 04:50:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v0yQRjcMF4pMatebKNWPD4GsrcfBYND0A2pjfYAUpEs=;
        b=XtMtV+/ghBdU8VV3FHaFLz+nSf+5BMS3Ht2+XkcfaTfeJtxKTqPTSJQELTiArBupYw
         mKlsGx5ta+ybqOaZ2SJhnUs8t/t54FC8x5Huhd6JcU2m+IGSp6LDu3MEUTk7lTUTzGQ7
         bIhMMv5tLiMh+F3W+F3P8mUxLmxkhKfcN89PMMkl78DpHxoqFv9ibuo7JgxRe205kZsL
         heviI+whSxz8sqePG3Is31YferQCAaUa8s8X2YSqEWxIIxyfgc1LoLODHom31kuuC3as
         C8ubLnbIFqAAqX8dj/QedaNKb4upFUst5JRI8zQPHYDse4zWc+/OxS1qAqPJRcjg7kFD
         aLMg==
X-Gm-Message-State: APjAAAWiaHR+LcaGCNaHfmga868klXV4a4XMSq47+5KfxNHVz5noeSv2
        NvZNL/jBwkRgxJSJxDIBMTauccKS+8xlvUP4vQ7GemJluVBX0IP25K/r119SrLtB/55RtQk7MQa
        4dqRU1P6tJHlE0Ofu
X-Received: by 2002:a37:a650:: with SMTP id p77mr16155372qke.188.1574167858728;
        Tue, 19 Nov 2019 04:50:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVpYrDtpqXfgyAR+mYTNqB981fhGl1zI6Y1Vd4W3jPJ7xhLz3f71eKnWfrx6kT2ISTRX8K8w==
X-Received: by 2002:a37:a650:: with SMTP id p77mr16155348qke.188.1574167858384;
        Tue, 19 Nov 2019 04:50:58 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id k65sm11891302qtd.14.2019.11.19.04.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 04:50:57 -0800 (PST)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e3?=
To:     Greg KH <greg@kroah.com>
Cc:     Rachel Sibley <rasibley@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
References: <cki.042792963E.5VOWULC1Q9@redhat.com>
 <8e0fa6de-b6b1-23ac-9e77-d425c8d1ba22@redhat.com>
 <c326c35e-453e-2dae-391c-5324803e6112@redhat.com>
 <20191119124428.GC1975017@kroah.com>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <236c4f8d-a54e-daa6-0896-eca236e23e58@redhat.com>
Date:   Tue, 19 Nov 2019 07:50:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191119124428.GC1975017@kroah.com>
Content-Language: en-US
X-MC-Unique: 5qjGg8PFPfS6C1BCp1OmxA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/19 7:44 AM, Greg KH wrote:
> On Tue, Nov 19, 2019 at 07:37:09AM -0500, Laura Abbott wrote:
>> On 11/18/19 7:07 PM, Rachel Sibley wrote:
>>>
>>> On 11/18/19 10:00 AM, CKI Project wrote:
>>>> Hello,
>>>>
>>>> We ran automated tests on a patchset that was proposed for merging int=
o this
>>>> kernel tree. The patches were applied to:
>>>>
>>>>          Kernel repo:https://git.kernel.org/pub/scm/linux/kernel/git/s=
table/linux.git
>>>>               Commit: 116a395b7061 - Linux 5.3.11
>>>>
>>>> The results of these automated tests are provided below.
>>>>
>>>>       Overall result: FAILED (see details below)
>>>>                Merge: OK
>>>>              Compile: OK
>>>>                Tests: FAILED
>>>>
>>>> All kernel binaries, config files, and logs are available for download=
 here:
>>>>
>>>>     https://artifacts.cki-project.org/pipelines/293063
>>>>
>>>> One or more kernel tests failed:
>>>>
>>>>       aarch64:
>>>>        =E2=9D=8C LTP lite
>>>
>>> I see a panic when installing the LTP dependencies
>>>
>>> [  690.625060] Call trace:
>>> [  690.627495]  bfq_find_set_group+0x8c/0xf0
>>> [  690.631491]  bfq_bic_update_cgroup+0xbc/0x218
>>> [  690.635834]  bfq_init_rq+0xac/0x808
>>> [  690.639309]  bfq_insert_request.isra.0+0xe0/0x200
>>> [  690.643999]  bfq_insert_requests+0x68/0x88
>>> [  690.648085]  blk_mq_sched_insert_requests+0x84/0x140
>>> [  690.653036]  blk_mq_flush_plug_list+0x170/0x2b0
>>> [  690.657555]  blk_flush_plug_list+0xec/0x100
>>> [  690.661725]  blk_mq_make_request+0x200/0x5e8
>>> [  690.665982]  generic_make_request+0x94/0x270
>>> [  690.670239]  submit_bio+0x34/0x168
>>> [  690.673712]  xfs_submit_ioend.isra.0+0x9c/0x180 [xfs]
>>> [  690.678798]  xfs_do_writepage+0x234/0x458 [xfs]
>>> [  690.683318]  write_cache_pages+0x1a4/0x3f8
>>> [  690.687442]  xfs_vm_writepages+0x84/0xb8 [xfs]
>>> [  690.691874]  do_writepages+0x3c/0xe0
>>> [  690.695438]  __writeback_single_inode+0x48/0x440
>>> [  690.700042]  writeback_sb_inodes+0x1ec/0x4b0
>>> [  690.704298]  __writeback_inodes_wb+0x50/0xe8
>>> [  690.708555]  wb_writeback+0x264/0x388
>>> [  690.712204]  wb_do_writeback+0x300/0x358
>>> [  690.716113]  wb_workfn+0x80/0x1e0
>>> [  690.719418]  process_one_work+0x1bc/0x3e8
>>> [  690.723414]  worker_thread+0x54/0x440
>>> [  690.727064]  kthread+0x104/0x130
>>> [  690.730281]  ret_from_fork+0x10/0x18
>>> [  690.733847] Code: eb00007f 54000220 b4000040 f8568022 (f9401c42)
>>> [  690.739928] ---[ end trace d3fd392f569e86d3 ]---
>>>
>>> https://artifacts.cki-project.org/pipelines/293063/logs/aarch64_host_2_=
console.log
>>>
>>
>> This looks like that same issue
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1767539
>>
>> I don't think the BFQ fix has been sent to stable yet, or at least
>> it was not in 5.3.11
>=20
> Any specific git commit id I should be picking up for this?
>=20
> thanks,
>=20
> greg k-h
>=20

Should be 478de3380c1c ("block, bfq: deschedule empty bfq_queues
not referred by any process") .

Thanks,
Laura

