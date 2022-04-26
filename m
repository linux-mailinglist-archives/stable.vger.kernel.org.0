Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B91510A0A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354769AbiDZUQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345270AbiDZUQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:16:55 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E881869D2;
        Tue, 26 Apr 2022 13:13:44 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id v65so17235322oig.10;
        Tue, 26 Apr 2022 13:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfj8yt9SaHGtr1I7+PHWn6ge5yJ++afR13dewFjSwX0=;
        b=gPhCzSMDWb9BhK7A7JUaFKCqq6v4eNevPADRtSlZ3AzCci6R0XRfzmdqDQ4w0O32NG
         FZ0DLPK6xBRuizSlummZwvOgPS5wevzGwFdAjv4j5YK2tIrpUzptpkxNg02Styuy8vy2
         qbI66lgckDk1msKV11tp2GgWbCyj4XzI8aRSdAzITRzdUC7YdMVP/DWb9W/fYkKFTWHQ
         RzmVn0zEm213YtTgYQbdmf6a1yTzJErSralQ8DtmhyGoqttK8iKIOjlPDTP4btsIXOS/
         tpRNqa+7oN5pwKKVMj3s+6Vymr6Y/FEPV4VhYGKT2FqTKYkrFhWbepEpEobCtdk2gN78
         pA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vfj8yt9SaHGtr1I7+PHWn6ge5yJ++afR13dewFjSwX0=;
        b=xyG7epoI46tjrJp6l7595guzZWN6GHlt88LBwew2GOq/L++qAcDQsqt4UIYZ5R/dwa
         VPpBcKScMZrKSNf66a5t5kIEAhD/7Nu+FWd3Y8813UhClhDDo15PiN+oVe5ZLTEUN6LI
         nci63XgoXTF8hJFFPhhJwqSEMrz4X4rwsgj8ykxSb5RwmeF5mJHUN0f1jzgsq+I5QBJ7
         IBgiKVuLSfGmQxY57iVdCvBPKLT5FpJSHJAd1aP7EMIYkgkZq0GLb7iVfkqfQ41ktWW7
         Kn0WWItatjcFesPIfMA8itpECVo250WfJJNZvpbhnj5SKkoENBmFtXUdrGpRWOH2Hyrb
         THkw==
X-Gm-Message-State: AOAM5306ox3LSLTCAzk+cLMWZkMm2niVttzl9z8zulVlbhGoM4XVDXfS
        Ug5SWsekM/9OGg7qAD2eQ3zNPe2NC+Y=
X-Google-Smtp-Source: ABdhPJy1DwqwromJHPQkXTxvFWAyhOUgILKOd2lJTDREs5ax3Yk5fxQnnyO5IT5qp9rfhBfu3Ymusw==
X-Received: by 2002:a05:6808:1895:b0:325:66bd:9285 with SMTP id bi21-20020a056808189500b0032566bd9285mr1656139oib.286.1651004023789;
        Tue, 26 Apr 2022 13:13:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q4-20020a4a3004000000b0035e974ec923sm257046oof.2.2022.04.26.13.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:13:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:13:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
Message-ID: <20220426201341.GG4093517@roeck-us.net>
References: <20220426081750.051179617@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:19:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
