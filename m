Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1366F2CCB35
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgLCAqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 19:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgLCAqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 19:46:48 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B22FC061A54;
        Wed,  2 Dec 2020 16:45:10 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id x22so994702wmc.5;
        Wed, 02 Dec 2020 16:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vhHfDtVfB3voF0jBllvbHRUDCdkncKz2vVPuYQWumd0=;
        b=Brik+Mt6ua8+6rHMl89y2/HYV8hpcNnVSYfrABWoIBFjBn1vN/doe+Et91YzutZ2hr
         j4JuOHpFPkZXpL1l+cLlNpW9Ji3Hs4fcg8hkpzHqRjwL5CdH+9iHiHWqJQ7eG4p50nED
         boNgwNpLgAeQTZ/kAySg92BguDIaE5alom6YwPlV0ejx2NTWc1rwTIxkmjZ7eQNQ3FQP
         mpR+Ra6IpQEtEiDTeSSwQyixkrMkLcSHul/C4JjV2TXULoVqmXxuJA0OdL/FkDBKn2wY
         2IKgZu3ulF6gD+XwNbyg9EW/MR4wu3fR7XspfjuH1UxZlKjEZi+kerCtCLbl8dkYGQPy
         ZaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vhHfDtVfB3voF0jBllvbHRUDCdkncKz2vVPuYQWumd0=;
        b=fp5lLXCz/v6Ygk3O3iohIlNCikLOK10gozkewsjV6a/VwHy/NzPlRrFt+6Kg/69glP
         SHqW0jhG5/o8UDsa1ZZc2rTYzei0U/DBYSfiBNSD6AWXWE+X6P172/PjVvnLjXDmNi5B
         OJDVXii/cpU6aYkbKVbLc57z5S2ZqExigKg4hpTQ2NJgBpnPnVqSoCxEjafIFfpxNY0D
         sSss5ThrKA/wGGkk0uQC+NiRhIwFEuLrF9mW8QU/Bkv4/itQdP4JRz6dPoAjc5ozj7uS
         VltNLJQHMQWwDimzjjnB0+f41hQwx49qB67U1B7pPpybGANasoMu2cufP1obBZiR1qBq
         uSIw==
X-Gm-Message-State: AOAM531IpeP/mj9EjtcVvB/IJ2pakWuBq8blFHxLzU1uaGURt0rm45yi
        RcOzmFMhs3pDhWsGjsWw6QrinmiHqCC/gQ==
X-Google-Smtp-Source: ABdhPJx1QoIxush08k1WYWSWmsNwx9qTeO2obDY0IA2rL/tBCGXsbHtI5mkZlWDHwsH2Lsg7pzqS8Q==
X-Received: by 2002:a1c:7dd8:: with SMTP id y207mr464591wmc.181.1606956308749;
        Wed, 02 Dec 2020 16:45:08 -0800 (PST)
Received: from [192.168.1.238] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id l8sm210652wmf.35.2020.12.02.16.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 16:45:08 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <70a236ff44cc9361ed03ebcd9c361864efdf8dc3.1606674793.git.asml.silence@gmail.com>
 <ee19d846-6f58-5ff0-7928-48c00fcbce3a@kernel.dk>
 <14be454c-46cc-310a-1a43-6065f3b3020b@gmail.com>
 <d67dd667-d161-a070-06ed-0cd0ae0e617a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.10] io_uring: fix recvmsg setup with compat buf-select
Message-ID: <0f397ee5-3aae-babe-815e-edaff1cc0abd@gmail.com>
Date:   Thu, 3 Dec 2020 00:41:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d67dd667-d161-a070-06ed-0cd0ae0e617a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/12/2020 23:24, Jens Axboe wrote:
> On 12/2/20 3:04 PM, Pavel Begunkov wrote:
>> On 30/11/2020 18:12, Jens Axboe wrote:
>>> On 11/29/20 11:33 AM, Pavel Begunkov wrote:
>>>> __io_compat_recvmsg_copy_hdr() with REQ_F_BUFFER_SELECT reads out iov
>>>> len but never assigns it to iov/fast_iov, leaving sr->len with garbage.
>>>> Hopefully, following io_buffer_select() truncates it to the selected
>>>> buffer size, but the value is still may be under what was specified.
>>>
>>> Applied, thanks.
>>
>> Jens, apologies but where did it go? Can't find at git.kernel.dk
> 
> Looks like I forgot to push it out, but it did get applied to
> io_uring-5.10. My git box is having an issue right now, so can't even
> push it out... Will do so tomorrow morning.

That's ok, just trying to keep track. Sorry for bothering

-- 
Pavel Begunkov
