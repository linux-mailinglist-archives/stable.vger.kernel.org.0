Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178A264ACFF
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 02:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiLMB0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 20:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiLMB0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 20:26:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AF114D15
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 17:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670894736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PNnuGiXysu47AR56a+iVf1X9BI5R1Thaz9yuLikoxqk=;
        b=IWmj5ahcHBKmyIRg7Cs5SqB3czgPfvrh1JwGZKdugWsB1NyLFnHMYCPfgPVf/573SuakK7
        KPPMps0kluE2HW2Gy2X3ZCBxdQGBfrsfWWG6twLnBh/NcxqQ3FFSYuLNURpwCUhzhzvM8C
        D0aNVhMjBu36Y5i+QtHi0mKM9gdqdKM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-WPAxB6kcM-m5yYdkXJEOKg-1; Mon, 12 Dec 2022 20:25:35 -0500
X-MC-Unique: WPAxB6kcM-m5yYdkXJEOKg-1
Received: by mail-pl1-f198.google.com with SMTP id l10-20020a170902f68a00b00189d1728848so11740192plg.2
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 17:25:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNnuGiXysu47AR56a+iVf1X9BI5R1Thaz9yuLikoxqk=;
        b=mFSJqWc9Ren1TNUMOB5oakWp8Yz+r6AqqytoS1Q27qOMl3+cEkGGhC92IXC2Rupt4v
         tS0XUrUfGW/CWJbd7bhd0EThH0PDHhlZk5jseHR0nT6INC9iebjNHWHh2Iug08RrFMEA
         wJZ8Krr/Q6EG6TIFL3r/MdCyuS/M1YbFmlyajMpkOTuspuA28hNAMfKXxIF0h0+eaZvJ
         dg8FQ0/McL04KMZWLPioM3masKsPOQ8laSf6RS+a3BIpuGKfNzXmDxRhQBztnSNRsELa
         jZ+JPC09J1QqRgkuUJSVfXLHJOkhtopS4EbAqkzPdWcxokfDYXkQ5bQLgBELhC5qqXTZ
         Wpxg==
X-Gm-Message-State: ANoB5pnLgoFV7kJ5ceHpDk1LJggwduYJtHAsoCRUta46akDPN8NbEzJh
        gqc85uDM4a+WaYIFBsrhtt8yMMT+sduaPXnTRm3zAW7ifYwm6aGkhfz+DPW3YMGHYe2RBKX/NCM
        oAz4Nap16WoaVdiIQ+SeY9uI1mbOmYkwxJbbRJcmUuWlmz54lJdBcfvSJ0PZUPaf8KA==
X-Received: by 2002:a62:be17:0:b0:56e:664f:a5f5 with SMTP id l23-20020a62be17000000b0056e664fa5f5mr19196071pff.8.1670894734140;
        Mon, 12 Dec 2022 17:25:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf75kyZssg6bnmviLzWUYVaP8fo6OxR1Gz7erC1kJ5EjkNgdOPk7g3rvdzeV8Jz1mOVAWdTNtQ==
X-Received: by 2002:a62:be17:0:b0:56e:664f:a5f5 with SMTP id l23-20020a62be17000000b0056e664fa5f5mr19196039pff.8.1670894733761;
        Mon, 12 Dec 2022 17:25:33 -0800 (PST)
Received: from [10.72.12.143] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b27-20020aa7951b000000b00574c54423d3sm6587234pfp.145.2022.12.12.17.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 17:25:33 -0800 (PST)
Subject: Re: [PATCH 2/2 v3] ceph: add ceph_lock_info support for file_lock
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de,
        mchangir@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221118020642.472484-1-xiubli@redhat.com>
 <20221118020642.472484-3-xiubli@redhat.com>
 <CAOi1vP-dhH-Z9_dgGLLkqwoZ5di1Bp4o+5zeJRgRHddU=X1AwQ@mail.gmail.com>
 <c5e95e043a1c79244fb6b3c4bc59f15fe1e9d5f4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <932429ec-3dfe-0c27-6b00-0a9efa9893fa@redhat.com>
Date:   Tue, 13 Dec 2022 09:25:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c5e95e043a1c79244fb6b3c4bc59f15fe1e9d5f4.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/12/2022 02:02, Jeff Layton wrote:
> On Mon, 2022-12-12 at 18:56 +0100, Ilya Dryomov wrote:
>> On Fri, Nov 18, 2022 at 3:07 AM <xiubli@redhat.com> wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> When ceph releasing the file_lock it will try to get the inode pointer
>>> from the fl->fl_file, which the memory could already be released by
>>> another thread in filp_close(). Because in VFS layer the fl->fl_file
>>> doesn't increase the file's reference counter.
>>>
>>> Will switch to use ceph dedicate lock info to track the inode.
>>>
>>> And in ceph_fl_release_lock() we should skip all the operations if
>>> the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
>>> the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
>>> inserting it to the inode lock list, which is when copying the lock.
>>>
>>> Cc: stable@vger.kernel.org
>>> Cc: Jeff Layton <jlayton@kernel.org>
>>> URL: https://tracker.ceph.com/issues/57986
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/locks.c                 | 20 ++++++++++++++++++--
>>>   include/linux/ceph/ceph_fs_fl.h | 17 +++++++++++++++++
>>>   include/linux/fs.h              |  2 ++
>>>   3 files changed, 37 insertions(+), 2 deletions(-)
>>>   create mode 100644 include/linux/ceph/ceph_fs_fl.h
>>>
>>> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
>>> index b191426bf880..621f38f10a88 100644
>>> --- a/fs/ceph/locks.c
>>> +++ b/fs/ceph/locks.c
>>> @@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>>>   {
>>>          struct inode *inode = file_inode(dst->fl_file);
>>>          atomic_inc(&ceph_inode(inode)->i_filelock_ref);
>>> +       dst->fl_u.ceph_fl.fl_inode = igrab(inode);
>>>   }
>>>
>>> +/*
>>> + * Do not use the 'fl->fl_file' in release function, which
>>> + * is possibly already released by another thread.
>>> + */
>>>   static void ceph_fl_release_lock(struct file_lock *fl)
>>>   {
>>> -       struct inode *inode = file_inode(fl->fl_file);
>>> -       struct ceph_inode_info *ci = ceph_inode(inode);
>>> +       struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
>>> +       struct ceph_inode_info *ci;
>>> +
>>> +       /*
>>> +        * If inode is NULL it should be a request file_lock,
>>> +        * nothing we can do.
>>> +        */
>>> +       if (!inode)
>>> +               return;
>>> +
>>> +       ci = ceph_inode(inode);
>>>          if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>>>                  /* clear error when all locks are released */
>>>                  spin_lock(&ci->i_ceph_lock);
>>>                  ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>>>                  spin_unlock(&ci->i_ceph_lock);
>>>          }
>>> +       fl->fl_u.ceph_fl.fl_inode = NULL;
>>> +       iput(inode);
>>>   }
>>>
>>>   static const struct file_lock_operations ceph_fl_lock_ops = {
>>> diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_fs_fl.h
>>> new file mode 100644
>>> index 000000000000..ad1cf96329f9
>>> --- /dev/null
>>> +++ b/include/linux/ceph/ceph_fs_fl.h
>>> @@ -0,0 +1,17 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * ceph_fs_fl.h - Ceph lock info
>>> + *
>>> + * LGPL2
>>> + */
>>> +
>>> +#ifndef CEPH_FS_FL_H
>>> +#define CEPH_FS_FL_H
>>> +
>>> +#include <linux/fs.h>
>>> +
>>> +struct ceph_lock_info {
>>> +       struct inode *fl_inode;
>>> +};
>>> +
>>> +#endif
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index d6cb42b7e91c..2b03d5e375d7 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
>>>
>>>   /* that will die - we need it for nfs_lock_info */
>>>   #include <linux/nfs_fs_i.h>
>>> +#include <linux/ceph/ceph_fs_fl.h>
>>>
>>>   /*
>>>    * struct file_lock represents a generic "file lock". It's used to represent
>>> @@ -1119,6 +1120,7 @@ struct file_lock {
>>>                          int state;              /* state of grant or error if -ve */
>>>                          unsigned int    debug_id;
>>>                  } afs;
>>> +               struct ceph_lock_info   ceph_fl;
>> Hi Xiubo and Jeff,
>>
>> Xiubo, instead of defining struct ceph_lock_info and including
>> a CephFS-specific header file in linux/fs.h, I think we should repeat
>> what was done for AFS -- particularly given that ceph_lock_info ends up
>> being a dummy type that isn't mentioned anywhere else.
>>
>> Jeff, could you please ack this with your file locking hat on?
>>
> ACK. I think that would be cleaner.

Sure, will fix this.

Thanks,

- Xiubo


> Thanks

