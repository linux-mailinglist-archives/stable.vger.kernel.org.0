Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E084B174E
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 21:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344434AbiBJU6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 15:58:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344411AbiBJU6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 15:58:51 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F4710C1;
        Thu, 10 Feb 2022 12:58:51 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id u3so7310977oiv.12;
        Thu, 10 Feb 2022 12:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+InDr92pv4KmMwevg5OzWT1Epn72izX1Xx7aDp0UWTE=;
        b=KYT2zzdKiHY4g72XiG5lxq+RBdhBguGH7a2uWOIgH9jFiGzTA3M9WwPOGukGjQ7ofv
         2gB5d0wylEMOqaqYReW+PqEbMGb/Wkxy36c2UxQZbHhT2Yi1VVGUxutcBjh2pE0Lk5vm
         IPqpIwY7q0iJjpNaNHHqsMzDSu2odEpsLA7CNj/FI+uUFXlOxshTD/1bTNYhMeEfuxSj
         5K/NLmOJ3/14K3N8Ti6d99dl2LSdZmwzvxupKh9yGpIN35+wSSrkx37vr4klyEjcXQii
         yvSZKT+dw5yvePrYte1OMqAbUVhTtWBEs5u6r1LU1VBIhI0s+edz9y5CLlrboOgcZ8Fa
         /HfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+InDr92pv4KmMwevg5OzWT1Epn72izX1Xx7aDp0UWTE=;
        b=Qa3GyTKGPvSPoXStUBw9Cq+vT5igPogbkX4OPimv1LvNXxS577S1NJ16g83/ViqDvj
         PgW71/moaIFm/YtR2lo2GqqojR6TketRZWB6ZQGnBT6NcGbTTdV9AMLlSkhYjr8eqW9m
         50uoyk91fnDYFv0KvSl9+oqv4iZ/k9TCrtkbp/f/TICV+2R3pHoBzNryI5R2ZdkwbpDH
         oYmQcLvpANhgZclsmJA1gr3FH633SZQl8kE+2W1vA4m3uXly3kPwJqDzw4pKi9LSaqpZ
         tsW1X2dF6rSABX+0iOVdiPkS7mmiuBkSrtWLVmYZrbv+xpkRqFgdm9qYeC/LH/3UdtaW
         j+oA==
X-Gm-Message-State: AOAM531MwHAm+NKI9C0WKsJ/OPNz5oVozBjZl7Td401e+Zw/Kn4E5m4T
        cYwdEPtRUHHHr1TSP8uae4A=
X-Google-Smtp-Source: ABdhPJwaK8is7zBBTzxJogCPj02X5ZjWnlCGQHtjzeHN+0p+pfycQ3eG51gMeLLcbeCV6B06ErMs/Q==
X-Received: by 2002:a05:6808:195:: with SMTP id w21mr1927519oic.88.1644526730586;
        Thu, 10 Feb 2022 12:58:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7sm3162997oiv.8.2022.02.10.12.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 12:58:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 12:58:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 0/2] 4.9.301-rc1 review
Message-ID: <20220210205848.GA2963295@roeck-us.net>
References: <20220209191247.830371456@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191247.830371456@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:13:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.301 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
