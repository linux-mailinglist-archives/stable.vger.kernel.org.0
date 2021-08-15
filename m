Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAA3EC970
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 15:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhHON56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 09:57:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231881AbhHON55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 09:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629035847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+FVfSl1vem65U43CNnC7At1r0k8wQFh2G3xl/DpsqI=;
        b=DMxqqPp+OeKlEEeRN+WHTNlSMBAy0VZih9t4o+s1ziyVZn+IHPKjvON5W0nDh3XrJ+OoYZ
        YbWml0SUNIFZFUWJsPvp7/GHo7MWr4jxN4EYYDDTQ7mFcLAH7978QOWzcnKJX5Lc9H0KmK
        X3rx6575tvU8ESAYZA0AN2YGtPPbdXY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-Gl4WouwGN4eqpd-JS_MrsA-1; Sun, 15 Aug 2021 09:57:26 -0400
X-MC-Unique: Gl4WouwGN4eqpd-JS_MrsA-1
Received: by mail-ed1-f71.google.com with SMTP id x24-20020aa7dad8000000b003bed477317eso1271377eds.18
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 06:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z+FVfSl1vem65U43CNnC7At1r0k8wQFh2G3xl/DpsqI=;
        b=jA/r9RDc3ruUrfJ6O3ZGNVPruLYKHN0gGyLOqoKDSRgDsH3T6/dbEqKbwc2dlkAwQB
         uO1pHK/dHaXaZj6o/KXmG+vB9t8oDOw7Afr+7ZfvYw2yvSJ9wtkc7kMte5OgKNv+6tDK
         rW9814hJtKciiOlg/PGspMy9vxwI/35cFlw+iTpv3bUPD1yGE5DGxZHeoMCKp7/15kH9
         L+y3u2KNpwX9aTTQcYVWk6st0LCfWVo3LbZpGccxorQHwsWqLTeiMvtdQIctCniv46cO
         JSZlbj3NT5jDKUgfm8qR96dVmbAOh5sCilwknh4hlVC/s+hpF7Nb/QLJzsAbZvURoAFh
         9iMg==
X-Gm-Message-State: AOAM530uBkcMdJ+Aq+P7mijXPl3x9jxo+8ZE+dpzrz1pd4tkzvIv+8Uo
        Un+fEKWxw07k+PZpj+7RcRNnR1Ne4JDXlaSMGzL4krscPHap25Cud7SsHmh+Ir9el9pewX79HGv
        u2tJag3DLxuX/kytM
X-Received: by 2002:a05:6402:1a45:: with SMTP id bf5mr14393017edb.169.1629035845007;
        Sun, 15 Aug 2021 06:57:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLX3Yr9Fwj+3Wtl5Zf6O/XficUHUKs2h7TQ6NiRxBlG99y8ta+Fc76Qclsr6Kn8X5xkcetpQ==
X-Received: by 2002:a05:6402:1a45:: with SMTP id bf5mr14393012edb.169.1629035844887;
        Sun, 15 Aug 2021 06:57:24 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id h10sm3478652edb.74.2021.08.15.06.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 06:57:24 -0700 (PDT)
Subject: Re: [PATCH 5.10 12/19] vboxsf: Make vboxsf_dir_create() return the
 handle for the created file
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150523.032839314@linuxfoundation.org>
 <20210813193158.GA21328@duo.ucw.cz>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <26feedff-0fb4-01db-c809-81c932336b47@redhat.com>
Date:   Sun, 15 Aug 2021 15:57:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813193158.GA21328@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 8/13/21 9:31 PM, Pavel Machek wrote:
> Hi!
> 
>> commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream
>>
>> Make vboxsf_dir_create() optionally return the vboxsf-handle for
>> the created file. This is a preparation patch for adding atomic_open
>> support.
> 
> Follow up commits using this functionality are in 5.13 but not in
> 5.10, so I believe we don't need this in 5.10, either?
> 
> (Plus someone familiar with the code should check if we need "vboxsf:
> Honor excl flag to the dir-inode create op" in 5.10; it may have same
> problem).

Actually those follow up commits fix an actual bug, so I was expecting
the person who did the backport to also submit the rest of the set.

FWIW having these patches in but not the cannot hurt.

Hopefully the rest applies cleanly, I don't know.

To be clear I'm talking about also adding the following to patches
to 5.10.y:

02f840f90764 ("vboxsf: Add vboxsf_[create|release]_sf_handle() helpers")
52dfd86aa568 ("vboxsf: Add support for the atomic_open directory-inode op")

I have no idea of these will apply cleanly.

Regards,

Hans


