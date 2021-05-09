Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6C63777B1
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhEIRFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 13:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhEIRFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 13:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620579879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gS221mF5itctneFLHEBt6dN2sStEXBf4HlghBIHalXQ=;
        b=Klo7aRUn90HST8as5YuFq55GNW3oH5p3JNGPNUT1kCyv2SZNPcUt1dT8STnwt0TAKThP8q
        +ru4fws8UN5YWbOEl+tjVqL9KtKVQbz5sQ/Q8Z6l0sz1sO68xSH3KZ8ygm1YTLrh2kZOxu
        o+Sjs3ihDBUGY8mw48MRDqmQaqOt/DA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-NKNK1PMkMt-tlAQTihZAUg-1; Sun, 09 May 2021 13:04:36 -0400
X-MC-Unique: NKNK1PMkMt-tlAQTihZAUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A58B18397A6;
        Sun,  9 May 2021 17:04:34 +0000 (UTC)
Received: from [10.36.113.168] (ovpn-113-168.ams2.redhat.com [10.36.113.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAF1169FCE;
        Sun,  9 May 2021 17:04:24 +0000 (UTC)
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     Marc Zyngier <maz@kernel.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, alex.williamson@redhat.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <8735uxvajh.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <65e48458-f94c-e5fd-03d5-93d6acfb356c@redhat.com>
Date:   Sun, 9 May 2021 19:04:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <8735uxvajh.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
On 5/8/21 11:29 AM, Marc Zyngier wrote:
> On Sat, 08 May 2021 08:11:52 +0100,
> Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>
>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>
>> The reverted commit may cause VM freeze on arm64 platform.
>> Because on arm64 platform, stop a consumer will suspend the VM,
>> the VM will freeze without a start consumer
> 
> It also unconditionally calls del_consumer on the producer, which
> isn't exactly expected.
> 
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> 
> Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Fixes: a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
> Link: https://lore.kernel.org/r/3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com
> Cc: stable@vger.kernel.org
> 
> Thanks,
> 
> 	M.
> 

