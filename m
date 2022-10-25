Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA97D60C286
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJYEPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJYEP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:15:26 -0400
Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61E1BB3AF
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 21:15:25 -0700 (PDT)
Received: from localhost (001.mia.mailroute.net [127.0.0.1])
        by 001.mia.mailroute.net (Postfix) with ESMTP id 4MxJWc5GPrz2KY9r
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 04:15:24 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([199.89.3.4])
        by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id ZkKH2xaU5hnN for <stable@vger.kernel.org>;
        Tue, 25 Oct 2022 04:15:22 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 001.mia.mailroute.net (Postfix) with ESMTPS id 4MxJWZ3jR5z2KYG7
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 04:15:16 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso10732321qkp.21
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 21:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c3nNwn7B+vDVB4LoTNGFSIvITeraYXuhtI1oxA/6BUw=;
        b=q8augwiI4yff4OaXv3vBsgQa6pXKo7nwKqCs0r0E3KWBY04JFgNqQNVjjVAoJjQyIx
         XkDpuYX+dQueqeU51V+ntDLZHF2KASQQu4z/xCqn4OF7oBbbbTfKoR75fisnvW8xrQxw
         cx9GjV3eNd0f/54WwdsCPqBzm0V+s8G96Un0yGwDtyP+AGfS0uweaDiio1wQI4JLFRLR
         3Ejzo1txHKhjjkRG5cErkkt7Y5doLpg8e2/zojy9SfvOkgY4ZiUw7yHiRkPTvsVLX67Z
         G0ntF2+FX6k8FI+fo4ZJaUhHIQXp7hNxqm/11gv981lbn1p1dqWzyOoPpWyNkUy63MBA
         JBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c3nNwn7B+vDVB4LoTNGFSIvITeraYXuhtI1oxA/6BUw=;
        b=cPqtF2E1zoW8rXhUJKclEmypZzIty6To/n005O5usuFY07cTSX7JlWzwy3YCtT8DV0
         Ir+uBxd87OgCh55A6hmxx9IbDuzRF6axlVT4RGO48K2alSgykBYJ1rWhCwGXdGvVsD9y
         KzEc5Q7p6q4tdPNgsvZTd4YoQeCVmeLpdtx6MegyrsdZT873ooRUc0QvXtR8RYU3Tfal
         wFPcRJPWpTM+5RGU260o03sIlRKve7zUeu1h3866v4rYLhBBvb1PPaDf5BYiVSSyOfcp
         Rsr7Gdn8pvvrGvIIYP8Wd8j0O+EvYZb+ieYU6449rd7Dn90E4OieIn5Ig1N/EoW5sqfB
         pnkQ==
X-Gm-Message-State: ACrzQf2uXmLbSYeR6GXfj+Ra31/iRKtm34PLoYHbPuFhQpcLyByRCAuG
        wRLpEEuAVJaF+l+yzanYVqPIXBiTdqNbSE7K4lxSSys45pWmIZ7CJaAwg8p4tyPnuOMz1mlVUn2
        eCYPMh/2rxhXXAHutJL14BGxaUUwu9ds=
X-Received: by 2002:a05:6214:d0c:b0:4bb:8618:9565 with SMTP id 12-20020a0562140d0c00b004bb86189565mr3285622qvh.73.1666671316194;
        Mon, 24 Oct 2022 21:15:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4xxx1yKAVHQ8B4KWPBDwCVZ2J//R2PIu/Ebk3SYnlDQNP5EaU9Ezc71lWO1F50wLw7PPdVVg==
X-Received: by 2002:a05:6214:d0c:b0:4bb:8618:9565 with SMTP id 12-20020a0562140d0c00b004bb86189565mr3285611qvh.73.1666671315977;
        Mon, 24 Oct 2022 21:15:15 -0700 (PDT)
Received: from [192.168.1.39] (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id h6-20020a375306000000b006f3a20dccaesm1209020qkb.136.2022.10.24.21.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 21:15:15 -0700 (PDT)
Message-ID: <bb0be398-c894-b842-e804-7b2163afc41f@sladewatkins.net>
Date:   Tue, 25 Oct 2022 00:15:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/390] 5.10.150-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20221024113022.510008560@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.150 release.
> There are 390 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.

5.10.150-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,

-srw

