Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD75194881
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 21:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCZUPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 16:15:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20960 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgCZUPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 16:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585253736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Awvdr9EejHG6LgAifa/OlpP1SiaNNAcBf8oMqF5bozk=;
        b=H4Z9EVa2S8QDeBemKpcZs2L9N/QOC6OWJL5JPExEEWyp8O/wNPLKVdOVc6Q+u0Df6fMkX5
        ngnJpUtKM600Dyzu1ZAwaWmeLGUqS9UQ6N5DD4oDVOOiTSP211JNVOL217fx1c2Nukaz6e
        x5czy2vrSj8+y5CKMPpCJT1QWDJo7cE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-YyccHX8iNQiB436XbHTBjQ-1; Thu, 26 Mar 2020 16:15:34 -0400
X-MC-Unique: YyccHX8iNQiB436XbHTBjQ-1
Received: by mail-wm1-f69.google.com with SMTP id i9so1252827wmb.5
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 13:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Awvdr9EejHG6LgAifa/OlpP1SiaNNAcBf8oMqF5bozk=;
        b=jTg2fb8qBFANxdXW8AVZjj7BTpQVuf13rJkRjynO+T8B734tRBmdIlzKoHYgCe+ZqY
         oevYkRlJOoDSPj1BZVqr68vwfefYNteVk5om7jcMW0obgjqWQhYpVCPU4vnIEXNEjY9g
         hw6MUKZTNf83vzUBK/iEwGv7KQp5D3j23tTq6rLPCoCQFgI/rR7b6eOPoV8F3FvKkoJm
         rTEa8fz4++5HiQ367ik/hYmXj69VfA1LVMi51WDYVQ+S1cZBV154rGVzmiCgpmF+2cfQ
         F6+XZNk63N6tpHKFIpWz5FfMJ6xGL/ITaIeRJJdq4aNwh29aIA9PHeiRfF+ppU3F09Zl
         r6EQ==
X-Gm-Message-State: ANhLgQ2vWdtg3HlML9ipLI0ZJcR2WhGg3MEkxGNaXyzDlvJE84aitUba
        OKBWaHJEq4zT/uJ0rn42zB6+GVoSJ7oiIvVysvnfTW+VF7SBtu6qxnaNFVFU7GPEo2+QL85bWW+
        Bi4kqwvdLhFvi1It/
X-Received: by 2002:a5d:6109:: with SMTP id v9mr11537586wrt.203.1585253733322;
        Thu, 26 Mar 2020 13:15:33 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtscskn14vA31RwZYWmkQbHQ1sAUUEad5PTUfbHowUoCzcvBXVzzKaOWC71tfeuvNdlPp5zDw==
X-Received: by 2002:a5d:6109:: with SMTP id v9mr11537568wrt.203.1585253733085;
        Thu, 26 Mar 2020 13:15:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac:65bc:cc13:a014? ([2001:b07:6468:f312:ac:65bc:cc13:a014])
        by smtp.gmail.com with ESMTPSA id e1sm5178897wrx.90.2020.03.26.13.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 13:15:32 -0700 (PDT)
Subject: Re: proposing 7df003c85218b5f for v5.5.y, v5.4.y, 4.19.y, v4.14.y,
 v4.9.y
To:     Thomas Voegtle <tv@lio96.de>
Cc:     stable@vger.kernel.org,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        LinFeng <linfeng23@huawei.com>
References: <alpine.LSU.2.21.2003261831320.11753@er-systems.de>
 <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
 <alpine.LSU.2.21.2003262103280.20929@er-systems.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e343d48-ab47-9611-fb3b-4d60b347d129@redhat.com>
Date:   Thu, 26 Mar 2020 21:15:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2003262103280.20929@er-systems.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/03/20 21:08, Thomas Voegtle wrote:
> On Thu, 26 Mar 2020, Paolo Bonzini wrote:
> 
>> On 26/03/20 18:43, Thomas Voegtle wrote:
>>>
>>> Hello,
>>>
>>> the following one line commit
>>>
>>> commit 7df003c85218b5f5b10a7f6418208f31e813f38f
>>> Author: Zhuang Yanying <ann.zhuangyanying@huawei.com>
>>> Date:   Sat Oct 12 11:37:31 2019 +0800
>>>
>>>     KVM: fix overflow of zero page refcount with ksm running
>>>
>>>
>>> applies cleanly to v5.5.y, v5.4.y, 4.19.y, v4.14.y and v4.9.y.
>>>
>>> I actually ran into that bug on 4.9.y
>>>
>>> Thanks in advance,
>>>
>>>  Thomas
>>>
>>>
>>>
>>
>> Yes, indeed.  It's not a trivial backport though, so I prefer to do it
>> manually.  I can help with that, or with reviews if Yanying already has
>> patches ready.
> 
> Are you sure we are talking about the same commit? Or do I really see
> something wrong here?
> It's an one liner. Applies cleanly. Compiles.
> Don't know if it fixes the bug, though.

It's a one liner, but usage of the function it touches has changed
subtly over the years.  So before committing it to stable I need to
check that all uses of kvm_is_reserved_pfn match 5.6 (and also
kvm_is_zone_device_pfn is probably not there in older kernels, though I
might be missing more stable backports there).

Paolo

