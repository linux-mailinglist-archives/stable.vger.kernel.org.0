Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F6D456E0D
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 12:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhKSLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 06:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhKSLQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 06:16:50 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C18AC061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 03:13:49 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso16248635otf.12
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 03:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aBpjYAWTia/cQ0f6LVj6yM0cFdnWl/MhnHW7qKvyljU=;
        b=Tx7KdjVozdASSKjMP+KOWLcBeqYfPnjURHHx71ffYbRwqp1LFVdjPbSniyXw/U7RLT
         72WWnMqTEsxgUSO0qW79kunTkM+un2/yLL2ZOvrfdboehMMapr3rcyCpFovU8jOy9jc0
         5hnnXP7ZG82lo9phYFcbmaMbykrpzhXqboh428bOMFrLqYge4YLd/b/OqlRo3afkB8U+
         tqi60jP0dZWK0qUfytjWPpoE7ZBuvmb2GP6krdj8R0G0bLvVhkUYuFhB/Lw3Z1WUyCzP
         E47f4/qm0cMfEEt7rZi+Be/m7n8hy56i6lkkrbPy/zeVb0W4NZolYnBd01z2IEOYLjP0
         c1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=aBpjYAWTia/cQ0f6LVj6yM0cFdnWl/MhnHW7qKvyljU=;
        b=rsZwlQV6KmI6C43KKftGv2G7u2/Tn5mudAzyJRfOrBgDvS11PLqlmd+odHW0uEvOBJ
         YehGYcL7X68OKSUZp/7Bl9g7U9a9EFuCIeQsCfv7FhO07IV0WAikJJ/dYxtNv0w1or0O
         oRQz/vFNcpqtBu1KKflUeuFbmKJ2jbUyP1jqSmbQRCqKf3oUWglppWLWDgQ0W5t5d0NT
         ELcl79QmnBqWzlahVFtP7gFQCm3Kkv1bFVR56QCI7O0bFMptmIJgO0ffJSoN1B5KNyP1
         eru/Ez4i++KDbkaGoz3EZwSeARhmdrcMUq8P4O1FK5mu/w0KkiS8Gs6oN2RzEUUE9iHe
         xHvg==
X-Gm-Message-State: AOAM5314+jJbrqy5ETXIH7/nFsFI/WcLnsH0+9pccf4SxQJut7sZj1CP
        w08rgKV4gQJGjORBkDd3JQlzpITlMY0=
X-Google-Smtp-Source: ABdhPJwrIFzClvAPV1Wy8ypSgZwmIGQE9zPLYQIDI2DbZC3o4c/fXsV3ahokw0tHkGCuWFkNehqRaw==
X-Received: by 2002:a05:6830:200d:: with SMTP id e13mr4138944otp.109.1637320428834;
        Fri, 19 Nov 2021 03:13:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg38sm694210oib.40.2021.11.19.03.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 03:13:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply commit 5c4e0a21fae8 ("string: uninline memcpy_and_pad")
 to v5.15.y
Message-ID: <70eadb53-b964-796b-dc4b-470e226c0982@roeck-us.net>
Date:   Fri, 19 Nov 2021 03:13:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

please apply commit 5c4e0a21fae8 ("string: uninline memcpy_and_pad")
to v5.15.y to avoid the following build error seen with gcc 11.x.

Building m68k:allmodconfig ... failed
--------------
Error log:
In file included from include/linux/string.h:20,
                  from include/linux/bitmap.h:10,
                  from include/linux/cpumask.h:12,
                  from include/linux/smp.h:13,
                  from include/linux/lockdep.h:14,
                  from include/linux/spinlock.h:63,
                  from include/linux/mmzone.h:8,
                  from include/linux/gfp.h:6,
                  from include/linux/slab.h:15,
                  from drivers/nvme/target/discovery.c:7:
In function 'memcpy_and_pad',
     inlined from 'nvmet_execute_disc_identify' at drivers/nvme/target/discovery.c:268:2:
arch/m68k/include/asm/string.h:72:25: error: '__builtin_memcpy' reading 8 bytes from a region of size 7

Thanks,
Guenter
