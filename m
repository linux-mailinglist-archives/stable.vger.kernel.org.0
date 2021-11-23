Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF745A070
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 11:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhKWKnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 05:43:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229764AbhKWKnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 05:43:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637663995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XK0aJCDPWMVY8iUCb8dM1QaYRFGC3oywwhYDDiHndV4=;
        b=MTaVS3OFlP7XVS0DuEZx6Ug2Yp8YlsPa8X+odN1TjL2r+KngB30UkS8uZ0iOApHh0WyJqD
        6+ij6/vxSAOxtpmZ5zmAWnsc+/k9g4/ACaOBWd/fD/osJPv+t9E4wevbPfOW+zirgPqXcE
        qKe/26Tpu+6VH9FdTogIRTdGoNlP6r4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-r_Leeq5sMZiQN7cxqgxDNQ-1; Tue, 23 Nov 2021 05:39:54 -0500
X-MC-Unique: r_Leeq5sMZiQN7cxqgxDNQ-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so3630870wro.18
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 02:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=XK0aJCDPWMVY8iUCb8dM1QaYRFGC3oywwhYDDiHndV4=;
        b=SNPcL45NQ47kaQdByNs+kPamta99sUlr2FFYsC8800RCK+gbnSDe3Q/BmpLlgcpcZn
         /EvUnukOZ+m5iGKPNFHp/5eUjJzzM90ZIIOX442xK+pTkbf5bCZ3n2mueSdtpb8uebz1
         LpcYGes32zm2X9gYiIFGrQw+BH99TsAloHJ/31FD2lM+gF+cxC5bUjUJoqQo0oc5irEC
         Aezib9VQLbQGWLRwN7Yvh6Eb0cEh4HYzXM9fURHT2Sg8fPze1Bg6i5KZot6RlH3xbtWs
         r4X/ig/xmIYk+RCxRfCWgJwj2ohmnDY3wRfh0uhy8lPoH9n8uiNguVbsCM93hjphAn6T
         Cs6g==
X-Gm-Message-State: AOAM533IO3eWiUK4AR7DuA1/YUdEMr03Vc1arCOpSGd3wLkYIb3yMNR4
        ZVNVgGa4kPAn9KR52AGilgQpYx0b7uvGY05onJnqIYJ1fVADFdXawwFv4wGmP4tiFEw2XTSD1k6
        KEFpFulRJWSXLEjpE
X-Received: by 2002:a7b:c102:: with SMTP id w2mr1721642wmi.151.1637663993248;
        Tue, 23 Nov 2021 02:39:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqhwwWfAzk772dDrU+DzYrMGjxPc1RC0qFfScB8KPG+OISG92+TCtdFD7PBOobSW78biUqSg==
X-Received: by 2002:a7b:c102:: with SMTP id w2mr1721617wmi.151.1637663992970;
        Tue, 23 Nov 2021 02:39:52 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6765.dip0.t-ipconnect.de. [91.12.103.101])
        by smtp.gmail.com with ESMTPSA id g19sm785878wmg.12.2021.11.23.02.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 02:39:52 -0800 (PST)
Message-ID: <1b3077a2-a365-3742-5238-e85cd3af816d@redhat.com>
Date:   Tue, 23 Nov 2021 11:39:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: FAILED: patch "[PATCH] proc/vmcore: fix clearing user buffer by
 properly using" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     Dave Young <dyoung@redhat.com>, gregkh@linuxfoundation.org
Cc:     akpm <akpm@linux-foundation.org>, bhe <bhe@redhat.com>,
        Philipp Rudo <prudo@redhat.com>, stable@vger.kernel.org,
        torvalds@linux-foundation.org, "Goyal, Vivek" <vgoyal@redhat.com>
References: <16375840231750@kroah.com>
 <CALu+AoRMcX9Xg97yBzHd1qYONNutoX9R+VksxpE0Hr6eUtXPGw@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CALu+AoRMcX9Xg97yBzHd1qYONNutoX9R+VksxpE0Hr6eUtXPGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.11.21 07:20, Dave Young wrote:
> 
> 
> On Mon, 22 Nov 2021 at 20:33, <gregkh@linuxfoundation.org
> <mailto:gregkh@linuxfoundation.org>> wrote:
> 
> 
>     The patch below does not apply to the 5.10-stable tree.
>     If someone wants it applied there, or to any other stable or longterm
>     tree, then please email the backport, including the original git commit
>     id to <stable@vger.kernel.org <mailto:stable@vger.kernel.org>>.
> 
>     thanks,
> 
>     greg k-h
> 
>     ------------------ original commit in Linus's tree ------------------
> 
>     From c1e63117711977cc4295b2ce73de29dd17066c82 Mon Sep 17 00:00:00 2001
>     From: David Hildenbrand <david@redhat.com <mailto:david@redhat.com>>
>     Date: Fri, 19 Nov 2021 16:43:58 -0800
>     Subject: [PATCH] proc/vmcore: fix clearing user buffer by properly using
>      clear_user()
> 
> 
> I think this is a very corner case and a good-to-have fix in stable, 
> but we can also leave it as is.
> I would like to leave this to David.  David?  Would you like to rebase
> or drop it?

I'll have a look how easy (and different) the backports for the stable
trees area. I assume they are easy, then I'll just do the backport.


-- 
Thanks,

David / dhildenb

