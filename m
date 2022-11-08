Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8936210FA
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiKHMjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiKHMjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:39:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0058D12A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667911115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AgQdWZoEspXDlcEX6Dbv2yYyf1ye0c7F6W8ytURut4Q=;
        b=f5ISosKEzVUbBgBDWmveo7SQUT+d5BrRqgGT7iIHYMsZP1wx7hgQ00svU+vgGz3yikxyn4
        0drfGgFPoQKBHCXXO/ITYiRiQc8fw706DJiEbYI+sYGgT/sCyD5rJKCxr/huhM1T/VKpR7
        7DeiG/kE+iWBdtRcBnAMltnhAOxPaiQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-6TCmlQoiPBmLp3JY0312QQ-1; Tue, 08 Nov 2022 07:38:34 -0500
X-MC-Unique: 6TCmlQoiPBmLp3JY0312QQ-1
Received: by mail-pg1-f198.google.com with SMTP id l63-20020a639142000000b0046f5bbb7372so7911756pge.23
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 04:38:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgQdWZoEspXDlcEX6Dbv2yYyf1ye0c7F6W8ytURut4Q=;
        b=yFPNZj4w4yYfepfPL9Ki7wYPKm0OxmN21fFbEYC4YwEiSF3FaVaE7f27A2fPaQ4Fcz
         3IL/Kkn36piCh65ThwrfoPanzfy1nrpCsrf3N0tr/Dnl5NaXxhzwRoUOaTL/7JJjKGn4
         tur/J03TEpNw1PYyYo5J8wYxxhMWx3setaKOKBzxtdDPHT+Xw3XIGAD8hrffjSl8O9TC
         c+231U4NfZdQxmhQUC+h04Fj8VoezyYxJKGNLYo0/EyPl3t4o8kHrghyTqQRQtfR+rl7
         R28wO5zbUHqe4QMy+4/WVHLE1O5oKhJYmletEMZUz6oUQeiPnzk8pMD429JGSkqNeejh
         NCDg==
X-Gm-Message-State: ACrzQf2M4uh8TKUf5lwIjlo/QUO0c16CrtW4O5E7b8Ycp3Y+2XiXJDUZ
        XvYjhaemjX0BkizvmYqWsYl24oEITLC4WIyTaOabTeErZZofV1M6m31Ehyx4diYF0TfYUhifIAJ
        sMk4ZFbok8kvbMovMu8IcZ7mH2ZlsLgnmTOctL28JYpwmJ2ZZJufkYuEJXvZimV1xdw==
X-Received: by 2002:a63:fb53:0:b0:46e:e210:f026 with SMTP id w19-20020a63fb53000000b0046ee210f026mr47461271pgj.29.1667911113564;
        Tue, 08 Nov 2022 04:38:33 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7PhDajmuKXvMTWwhO0e4dAIwoyZoJJ7JQqI0jC0qVwcrHyMjguVilGXBjAopmP3q7K4io8NA==
X-Received: by 2002:a63:fb53:0:b0:46e:e210:f026 with SMTP id w19-20020a63fb53000000b0046ee210f026mr47461239pgj.29.1667911113091;
        Tue, 08 Nov 2022 04:38:33 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d10-20020a621d0a000000b00562664d5027sm6300022pfd.61.2022.11.08.04.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 04:38:32 -0800 (PST)
Subject: Re: [PATCH v2] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221108054954.307554-1-xiubli@redhat.com>
 <CAOi1vP8C20dU+jNqLw92N20mOyAecZWeK4QOX4WD=e-GZBb32Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8ba8c0bc-28b6-590e-7b77-b805ee7ae8f6@redhat.com>
Date:   Tue, 8 Nov 2022 20:38:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8C20dU+jNqLw92N20mOyAecZWeK4QOX4WD=e-GZBb32Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/11/2022 18:50, Ilya Dryomov wrote:
> On Tue, Nov 8, 2022 at 6:50 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The request's r_session maybe changed when it was forwarded or
>> resent.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 88 +++++++++++++++++++-------------------------------
>>   1 file changed, 33 insertions(+), 55 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 894adfb4a092..172f18f7459d 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2297,8 +2297,9 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>          struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>> +       struct ceph_mds_session *s, **sessions = NULL;
> Hi Xiubo,
>
> Nit: mixing pointers and double pointers coupled with differing
> initialization is generally frowned upon.  Keep it on two lines as
> before:
>
>      struct ceph_mds_session **sessions = NULL;
>      struct ceph_mds_session *s;

Sure, will fix it.

>>          unsigned int max_sessions;
>> -       int ret, err = 0;
>> +       int i, ret, err = 0;
>>
>>          spin_lock(&ci->i_unsafe_lock);
>>          if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
>> @@ -2315,31 +2316,22 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>          }
>>          spin_unlock(&ci->i_unsafe_lock);
>>
>> -       /*
>> -        * The mdsc->max_sessions is unlikely to be changed
>> -        * mostly, here we will retry it by reallocating the
>> -        * sessions array memory to get rid of the mdsc->mutex
>> -        * lock.
>> -        */
>> -retry:
>> -       max_sessions = mdsc->max_sessions;
>> -
>>          /*
>>           * Trigger to flush the journal logs in all the relevant MDSes
>>           * manually, or in the worst case we must wait at most 5 seconds
>>           * to wait the journal logs to be flushed by the MDSes periodically.
>>           */
>> +       mutex_lock(&mdsc->mutex);
>> +       max_sessions = mdsc->max_sessions;
>> +       sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>> +       if (!sessions) {
>> +               mutex_unlock(&mdsc->mutex);
>> +               err = -ENOMEM;
>> +               goto out;
>> +       }
>> +
>>          if ((req1 || req2) && likely(max_sessions)) {
> Just curious, when can max_sessions be zero here?

Checked the code again, just before registering the first session, and 
this is monotone increasing. It should be safe to remove this here.


>
>> -               struct ceph_mds_session **sessions = NULL;
>> -               struct ceph_mds_session *s;
>>                  struct ceph_mds_request *req;
>> -               int i;
>> -
>> -               sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>> -               if (!sessions) {
>> -                       err = -ENOMEM;
>> -                       goto out;
>> -               }
>>
>>                  spin_lock(&ci->i_unsafe_lock);
>>                  if (req1) {
>> @@ -2348,16 +2340,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                                  s = req->r_session;
>>                                  if (!s)
>>                                          continue;
>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>> -                                       spin_unlock(&ci->i_unsafe_lock);
>> -                                       for (i = 0; i < max_sessions; i++) {
>> -                                               s = sessions[i];
>> -                                               if (s)
>> -                                                       ceph_put_mds_session(s);
>> -                                       }
>> -                                       kfree(sessions);
>> -                                       goto retry;
>> -                               }
>> +                               if (unlikely(s->s_mds >= max_sessions))
>> +                                       continue;
> Nit: this could be combined with the previous condition:
>
>      if (!s || unlikely(s->s_mds >= max_sessions))
>              continue;

Sure.


>>                                  if (!sessions[s->s_mds]) {
>>                                          s = ceph_get_mds_session(s);
>>                                          sessions[s->s_mds] = s;
>> @@ -2370,16 +2354,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                                  s = req->r_session;
>>                                  if (!s)
>>                                          continue;
>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>> -                                       spin_unlock(&ci->i_unsafe_lock);
>> -                                       for (i = 0; i < max_sessions; i++) {
>> -                                               s = sessions[i];
>> -                                               if (s)
>> -                                                       ceph_put_mds_session(s);
>> -                                       }
>> -                                       kfree(sessions);
>> -                                       goto retry;
>> -                               }
>> +                               if (unlikely(s->s_mds >= max_sessions))
>> +                                       continue;
> ditto
>
>>                                  if (!sessions[s->s_mds]) {
>>                                          s = ceph_get_mds_session(s);
>>                                          sessions[s->s_mds] = s;
>> @@ -2387,25 +2363,26 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                          }
>>                  }
>>                  spin_unlock(&ci->i_unsafe_lock);
>> +       }
>> +       mutex_unlock(&mdsc->mutex);
>>
>> -               /* the auth MDS */
>> -               spin_lock(&ci->i_ceph_lock);
>> -               if (ci->i_auth_cap) {
>> -                     s = ci->i_auth_cap->session;
>> -                     if (!sessions[s->s_mds])
>> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
>> -               }
>> -               spin_unlock(&ci->i_ceph_lock);
>> +       /* the auth MDS */
>> +       spin_lock(&ci->i_ceph_lock);
> Why was this "auth MDS" block moved outside of max_sessions > 0
> branch?  Logically, it very much belongs there.  Is there a problem
> with taking ci->i_ceph_lock under mdsc->mutex?

I will remove the 'likely(max_session)' and there is no any problem for 
this.

>
>> +       if (ci->i_auth_cap) {
>> +               s = ci->i_auth_cap->session;
>> +               if (!sessions[s->s_mds] &&
>> +                   likely(s->s_mds < max_sessions))
> This is wrong: s->s_mds must be checked against max_sessions before
> indexing into sessions array.  Also, the entire condition should fit on
> a single line.
I am moving it to the if(req1 || req2) {} scope and it will exceed 80 
chars. And will keep it in two lines.
>> +                       sessions[s->s_mds] = ceph_get_mds_session(s);
>> +       }
>> +       spin_unlock(&ci->i_ceph_lock);
>>
>> -               /* send flush mdlog request to MDSes */
>> -               for (i = 0; i < max_sessions; i++) {
>> -                       s = sessions[i];
>> -                       if (s) {
>> -                               send_flush_mdlog(s);
>> -                               ceph_put_mds_session(s);
>> -                       }
>> +       /* send flush mdlog request to MDSes */
>> +       for (i = 0; i < max_sessions; i++) {
>> +               s = sessions[i];
>> +               if (s) {
>> +                       send_flush_mdlog(s);
>> +                       ceph_put_mds_session(s);
>>                  }
>> -               kfree(sessions);
>>          }
>>
>>          dout("%s %p wait on tid %llu %llu\n", __func__,
>> @@ -2428,6 +2405,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                  ceph_mdsc_put_request(req1);
>>          if (req2)
>>                  ceph_mdsc_put_request(req2);
>> +       kfree(sessions);
> Nit: since sessions array is allocated after references to req1 and
> req2 are grabbed, I would free it before these references are put.

Sure!

Thanks!

- Xiubo

> Thanks,
>
>                  Ilya
>

