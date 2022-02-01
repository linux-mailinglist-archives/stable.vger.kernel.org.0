Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017F24A585B
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 09:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiBAIQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 03:16:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234578AbiBAIQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 03:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643703374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iF9w/EWzbcab7CEp+886dB7LcQJEOM9pY9E+Ls1yiTc=;
        b=TV2v7tl1Zvt9iVoN6V4YOl+wiL5JKoZaHumc5lttzuhncCwRYf9ktyUhiJ83wX52MpqgPA
        B9Khprja1jKg9mZ3F9grJ5w3bh3mTvElv0b1ysL/KbzCgKY/fS+lXpCdFYYxYceF6ITXnI
        GUv5UguLbukFDr6LoCWa0um0wiBoHLI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-1s46bQW5MmqBinVz0lvoTw-1; Tue, 01 Feb 2022 03:16:13 -0500
X-MC-Unique: 1s46bQW5MmqBinVz0lvoTw-1
Received: by mail-ej1-f72.google.com with SMTP id kw5-20020a170907770500b006ba314a753eso6152233ejc.21
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 00:16:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=iF9w/EWzbcab7CEp+886dB7LcQJEOM9pY9E+Ls1yiTc=;
        b=EgNIMUx71sLZ1GCGVQZHANgArgQwlPXmp0x2VehZxxgcF7rlX+h+BLrpUylkZgqZiZ
         E3/ujQBv/ZZvXq/NB+LcwevAoHIXLwUMrGQsyqlmcy8U0Ka35lDfgdoSjccuva3Sjf3F
         gcwOcfRWtB9Ynfx4iB41bMMnA6K9eTviD0kQ/5ruT8m0sy0spa5FixdXvyO7ATLBC0x5
         4sDC3v+Q6r+q3N1uUFABqKN8BMMKqDazfex/tpFMGv/Kr2zJHmi0ndC+AQJ+Lkdcn1aM
         0AUBSsJSkId8LQKt6mMNfVRqEGhSsvvnRdwHemWwapeIEdgC/BmUjml/AG9+3GjIbM2C
         hJ9w==
X-Gm-Message-State: AOAM531YWI94LE96f/ulLL4Wq88Br5OSjDDQtz502Rl3dRGsZ+acWcQt
        BVdpSHABY6aAUI+46bendaD2fTdM5yG3jU0YGQwEQyTHRL4V7SERFrrKUq7Zmu06gi9XfBQHl88
        lVyA8p1hTylEqdqem
X-Received: by 2002:aa7:db8f:: with SMTP id u15mr23878846edt.36.1643703372250;
        Tue, 01 Feb 2022 00:16:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwamLK6ay27bqiSrVmgRcJ7JB3jtltO7wdzb/R1xyMI58jT5fc1iRd1ruBPTJB8FcSJ0H18yA==
X-Received: by 2002:aa7:db8f:: with SMTP id u15mr23878827edt.36.1643703372010;
        Tue, 01 Feb 2022 00:16:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c711:ba00:67b6:a3ab:b0a8:9517? (p200300cbc711ba0067b6a3abb0a89517.dip0.t-ipconnect.de. [2003:cb:c711:ba00:67b6:a3ab:b0a8:9517])
        by smtp.gmail.com with ESMTPSA id t27sm14169757ejd.168.2022.02.01.00.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 00:16:11 -0800 (PST)
Message-ID: <a457b70a-004c-e49a-26d2-c207c28bda98@redhat.com>
Date:   Tue, 1 Feb 2022 09:16:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v1] drivers/base/memory: add memory block to memory group
 after registration succeeded
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>
References: <20220128144540.153902-1-david@redhat.com>
 <20220131170123.42d7f46ecea0da1cb1579113@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220131170123.42d7f46ecea0da1cb1579113@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.02.22 02:01, Andrew Morton wrote:
> On Fri, 28 Jan 2022 15:45:40 +0100 David Hildenbrand <david@redhat.com> wrote:
> 
>> If register_memory() fails, we freed the memory block but already added
>> the memory block to the group list, not good. Let's defer adding the
>> block to the memory group to after registering the memory block device.
>>
>> We do handle it properly during unregister_memory(), but that's not
>> called when the registration fails.
>>
> 
> I guess this has never been known to happen.  So I queued the fix for
> 5.18-rc1, cc:stable.

Triggering that registration error is fairly hard, usually we fail
memory hotplug because we fail to allocate the (largish) memmap. So I am
not aware that this BUG actually triggered.

-- 
Thanks,

David / dhildenb

