Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A88A3226EC
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 09:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhBWIK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 03:10:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhBWIJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 03:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614067712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QJQaZPz8BU5jNxqGBbzYmwqQYEQoV6UYoqOet8cn2TE=;
        b=N3T40MFy7ucV6N4g7+MfJPydeDJy+g8Pzk86Uhrj4U6yD+DiYwhjh4pikeiaPxqUTxBC2D
        Zm+U3mloCt9AWe7Q2DZN5lnskVko14TrW3BiHR5EQZlq6JzlRqZ3B7kF41mnZU1W3525hO
        MKM2miFcT2N/wxaNSM5Dy7vlGEl+nHA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-FXh69dD2Nl2zskHNfKMYsw-1; Tue, 23 Feb 2021 03:06:59 -0500
X-MC-Unique: FXh69dD2Nl2zskHNfKMYsw-1
Received: by mail-wr1-f72.google.com with SMTP id d7so6983766wri.23
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 00:06:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QJQaZPz8BU5jNxqGBbzYmwqQYEQoV6UYoqOet8cn2TE=;
        b=i0oThhvU/eVeXsCCWv6DGfp951dutqhzt6JJ3L0RBVW8yIMN7YMH/yaZtIqUsVrGst
         cMCrgyta+h1JMIZPYZa2WpprzyYwwWznbml5ieZi0MmieX2qEtYSFecIQKF/FVyjCTRL
         L0xlyb09TJ72As0a/T5en3BlqCHkx6MyzymAhXOthdOrfLWXrMv2/Bc7MJzZqJ0/bnf0
         kkqLKikmhEQnNz930IEJxzBNODh0ZnWkDPk7QtbJSkKTufWiWX+mYMgueVHMCCl6jIhS
         Tj/kK9k+eUgfX54Xza5W+5fYVsrsxj/viiSbxDwu+0dT69m4xO/1JT1RBfZ247yh9C2N
         YKJw==
X-Gm-Message-State: AOAM532WhLI/z7eYpbrl6hjVbfJb5RxUqa7iX5UwKRJdxyvm52RqrN+k
        HoM2gTpjyIl9P+qShklgDqE8OcQ7pXIsLUFRcNNcXfsc7hzo/wJkV+Pfc4hjH+eqxa7ood2FvrI
        NksygSF1YqqoJOwWz
X-Received: by 2002:a05:6000:2aa:: with SMTP id l10mr25427491wry.368.1614067618437;
        Tue, 23 Feb 2021 00:06:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMIH1kwz2CQY7I9V1/kNJmJOFjB038suRPfBB8YuLFHXVn1XserOYC9TniXTjzHgbqy7vqMQ==
X-Received: by 2002:a05:6000:2aa:: with SMTP id l10mr25427472wry.368.1614067618257;
        Tue, 23 Feb 2021 00:06:58 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v188sm302614wme.1.2021.02.23.00.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 00:06:57 -0800 (PST)
Date:   Tue, 23 Feb 2021 09:06:55 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.10 03/29] vdpa_sim: store parsed MAC address in a buffer
Message-ID: <20210223080655.ps7ujvgvs6wtlszf@steredhat>
References: <20210222121019.444399883@linuxfoundation.org>
 <20210222121020.153222666@linuxfoundation.org>
 <20210222195414.GA24405@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210222195414.GA24405@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 08:54:15PM +0100, Pavel Machek wrote:
>Hi!
>
>> From: Stefano Garzarella <sgarzare@redhat.com>
>>
>> commit cf1a3b35382c10ce315c32bd2b3d7789897fbe13 upstream.
>>
>> As preparation for the next patches, we store the MAC address,
>> parsed during the vdpasim_create(), in a buffer that will be used
>> to fill 'config' together with other configurations.
>
>I'm not sure why this series is in stable. It is not documented to fix
>anything bad.
>
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> @@ -42,6 +42,8 @@ static char *macaddr;
>>  module_param(macaddr, charp, 0);
>>  MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
>>
>> +u8 macaddr_buf[ETH_ALEN];
>> +
>
>Should this be static?

Yes, there is already a patch [1] queued by Michael but not yet 
upstream. When it will be merged upstream I will make sure it will be 
backported.

Thanks,
Stefano

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=8c0bea4adac9f1f9ac827210fa8862be4bde6290

