Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D565228C1
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiEKBL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbiEKBLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:11:46 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CD112F1FB;
        Tue, 10 May 2022 18:11:45 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id c19-20020a4a3813000000b0035ea4a3b97eso561336ooa.12;
        Tue, 10 May 2022 18:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v2Kzs5oXrEeWuv01gGc7CQlZr3Ci3J0pblVw+GVutdA=;
        b=UyeWvM47E9XmgjDJgUlwD0zxYdbxTQZipWJVwjk+tBJfl/BPHZbt2shRtS3t6UxZVc
         Jv9SMIyMV3TcXuIslfw8/Jh4xOwJB7Dglpzf31JPzISEjb1Xd5xob0ophaTTGUclsGmU
         G41EMd3Z7KAmvkpGSfb8gm3bY39Q5H3BfJD/3MM0bSYcq7lE182vGOn/Efb54PScRf0r
         TpvUQ8hCeBDyMwxranwF13VW6VmAHJxxhbwzEAuF4Y/f6eFZixBINZF2xs+NpjUsdzbY
         NPj0Es2dXz8Ft5zNFi9nvIRJUFn1gEKG763VyJFJRLDQ18KcC/fT6ER/Rx+cPBl4lNN6
         kOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=v2Kzs5oXrEeWuv01gGc7CQlZr3Ci3J0pblVw+GVutdA=;
        b=GraKcSnCFSV3AR6GtEZ+3ca2DvTfsEsHLrd98OET3U1WzCkjY6FVhJvDf+sKw7JJrS
         O/o/lbJ8Pa5MJBP1WkMmH2Y3NBZAnyi4ZxK31q2CUXnFSwAPXedx/7sp0YHUK+hLqROA
         yaYlyBE7lI3js+MFpD1tRjjIkbXM/xLrKtg0pi7+D10GDoM+7c/Kv+nakrQ8AL2bM/KZ
         72r1vSu0vWVoh+0hAfrJQ3zk0rnqA2V/PKkZmTlV/Bp+c4pN7Usm9u3pak7luMzDu4nW
         LZZp4y36lLNSn88x9J3S9U9R+tbKF3S0wj8yQB7ANbGrHDRV+ZuJPl5F2MB4p6nrGisD
         R9kw==
X-Gm-Message-State: AOAM5312LTHstUrn0qCBYfCJl7Sp010c9t1HIfIhqWvT124NRfSREnF4
        jbxgwMt0KtqngjfJ0mBPFQU=
X-Google-Smtp-Source: ABdhPJx7myB8sNv5n3V2ns25yKtkRFM/1CdziP6zr8TaO4Gjib6XeIfxRcxoNGCxRy0ort58g/MCJw==
X-Received: by 2002:a4a:ad0a:0:b0:35e:79da:30c7 with SMTP id r10-20020a4aad0a000000b0035e79da30c7mr8860030oon.53.1652231504399;
        Tue, 10 May 2022 18:11:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z61-20020a9d24c3000000b00606765d8db2sm272431ota.77.2022.05.10.18.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:11:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:11:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/52] 5.4.193-rc1 review
Message-ID: <20220511011141.GD2315160@roeck-us.net>
References: <20220510130729.852544477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 03:07:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.193 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
