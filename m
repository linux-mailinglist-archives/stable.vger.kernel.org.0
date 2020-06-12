Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E731F7321
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 06:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgFLEpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 00:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgFLEpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 00:45:46 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C836C03E96F;
        Thu, 11 Jun 2020 21:45:46 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so5478463edm.10;
        Thu, 11 Jun 2020 21:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lxhhGiscdsO0LG4KoE+YfRUOmpmBHP4wu/EFbM+iwtI=;
        b=Yqi1SEggLbz50bsbpIAscKxCToPTn+mya0lMnGzuQo49KEFey3E9n2wHnoQCMg/4NF
         ZwKXuRdJg7E1wCU7SrVw+5nv/rleD2CPDiJsEQ+FdYIJIXTJFBo6qBIdnBm45AoRqEnD
         2anrCBQTUdx64PHTsYeWlZ2JU7cSgNkUegmQyT6p3nmYd0XQRQbKE/OdAuhYP6M0HIX9
         Tm9SgniQCl0qVLP2v42OIMAf+HKKxr/N8YRaHdKFPMzERbFtCRx3GjgbI2xFoc8Lkbi9
         VkTPv/rbkB2RD1Z9Jy1CEPQ6ln2t3XnQPdGl1un+60dPaUYGNJWugT/BkqzjltOpVl2h
         ZPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lxhhGiscdsO0LG4KoE+YfRUOmpmBHP4wu/EFbM+iwtI=;
        b=Fu7TDCph8hYjJF3vYHkKDtbA0K36W4/9ogbIGK/BtauXiGQduJ3QgPRZBuBFakIKN0
         q4tuU+IUqi70fgWhPRtv6PvlGZshp2vcFvlYwMl8Zn8JAEQvdMXe1c+/2YmeRMcZ0ClA
         1jLE5/Ptw1venmc9PdBAp7MeyZEGKGpj99un80MhhCKxduSvYAfgOtS13Yj7a8Hoan09
         Pr60jwholCkJ98ggixgIp7YKvTu/2i71l68vj0vJZoMZ+ICFrmqPjqaeVe8d2gxuDoCz
         F99xkABeNV/6NGZWnxi1/M2RDZV/QfYAknZoB/feRd9c3DDsBbL5ukR2ang10rKsFW3W
         Xn2Q==
X-Gm-Message-State: AOAM531OQeG4hAdQ0Br7fj9j7Oqtea5h9kEClcsrrTmC/VPCTlbXpJyE
        oBJkVvDOsyZbHu8yhMerZnBsSC8P
X-Google-Smtp-Source: ABdhPJxBGWr9COr76vt9/g64wZvKXdmusG0FKFjiakTVW+zMZyHOgATCGmLQKDCyxw35f5swDgWuzw==
X-Received: by 2002:a50:f017:: with SMTP id r23mr9611717edl.205.1591937144823;
        Thu, 11 Jun 2020 21:45:44 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k9sm2536614edl.83.2020.06.11.21.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 21:45:44 -0700 (PDT)
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
To:     linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b1f0668-572e-ae52-27e6-c897bab4204c@gmail.com>
Date:   Thu, 11 Jun 2020 21:45:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/5/2020 9:24 AM, Florian Fainelli wrote:
> Hi all,
> 
> This long patch series was motivated by backporting Jaedon's changes
> which add a proper ioctl compatibility layer for 32-bit applications
> running on 64-bit kernels. We have a number of Android TV-based products
> currently running on the 4.9 kernel and this was broken for them.
> 
> Thanks to Robert McConnell for identifying and providing the patches in
> their initial format.
> 
> In order for Jaedon's patches to apply cleanly a number of changes were
> applied to support those changes. If you deem the patch series too big
> please let me know.

Mauro, can you review this? I would prefer not to maintain those patches
in our downstream 4.9 kernel as there are quite a few of them, and this
is likely beneficial to other people.

Thank you!

> 
> Thanks
> 
> Colin Ian King (2):
>   media: dvb_frontend: ensure that inital front end status initialized
>   media: dvb_frontend: initialize variable s with FE_NONE instead of 0
> 
> Jaedon Shin (3):
>   media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
>   media: dvb_frontend: Add compat_ioctl callback
>   media: dvb_frontend: Add commands implementation for compat ioct
> 
> Katsuhiro Suzuki (1):
>   media: dvb_frontend: fix wrong cast in compat_ioctl
> 
> Mauro Carvalho Chehab (14):
>   media: dvb/frontend.h: move out a private internal structure
>   media: dvb/frontend.h: document the uAPI file
>   media: dvb_frontend: get rid of get_property() callback
>   media: stv0288: get rid of set_property boilerplate
>   media: stv6110: get rid of a srate dead code
>   media: friio-fe: get rid of set_property()
>   media: dvb_frontend: get rid of set_property() callback
>   media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
>   media: dvb_frontend: cleanup ioctl handling logic
>   media: dvb_frontend: get rid of property cache's state
>   media: dvb_frontend: better document the -EPERM condition
>   media: dvb_frontend: fix return values for FE_SET_PROPERTY
>   media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl()
>     return code
>   media: dvb_frontend: fix return error code
> 
> Satendra Singh Thakur (1):
>   media: dvb_frontend: dtv_property_process_set() cleanups
> 
>  .../media/uapi/dvb/fe-get-property.rst        |   7 +-
>  drivers/media/dvb-core/dvb_frontend.c         | 571 +++++++++++------
>  drivers/media/dvb-core/dvb_frontend.h         |  13 -
>  drivers/media/dvb-frontends/lg2160.c          |  14 -
>  drivers/media/dvb-frontends/stv0288.c         |   7 -
>  drivers/media/dvb-frontends/stv6110.c         |   9 -
>  drivers/media/usb/dvb-usb/friio-fe.c          |  24 -
>  fs/compat_ioctl.c                             |  17 -
>  include/uapi/linux/dvb/frontend.h             | 592 +++++++++++++++---
>  9 files changed, 881 insertions(+), 373 deletions(-)
> 

-- 
Florian
