Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE56ED98F
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjDYBGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjDYBGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:06:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D806BB46B;
        Mon, 24 Apr 2023 18:06:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a5197f00e9so41891805ad.1;
        Mon, 24 Apr 2023 18:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384785; x=1684976785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PYhIC8A+vRfUJbG7J9IK58OOiMWwt612eKQj0CGvYsE=;
        b=AhIfh2vRTxbdcNlULkTq+MtVq9+aCn6vCpFkd+UC/3lyXkhZ/7BsxMJtm4wg1wXnBM
         MeGj0mC+la761xK8jv46LY4Cw58Nk6ch2ZjI3VN9Hcl2iuoP4X4KpbmjwztWshPpu6Tc
         qMtlLQqGNh2AFzyxvxUYPNTGb+EoV9gxw7FdUS/LaJ+5r5gSIYXwf+VqwpflAQ+fJnBt
         VSVuSfoZRnm052HUcC8QsApZT2Mll8yiqktm9gKDGzEBEZ4Z/kF+J5Kgjb7xH1/1PHU2
         mrh+324zPnkHDOLGdE5HRg3RXMLtq57XRGp6SH/U2BAC5B0R6HTu/Im/r/GVxeCCNRxl
         /PtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384785; x=1684976785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYhIC8A+vRfUJbG7J9IK58OOiMWwt612eKQj0CGvYsE=;
        b=E8MbTrip1LD9FATiKrfUII8C7Fnwg+tG9PwDu/IVmia1TY7E50+crsNoeUYLa6L02e
         0+gm1RhEcNUpOLGtWMFxDVoqOx3IjthH+DoR7IxlwBdcQ+w4TJn9ayBq9JorVBsxPWMv
         JjXODvMvuNi0n1MDSOXiWM8GViQprNGJDawrB+6OfjWQcGY0M7UAgtbpDkT6tBFL1VX6
         cNIiVpXbvHfW99nv+ZYrn0DJpjepHmFi2kEih0+lDvv8O7bfabT8SixPNSkO3YMONkYj
         t7nlRLZCmOWYGZtREdWiHT+x/FHIhfF4zzVtJlD0PHhbz3bHi1jEEHt8sMNB4yDS0Pl4
         8GDQ==
X-Gm-Message-State: AAQBX9c29llOZ0qRSc9cnGNgNpW9Tn97Z8L4bnqVPP+KHFTDKBPXnz6/
        /PtQPoZMxRy1v9YkrvWmx7E=
X-Google-Smtp-Source: AKy350bDvpzKjx6oGE6qZx5ODWTxaHM6zDKZDQyIq0AfDg6HnOMkjf2HeoIR4Bd4uCC7TS+K6uobww==
X-Received: by 2002:a17:902:ce8f:b0:1a9:7262:fe55 with SMTP id f15-20020a170902ce8f00b001a97262fe55mr8380140plg.13.1682384784799;
        Mon, 24 Apr 2023 18:06:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902bc4c00b001a647709864sm7082421plz.155.2023.04.24.18.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:06:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:06:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <f449f442-c16f-417d-a637-7ed02bf69cd9@roeck-us.net>
References: <20230424131136.142490414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
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

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
