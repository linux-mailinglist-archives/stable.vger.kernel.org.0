Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF58B17E066
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgCIMjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 08:39:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38142 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgCIMjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 08:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583757542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7CLGqdoaP36QTdGK0i2IH/HF/wilyiqa55OPDDbgLs=;
        b=HlgiuVlmVjtEfXPPwGFH4+71uX1k1vJ1V/HIDS9xfpfgKqqEo3Mx7XKkZdHwIYeyZ9QmxG
        VMhou55UT0HjFOPMPxQsFEQY9UhZzTyfYdCJkiVZcoL/aXNG4DISE9NlWFhkddJEfMTYHx
        ikYNM5bK0387kqNcXHsaD0QOIMhgbEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-tnkRarEiO4ynNJ6-eRIOpg-1; Mon, 09 Mar 2020 08:39:01 -0400
X-MC-Unique: tnkRarEiO4ynNJ6-eRIOpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 215178010C7;
        Mon,  9 Mar 2020 12:39:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13B257389F;
        Mon,  9 Mar 2020 12:39:00 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07B63182B010;
        Mon,  9 Mar 2020 12:39:00 +0000 (UTC)
Date:   Mon, 9 Mar 2020 08:38:59 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-tip-commits@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Message-ID: <1730012660.14065813.1583757539864.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200309122504.3DA3A20848@mail.kernel.org>
References: <158368551265.28353.5476421599260286182.tip-bot2@tip-bot2> <20200309122504.3DA3A20848@mail.kernel.org>
Subject: Re: [tip: efi/urgent] efi: Add a sanity check to efivar_store_raw()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.123, 10.4.195.3]
Thread-Topic: efi/urgent] efi: Add a sanity check to efivar_store_raw()
Thread-Index: B2X47Y+Uq4qEVjs09cJtEFLm0MG2vQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

----- Original Message -----
> From: "Sasha Levin" <sashal@kernel.org>
> Subject: Re: [tip: efi/urgent] efi: Add a sanity check to efivar_store_raw()
> 
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108,
> v4.14.172, v4.9.215, v4.4.215.
> 
> v5.5.8: Build OK!
> v5.4.24: Build OK!
> v4.19.108: Failed to apply! Possible dependencies:
>     98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
> 
> v4.14.172: Failed to apply! Possible dependencies:
>     98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
>     ea2ce8f3514e ("time: Fix get_timespec64() for y2038 safe compat
>     interfaces")
> 
> v4.9.215: Failed to apply! Possible dependencies:
>     31ea70e0308b ("posix-timers: Move the do_schedule_next_timer
>     declaration")
>     96fe3b072f13 ("posix-timers: Rename do_schedule_next_timer")
>     98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
>     d5b7ffbfbdac ("time: introduce {get,put}_itimerspec64")
>     ea2ce8f3514e ("time: Fix get_timespec64() for y2038 safe compat
>     interfaces")
>     f59dd9c886ac ("time: add get_timespec64 and put_timespec64")
> 
> v4.4.215: Failed to apply! Possible dependencies:
>     2bf8c4762659 ("net/xfrm_user: use in_compat_syscall to deny compat
>     syscalls")
>     31ea70e0308b ("posix-timers: Move the do_schedule_next_timer
>     declaration")
>     4f01ed221e2e ("drivers/firmware/efi/efivars.c: use in_compat_syscall() to
>     check for compat callers")
>     96fe3b072f13 ("posix-timers: Rename do_schedule_next_timer")
>     98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
>     bc2c53e5f1a2 ("time: add missing implementation for
>     timespec64_add_safe()")
>     d5b7ffbfbdac ("time: introduce {get,put}_itimerspec64")
>     ea2ce8f3514e ("time: Fix get_timespec64() for y2038 safe compat
>     interfaces")
>     f59dd9c886ac ("time: add get_timespec64 and put_timespec64")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

I believe I can try to backport this patch for the failed-to-apply branches.

I will do the same for "[tip: efi/urgent] efi: Fix a race and a buffer
overflow while reading efivars via sysfs" (from the same patchset) which may
fail to be applied too.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

> 
> --
> Thanks
> Sasha

