Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1688226E5DE
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 21:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgIQOn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:43:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727647AbgIQOmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 10:42:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600353725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myovNycxMKo26Rju4GydiaUlBrxYAZeyD29wxfgC+ok=;
        b=FbY01TRCFQKUa7lhGpOn4N6nCgo5YQvzKJCyjM/WY8QwEkAuKjd1NqyYzhIi0tA3C5HDZq
        a7bSSALMu67t+Q+hx7HdyVWBNMbUBYZWXbJlmdVeCC5RRd+P1Aju4pNZrbYib08vF5SS0Y
        sxM4hIP7tbwM+koq+0j5/v8Zezb3F9o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-x3sgwBlWP_m3BS1zEtPHeA-1; Thu, 17 Sep 2020 10:42:04 -0400
X-MC-Unique: x3sgwBlWP_m3BS1zEtPHeA-1
Received: by mail-ej1-f69.google.com with SMTP id md9so968782ejb.8
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 07:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myovNycxMKo26Rju4GydiaUlBrxYAZeyD29wxfgC+ok=;
        b=bxNyOyT9WSSjaOBiKaDQfc4K+14e103baYYQwc1potEZJw/5Ldxmr2yki1zoCzGfsU
         S5bLBNiCDE9BaTF6IlaYtu7bGbFvWvBQF3Ar6Oh18gXVNxC7ua5JCxyU7tCaB9B0R0rB
         KYjRQyHu5RCr9e8EZ1WFCUcAMmUWWh5Ndz/cyJe3NYoxxRnWTUJHG/oEGc+0dtYYQqw3
         Tjazb4XNfVsF7i1t7+obzrJk2FiXN3OXIX1AJGnKE7/utQE1lw8u07CHO0S7S0KpIAt6
         PRbZr2gYEZWGyn5i//e3x91eEMbnG9XkbHqHCCHMVY1nKyjcDPEhYrLijbILdxpTYDqx
         bOTA==
X-Gm-Message-State: AOAM533yDFt99GtnVguRJ/do/gBqVcb6M1pplgQgEtMv7IjUEoDI4wEr
        0QJFu6jTrfi9vlOKuRbG0kxI5VcUZ/EVachmh3bTgNc7uk6D211esn48zNo+AVM+P2jEGMXF0nB
        60nLerBQ+iAW2UjCi
X-Received: by 2002:a17:906:90d5:: with SMTP id v21mr30734483ejw.123.1600353722641;
        Thu, 17 Sep 2020 07:42:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFpZh53OeBv4+9I5bJfUa+XixMw9PWtv9RZJkVFjDuy42apsGEERMHatoCHZLmv2cPfL05DA==
X-Received: by 2002:a17:906:90d5:: with SMTP id v21mr30734465ejw.123.1600353722453;
        Thu, 17 Sep 2020 07:42:02 -0700 (PDT)
Received: from x1.localdomain ([2a0e:5700:4:11:334c:7e36:8d57:40cb])
        by smtp.gmail.com with ESMTPSA id b6sm16802199eds.46.2020.09.17.07.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 07:42:01 -0700 (PDT)
Subject: Re: Sound regression in 5.8.8 caused by "ALSA: hda - Fix silent audio
 output and corrupted input on MSI X570-A PRO"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Dan Crawford <dnlcrwfrd@gmail.com>,
        stable@vger.kernel.org
References: <7efd2fe5-bf38-7f85-891a-eee3845d1493@redhat.com>
 <20200917143142.GC3941575@kroah.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <5a58e0f2-b3d3-104e-73be-5f8a59178a7b@redhat.com>
Date:   Thu, 17 Sep 2020 16:42:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200917143142.GC3941575@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 9/17/20 4:31 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 16, 2020 at 08:28:29AM +0200, Hans de Goede wrote:
>> Hi All,
>>
>> This bug got filed against Fedora last night:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1879277
>> "1879277 - Audio ducking after Linux kernel 5.8.8 update, with headphones plugged in"
>>
>> The system in the bug is using a MSI X570-A PRO motherboard. So this is almost
>> certainly (this has not been confirmed) caused by commit 8e83bd51016a in the
>> stable tree: "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO".
>>
>> I'm not sure how to proceed with this one for the stable series,
>> I guess a revert is in order, but that may (re)break non headphone usage?
> 
> If you revert, then 5.9-final will also cause the same problem, right?
> 
> Or is all ok there?

The reporter has not tested 5.9, but I assume that 5.9 final will also have this problem.

Regards,

Hans

