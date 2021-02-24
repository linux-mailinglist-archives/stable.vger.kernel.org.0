Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A9324387
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhBXSHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:07:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233732AbhBXSHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 13:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614189973;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toxhg0cmaDLsC5HXvtt/9Q6frW8bNQ4QoBennLsllvk=;
        b=Uu1Fk9Eps9NmaEvkdThH0PtRx2pEu6+lpGTNQVZaDilWQzag1CkK/qH5QNitWPrxeUti+7
        48qsIocoNmZGM5k65eCw434jxiQuAgXeBYSZxWwsZa2P9wIpHNm7icBNpHE1GsTMCFF65a
        sU6ZUAMkPEVuTNdidMt6gUW193tZLWo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-D1mPnk93PhCFcN9EDt2xAg-1; Wed, 24 Feb 2021 13:06:12 -0500
X-MC-Unique: D1mPnk93PhCFcN9EDt2xAg-1
Received: by mail-qt1-f200.google.com with SMTP id l1so2262917qtv.2
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 10:06:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=toxhg0cmaDLsC5HXvtt/9Q6frW8bNQ4QoBennLsllvk=;
        b=W/8eKbeXC8E/nqmaz96keCY3NWQYHRTBMSjkB6ynrs+pYx9u6xVLpzYBBLXy719fAn
         mqQJ40KszRztxCKG65YF+k4GY+2HqNQxcSUmH1OssbDvblUW8E3GmGMahu5d3VawXoL+
         ZxI0pPtgmAaNBYZMchp/1+Fq1Z67g/NLb+0LDIwXv+Jk7vw6HwaWG70yQeMR5H6fZ5Rq
         z/9cVhNxyC6uCQCtYZM2XlvsNDUc6497nrbIznENKgGOm9ct12K7bDVrdmOKyrGi9O0h
         Nbc3+zo2hVzv5/iATd4R+7VUoSr8Mxmh5vDFIpsmGuhZ2fL67HrtLWqrW3APyjEX2TUm
         jURQ==
X-Gm-Message-State: AOAM530aZ40vUOT8uvBFhHYfebhLNcRitC5Swk6X7y7UdG0xUkONISQU
        OdVVh8DFYKXnOIqRw+tJuQT84MTQ84DEUKwmBkPuyuh4vt/rKtDRg57I4m3VeKydynCHshykFc1
        cdhuSO/J8XM+KFYDu
X-Received: by 2002:aed:2c85:: with SMTP id g5mr5616531qtd.306.1614189971750;
        Wed, 24 Feb 2021 10:06:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJwe+mRTTlP+grZsk6m2cwXYETqnTRPylzZOnv4KQT3mbXpASK44Fyx+/0UBtQmUKuE5N5fw==
X-Received: by 2002:aed:2c85:: with SMTP id g5mr5616519qtd.306.1614189971551;
        Wed, 24 Feb 2021 10:06:11 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id 18sm1672101qtw.70.2021.02.24.10.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 10:06:10 -0800 (PST)
Message-ID: <cbb963ec0b2fb93ddbc81f83e5e6eba4264b9a5c.camel@redhat.com>
Subject: Re: [PATCH 0/2] Set CLEAR_PAYLOAD_ID_TABLE as broadcast request
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Nicholas.Kazlauskas@amd.com,
        harry.wentland@amd.com, jerry.zuo@amd.com, eryk.brol@amd.com,
        qingqing.zhuo@amd.com
Date:   Wed, 24 Feb 2021 13:06:09 -0500
In-Reply-To: <20210222040027.23505-1-Wayne.Lin@amd.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ooh, nice catches! For the whole series this is:

Reviewed-by: Lyude Paul <lyude@redhat.com>

I will go ahead and push these to drm-misc-next

On Mon, 2021-02-22 at 12:00 +0800, Wayne Lin wrote:
> While testing MST hotplug events on daisy chain monitors, find out
> that CLEAR_PAYLOAD_ID_TABLE is not broadcasted and payload id table
> is not reset. Dig in deeper and find out two parts needed to be fixed.
> 
> 1. Link_Count_Total & Link_Count_Remaining of Broadcast message are
> incorrect. Should set lct=1 & lcr=6
> 2. CLEAR_PAYLOAD_ID_TABLE request message is not set as path broadcast
> request message. Should fix this.
> 
> Wayne Lin (2):
>   drm/dp_mst: Revise broadcast msg lct & lcr
>   drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
> 
>  drivers/gpu/drm/drm_dp_mst_topology.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> --
> 2.17.1
> 

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

