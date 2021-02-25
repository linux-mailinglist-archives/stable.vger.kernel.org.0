Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625D232514E
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 15:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhBYOKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 09:10:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232969AbhBYOKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 09:10:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614262133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNsc4ofKzldRkYnvwJXNs5RK+6GkOrDBT7I8mnRbwPw=;
        b=N29vx6eU+uYn3OEQqx4Aiz5pWTaDk9QJOLzoZwK6UTP6IVpC4q2pcGmL087RKI6/OqP61D
        6PjmZ+0ksP1sRBoU0ewhHO8IQwRVh7rcv++FuVf/AHazLknMsxwDfp4ZF7kXGGVJdxyPZ9
        LDLc1C8yvSmVXQM3tVftrqW32j+yR/A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-zt5kT_v9Mfqj4x8cTm1jHw-1; Thu, 25 Feb 2021 09:08:51 -0500
X-MC-Unique: zt5kT_v9Mfqj4x8cTm1jHw-1
Received: by mail-ed1-f71.google.com with SMTP id f11so2718023edk.13
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 06:08:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xNsc4ofKzldRkYnvwJXNs5RK+6GkOrDBT7I8mnRbwPw=;
        b=uN3Ib78cqebCR47zPDEUeUSkf46oj4WycpTwN6ZzoOWoW54D1bzX5fyn3iJHq0EDtM
         O9L8YH9jLoGXAOCGSX0AfdtwbcXqRU611o74Frh5O/mJ4hFGzIk4zAy4rhvg3NqnWiN+
         s9ycXoOowv6o/VoacFxD043ZBoUhe34tOd+kyGvMjPxODMUcXwdSbX/8y2GQP6IxrqDc
         Ds2SJxPKjJuQ7Gp6uw21Hs0ti2cT3ptY3i/MXowIwYvqdjrzhbEv62hYZ4AboTRubj+5
         WhCH2/I6hcWoTyso5H9IGs/phVuGCRlb6MQw7DGd0AfX17+SHj+5os+G7+ygxLDm0TUq
         H6UA==
X-Gm-Message-State: AOAM532Q/ldqmnoUI0X7jJmZQthL3ifCvhNHGtO+m/Em4AMcev7vweVe
        Mzc8EpB14xpVGv59J34gekNmDYWUUKQMtfwZ8gzHsSGZDgsWfUKTEMoRfaDihlB4nMVA0nO+ZoR
        Mx3eEiN2Gn7DETod6888o8M4olrYE9z50Z3ReJ9yPvqTIKTlsPKK3A4AI5WPY7PuwlpJk
X-Received: by 2002:a05:6402:3094:: with SMTP id de20mr3167294edb.30.1614262130251;
        Thu, 25 Feb 2021 06:08:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxY56CyJDqPgrpPwrlvj/L3fwThCI0QfgFNmU7YNK3uL4Lag5SJFkzcE5hemnhTWzlmcgaeaA==
X-Received: by 2002:a05:6402:3094:: with SMTP id de20mr3167270edb.30.1614262130030;
        Thu, 25 Feb 2021 06:08:50 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id ca26sm3657595edb.4.2021.02.25.06.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 06:08:49 -0800 (PST)
Subject: Re: [PATCH stable 0/1] Bluetooth: btusb: Some Qualcomm Bluetooth
 adapters stop working
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20210225133545.86680-1-hdegoede@redhat.com>
 <YDep2EFvaTwFpbVN@kroah.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <f78f16ac-a34f-3903-6c97-db5d404f175a@redhat.com>
Date:   Thu, 25 Feb 2021 15:08:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDep2EFvaTwFpbVN@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/25/21 2:44 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 25, 2021 at 02:35:44PM +0100, Hans de Goede wrote:
>> Hi Greg,
>>
>> Here is a cherry-pick of a bluetooth fix which just landed in Linus' tree.
>>
>> A lot of users are complaining about this:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=210681
>>
>> It would be good if we can get this added to the 5.10.y and 5.11.y series.
>> Older kernels are not affected unless the commit mentioned by the Fixes
>> tag was backported.
>>
>> I've based this cherry-pick on top of 5.10.y, it should also apply cleanly
>> to 5.11.y.
> 
> 
> This is already in the 5.10 and 5.11 -rc1 kernels I released a few hours
> ago :)

Ah, until now I had missed that there is a separate rc stable tree:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/

Well live and and learn I guess :)

Regards,

Hans

