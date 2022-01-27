Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD149E67B
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbiA0PqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243097AbiA0PqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:46:02 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8219C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:46:01 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f202-20020a1c1fd3000000b0034dd403f4fbso2160513wmf.1
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=mD8BsuCJasSkpkxaaqDLPDCI5MsBcn4xIxsCb70RTuM=;
        b=M6+5QuWsfjE0nxWNyt7LZ2xEMKHfzVGJpRUfyqYBz36uv2uueN7CErKAXyPpUr3Oo/
         xFGbmTwYvIrK6ikSHqnWqqnlEl8TSddTlZdpnvmH7Yi0Z1uIzfFt3FrBAHuTeBiRbYT/
         u+TaaklUyDv+RZc3ZtAqehkCXOzs5mbuwIrohFyNH54a7TCgbcShSrZQXJZiSZXWpS2t
         h0AyWUUrSzfvvD46g/2/wqWKzjbyEgFVRtn0aep4Xpa5u0rRaWBZs4/jvanNxG3lrdAT
         8HLtFrfUtu3YMtDMUV9EnxBYr9mFVDub8Pp5Ms0z92mw221wKGNMiNKAnJEZ7Xzzx4Iw
         DVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mD8BsuCJasSkpkxaaqDLPDCI5MsBcn4xIxsCb70RTuM=;
        b=HkF7DupQmeeH8P/d0UhzHK/HS+pN+qUEhiFiXhhtgbbj7haI48AUx8xl/IRodqT7os
         +oHmk0kwtUfGC5sxOvOSDTLRRmlhA537JiQlG8D/BY4xG4GQgKimaldkV1LEEZuOc09+
         WNOuVSvqVyhPC4BdMZeElS0iKTnp3eaJgmz+e68VUQcB9kSSMKWh7vSX3ZBxZgW3Wg+9
         V0mSvW0/+zSNglQejjK/JJyAekc2relQQAXnZqMXjRQWoGCLcthXPGPJ51CZQ3atWwo1
         PWbeG/O90L0O4P1SMJjbOppxjaY6ZyKd8xzsNbVWjdLHM65KZxBYn2sjMaTwLthucG3O
         7Sxg==
X-Gm-Message-State: AOAM530PLzIbG3NILt0XBcMcHFFuuoha595PcJ9uMS09GIR96psUWMOO
        KxROOGXmLLX1pkSIuT6fBP4lMA==
X-Google-Smtp-Source: ABdhPJxND0YwiWRTGwsVdqIY/nCGxAEVWGCOpdIMKYmIqtlS3y76dsdyR7NPE2OSE9SxxGl7vb49Dg==
X-Received: by 2002:a05:600c:34c2:: with SMTP id d2mr12160612wmq.120.1643298360247;
        Thu, 27 Jan 2022 07:46:00 -0800 (PST)
Received: from ?IPV6:2003:d9:9707:d500:f72a:8d22:e3d4:f73? (p200300d99707d500f72a8d22e3d40f73.dip0.t-ipconnect.de. [2003:d9:9707:d500:f72a:8d22:e3d4:f73])
        by smtp.googlemail.com with ESMTPSA id m6sm2780185wrw.54.2022.01.27.07.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 07:45:59 -0800 (PST)
Message-ID: <5ae2873f-527f-9769-a606-4ff6786c0fcc@colorfullife.com>
Date:   Thu, 27 Jan 2022 16:45:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: +
 mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch added to
 -mm tree
Content-Language: en-US
To:     akpm@linux-foundation.org, 1vier1@web.de, arnd@arndb.de,
        cgel.zte@gmail.com, chi.minghao@zte.com.cn, dbueso@suse.de,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, shakeelb@google.com, stable@vger.kernel.org,
        unixbhaskar@gmail.com, urezki@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
References: <20220127025542.F0GTnQlNA%akpm@linux-foundation.org>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20220127025542.F0GTnQlNA%akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On 1/27/22 03:55, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: mm/util.c: make kvfree() safe for calling while holding spinlocks
> has been added to the -mm tree.  Its filename is
>       mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch
>
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch

Please drop and replace with

https://marc.info/?l=linux-kernel&m=164132744522325&w=2

If I should rediff/resend, just ping me.

--

     Manfred

