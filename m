Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F68865540C
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 20:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiLWTva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 14:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiLWTv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 14:51:29 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1A2E031
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 11:51:27 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c34so1726297edf.0
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 11:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U1O5nw6K8QchpZNcUvDN6FRF4+x+KncDJQ5gRZIMULk=;
        b=f0R6scQzva0Lc5Nij+dIpVsNMGkuHZitAu68/ZTGWVwtG9dK7eEq/lR5sX03hxpUBK
         aiuosAvd8bgvaakiVCqpa/xEwAbEnxgUMNpEZW/Uc62wTVFHwo7yYnkRgL9E4eoXciVr
         az3reSWyypjiwPNG6Q5rHtiAvWE1I6G5wIaYtWfbQNkQgsbtgputQSfWcCRNOB7unatu
         XyFriFSTn1GyRuWmsJ17mWEbxgJLlBd0iRFyZ+lkKr//kykOxZE1goEkO6mFsGVeg1jU
         e8F/w4CtP9CFGI/fpnkKXn7krcKjGbO3S93YPhAU/KYT9/p2bFRM4a8XYNTjlbUi8YLJ
         9PUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1O5nw6K8QchpZNcUvDN6FRF4+x+KncDJQ5gRZIMULk=;
        b=chSkG9BL9724wv/dxizOgdX8PiwhffsUOx3S5g3UVa9PQENPLQjAT403FnMKbzc17E
         gKzJ3jCXdv4eft3Vd9aMwMhdNcuyZ5UzVWIfwzdta3LwW1yTmas4nMOqqoMaE4Zpv1wj
         +HFPbZvyBoB0B+2rfmh3Sv1eBtxDYwNaSA6aValmpqpd53+GNO0WJ18riYVJ+q9A9sno
         zy/ZcyDzb9f88UCDC67P+xrUSHFo9KdTzsojC7otqAgeL0eJ/GIP8LibFMY+7Hs8iFCu
         bEY7yH1UbAHYiJQ/CMJTy3ItXrKunGudldICfohBfVzQ4RGK0ijryUVWWEGIsYfnbAFL
         BmcQ==
X-Gm-Message-State: AFqh2kpzZ9wAe3dxNG11kQAozGchhOHYbFaiUwi24QWs2YoBMjqpncX2
        G0FLq0KJUoguC1eiCEpvN54=
X-Google-Smtp-Source: AMrXdXvTTOAHURFaLB+VL6ZCUYIZHOsrVeJQwTnJaMU05LMJ5BaHp8TsJr5grUO7fwPYQcRwbMy+aQ==
X-Received: by 2002:aa7:ca54:0:b0:47f:4901:d46d with SMTP id j20-20020aa7ca54000000b0047f4901d46dmr6054589edt.41.1671825086464;
        Fri, 23 Dec 2022 11:51:26 -0800 (PST)
Received: from [192.168.10.127] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id y3-20020a056402134300b0047f5f5bb5fasm1788694edw.62.2022.12.23.11.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 11:51:25 -0800 (PST)
Message-ID: <38cd1c38-b469-f25d-369e-57877865fdbb@gmail.com>
Date:   Fri, 23 Dec 2022 20:51:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine)
 on haswell laptop
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
 <Y6W6Qxwq94y9QGFl@kroah.com>
Content-Language: en-US
From:   Sergio Callegari <sergio.callegari@gmail.com>
In-Reply-To: <Y6W6Qxwq94y9QGFl@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/12/2022 15:25, Greg KH wrote:
> Can you use 'git bisect' to find the offending commit?

Must learn a bit more about the distro I am using and what it requires 
for a custom kernel but I may try.

In the meantime, just to make sure I was not reporting an issue that had 
already been addressed, I installed the 6.1.1 kernel from arch linux.  
Same issue.

Forgot to mention that the lock is so bad that not even the Sysrq magic 
works.

Best,

Sergio

