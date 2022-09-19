Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1395BCFAF
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiISOx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 10:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiISOx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 10:53:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C8D3340B
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 07:53:55 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so7479203pjq.3
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 07:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=nThmnf+XQ5QO+jjxi3Y8eMd0kQ2NZiZtYYZ+toSOT5Y=;
        b=NHsdy1Xi1Z+ZOc516IQ5l2PnNhBAoZShWtnuadBwYdv080+cqlA3kw8vEvoFrtvAQP
         O+ih4/O2UShUj9TsO7rr5a6N+/E4wzNXS2sUqr5TNM15lYzaPmYbu0k3aLCu5OeO2UBP
         eLiby2OuFVcDxWdT/HjMUmic7B3XoBqguPEsJj/1mrRXpQ1UUP0aCevAbWdDw7kZ9Noz
         ymVsK1yRGxr/PByRp3gHjcS+jOcDKorK2iOBgYxpLO73Pq6m4PWbRLxYul9tSxFGMpr5
         ITsMDKJKKas1dsfMIFJwmwGSz/eOXTHPtUKNJmJmttZ+OjvRCxUS4iKUe6UWd7Fmkrvl
         enMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=nThmnf+XQ5QO+jjxi3Y8eMd0kQ2NZiZtYYZ+toSOT5Y=;
        b=suIzaczzof7oTVELqiPnu/jNlj8fmOxoA9j7554TphkRAOLBHBnnNOe0Aw4WGM79NF
         OWshTdTXpbUbtwXr/0o7uA2C0t7UcdkiwjLhy4bbJCNdQHdAAnUhnChgn0dOArATvbX8
         HxB81T2prnMMLiM+n5/hl70gTBt7rezPfLDM3ORTX1dXHSt7jycSmCetQPLKdcKPGwr8
         80swb5VwArJ4I8koMWbpb4jP6MVlF9lQZMyrNA/RniyrfJwPG/5qNTg0R9aslGEtRHyW
         Ic+l7ilgVFzxjvZPO9kQd7/5kWhQ85Y1GYRv6nOo+gU3442EncH1L4dlddzcdUVIZMby
         xIKA==
X-Gm-Message-State: ACrzQf1WgQwGylJ8Zzjrx/gulPlrCP3KUqbt7jG69m44YvZaxgWC4Eov
        vMoqcu7fGJq0COP6g1BJKwjOPw==
X-Google-Smtp-Source: AMsMyM7/0aBmCLJgAYK6OcvQ1wiLUqG0rH3NdvggIZGPO6zrmlCO+9X3rdOy86aEN2TjosN73odQ/g==
X-Received: by 2002:a17:90a:bc83:b0:203:9dd:15ed with SMTP id x3-20020a17090abc8300b0020309dd15edmr30484450pjr.171.1663599234476;
        Mon, 19 Sep 2022 07:53:54 -0700 (PDT)
Received: from ?IPV6:2601:1c0:4c81:c480:feaa:14ff:fe3a:b225? ([2601:1c0:4c81:c480:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id n68-20020a622747000000b0053e599d7032sm20349038pfn.54.2022.09.19.07.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 07:53:53 -0700 (PDT)
Message-ID: <75180d8c-235d-cdfa-2dff-01e0b8a24691@linaro.org>
Date:   Mon, 19 Sep 2022 07:53:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] usb: mon: make mmapped memory read only
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
 <20220919042533.2688081-1-dvyukov@google.com>
Content-Language: en-US
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220919042533.2688081-1-dvyukov@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dmitry,
On 9/18/22 21:25, Dmitry Vyukov wrote:
> Hi Tadeusz,
> 
> Looking at places like these:
> https://elixir.bootlin.com/linux/v6.0-rc5/source/drivers/infiniband/hw/qib/qib_file_ops.c#L736
> https://elixir.bootlin.com/linux/v6.0-rc5/source/drivers/infiniband/hw/mlx5/main.c#L2088
> I think we also need to remove VM_MAYWRITE, otherwise it's still
> possible to turn it into a writable mapping with mprotect.
> 
> It's also probably better to return an error if VM_WRITE (or VM_EXEC?) is set
> rather than silently fix it up.

Yes, I think that returning an error will make more sense here.
I don't think we need to worry about VM_EXEC. Even if userspace will try to execute
from the mmaped location it won't work. It will probably crash the application without
causing any harm to the kernel.
I will update the patch and send a v2 soon.

-- 
Thanks,
Tadeusz

