Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185CA4FC54E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349729AbiDKTxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 15:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349727AbiDKTxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 15:53:12 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809FC275CC
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:50:57 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k25so19966075iok.8
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8+mHCTiuDRUOfVOxDZYRCTUH0i/jDycYz8apiJvfvR8=;
        b=A2elvz/m3+cavtJHAJlUxIuvYfuyyzb0bG+yxqlTg2MBN0yN13hELqmy843+V88XSm
         Sx1+fmgHO40mFyFrfjO8mAS7RriVcda2lgO2JkemESPrusWiuaYgryyhAXgDdvzCcbr4
         HMpahUD1W5zP8je29XWwF80TunlZN2uQ4i84lGps1KYR47NtCYShkwVyuD4IHBqCfJu+
         BnTe8hG7P02DitA/XyeWcQ1BwxDcVhKo7VwZN6DidnQtMo2Cqq7ZS2/8NESGbemAAKm9
         L34bB4W02xoLnHrOFw3JTR0rvjYARfj1ZXvn/CbyS4BhG0qR3sQyeBnOO07iVK7agmMe
         9ZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8+mHCTiuDRUOfVOxDZYRCTUH0i/jDycYz8apiJvfvR8=;
        b=uqWLzIAntPqwYmg9zEwB/TonQr0cOOrxQg0EBETUhLqFTNgsWeOolsr/8K6e8/K6cv
         aARDcX+5bdTh3XkzyKus8jOMToYPf3Czjexnq9GPh2Y8Aywh02yXcneIIFou8sm8dKgj
         tJ4AOovcqiHqjRsanpN8Y4m5MqgjFww6FIv4SGCkcy2V3ofILcmUMT3AmslaoHl6Iwzp
         0qvo+ck8oo5w8oDcRXnJZT8dRjWMtPN1oTpOtX0EtQbJcaxuQZeCmKwMyJcSFSmuEAhg
         gNoSt3DmeCeQ0RbQaM4YWztUeE+djO+ZCnfS4ij2w0XsSEAZleIqjpVh3EOrJ5pfm7cf
         41xg==
X-Gm-Message-State: AOAM531A1lggkPaEM79FgzWWC5qjxjbaBn1aYYF7FXYJwYc+qKP6lJQj
        SwXLOQ8CVyMaHvBCvnfumgp9KPCoxKo0EA==
X-Google-Smtp-Source: ABdhPJy80SfVWBSciE2NyXL1gJn0KZMoA2saCkwKmyXCJcJQlSwGcjvxWAQm3x9nAoEwVHLhhk6Qyw==
X-Received: by 2002:a05:6638:33a5:b0:326:3a0c:76ee with SMTP id h37-20020a05663833a500b003263a0c76eemr1355247jav.55.1649706656868;
        Mon, 11 Apr 2022 12:50:56 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i81-20020a6bb854000000b00649c1b67a6csm20723854iof.28.2022.04.11.12.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 12:50:56 -0700 (PDT)
Message-ID: <7bc5956c-46f1-9411-7ba7-6bfd92b7323c@kernel.dk>
Date:   Mon, 11 Apr 2022 13:50:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: FAILED: patch "[PATCH] io_uring: move read/write file prep state
 into actual opcode" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <164966306719476@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <164966306719476@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/11/22 1:44 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

For now, let's just drop this series otherwise marked for 5.15+ for
5.15-stable and 5.16-stable. It would require further backporting, and
it isn't strictly necessary.

-- 
Jens Axboe

