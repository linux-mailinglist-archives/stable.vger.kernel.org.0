Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139DE565966
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 17:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbiGDPIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 11:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiGDPHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 11:07:54 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92433101D5
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 08:06:57 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f39so16284785lfv.3
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 08:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PsBtHpMy5uXbzB8lQXz0O4ljYPlSjSFx7+ITMI5I+k4=;
        b=iDr+ves6KwXdx6kwvxF0OHsV7sQR51hDU6nL0DhVwTIm66romjSo+HVJTFsg34JQQG
         bbjBCx7I6EN6/bET2XvqMCyjeiA0m6Ny29na9Rt6aXiJ5yQWYVAtFA2kvKCZrJpQer+X
         il7kSCH0O0z6hSS+sON2uZ3KOV0eS3/h8WZCSsjMpN2I9J//11iNCm4HhHzT39p1pbO2
         u2gnTQhwC3LCxrYdGfjL+9PUJx3tUBWq65etISsOQAqTwvd3enQg363eky5hQlZEuke/
         bDiFbJ0su0iMZb3IlItWzfztHoGMT2VApEBSDzCL7x6ml+hPXllWFxIuTOKRZgo0Fpfi
         iAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PsBtHpMy5uXbzB8lQXz0O4ljYPlSjSFx7+ITMI5I+k4=;
        b=vixkkDLF20QXTD+1kzx29b3LssGJsqx+i3rUSym4P0LRKDonMjQB5ncRF/EZ90S3Yp
         tZXsrehlkeDso1PlxDbubioAbdtVW8tWGTWyZv9tROwo1+PE1VJXeXjRAeasyJUuZ7Zu
         aATunldktYytUhk2I6USnm37ywGJkeS4fb4CNc02qNY9unjHERXSyMHjmuIVPzyEeImF
         fE05KhhlQR5vES6J1dbNuGkjew6N25apk5imNLZcp44p3YJ/RLQUjbPp0BaChN4QUYQ8
         2YsOkR5YcgjPur8ll1l28GOIQfUXjoXNicN8Zwh2D2z6bHaMZKAzg4Xmz9oplh8h4DVD
         YrTg==
X-Gm-Message-State: AJIora/NEYAwYwySqd0aBQZPx2FPHEiePRtnVUTgpbo1460MyC39aQwO
        eMVNE7uV4obdM/7DHMFn/BgjYA==
X-Google-Smtp-Source: AGRyM1s2oQBCaEnNr3OBe9rDORvEdR2sDiB5OOWkRvQ5aU69AT/EctYaJYARM1BSFTuPGf6cTjOvow==
X-Received: by 2002:ac2:5ec9:0:b0:481:16ae:5a55 with SMTP id d9-20020ac25ec9000000b0048116ae5a55mr20001113lfq.678.1656947215789;
        Mon, 04 Jul 2022 08:06:55 -0700 (PDT)
Received: from [192.168.16.142] (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id y9-20020ac24e69000000b0047f647414efsm5173735lfs.190.2022.07.04.08.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 08:06:55 -0700 (PDT)
Message-ID: <612195b5-aca0-2902-66f8-7d9a4f33c4dd@kvaser.com>
Date:   Mon, 4 Jul 2022 17:07:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 0/3] can: kvaser_usb: CAN clock frequency regression
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
References: <20220603083820.800246-1-extja@kvaser.com>
 <20220704130742.aeczqfbfnwemb7ax@pengutronix.de>
From:   Jimmy Assarsson <extja@kvaser.com>
In-Reply-To: <20220704130742.aeczqfbfnwemb7ax@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/4/22 15:07, Marc Kleine-Budde wrote:
> On 03.06.2022 10:38:17, Jimmy Assarsson wrote:
>> When fixing the CAN clock frequency,
>> fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device"),
>> I introduced a regression.
>>
>> For Leaf devices based on M32C, the firmware expects bittiming parameters
>> calculated for 16MHz clock. Regardless of the actual clock frequency.
>>
>> This regression affects M32C based Leaf devices with non-16MHz clock.
>>
>> Also correct the bittiming constants in kvaser_usb_leaf.c, where the limits
>> are different depending on which firmware/device being used.
>>
>> Once merged to mainline, I'll backport these fixes for the stable kernels.
> 
> Added to linux-can/testing. I had to move the kvaser_usb_driver_info
> into kvaser_usb_core.c and the keep struct can_bittiming_const
> kvaser_usb_flexc_bittiming_const in kvaser_usb_hydra.c as structs in
> header files cause defined but not used warnings on some platforms.

Ok. Thanks Marc!
