Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFAB6E2F7C
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDOHhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 03:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOHhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 03:37:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBEF4227;
        Sat, 15 Apr 2023 00:37:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b67a26069so457440b3a.0;
        Sat, 15 Apr 2023 00:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681544247; x=1684136247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fLN+c02TASIAiZAxTjvtJhCNuPlByu12AChb+JeIKgo=;
        b=HnEFBD24or9NNXSEt05PV2b2lWA1xu3zDts7mAT3tCpmXelaa3JTswPt0XvCmkdFJM
         G2MtiSJF5WGfd5nAWBh4IDrRzlh3FBYCf7/B2i2m/bZYZXoiteppvRnrprG3a1MNu5lt
         fNi8l/fmzNPz3QpTRahstHbYzFqRtnAaM9F+oBWMaN6RFX0BTunZg7aTZ+4RZ2fHeV7k
         Be0FiJb8da0U3tYPDU/ApCGmSHhV+I85vJoX/oT+fv5kgvHBio2EC5guoEdMHLvR7txX
         KX/1ukvXbH1AKf9Vp+q7a+h3bvRZ+SgmJgZUrzAPgk5nIvyQk56B+rmxrzpEeCe1fsH4
         ppcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681544247; x=1684136247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fLN+c02TASIAiZAxTjvtJhCNuPlByu12AChb+JeIKgo=;
        b=jox5q4zta8Gm005X2D+dYyLuj2SChC6F8buE1a6nw21UslZ5KepfTjgd7GucduSVV2
         XUub/QgTZqXpzA50ihBHXhjwS3Ph9chHww341wMRsO+1bKnP+5a6XMgtv0C5ehzvu5Wo
         7sUzIgY91CpPN9wUai1wPyRPKpl3M1rSmIqGfMHErbiZHT3NdpDmV7R/Ld7zCfykorbm
         +rA4hbEkMyPPFJ5BZUWcslzOXH6ggh+9deifvxO0UHSieHAjm9DOoD0JL4R/bLzx1bz1
         gLIDliThgsJSnmmGLp7I9Uf7uf57+HMgIx79ErO0MswQ27UUKCI1a9+k320fTfOdoiGo
         e2oA==
X-Gm-Message-State: AAQBX9dK87hQcsucvPcvQ4VpHJgNxZWMsrH9Q3P5xfre5Qnl0mOFThP/
        gDRcc10hTr7rSP2Xt7H7ks4E+9f68uijpQ==
X-Google-Smtp-Source: AKy350agWvuQm7leUafw+gUduLmt/CoJ227PsKwb7+H43BCO7VOSJPw3Ppo3hea+qUunX+4bj+sOIg==
X-Received: by 2002:a05:6a00:248a:b0:63b:64a6:570 with SMTP id c10-20020a056a00248a00b0063b64a60570mr6497037pfv.26.1681544246931;
        Sat, 15 Apr 2023 00:37:26 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-70.three.co.id. [180.214.233.70])
        by smtp.gmail.com with ESMTPSA id i26-20020aa787da000000b00636caef0714sm4245137pfo.144.2023.04.15.00.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 00:37:26 -0700 (PDT)
Message-ID: <ca1aecf9-241a-6623-69cc-12d08bd61c80@gmail.com>
Date:   Sat, 15 Apr 2023 14:37:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
To:     Acid Bong <acidbong@tilde.cafe>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     stable@vger.kernel.org, linux-acpi@vger.kernel.org
References: <CRVU11I7JJWF.367PSO4YAQQEI@bong>
 <5f445dab-a152-bcaa-4462-1665998c3e2e@gmail.com>
 <b2edf1ed-2777-03ef-4d5e-e355a6074f78@leemhuis.info>
 <CRWCUOAB4JKZ.3EKQN1TFFMVQL@bong>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CRWCUOAB4JKZ.3EKQN1TFFMVQL@bong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/23 16:07, Acid Bong wrote:
>> Thorsten
>> why do you pass pci=nomsi
> It's a workaround for another issue i've been facing for about 2 or 3
> years, since when I first tried out Linux (started with loading Kubuntu
> and Mint live images). Without that workaround Kubuntu didn't boot for
> me - on kernel 5.8 it only reached the graphic installer part, but hung
> after language selection menu, on 5.4 and 5.11 - didn't even reach the
> graphic session. With Mint it was more severe - the screen was flooded
> with PCIe errors, like so:
> 
> 	Apr 10 18:47:08 bong last message buffered 3 times
> 	Apr 10 18:47:08 bong kernel: pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask

Hardware issue? Or is this another kernel issue? If it is the latter,
file separate report (see Documentation/admin-guide/reporting-issues.rst
for how to report kernel issues).

-- 
An old man doll... just what I always wanted! - Clara

