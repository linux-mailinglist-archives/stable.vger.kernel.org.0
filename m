Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7406243A7
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 14:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiKJNyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 08:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiKJNx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 08:53:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801D618B05
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668088383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8FWT9TyrBpCw16hoPVklgzSvxya7R9n4dXybApYg9Xs=;
        b=OOcliCoFWtueWS2LtExwdOHBn62UFJOOeuzd49aNPx+vGyOrm7UCqEWW6yHrWfPSmBlS2S
        LTo+VXE+5K8fQ/Who1ksNf+oNZxck29fxHuC8+P98KA3MzQudEsCHZEsI9Orbcp2LFiiwW
        OnzQ8w9zAcXLdskpuWt/+6bM6rl+jXU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-310-khzT0KmoOXSHIgkefiYvjA-1; Thu, 10 Nov 2022 08:53:02 -0500
X-MC-Unique: khzT0KmoOXSHIgkefiYvjA-1
Received: by mail-pj1-f71.google.com with SMTP id g6-20020a17090a300600b00212f609f6aeso1125582pjb.9
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:53:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FWT9TyrBpCw16hoPVklgzSvxya7R9n4dXybApYg9Xs=;
        b=Lb0Tmqhqel58YAIuwbopvU3ViGQDfnpaAwKiqzLKNxmYNm94C2+Qlmazd2sOlr8U0l
         WI/iccP8wtB/vLWaGpdo2A8lttAAMgXkzHHDBCC06rHt0dVbWq7aPfas6/DiQg8GNH26
         O9PH9MWdMeDzY47ZQw5q2zdd+aWKujF940gb6u88woeqYLnLSmGDMK4cxr/W/vnY7WL9
         56l4axyE2TC6dPFpRsqOXaxT2QJeXrzGkI6zQ1eZRCqEfZ4GfGwWkNR87IgwG/U3U/NC
         DzSwM4NBKlzEPk6BV3BdLFa4xgjkjb0ZvpHIMHatoXGM4Io4StHG8wb7H66V+r5PGeLG
         eBVg==
X-Gm-Message-State: ACrzQf1jeRViGXMsJovD2Bi5aYNl1ig0hXHmCkZjJ2RXWwIA5uMc8kQI
        OauEMPNA7CA1AJVMV0seV3zqxLBZ5YQ7pGxC9BXN49UcczNipc08LJgeZpPjjknB6T/z1Z4vwkW
        EChjgIGS6IpQrIGiC/59ha8TL125ZrqYAJgc+0VOoKuMcrZ2KwmXxS2/iR3mYi0zIlQ==
X-Received: by 2002:a62:6502:0:b0:56c:12c0:aaf1 with SMTP id z2-20020a626502000000b0056c12c0aaf1mr2676315pfb.50.1668088381238;
        Thu, 10 Nov 2022 05:53:01 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4M6tvQVkMUDbtPrTjA7NFgPmODC8PpLgiBHLE8BihURFhUw3gCYZ1RYGREBmxjiuKgfPBmDA==
X-Received: by 2002:a62:6502:0:b0:56c:12c0:aaf1 with SMTP id z2-20020a626502000000b0056c12c0aaf1mr2676171pfb.50.1668088375968;
        Thu, 10 Nov 2022 05:52:55 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y18-20020a170902b49200b001769206a766sm11152484plr.307.2022.11.10.05.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 05:52:55 -0800 (PST)
Subject: Re: [PATCH v5] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221110130159.33319-1-xiubli@redhat.com>
 <CAOi1vP-Evz+q7XU2EKNRaqCWOVHm8pm0WVp6No21=q55tDdGag@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5a9b784c-8c94-c083-a8fb-8548edffebbe@redhat.com>
Date:   Thu, 10 Nov 2022 21:52:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-Evz+q7XU2EKNRaqCWOVHm8pm0WVp6No21=q55tDdGag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
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


On 10/11/2022 21:48, Ilya Dryomov wrote:
> On Thu, Nov 10, 2022 at 2:02 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The request's r_session maybe changed when it was forwarded or
>> resent. Both the forwarding and resending cases the requests will
>> be protected by the mdsc->mutex.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V5:
>> - simplify the code by removing the "unlikely(s->s_mds >= max_sessions)" check.
>>
>> Changed in V4:
>> - move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch
>>
>>
>>
>>   fs/ceph/caps.c | 48 ++++++++++++------------------------------------
>>   1 file changed, 12 insertions(+), 36 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 894adfb4a092..065e9311b607 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2297,7 +2297,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>          struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>> -       unsigned int max_sessions;
>>          int ret, err = 0;
>>
>>          spin_lock(&ci->i_unsafe_lock);
>> @@ -2315,28 +2314,24 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
>> -       if ((req1 || req2) && likely(max_sessions)) {
>> -               struct ceph_mds_session **sessions = NULL;
>> -               struct ceph_mds_session *s;
>> +       if (req1 || req2) {
>>                  struct ceph_mds_request *req;
>> +               struct ceph_mds_session **sessions;
>> +               struct ceph_mds_session *s;
>> +               unsigned int max_sessions;
>>                  int i;
>>
>> +               mutex_lock(&mdsc->mutex);
>> +               max_sessions = mdsc->max_sessions;
>> +
>>                  sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>>                  if (!sessions) {
>> +                       mutex_unlock(&mdsc->mutex);
>>                          err = -ENOMEM;
>>                          goto out;
>>                  }
>> @@ -2348,16 +2343,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
>>                                  if (!sessions[s->s_mds]) {
>>                                          s = ceph_get_mds_session(s);
>>                                          sessions[s->s_mds] = s;
>> @@ -2370,16 +2355,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
>>                                  if (!sessions[s->s_mds]) {
>>                                          s = ceph_get_mds_session(s);
>>                                          sessions[s->s_mds] = s;
>> @@ -2391,11 +2366,12 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                  /* the auth MDS */
>>                  spin_lock(&ci->i_ceph_lock);
>>                  if (ci->i_auth_cap) {
>> -                     s = ci->i_auth_cap->session;
>> -                     if (!sessions[s->s_mds])
>> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
>> +                       s = ci->i_auth_cap->session;
>> +                       if (!sessions[s->s_mds])
>> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
>>                  }
>>                  spin_unlock(&ci->i_ceph_lock);
>> +               mutex_unlock(&mdsc->mutex);
>>
>>                  /* send flush mdlog request to MDSes */
>>                  for (i = 0; i < max_sessions; i++) {
>> --
>> 2.31.1
>>
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks Ilya!

- Xiubo


>
> Thanks,
>
>                  Ilya
>

