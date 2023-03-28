Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9296A6CBE56
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjC1MCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjC1MCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:02:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFF87EE5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:02:06 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id er13so7636818edb.9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680004925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pS4Fobk4rbnvFOqUGO4sloBO/Pdy7bHW5mqwk3UMU+E=;
        b=lIAozFQlh4U4yuo+XC8enmoEAniv0i3PChrRB7EQWmpjYohHBvaWzUosjt8RnQvQvD
         c1DevfhQXfW4lev6+SKhTHFWZK+4nej8ZJ2bLbm63Mgd4OAQYRVnqVOSSxsdMjIajJCc
         6kRZw8T52/KZvNpwMo3Ww1RbblK5j3trcjRTYDfH2oiSDAZc9fY/vYYfikHAVA76NJJ1
         uU1tEJLXkVTc23OK5SU+UMKlEy+kTYyQuP+cPgMStK2QixtHqsC7RdIbEvjgnHFu6oTz
         zfS7IBos2KU8hVQG7cxeDhW/hFD7AE8lBTe22ZJgxTM6AWAgMgLjxVdkx3ySw8Cp6ZB7
         xhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680004925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pS4Fobk4rbnvFOqUGO4sloBO/Pdy7bHW5mqwk3UMU+E=;
        b=fwRvHa3Ys+KhxlW6TT3bYs2ZTCQJowTQmxnWllGUTFVZHgszlOhHzrAKBHwDZ2MEod
         v7brWBjuNsKM39RVpkxKYkCyVq33krKkPUTKNfTS4fzb7ns+M8UlwcOAR/3zuIZRCIDP
         66NZegOV4kMbCNTvXWMSFCVdRzhyCEw0Ah7fva1CH8IyVVfVqULq630wZqmrtOSdgzlS
         rjQU6/m9rSjCyis1ys9wRpuw5mjYEqjqdJDXxijzohXSH/PZ3FqAqfsPO5bBSpE5sgEL
         +MmBEo0kSN2es7PQgpAXCIwgB/CvVCzUYTRUAYuTWXcwY7//b7mCpNjsR0zvk3CvnYVk
         1oQg==
X-Gm-Message-State: AAQBX9dJ6NEKSvKFdE8mPawdBgEc4AZFE6f9xe5WwzX6QpH1beMjgs+D
        2QWVWXSVSt4u3N049ZQVJu9Nh6vtj6t+hd+egtM=
X-Google-Smtp-Source: AKy350al2o/SOWe50tAeCWNYpHoai78MclyPykTYMAGBH7mjvsG8K7rVa/8wtKR5EV8DAZsw74P7Fg==
X-Received: by 2002:a05:6402:1a48:b0:501:d3a1:9a4a with SMTP id bf8-20020a0564021a4800b00501d3a19a4amr15606297edb.19.1680004924925;
        Tue, 28 Mar 2023 05:02:04 -0700 (PDT)
Received: from ?IPV6:2003:f6:af12:cb00:3146:384f:5efc:fd5d? (p200300f6af12cb003146384f5efcfd5d.dip0.t-ipconnect.de. [2003:f6:af12:cb00:3146:384f:5efc:fd5d])
        by smtp.gmail.com with ESMTPSA id x11-20020a1709064a8b00b009342fe44911sm12238923eju.123.2023.03.28.05.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 05:02:04 -0700 (PDT)
Message-ID: <c359c777-c3af-b4a6-791d-d51916160bf5@grsecurity.net>
Date:   Tue, 28 Mar 2023 14:02:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Linux 5.15.103
Content-Language: en-US, de-DE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, lwn@lwn.net, jslaby@suse.cz
References: <1679040264214179@kroah.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <1679040264214179@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.03.23 09:04, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 5.15.103 kernel.
> 
> [...]
> 
> Vitaly Kuznetsov (4):
>       KVM: Optimize kvm_make_vcpus_request_mask() a bit
>       KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
>       KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
>       KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
> 

That list is missing commit 6470accc7ba9 ("KVM: x86: hyper-v: Avoid
calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL") to fulfill
the prerequisite of "KVM: Optimize kvm_make_vcpus_request_mask() a bit".

Right now the kvm selftests trigger a kernel NULL deref for the hyperv
test, making the system hang.

Please consider applying commit 6470accc7ba9 for the next v5.15.x release.

Thanks,
Mathias
