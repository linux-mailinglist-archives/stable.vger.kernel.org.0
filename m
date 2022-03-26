Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9084E80C1
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 13:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiCZMUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiCZMUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 08:20:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B53267FBC;
        Sat, 26 Mar 2022 05:19:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j8so582954pll.11;
        Sat, 26 Mar 2022 05:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j8I12NKE7GCwX8ETG3CanhqtlnJT2sKn53KmOxi+4XY=;
        b=bSZJch7t2yV7xvunKHliffwHi0kgRM4RBdIHp0/YuigY3ucme/UBMr3lglwkLFgyGf
         BtcqoOXdOeL33hSUooLhnEqM1Z3+T+SSl2iVA8Yno6997S7IX7DGoPcvD1ILGPf4cvSq
         ZC0HHjVRpvUEbu2olU0mDY78cFc59lcJ1L5ezPPHWOwVGcfo4I2oo+2DMCgheYB8S660
         uDVY2HW4Ux6GTJGdNACAnyng/RsB1EthurHnfvJo8cKn95vknAIoJmlFVaThcfIvZebn
         kvbq/nv77Q6D2IWwiSMJWeqsBdUdDnKlRM21AMNaKP6YJi+/TrWZWV2yzo7WRHMCw9d+
         CTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j8I12NKE7GCwX8ETG3CanhqtlnJT2sKn53KmOxi+4XY=;
        b=3MditiNyfaT8uC5Yfgu/pq01sK+b15cVQ/mKhzhjV0BHiSK/SmpZ9Wl8Y9oxv2FQoy
         waDMO4mjrPhKl+PphTHs4HMLgQ0Hso/LWZTgMWFQuIp43vglwGMFZlDL+1FYgnZ0Z/zE
         HDOuxzj9uaU6UNUTfGXLlA7tvBQqzt7BHGC49h5OF5VBjTK2wLyI6jE3Weg/oiywbpOE
         jDvhqqtxi9CpfyJo32brLc85yfGe5X1Va/kpLaBog8l/NAdkt7ssC+5gsq1EZT8wqIHm
         jojmnA3FNykKWM8gbjGGVLwQz9pihLqD51UxLvb+bGrYNHJ88sVFBppbNlW5VE+UeR20
         sEIA==
X-Gm-Message-State: AOAM530zAfXzOWBIK4Xnrodo1lFtgx9EVAs5PKT0czY5IJ+CvnX2XBw0
        tsL6HgTylaWaK7KTsFBmq7c=
X-Google-Smtp-Source: ABdhPJzFrGoZVEDskdXJHd55VGwfJbiTBCtGCwWHMCIEHMdZRvA6boe5ySvpR2OV+C+Zc1+EXPhJhg==
X-Received: by 2002:a17:902:c948:b0:154:1e4f:9837 with SMTP id i8-20020a170902c94800b001541e4f9837mr16391540pla.115.1648297157221;
        Sat, 26 Mar 2022 05:19:17 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-24.three.co.id. [180.214.233.24])
        by smtp.gmail.com with ESMTPSA id a11-20020a056a000c8b00b004fade889fb3sm10805098pfv.18.2022.03.26.05.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 05:19:16 -0700 (PDT)
Message-ID: <b584a068-e0bd-bf61-a622-6b081a4a30a5@gmail.com>
Date:   Sat, 26 Mar 2022 19:19:11 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220325150420.245733653@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/03/22 22.14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.1 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
