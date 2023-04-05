Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40826D85E7
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjDESYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 14:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbjDESYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 14:24:02 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8701E6A6B;
        Wed,  5 Apr 2023 11:24:00 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id c17-20020a4aa4d1000000b005418821052aso11003oom.6;
        Wed, 05 Apr 2023 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680719039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJJt5ZmLdmo6nA2ruRkOyJYK88J9AtGXuib+DBnV/oA=;
        b=P7Bb+8RT7KU4UzfZkFET2IFOp9hBT+o3Uk2zFF+uRu76XQbRQ/Sm1ndijsR3VJuE0g
         8iEL8wM6cgIEM71gfylJaujZfQKAVkVNe+dIQvaaPtsVGBx2ruhgIiSDnXzDaKvQILcI
         8W8nQXbXiEhXJxzqHa9OQ63tdPRiOEubb7w14hViW5p4T11/WW3nnQ7nsCYa8SLidHMj
         BI28zm5MwhvzPr4XjGQLeHi7VDSTNHBSFjLmXtSlrDtJL6I4Z/nOctJ0Rv0Ee8GnXPap
         atm0HkUa14BVWDEN9JDUBeeJixynE3LQzbk4mITdkY9BnIE4+5vULdYP8xMxQbxPOmf+
         9tCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680719039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJJt5ZmLdmo6nA2ruRkOyJYK88J9AtGXuib+DBnV/oA=;
        b=LURJ9ZdGnJ5yvJOLhgUnc8rcmbzfs2gTwIwtmHRPridonc1pEHfE1n8LhgpEKW2MqF
         pghajTBvIZcOay+15YlwrQJCSKEZYcpA/ZEbY1HXyQxqP7RPS05A7rvJev1ykKoWORK1
         m22roCWv8GhKn0wvbFlTWDaaBPCFLpERVBz/A9uifOa70zdFzufHEZanMKcP+/w221Ku
         GM3M/breontNb2LJKZkq1rUW7K3sV8AgZE0ItkqNClAJyhvmpIpx5SJ/L5M6WjuzpQda
         zET7WMECe/dk9ChhpUNwGV1b9iCaofHmaD4PJyCxWsOfVVxuMV2Ml+FiCo+5p9ML8GvG
         L8wg==
X-Gm-Message-State: AAQBX9dkRPh63lAlrQDiJ6bZSNNMY99DupuQTniCWD2xEHh2Z+skhJrc
        pHwBgiznzMzcnL7FcsLAMHPjQA1GWj0=
X-Google-Smtp-Source: AKy350aSmjHUdkgQEa8IbniOopA8vMgCr5Kz2tSuUlmEfeFvdo3tWWPv2KiEWTZHsbyGG0v8wKyuZQ==
X-Received: by 2002:a4a:4f03:0:b0:53b:51b6:3b43 with SMTP id c3-20020a4a4f03000000b0053b51b63b43mr3133411oob.9.1680719039577;
        Wed, 05 Apr 2023 11:23:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i185-20020aca3bc2000000b003848dbe505fsm6605353oia.57.2023.04.05.11.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:23:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 Apr 2023 11:23:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <d5f456e9-bcfa-42bc-be3c-56ae454990f6@roeck-us.net>
References: <20230405100302.540890806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
