Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F3C355B53
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhDFS2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 14:28:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234503AbhDFS2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 14:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617733712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ExwLAkj1fMHpkfyODtJlsJyo9etWcSmaQ4u6oODW1wU=;
        b=cGVKrEfMkjRg5DhirbQ0vQIsx4QNIQKG23aJjeljB+NgrQqeCey55NHKkUfBJZ73u0sjcE
        B5lUKlXNRalNybBldXPCQtUI+ABO9ZHT4OaTuk9/W+IjSRx/F61nlvJrQ4vV3EDa/vf/oO
        IY4IFOauhVC7jPYRDabJi0cH2cVM05o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-tLAKDu3qPReqgR1h09w0sA-1; Tue, 06 Apr 2021 14:28:30 -0400
X-MC-Unique: tLAKDu3qPReqgR1h09w0sA-1
Received: by mail-ed1-f71.google.com with SMTP id o24so10816750edt.15
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 11:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ExwLAkj1fMHpkfyODtJlsJyo9etWcSmaQ4u6oODW1wU=;
        b=I+rCR+WEpXRAe+DUebzEeYgldyf8eG/c7aARVBGq27U9Je6PCULB++RAVLndyJfAXb
         G7ZDYuqnkeamvyeqMgTxdqWrVj7ZSKJzPhDiBkP7Nii05zFKmqdWhWrB7Nc8UyZqV6N3
         vZ0z4kYwcGRwl3I1z7QwOFDGWLLplAafilH4kErVXPKc4aAuZnPEYtPSId6sHGE9HjZW
         lYUJp8ltdr+bXzHhwsdxvvmaStHtlnPCVDx3Ndf2wRdkyNaye9k1EiAyyp9suAPP6gN0
         9gPFRKLT/CvycN3ZIFJVTXx5GrXTGWtBiiMTnU98NqECsn/GFUAjzidPzuZE68Norm1v
         t2Kw==
X-Gm-Message-State: AOAM531wnVAaecae+YyA5eYUqld6qC08jRkT/LbSZCMohzYD/i8daIGH
        vaa954+HdeqraBgeKfXJSvitrq15I9wXzwmWLh81iL+2PolfcBjcOQznpji7Sk5MLYYzMMbFgf9
        ebtrUbmuc4+SdT9OV
X-Received: by 2002:a17:906:94d6:: with SMTP id d22mr22000281ejy.424.1617733709699;
        Tue, 06 Apr 2021 11:28:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpgw/p6Mo1Hx6lijePusQxXGz7YjW0OgTIpoeEwLoRcWqZWIoCS57lCegT9niDK9adLymsgA==
X-Received: by 2002:a17:906:94d6:: with SMTP id d22mr22000261ejy.424.1617733709485;
        Tue, 06 Apr 2021 11:28:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u1sm14076727edv.90.2021.04.06.11.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 11:28:28 -0700 (PDT)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com> <YGxm+WISdIqfwqXD@sashalap>
 <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com> <YGyiDC2iP4CmWgUJ@sashalap>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs in
 TDP MMU map
Message-ID: <81059969-e146-6ed3-01b6-341cbcf1b3ae@redhat.com>
Date:   Tue, 6 Apr 2021 20:28:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGyiDC2iP4CmWgUJ@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/21 20:01, Sasha Levin wrote:
> On Tue, Apr 06, 2021 at 05:48:50PM +0200, Paolo Bonzini wrote:
>> On 06/04/21 15:49, Sasha Levin wrote:
>>> Yup. Is there anything wrong with those patches?
>>
>> The big issue, and the one that you ignoredz every time we discuss 
>> this topic, is that this particular subset of 17 has AFAIK never been 
>> tested by anyone.
> 
> Few of the CI systems that run on stable(-rc) releases run
> kvm-unit-tests, which passed. So yes, this was tested.

The code didn't run unless those CI systems set the module parameter 
that gates the experimental code (they don't).  A compile test is better 
than nothing I guess, but code that didn't run cannot be considered 
tested.  Again, I don't expect that anyone would notice a botched 
backport to 5.10 or 5.11 of this code, but that isn't an excuse for a 
poor process.

> Right, I looked at what needed to be backported, took it back to 5.4,
> and ran kvm-unit-tests on it. 

I guess that's a typo since the code was added in 5.10, but anyway...

> What other hoops should we jump through so we won't need to "hope"
> anymore?

... you should jump through _less_ hoops.  You are not expected to know 
the status of the code in each and every subsystem, not even Linus does.

If a patch doesn't (more or less trivially) apply, the maintainer should 
take action.  Distro maintainers can also jump in and post the backport 
to subsystem mailing lists.  If the stable kernel loses a patch because 
a maintainer doesn't have the time to do a backport, it's not the end of 
the world.

Paolo

