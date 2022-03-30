Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0393C4EBB21
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 08:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiC3GwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 02:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243416AbiC3GwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 02:52:06 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A8F98F67;
        Tue, 29 Mar 2022 23:50:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s11so17881230pfu.13;
        Tue, 29 Mar 2022 23:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PREjFWEeKVsrZp9JQYkAg3nJ9VbOpXqQtmse9DPiKQI=;
        b=NrI8JoyFrB+ZLxwF5c73YQ4YEjQQ/2wghgm+5eDZl0aWEj0jVZEay8hHQCZfsLDL/d
         9de0DJpnkc2/S6nj07SpB/2RFsCWU0Cb9fZYJYPYmhHQdzhb+8ABdQUUvpkbF2OCES/P
         jfWY7q/fCZA35HPgua1iYhzGk34XJRF/plH0EBjYxsJZ+7paeSCzTrnsyx1rVLWjHXQB
         mlFRpMkQdkt1i7ZUlZGggrCXOczwwYHARJ3Rn090uUR/kLxEFKoz6U8GX1CEBvzClLsB
         HG991tUcjcdH0p/PRvpKOgc8KqhZejq7Y38DYnHX4G2xkCj9zmrBTRlnUtM0gwNOwMI8
         a10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PREjFWEeKVsrZp9JQYkAg3nJ9VbOpXqQtmse9DPiKQI=;
        b=pDwOSJ1fdZdM0icUccYUqekVbk73S558MGGeI/Zxn3HPIifCUtOOo+JyyKBTEJkeiV
         7fxSbK0zEbsva0RTNgvwOG0hEIlDHlCQP5X3q+Dbl95hzOUWlj0FOz9OP4rAZbUaupEt
         MRYx48m8edPAX5Sa/UynPs9p4MzZR48FeBEtG6ydx9g+oEed2iLOGmxdZbkv1UlnL6B7
         /0Jxmfn+w6AosYOSyZLFtUmWJRbwhfYSiUYQTFtRZhKrapM0W9JIntBnwcGCW0QCj2dX
         Ac0ghRW6D4IyVEAeBxQF7mwSn2fi6gBZ9kWB3ex9NWVEDzwjPIrdoWhQ7mIcsQbOfCbC
         Ek1w==
X-Gm-Message-State: AOAM533YSHFJ9nzN5mCNjgF5XV2jZpIEjWFAbR9Ly0gVHksv0AvZPzMd
        cImEXMInI+99QWjiUgUoOuQ=
X-Google-Smtp-Source: ABdhPJxyZiBi4XbIKhMmWldOgfPgWv12lWKTF90ymwn7JpBab849AcsXIMAC8MJNnTaMIutJh6syMg==
X-Received: by 2002:a63:44f:0:b0:385:fa8a:1889 with SMTP id 76-20020a63044f000000b00385fa8a1889mr4917683pge.160.1648623021096;
        Tue, 29 Mar 2022 23:50:21 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090a280a00b001c9ec7a7f5asm1785046pjd.49.2022.03.29.23.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 23:50:20 -0700 (PDT)
Message-ID: <432fb484-eecf-8203-c457-9092b48a0528@gmail.com>
Date:   Wed, 30 Mar 2022 13:50:13 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Stable release process proposal (Was: Linux 5.10.109)
Content-Language: en-US
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
References: <164845571613863@kroah.com>
 <44e28591-873a-d873-e04a-78dda900a5de@ispras.ru>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <44e28591-873a-d873-e04a-78dda900a5de@ispras.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/03/22 06.49, Alexey Khoroshilov wrote:
> The problem will be fixed in 5.10.110, but we still have a couple oddities:
> - we have a release that should not be recommended for use
> - we have a commit message misleading users when says:
> 
>      Tested-by: Pavel Machek (CIP) <pavel@denx.de>
>      Tested-by: Fox Chen <foxhlchen@gmail.com>
>      Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>      Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>      Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>      Tested-by: Salvatore Bonaccorso <carnil@debian.org>
>      Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>      Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>      Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> but actually nobody tested that version.

I think you missed the point of having Tested-by in stable releases here.
The tag is used to indicate that the entity (individuals, organizations,
or bots) had successfully tested the release candidate (stable-rc). The
degree of testing can vary. For example, I only did cross-compile test [1],
then I offered Tested-by in my name.

[1]: https://lore.kernel.org/stable/2b3af5d1-8233-45a6-7a44-a19f7010cd6b@gmail.com/

On the other hand, Naresh Kamboju (LKFT) did full testing as indicated on
[2].

[2]: https://lore.kernel.org/stable/CA+G9fYu9CjYCQwM3EO5eguRC0rq00HMuE7cEAG4E68shzw4OHA@mail.gmail.com/

Regardless of how testing is done by entities involved, the point of having
Tested-by is to give kernel users confidence to upgrade to more recent
release, as almost all sufferings of testing is represented by Tested-by
entities.

-- 
An old man doll... just what I always wanted! - Clara
