Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95093238D1
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 09:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhBXIiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 03:38:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234580AbhBXIhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 03:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614155785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CE7U1bZ1YGl3XEvcRWSU6EnQV8VmyBEPYCmQyZoxSGU=;
        b=WdKcwoc8G3LSN9YzNbpU1ulzxLAUiQakdJ0LIIVxCGiIL9zP9RYsx3f+XLZY8qBBQ5JOfO
        OOZyXJ1Y2T3Q6qCIMBK/oUT45rnsmLjBcN7JPchQlYO0R84u9bmLCvf9BhCHu8g//wB8+K
        W5ZGKDccDdA3CLbvhVWcFR3Q/LDsUuw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-7CdmH6B3NpaLxpd5lgp-zg-1; Wed, 24 Feb 2021 03:36:20 -0500
X-MC-Unique: 7CdmH6B3NpaLxpd5lgp-zg-1
Received: by mail-wr1-f71.google.com with SMTP id w11so720100wrp.6
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 00:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CE7U1bZ1YGl3XEvcRWSU6EnQV8VmyBEPYCmQyZoxSGU=;
        b=Igta0zb/s23/lR8/bexTzsS4W+5CTzMZEHH1fokBNG5GEc+OYEBk8rZFU32s2djRS+
         ukNZKlv6uRrWmn61qs42pfcg8+QLzqFy9orx660KLnQpvwAcaiYF/PS0sysBR4phlNnO
         A1/yDWrfhE3FPhuPunvx0RSfe7d06vHWmzfKUG+SJwAMgJ+K99eFYoXMfvTK240PfHyM
         RqMwUMQwMiL4rT2QkHMAeRPvrnunZGmg/XWsx5VFNCzCXVeDEWZoS6entcCv9uELyFIu
         X6X1ffMC7AWRQFw+TvHbD0Zn0zRx3gwTog9KsaP4eoR0dFnRG/EEEY5PyE2CHIDjG1Hj
         yg9g==
X-Gm-Message-State: AOAM532LbuAbk5aN9rEa9RKPV0z57+fcoWvDXqeanJIioQmJ6hAbWEYk
        qeQLWvtGIsqpLHbHD/VRJgGtS/Mer6weExf21XgwXort5TsI7i1FNvecj0iRpdYYp3uQAAqw4t8
        myZLYcLorZM/qoBnC
X-Received: by 2002:a7b:cf0c:: with SMTP id l12mr2617562wmg.41.1614155779516;
        Wed, 24 Feb 2021 00:36:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAhQcAI7N30VO8jh2UgZcBUTCQKzHiQPGY/fG+BniOkSvX+sc5ciX0JXEQvcLrR72Del5zwg==
X-Received: by 2002:a7b:cf0c:: with SMTP id l12mr2617543wmg.41.1614155779327;
        Wed, 24 Feb 2021 00:36:19 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v1sm1585860wmj.31.2021.02.24.00.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:36:19 -0800 (PST)
Date:   Wed, 24 Feb 2021 09:36:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.10 03/29] vdpa_sim: store parsed MAC address in a buffer
Message-ID: <20210224083616.ha6xhjt5itb43477@steredhat>
References: <20210222121019.444399883@linuxfoundation.org>
 <20210222121020.153222666@linuxfoundation.org>
 <20210222195414.GA24405@amd>
 <20210223080655.ps7ujvgvs6wtlszf@steredhat>
 <20210224082954.GB8058@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210224082954.GB8058@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 09:29:54AM +0100, Pavel Machek wrote:
>Hi!
>
>> >>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> >>@@ -42,6 +42,8 @@ static char *macaddr;
>> >> module_param(macaddr, charp, 0);
>> >> MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
>> >>
>> >>+u8 macaddr_buf[ETH_ALEN];
>> >>+
>> >
>> >Should this be static?
>>
>> Yes, there is already a patch [1] queued by Michael but not yet upstream.
>> When it will be merged upstream I will make sure it will be backported.
>
>Having it in mainline is enough, I don't really think it causes
>anything user-visible, so it does not need to be in stable.

Got it.

Thanks,
Stefano

