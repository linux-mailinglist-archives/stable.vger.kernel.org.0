Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F541D04F
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfENUJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 16:09:20 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:34607 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfENUJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 16:09:19 -0400
Received: by mail-ot1-f44.google.com with SMTP id l17so97499otq.1
        for <stable@vger.kernel.org>; Tue, 14 May 2019 13:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=379AXH8FZwrPwVaDAKf9olFHdauycTaqTafIRJjebcY=;
        b=F18Zle6VZJmusNtHoNqC3nLxfSBZX5mK3Su2s6ziz7zJQeGBKlDCL+Vt4A0l5W24Ih
         C5vduzNzKt7bCOQRHacmuZMyAtXwtiiB0kYsdHqErSuakuR+IwB+4INB7Ikj66MzNLHB
         aGFas8L6D702MTkWYobJ27T9qP9TVvyd0o7Dm6BtgBNOkt4IDvDMYovC3cT+3sw3hvTz
         G05lOnI6VfW0EbRV1AkXxQXZpXodyFqzUVM9wTyDdERDn7zvBhczmqjvkOzxT/9Hfw+I
         2fyXG2EAhoCR2tBNXdazXy3F2XdQeBcGB8jvc0Wd6zvTGfQa7Giew9WekUm4XnGBIp88
         wT6w==
X-Gm-Message-State: APjAAAWMx9kyhBKjfcw9nBUUf88YWXZSAGI06orbZFzMKZtkixD4ibVh
        n2c7ChwYA8SSqHQ1nU2jC/0yRelVOuQ=
X-Google-Smtp-Source: APXvYqyTZRX0GL0g0moe9Mp8AWLG74FCVPfe6EHCZJzX1oyQbJv3KZuMBtQYaeYBu61wr4NI1VH6RQ==
X-Received: by 2002:a05:6830:1541:: with SMTP id l1mr23112848otp.350.1557864558780;
        Tue, 14 May 2019 13:09:18 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id f5sm5246547oto.67.2019.05.14.13.09.18
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 13:09:18 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8e_FAIL=3a_Test_report_for_kernel_4=2e19=2e4?=
 =?UTF-8?Q?4-rc1-f1f5cdf=2ecki_=28stable=29?=
To:     Greg KH <gregkh@linuxfoundation.org>,
        CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.2A0764DDE0.XWP9Z2MJYF@redhat.com>
 <20190514194511.GA22244@kroah.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <15c477fa-7246-a1fe-a175-612f2f6be85b@redhat.com>
Date:   Tue, 14 May 2019 15:09:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514194511.GA22244@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/19 2:45 PM, Greg KH wrote:
>> We attempted to compile the kernel for multiple architectures, but the compile
>> failed on one or more architectures:
>>
>>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> Is everything failing now?  Has this ever worked?

This has worked before, but it appears to be failing on ppc64le as of today. The relevant failure is here:

> 00:00:20   CC [M]  sound/core/oss/pcm_oss.o
> 00:00:20 arch/powerpc/kernel/security.c: In function 'setup_barrier_nospec':
> 00:00:20 arch/powerpc/kernel/security.c:59:21: error: implicit declaration of function 'cpu_mitigations_off' [-Werror=implicit-function-declaration]
> 00:00:20   if (!no_nospec && !cpu_mitigations_off())
> 00:00:20                      ^~~~~~~~~~~~~~~~~~~
> 00:00:20 cc1: some warnings being treated as errors
> 00:00:20 make[3]: *** [scripts/Makefile.build:303: arch/powerpc/kernel/security.o] Error 1
> 00:00:20 make[2]: *** [Makefile:1051: arch/powerpc/kernel] Error 2
> 00:00:20 make[2]: *** Waiting for unfinished jobs....

We haven't seen this same problem in mainline recently.

--
Major Hayden
