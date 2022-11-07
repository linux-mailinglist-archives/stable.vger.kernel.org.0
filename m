Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACAF61F15F
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 12:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiKGK7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 05:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiKGK7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 05:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F4193C7
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 02:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667818699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Z1EOSRlp4jl1RjYNN5yP+/AS3LSGqO1qinKUvHFCoI=;
        b=gIyXzvrhjL0CYS2aIDuXvrviDww9X+efdi6HjNUPkKpcRQtEvTyEOXRekwXTRHlrm+sBlF
        FOJsAqv6WJIOZhnXWkm1O96vOW7XqYiZklJjRv5/jHn7qGb/R+Hj9EAPOjuzCviSXBsDmw
        WqeZH2TwPxGsrkO6+ykSowZgZAxsgsY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-457-2RnoVR9KOVSsq0Wy_PGYGQ-1; Mon, 07 Nov 2022 05:58:17 -0500
X-MC-Unique: 2RnoVR9KOVSsq0Wy_PGYGQ-1
Received: by mail-pj1-f69.google.com with SMTP id k9-20020a17090a39c900b0021671e97a25so4445858pjf.1
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 02:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Z1EOSRlp4jl1RjYNN5yP+/AS3LSGqO1qinKUvHFCoI=;
        b=RjLC2csUtQe+DZK0OM+N0fm5atYdSz2j9/+Qsuw4+ZnRhPqFsvdmwONl8BSi5TfCrj
         AY25nDxk7WmJH8dUi7nAOnGD7wbH2Bmql/d/VLvwGu86v4hQai81g02U46hSSc/I3xvr
         VjaZjcCDP504sCRrwV8RHpNYwlv8qhdFyPKoLiI0ZTJfiWK7NXeVI7dIlHqBdSafgXEp
         5nqW9BkcQqADVQTiO+93xWsHqSCrqIn16LY5+haP/znOTRuaJmduw9HmMMX4wa5GwxJv
         kca/YrLNa+frsEU3klsmSWEi0bROFKgRSTD/5e8eGBYjNeNhJEZ4YV+QdY8muByramFv
         IwgQ==
X-Gm-Message-State: ACrzQf24upMpn6dNge140Rec/aIBGtQBzUe9pDxfFA7mnTOwdpK548Es
        TQPFFGjS3J4DJ8QklMcX7npSL5KrPnBE0Yi30vBOpQ+oVZKebIjHaTl+0Iw78OdEzqbycmnE+5p
        7BvRfVDwG0vrHYug4SW0xLS5I5IMqVCEF4B4I7iYtmHMvct7L2rL2O11YOvs5toHu2A==
X-Received: by 2002:a17:903:3011:b0:186:892d:1c4c with SMTP id o17-20020a170903301100b00186892d1c4cmr49539995pla.152.1667818696555;
        Mon, 07 Nov 2022 02:58:16 -0800 (PST)
X-Google-Smtp-Source: AMsMyM50ACHM/kWKhh/M0rblZrC1wMVJmyDC87RVuVplMs9xi/OAuunuiRT5QPaTi5sruG7XrdKi5g==
X-Received: by 2002:a17:903:3011:b0:186:892d:1c4c with SMTP id o17-20020a170903301100b00186892d1c4cmr49539969pla.152.1667818696215;
        Mon, 07 Nov 2022 02:58:16 -0800 (PST)
Received: from [10.72.12.88] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y28-20020aa79afc000000b005627ddbc7a4sm4200352pfp.191.2022.11.07.02.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 02:58:15 -0800 (PST)
Subject: Re: [PATCH] ceph: avoid putting the realm twice when docoding snaps
 fails
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, idryomov@gmail.com, stable@vger.kernel.org
References: <20221107071759.32000-1-xiubli@redhat.com>
 <Y2jgZ52dV+TzWhlQ@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b9366f31-01b6-a5f7-ea11-5e0f88934f58@redhat.com>
Date:   Mon, 7 Nov 2022 18:58:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y2jgZ52dV+TzWhlQ@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
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


On 07/11/2022 18:39, Luís Henriques wrote:
> On Mon, Nov 07, 2022 at 03:17:59PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When decoding the snaps fails it maybe leaving the 'first_realm'
>> and 'realm' pointing to the same snaprealm memory. And then it'll
>> put it twice and could cause random use-after-free, BUG_ON, etc
>> issues.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 9bceed2ebda3..baf17df05107 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -849,10 +849,12 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>   	if (realm_to_rebuild && p >= e)
>>   		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>>   
>> -	if (!first_realm)
>> +	if (!first_realm) {
>>   		first_realm = realm;
>> -	else
>> +		realm = NULL;
>> +	} else {
>>   		ceph_put_snap_realm(mdsc, realm);
>> +	}
>>   
>>   	if (p < e)
>>   		goto more;
>> -- 
>> 2.31.1
>>
> This patch looks correct to me.  But I wonder if there's a deeper problem
> there (probably not on the kernel client).  Because the other question is:
> why are we failing to decode the snaps?  But I guess this fix is worth it
> anyway.

Yeah, good question.

At the same time the MDS also crashed [1][2] just before the kernel 
crash was triggered seconds later. And the metadata in cephfs was 
corrupted due to some reasons.

[1] https://tracker.ceph.com/issues/56140

[2] https://tracker.ceph.com/issues/54546

Thanks!

- Xiubo

> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>
>
> Cheers,
> --
> Luís
>

