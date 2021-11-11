Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B421C44D401
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 10:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhKKJ1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 04:27:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232456AbhKKJ1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 04:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636622700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoIxLEENy2F1Zskv5/PoD5j6jmD+4MPXDSF/F9jQnm4=;
        b=S+4Z4z0VCGJ4JV80lSh/R9IRk17Q5RLrYlQfYsQhpk4svPRsQQDauKn8gxX355glaPIlLy
        IodihxzWV8eUx7Uvnd7qb42Z/tWluATihq4c8hCvFLzISg6zaIHdYWtNIBQGm/ZWEWZXtR
        hwALAzH0jHVHckb9AG6KXSMIHO4X3U0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-XlCPoPmKPDuZnaG_fLV3LQ-1; Thu, 11 Nov 2021 04:24:59 -0500
X-MC-Unique: XlCPoPmKPDuZnaG_fLV3LQ-1
Received: by mail-wm1-f72.google.com with SMTP id n16-20020a05600c3b9000b003331973fdbbso2430425wms.0
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 01:24:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=XoIxLEENy2F1Zskv5/PoD5j6jmD+4MPXDSF/F9jQnm4=;
        b=F2dz7yPCD8HDky3BIKA9QJ7uwtwN2oJzpOAnoYVUd7vMOYxo5ab0iTcPKCWIz6Nh8I
         XPwvuSJDPurCh6lAGwjPMmlyiTjYodayezWIjW6IDhV+BbmR6XlF+wtr87IKTIDUvAAj
         lHqOLRUA1Wa41ADZ9Tq51xVU1MwrQ6augt/mr2E7jNfi7u4pXmMUajv5/CElcUECKSln
         683JgfDUHISKqPYwQNluofC37tVJ0hfO0FgmCDUpd4EZVOK562K++zuCJVWxn+qbusRj
         aJtbfJz3NB6kJBTQkmwWOssEopLHNmvshy7oYryjJ/DaV19mP9pq98YBbjNg8OALdGjX
         AfJQ==
X-Gm-Message-State: AOAM533hWrUgBB5A8FhFt48npupuaJkVQX3SQdgiZRMxs82hc5+6vtuM
        quugZM12Rvey+RNofPWq6fp3nEhPZFzxlfVVmlFaOLnFTQ7tBbRgYXqv4MrehCoo53UJgAUYRE5
        clrxFDmR8jnWlQETp
X-Received: by 2002:a05:6000:18ad:: with SMTP id b13mr7062535wri.195.1636622698149;
        Thu, 11 Nov 2021 01:24:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/L5EBwaiQ5M/k0471vvBJxC4do3fiwU7k3yCJtLLPx+phRd7gimWqthqE//nDPulozzVurg==
X-Received: by 2002:a05:6000:18ad:: with SMTP id b13mr7062518wri.195.1636622697991;
        Thu, 11 Nov 2021 01:24:57 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.106])
        by smtp.gmail.com with ESMTPSA id l26sm2293227wms.15.2021.11.11.01.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 01:24:57 -0800 (PST)
Message-ID: <1ddb9e88-1ef8-9888-113b-fd2a2759f019@redhat.com>
Date:   Thu, 11 Nov 2021 10:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [REGRESSION]: drivers/firmware: move x86 Generic System
 Framebuffers support
Content-Language: en-US
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Ilya Trukhanov <lahvuun@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        tzimmermann@suse.de, ardb@kernel.org, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz,
        dri-devel <dri-devel@lists.freedesktop.org>
References: <20211110200253.rfudkt3edbd3nsyj@lahvuun>
 <627b6cd1-3446-5e55-ea38-5283a186af39@redhat.com>
 <20211111004539.vd7nl3duciq72hkf@lahvuun>
 <af0552fb-5fb5-acae-2813-86c32e008e58@redhat.com>
In-Reply-To: <af0552fb-5fb5-acae-2813-86c32e008e58@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/21 08:31, Javier Martinez Canillas wrote:

[snip]

>>> And for each check /proc/fb, the kernel boot log, and if Suspend-to-RAM works.
>>>
>>> If the explanation above is correct, then I would expect (1) and (2) to work and
>>> (3) to also fail.
>>>
> 
> Your testing confirms my assumptions. I'll check how this could be solved to
> prevent the efifb driver to be probed if there's already a framebuffer device.
> 

I've posted [0] which does this and also for the simplefb driver.

[0]: https://lore.kernel.org/dri-devel/20211111092053.1328304-1-javierm@redhat.com/T/#u

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

