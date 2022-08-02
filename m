Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43785876A2
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 07:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiHBF14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 01:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiHBF14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 01:27:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D603C8DF;
        Mon,  1 Aug 2022 22:27:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso7286948pjf.5;
        Mon, 01 Aug 2022 22:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=Ql/7c4Gz1cX7T+2UxQonYqIyboX170WuqKH0laFZeLM=;
        b=oIIOL6+25YrpYtZ6//CXPrHoWjPUN+1HHYKzvVqbjD5F8CFMg8L3pf6Q2cvm1iYlt9
         FRSyWQ9LUsWZiZXLFiyGd9+GMcx2SvkjOXIhzgTJI7Xuamg510RM7I6JcaQpkkmLeMBv
         cNFm5zCYClae11Hbk0QVSHn4BtY8BWttlMvu6J7A4vvrwMjW5lXSv7IUWoVRZEn2fvDQ
         n/2+hI2wiIO5T6hupDADu8F9Ik9Ox6THoRRfyFGVukTY8fUfLbsr5z1qmnWktX7NiHfz
         Ct2Piu9KPUrDRsyWz4EAowBtZrkkfBRq6NYev3UzQH/w8DzgDwdyQGCX52NSnhzBJcI4
         X6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=Ql/7c4Gz1cX7T+2UxQonYqIyboX170WuqKH0laFZeLM=;
        b=ZDiA7eYNm/6OqVayiBb7RK5gi2SmffLlnEWsU2VO09dK8VJNKcjNykcD9z4D+xhxiF
         4WXnxlbrISKwd5vfI2h4arNFI71JPZiTW4e4IuUty056qlaHOueWIMGCQVu49V+VvNMy
         VR5Rq0sAv6EQNz7TMhIxOLQt9c0hZBJUUvTDxggtL8fIerpPo+l2Sb1NKLA+UAi/MGUH
         2NfV5DFtYSTtdqLq9G3Fp0b9aYUnrUL5RieyFGiul5tiYDbKn0347pQOUcK1vNnRDklR
         cy1CQsnjVZ1DMbbMJ94VFe+qZAwn5mclMXiLCCfiI4GoTCTjf7Mf5cWzzymhnTT0Zue3
         aTUg==
X-Gm-Message-State: ACgBeo1HD6niqnONudOwH88MhmxVfvSpIwz/DK/RnWqEvw3DbTsv9bgw
        jTUi6SytCCZ4lC4z2siwVEI=
X-Google-Smtp-Source: AA6agR584uZx68DfqcHqibHsGSXAdHPos1s61kj7E7BRtR5Vbf8c78Gi1fcwSMCUfXda3JFljAEPEw==
X-Received: by 2002:a17:902:eccc:b0:16e:f1c2:7963 with SMTP id a12-20020a170902eccc00b0016ef1c27963mr6723862plh.170.1659418074562;
        Mon, 01 Aug 2022 22:27:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id rv2-20020a17090b2c0200b001f280153b4dsm12761862pjb.47.2022.08.01.22.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 22:27:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Aug 2022 22:27:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/34] 5.4.209-rc1 review
Message-ID: <20220802052751.GA572977@roeck-us.net>
References: <20220801114128.025615151@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 01:46:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.209 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
