Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A053363FDC5
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 02:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLBBn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 20:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiLBBn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 20:43:56 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA09CD79D;
        Thu,  1 Dec 2022 17:43:55 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-142306beb9aso4166088fac.11;
        Thu, 01 Dec 2022 17:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EDAw+k7/ZK1+ApeJfLb7KmbDjE8+VFTywcK2NeWnPYs=;
        b=l3VU1hWeYUqaYSxqmFL7JLE214mr/ZCBJI7yMMK1Zv98TbfYXLpMuuAMOTJzl51nvQ
         HcV+Oj1QdjfAZrei5nTpZi1bEvKDKmZ+v8zPnq1FN1pZOs2gS09NDmYgIxT78JqPVl7U
         uUPAOLP3PhGX0XLAOknASuS6JPApRYJaoKe/FAL0mR+DsnL8FaihfgJAdjRtbE9BDaE7
         sf52IFDVpcuPFKVFFv11wOWBabMsagaLjD8mPV1V2wHlTaVFyEClQoXJpUybGuXSksOB
         OPw+OpVN6NS0oPHTPN2kM55gqXEznUSZTE4tAv1ngDAXekhU7OP//yOWepftBOSOg96A
         lFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDAw+k7/ZK1+ApeJfLb7KmbDjE8+VFTywcK2NeWnPYs=;
        b=R+wItm8bkNPDx/d2LfsLZhkPCecIG6r+NyJ+SH6tx6Y2aY7Uoqo0nVYF02XYvqCCye
         FV/l3MPbE+VuHmCr+sstrj1GM2NRHWdvHcgH1RMc6PAzZxdu1kZ/ERa6gqlLsCfPesl+
         M2+LD/KALbxT/JkWnj/O1QoRVHyFaVetAyz6iTiky1qk/gLOP1c8ah5ahr7vQkmBlBbB
         QOe+NjZJeAHO2emDyxZtGoQH8u1yHPt14MrBckm/zOeKIKhIo1yomR6A9BiuNqZRWp1h
         ZxtMpHK9MErFwpu25YiuuVPYKorzKZcXR0DPGlS/uKB6yzCVs7HOec+2/nZQ3lR4iGB4
         QsLw==
X-Gm-Message-State: ANoB5pndcIjOHLg34R0PSgwj6QW3iYTaKVxq5nvn18h9gBB3ZMVUIxGD
        LR1QysTmKykqUgKfrs9VcKurWaBSPyA=
X-Google-Smtp-Source: AA0mqf6U9hus+hGon+eWJAZLXnx15a4jf8LkIA7TcNeEwiaFyxshHup8CZbdMB92acViWUaT88Lzwg==
X-Received: by 2002:a05:6870:d1cd:b0:143:75da:a5b with SMTP id b13-20020a056870d1cd00b0014375da0a5bmr19439027oac.74.1669945435247;
        Thu, 01 Dec 2022 17:43:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cy23-20020a056830699700b006391adb6034sm2816308otb.72.2022.12.01.17.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 17:43:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 1 Dec 2022 17:43:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Message-ID: <20221202014353.GA2255418@roeck-us.net>
References: <20221201131113.897261583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 02:11:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Dec 2022 13:10:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
