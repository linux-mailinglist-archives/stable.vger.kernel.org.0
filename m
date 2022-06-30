Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4746560F37
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 04:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiF3CbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 22:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiF3CbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 22:31:15 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54DE2CDDE;
        Wed, 29 Jun 2022 19:31:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x138so14117458pfc.3;
        Wed, 29 Jun 2022 19:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u3R4IHZ6VBq/kuSImjbbeAhpWYp+1DcaA+WpCIvs64s=;
        b=CwgNoSx6IgQ5ODpGlvbpdXRCFZh94rMWGzZu9W2Vcy/u3UXazNuEmg7H0JWKCXBTl3
         7t5k2QfOO+Z+ex+TQRIit1z1tNrPaEhWceaUBxl2g1MaiVDsTmJB+xhAyrGQrHfXSN5e
         hV5hZPKrNxBQSdUyi0hTh7H6zYjtBYJ2JTQVhNOdTvTHr31HnHi9S8wdxzG7wFwBYnT1
         eBcPna1MXIoLi/G/WMGR4KIkQBVnl70jTNsdiOF5n+OCI3kBBVP4BWu2Nz0K/iCnxkTx
         ex+rtO2TNUarl54Oae9M+R8Fil4GTQ0mwJkGrsjkFc1g6coBIIqWGL4pCpwOqWnRrXI9
         ibQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u3R4IHZ6VBq/kuSImjbbeAhpWYp+1DcaA+WpCIvs64s=;
        b=L24KQXm8H3fPYwK+kilZh1crGeMwtNqd2ZCS7r+lkli3aRNIi0P73XWyOmAbp/xTFy
         TE73WHyQg/lZW59w+kCpRc6mP3yfu5B6yNtEm4+wZpxts6b6dsStDGIUYI2LygoHKB0Z
         04LHf6cwLnuhbzMWaihzZYTSF7rHeWiYfUdqtzHv9mRls/nwGQeCCUTRqY2JxfKD0sp5
         +NHu/7mE67aHWQfKIwCfLhdqG5rNEtOXccfNYyhqw9AXmdSc6hmzX79JgBt5q3Eo1Dc6
         d9TVT5AdrVptcg5qYgI/KZALZtSxh0ySnIc459pLV/+q+SpAvVyeiJUvjlL6hd/4L4NB
         AyMg==
X-Gm-Message-State: AJIora+EDIk0t1DgwBEiQCZ8Jx+OqFmApw4pi0Q7aY50w0/BEBQvAZuW
        Gd0dI74/rMPPdqK4H9FwbBeQEavSNwE=
X-Google-Smtp-Source: AGRyM1vclCAYocqHc2zY+JXqM+Oz0jj1IzHqOVYYCaUeXcbIW96r+F7HszcB/332U4Qnd75+TXSK1w==
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id v8-20020a655688000000b003c21015988emr5502600pgs.280.1656556274266;
        Wed, 29 Jun 2022 19:31:14 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 84-20020a621757000000b00524e8e48156sm12604707pfx.142.2022.06.29.19.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 19:31:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4bafbfe7-1a9e-651e-41c1-76a131c1a477@roeck-us.net>
Date:   Wed, 29 Jun 2022 19:31:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19 v1 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Content-Language: en-US
To:     William McVicker <willmcvicker@google.com>
Cc:     stable@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        kernel-team@android.com, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20220629225843.332453-1-willmcvicker@google.com>
 <20220629225843.332453-2-willmcvicker@google.com>
 <d4a85598-af50-541a-9632-8d0343e8082d@roeck-us.net>
 <YrzdyUm/xlJPldwP@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <YrzdyUm/xlJPldwP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/22 16:18, William McVicker wrote:
> On 06/29/2022, Guenter Roeck wrote:
>> On 6/29/22 15:58, Will McVicker wrote:
>>> From: Guenter Roeck <linux@roeck-us.net>
>>>
>>> [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
>>>
>>> The thermal subsystem registers a hwmon driver without providing
>>> chip or sysfs group information. This is for legacy reasons and
>>> would be difficult to change. At the same time, we want to enforce
>>> that chip information is provided when registering a hwmon device
>>> using hwmon_device_register_with_info(). To enable this, introduce
>>> a special API for use only by the thermal subsystem.
>>>
>>> Acked-by: Rafael J . Wysocki <rafael@kernel.org>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>
>> NACK. The patch introducing the problem needs to be reverted.
> 
> I'm fine with that as well. I've already verified that fixes the issue. I'll go
> ahead and send the revert.
> 

My understanding is that it is already queued up.

Guenter
