Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1FE590FB0
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 12:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiHLKus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 06:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHLKus (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 06:50:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521FC1EAD9
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 03:50:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y13so1334525ejp.13
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 03:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=fdVnuyVKIIbMwabbEm8iRAz/PbyHrbg7fLixbmQ3Sqs=;
        b=gsUTqdum9aR+srBEky+KDxCVtnjR7qbmrhD0oYq8hNM7TbTVAeybMNSVV+rcSTdzc8
         o1sbdFbTCipeP2nCNybJ2CbIkpR8Jyg+UDfxeGEsLyDJtujXmzTCXyXfN5H7SWzf5C7h
         unGHrOA47nOiUsnShOjIWjNu1QPwQyHoB+XLOlNm18iZchwBf1fWAZrB1X+1ralbpJHn
         xbAuy7T6S6fnLCBSFbCsYILLlU1G7tQ8ABY3PakozPebdTxpe40DEKh9bxoBlR/bsLEC
         AbJX3x0nH1jKOM5xHBtUHk8mjxyTX0bY4OSeYxsdilYtnSDHmRwjVHAy2Zhu1jLqq2ec
         mzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fdVnuyVKIIbMwabbEm8iRAz/PbyHrbg7fLixbmQ3Sqs=;
        b=jxddpa3f1yYvEgmvHhSoB6NYawk9c1hSgfOrQBMYJiBg6BCXwWcg0zC5A3XSAQXrO1
         WyIuzu7usEDIlGC7w8E/tljJWUF4HVpGlIXh9JczmOeAlj9kSPKuw/nPfj7Lbv+BN+7s
         wPxrSLn737b37UjN49QdAa9TlGEI14DjUJXBZpP0k1YfG9UeXwIq4dNVod+JcJZmgib9
         sY01fCP1v9R1ZPdDiHj4vXiZQTVXWeZTsOA7OI0lpwuAQFQsuM3gLOIkCR2VNx3i325i
         iRa8arpEAuij7JxGjtT9ilXu6byekbl/qLkvsjb15+q1c8AGlXQumRKCUyA0Ew9b2hs5
         91zg==
X-Gm-Message-State: ACgBeo2+YLh/YqzBdDNVCoCBzZpd+1PBS+PjLII6XM4H+khjvIfpHEZb
        4uFMMlCpHSvSZK2pvg/j/6JIN6OsWqw=
X-Google-Smtp-Source: AA6agR4J2HStpfCplAZDGpu51dJ1LeoiQapigTPcy68Yu7DqbMLlCIDMGzMeD85EwF2AWZF3ek3kMQ==
X-Received: by 2002:a17:907:160f:b0:731:55b2:1c1f with SMTP id hb15-20020a170907160f00b0073155b21c1fmr2316506ejc.731.1660301443716;
        Fri, 12 Aug 2022 03:50:43 -0700 (PDT)
Received: from ?IPV6:2003:f6:af06:6200:89ba:3e69:7b55:bcef? (p200300f6af06620089ba3e697b55bcef.dip0.t-ipconnect.de. [2003:f6:af06:6200:89ba:3e69:7b55:bcef])
        by smtp.gmail.com with ESMTPSA id ck26-20020a0564021c1a00b0043d7b19abd0sm1147210edb.39.2022.08.12.03.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 03:50:43 -0700 (PDT)
Message-ID: <da7d4c6f-0010-6f77-e64e-20f3ebfb57dd@gmail.com>
Date:   Fri, 12 Aug 2022 12:50:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 1/1] LSM: Initialize security_hook_heads upon
 registration.
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <20220811115340.137901-1-theflamefire89@gmail.com>
 <20220811115340.137901-2-theflamefire89@gmail.com>
 <YvTzZM499PnOTMZD@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YvTzZM499PnOTMZD@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.08.22 14:17, Greg KH wrote:
> As this fixes no bug or real issue that anyone is having with 4.9, why
> is this needed?

This makes it easier to maintain the kernel by removing error-prone code.
I mentioned this patch earlier and you seemed to be interested to at least
have a look at [1].
An example where this turns out to be useful is backporting the fix
for CVE-2021-39686 (see the ASB[2]). That relies on a new hook (see [3]) which
is much easier to add with the simplification done in this patch.
Without this patch the patch with the new hook applies cleanly but the kernel
then fails due to an uninitialized hook list head.
This doesn't apply to the upstream 4.x branches directly but only to the 
Android branches as Google seemingly backported some 5.x security features, e.g.
ec74136ded792 "binder: create node flag to request sender's security context"
 
> What devices and users would benefit from this that would need it for
> the next 5 months only before they move to 4.14.y?  And why aren't those
> users on 4.14.y already?

The 4.9.y branch is also used by the Civil Infrastructure Project (CIP) to maintain
a SLTS (Super Long Term Support) 4.4.y branch which is e.g. used by a community
maintaining alternative Android builds for devices no longer supported by their
vendors.
Given that there is a community extending the lifetime of the 4.4.y LTS branch it
is reasonable to assume that there are many other devices besides mine that still
use the 4.4.y branch and benefit from the change to 4.9.y which will then be backported
to 4.4.y by the CIP. And in extension one can assume that 4.9.y is and will be used
for some devices where moving to 4.14.y is not feasible due to e.g. proprietary
interfaces or simply the amount of work required to reapply all modifications
from e.g. Android/Google and different vendors to a newer kernel given that maintainers
of such devices are often very limited in resources and time.

Regards,
Alex

[1] https://lore.kernel.org/all/YsrKlIEV2ytKcWb8@kroah.com/
[2] https://source.android.com/security/bulletin/2022-03-01#kernel-components-05
[3] https://lore.kernel.org/all/20171026084055.25482-1-mjg59@google.com/
