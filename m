Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73EE50608E
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbiDSAJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237754AbiDSAIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:08:55 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4E1181;
        Mon, 18 Apr 2022 17:05:42 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-de3eda6b5dso15890966fac.0;
        Mon, 18 Apr 2022 17:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QC7Wg5kDfhYoq0OxJrWjmW32qZnaEi3hPhmbfyCSKd8=;
        b=a8M/lW5CZb30LNbtSRXYHv7cKLrpwXiYUaqOEk79EvcPyOPuQaEDaDsIcWIhczdFyJ
         Z873mxJErJniv6Dv8ipWCViCKFYPNdIu9ml7Oj1J2jVU0p+doivnABcDnsfUyBq79u8D
         pYJe/BA7Pao24dGwN02TR2ckQMej8VsSR6Yg8dyiKcPacvyYGfIF6nG9pokZzDqAggC9
         +0qJ1fGv1NSKLXoLkvH9WVoEgYDA4BLs3yG8ApUU8qEKUfXhCKThwO68XAOhNs3gvw+h
         hqIJltRu2PG5d2LX3F0akwOQCpiqJrzaJb1purDSSxEf571r+USy0/lTk4ikektUkij4
         Xw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QC7Wg5kDfhYoq0OxJrWjmW32qZnaEi3hPhmbfyCSKd8=;
        b=ciBZI9aP7Z9HmGSUeQCmp17dTl0+HDHVtCQK/BzvP0bh9JJFj9Vc2LxFz6yuUSWVxy
         Wc7jI4FivZaVtPHbI4oZOQC7CRDafgB9hcD05fjCTfbzKLOy2vfxBiqUmFuRbJrElymp
         cman8gzLJz05MDxATdahSlxa3O/ujbP43yKaO/IxaOsPYOwdObys/3suy27Z9AUcQRRF
         iS1wd5zldOtK5Zogvwv1FngDhVd/sN+gYA1zWFNHb3bhZIz9EgX9AQID7VQBvUbGMvfL
         15a1148Sq5vNAW2iM8bB7S59sutKtjBPHJQ7hC9WuEK8A3aZefKfy737k4ivxKJNavKE
         zgxg==
X-Gm-Message-State: AOAM533M2RZ+dlasxCIV2qc2db5jwCS1B/Lqu4Xb71hWYUncBVYhVuDh
        YnTXLvlsTHyJxu+Jf0aBYbjspnQQxFo=
X-Google-Smtp-Source: ABdhPJxijHJXgZhNNNA/FAWD5dZ6oD0TJfmxoZPzbylB7jcvdlacu3OT0hC3vsi4DCdubGH71iIZ0Q==
X-Received: by 2002:a05:6870:d192:b0:de:691:81ad with SMTP id a18-20020a056870d19200b000de069181admr7215795oac.165.1650326732373;
        Mon, 18 Apr 2022 17:05:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id lw19-20020a0568708e1300b000e2f7602666sm4519558oab.15.2022.04.18.17.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:05:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:05:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/63] 5.4.190-rc1 review
Message-ID: <20220419000530.GD1369577@roeck-us.net>
References: <20220418121134.149115109@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:12:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.190 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
