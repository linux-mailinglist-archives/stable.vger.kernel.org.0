Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F824441DD
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 13:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhKCMuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 08:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231178AbhKCMuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 08:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635943695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23WhxMz3+48FzFHwlxmPj02acSTgkQZrkSiKgIIumjM=;
        b=WU2OnckOiJBSuncflqNgXGOYQP4nJyytDmldCvuQb0NBV3dYWSIO9RcPXXHQEYeY6y3qT/
        fZZO+k3/niPq1/dy3TjPF8e3ud+qW+kea6Deapv8jdHdz0sX5psVe0rM9kehpVddLpOT7/
        MCFrFJ3yaNhxakMD2qB/V/S6QftcnyE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-ZzPKlO7QNNWih8KExIsE8A-1; Wed, 03 Nov 2021 08:48:14 -0400
X-MC-Unique: ZzPKlO7QNNWih8KExIsE8A-1
Received: by mail-ed1-f71.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so2354846edv.10
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 05:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=23WhxMz3+48FzFHwlxmPj02acSTgkQZrkSiKgIIumjM=;
        b=OPyRn4ZiG9/Zc/HRoFjeZuBSoDpe+ZulSVTlWltX1bfGvf0FZAmMuigDL2wpERNtJM
         iGTP5Cn76lSYtE6+QzDNVXXqWvA0t8nA4KrVHlaTCiWRsy4kLF8VCwsO0m6KTCyLrvlm
         3smHcMkjtiA89Phj6lgh9A9qeU66keWn1snDx4QGRzlKr2g4CdyhV7SRdI+R48vANuve
         ue97As9m5V6sgcF+9W0EMaFRk1jrspve3yciaSRVJgUaoLLGD76yfeJUbojjby5Iboe8
         t6aJU4si/Wy8FNzEBjBT5WtVnViZu8fOs6Nj8iyNg4BvxhD2A7grnYdNx21kEtGT46yH
         YfMg==
X-Gm-Message-State: AOAM530xMvhUt6lF9rCQ16x0ist1AsKGCd72E2jvR6GZE2RWnFCA+zXM
        XKJSdykF4A2amwwNXOla4oBBR28U56pzREYRlku9a6TMcLbCj6Grp55yDtzMznmDN1gcEy+BVj1
        093Vk8a6ySpP5kvIz
X-Received: by 2002:a17:906:478e:: with SMTP id cw14mr37767169ejc.46.1635943692930;
        Wed, 03 Nov 2021 05:48:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6OIsK0AvTXY0lZzL+PtKLE6c1q8xQqII05vHVzhVv1JrISlGeLAHulWml5Q39YjAPf7bZMQ==
X-Received: by 2002:a17:906:478e:: with SMTP id cw14mr37767139ejc.46.1635943692731;
        Wed, 03 Nov 2021 05:48:12 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:1054:9d19:e0f0:8214? (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id oz13sm1132942ejc.65.2021.11.03.05.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 05:48:12 -0700 (PDT)
Message-ID: <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
Date:   Wed, 3 Nov 2021 13:48:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: 5.14.14+ USB regression caused by "usb: core: hcd: Add support
 for deferring roothub registration" series
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
References: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
 <YYJRRg8QDBfy2PP7@kroah.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YYJRRg8QDBfy2PP7@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/3/21 10:07, Greg Kroah-Hartman wrote:
> On Wed, Nov 03, 2021 at 10:02:52AM +0100, Hans de Goede wrote:
>> Hi Greg,
>>
>> We (Fedora) have been receiving multiple reports about USB devices stopping
>> working starting with 5.14.14 .
>>
>> An Arch Linux user has found that reverting the first 2 patches from this series:
>> https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/
>>
>> Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).
>>
>> See here for the Arch-linux discussion surrounding this:
>> https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
>>
>> And here are 2 Fedora bug reports of Fedora users being unable to use their
>> machines due their mouse + kbd not working:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=2019542
>> https://bugzilla.redhat.com/show_bug.cgi?id=2019576
>>
>> Can we get this patch-series reverted from the 5.14.y releases please ?
> 
> Sure,

Thanks.

> but can you also submit patches to get into 5.15.y and 5.16-rc1
> that revert these changes as they should still be an issue there, right?

Yes I assume this is still an issue there too, but I was hoping that
Kishon can take a look and maybe actually fix things, since just
reverting presumably regresses whatever these patches were addressing.

We've aprox 1-3 weeks before distros like Arch and Linux will switch
to 5.15.y kernels.  So we have some time to come up with a fix
there, where as for 5.14.y this is hitting users now.

Regards,

Hans

