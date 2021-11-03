Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26328444985
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKCUaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhKCUaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:30:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333BDC061714;
        Wed,  3 Nov 2021 13:27:46 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u1so5342766wru.13;
        Wed, 03 Nov 2021 13:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=inCfVShktbFlp9RqTscFQ/eED9EcyLjfzRZNA7bFTbM=;
        b=GjWbTAYKvBWy0UmOy2MlKsllroWlVH6z+zrV2BnoJVnL0ka/wMzUibXj4a0HPt5SU2
         CJdIbVuMOuYs4Qv4myrt6uDAJJa4wxCXw6XLGwxLYYH+pLVgNjCI/gD9piQUHgx/ASz2
         vNaOyY3LLn9c9rULxb37qN68d+LoxvJGlekkz83RAwokRhVSiNNOx3Zl+4A/4SBglaIG
         U6yZfyJ82cwRWg84UH6+hLt+tbFeDvtwgYIrsyb3P587uzmXvoXTNu1BhvD31wP3xJWf
         eOb0kGUuoEJ36Fe0Db52sn09bei0PW3IEbuwQh8d2/V2NO/tW4QhWbjeNoZzl+6u68/P
         sgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=inCfVShktbFlp9RqTscFQ/eED9EcyLjfzRZNA7bFTbM=;
        b=vKewyr3vc8LuOgM3fdLGokyX/kUURg29PN/0mNuwUHMrJa3jSU3yWRJl2GT060VVrB
         voXXzCzWnfr2w7gTkScNweMqNlsGc2Jggklw9K8uqrovoF80Gu8hK8qaHkSdlQn3pYZ9
         yFaczsfJuu7w4GzImFWr83eJ/JEgOKcWtPQ+RwzHoiL0MOJeuLIRs/EYEPkPwHs3puRH
         6hYmViIFAPgkVWyd78t5sQkFGxsdFZTqXr6oIqD+2krfzAwbe0cD3DvAUX+S3Mp/+lLQ
         WCkpl4sRgjzX8Nabr3QHi+zF66GzcgFWRTKB/l5U7NG+Hm19NUFTItbMaDmAFBsDptFc
         UQLw==
X-Gm-Message-State: AOAM533eBhouBwO9mEsam8XVHy4ZDoQJgLr9HogB8hQeewybUCBM04/7
        Vyk4urWR54pJzwL4/1uDXMdJFw5bGRT/6w==
X-Google-Smtp-Source: ABdhPJz624LHZPm5YmMYEiLDMbzfwX9CWQyaLc4nQh3wKvpmgJkEqNEvcm+DPyWzYYQZ6sjXHqoruw==
X-Received: by 2002:adf:e742:: with SMTP id c2mr32058303wrn.232.1635971264883;
        Wed, 03 Nov 2021 13:27:44 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:d46:f711:c3:94fc? ([2a02:168:6806:0:d46:f711:c3:94fc])
        by smtp.gmail.com with ESMTPSA id y7sm2885092wrw.55.2021.11.03.13.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 13:27:44 -0700 (PDT)
Subject: Re: [PATCH] ARM: drop cc-option fallbacks for architecture selection
To:     Arnd Bergmann <arnd@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Matthias Klose <doko@debian.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211018140735.3714254-1-arnd@kernel.org>
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
Message-ID: <2e301421-9fd6-a879-1dab-7b3749edfaf4@gmail.com>
Date:   Wed, 3 Nov 2021 21:27:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018140735.3714254-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.10.21 16:07, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Naresh and Antonio ran into a build failure with latest Debian
> armhf compilers, with lots of output like
>
>   tmp/ccY3nOAs.s:2215: Error: selected processor does not support `cpsid i' in ARM mode
I just had exactly the same problem, and this patch fixes it for me as well.
Compile- and run-tested with gcc-11 (Debian 11.2.0-10) armhf & Linux 5.15.0

Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>

