Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E551AF2E7
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgDRRl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 13:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgDRRl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 13:41:57 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFEDC061A0C;
        Sat, 18 Apr 2020 10:41:57 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h2so6161327wmb.4;
        Sat, 18 Apr 2020 10:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vL+RplNY3ZIE1o7nDQNiVeonG9MjYVrxPyRVaheiPPQ=;
        b=J5VDP3LmaTyk51ObVB2bhg+Qs7x655ICKFzuSnHTwwqcFUe3NqRxV8lj0FjtGGWiRV
         mH3kLMXHkyZXt2/Kkesh9E1YpSX3rGLmuPBFmZ3QmCQJalCQAp4totzauuXD3QuplMK5
         nej0TGu7qBGpKsilBeeWWRbaoNAcUdxy5xLb4Wm0w6HXbFTixy1gQMQBjULTO7sWBC1B
         1V3S+WC97bY6QueaCExOqGZXDtowo9XoDATyVpiYr9kn2W65FxZ518wW1ApLKBpqVZ6J
         iju/XZJPazIV6oRD5hxlHvntd3RPUqPJHCSmRVa6JS0Cf9IAykAagxYQX3yXKyjo9Tpf
         Fnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vL+RplNY3ZIE1o7nDQNiVeonG9MjYVrxPyRVaheiPPQ=;
        b=FASIG+F93FYaJJlV4nt9QnuLm635nqtwmETcZ7gAyqAZEzFIuCK+yfC68kDovYyYv1
         wItpCDIOL1O3d5J/x/is72EiUujRbLhqFjpjYSDt+HXfr+sW33bzpEwJuD7hf84dZJnA
         8JsuSVSF9EQW1zAyEokvCjDSf//IZgbHZ8Wfv6cpJ//H86FqQ6TAFmQQ4DguAt/PWU54
         U2lwUA8F2P38aU1ySvoGsFq1tCv92W8d4kIKklt50VSYo/cFzz9JAsKQoXMVBRHHYdQ3
         8vfk0NOUTgpnOP2XR9hlwu/2f+x55nxuvYqLi6rs7cJlQPbJAgkqi+TDb1BZH1h+JKY0
         3ofA==
X-Gm-Message-State: AGi0PuZiK1StSOMvTY4cnc4t/FI+6kYBGTR6uv8d+rQSScywTHJWrRYs
        bc88Jgva8rGu3QM5FPniM3UGKNO4
X-Google-Smtp-Source: APiQypIIip+Rk8mfKtIcb512j/wd+M3pvf0/bkXJoBgXafCK8aumejBzvzhaMVb7W00+z5sR9GZclQ==
X-Received: by 2002:a1c:e444:: with SMTP id b65mr9460710wmh.6.1587231715932;
        Sat, 18 Apr 2020 10:41:55 -0700 (PDT)
Received: from [192.168.43.18] (188.29.165.57.threembb.co.uk. [188.29.165.57])
        by smtp.gmail.com with ESMTPSA id p190sm12370313wmp.38.2020.04.18.10.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:41:55 -0700 (PDT)
Subject: Re: [PATCH ] staging: vt6656: Fix calling conditions of
 vnt_set_bss_mode
From:   Malcolm Priestley <tvboxspy@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org,
        Oscar Carter <oscar.carter@gmx.com>, stable@vger.kernel.org
References: <c64e7134-c1a1-ecd1-1e0c-e0bfe002740b@gmail.com>
Message-ID: <8b304334-d2f0-8b59-287a-fb4c011a6072@gmail.com>
Date:   Sat, 18 Apr 2020 18:41:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c64e7134-c1a1-ecd1-1e0c-e0bfe002740b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry this was sent twice gmail reported the first one failed.

Regards

Maloclm
