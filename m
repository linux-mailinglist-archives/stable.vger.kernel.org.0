Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABB655A4E6
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiFXXeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiFXXea (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:34:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD620857B2;
        Fri, 24 Jun 2022 16:34:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q18so3302056pld.13;
        Fri, 24 Jun 2022 16:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RkQGvEn1/J57fLgaw04+bizgAVhySmUV40+u0IkiKek=;
        b=dfI1wxKP0f8KFIV849Oyu2TP+kFrA7/D2/hHeWn13chfZEog17VrmjRzAIxM+BA0d3
         iluEIMBUbww1y+ccsdxOAtOJ9Uwnzr1+kI1IJuRdL2tTz3jYSv9+s4ZyHhsNi2jBwTWP
         9Q4ilIOl7d27b6/4xc6yt8DrVYfqTA2qAGO2OIwZ+yDoF8dgbe04pbWmYxn97xpY5zoX
         EjhwvQ1YWyVoZ276gPOxzp7jvSNCngw7u4C/MBh8V5AS/TSOG5huomUlJQ55dZUjuyNM
         5/Ur/wGejphZwcDYQ+hrI+seBz6kO+6/PVaCZneEif0Jil88d3GSiTBh9+JzhztXZ7Y4
         FSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RkQGvEn1/J57fLgaw04+bizgAVhySmUV40+u0IkiKek=;
        b=RxrhtKbpUz4NIxHdf3b1Wq7eO0FAaIlb2+L05fxzltSXbCFDOL0441W6L2n8ukrbtT
         yggWOH2gHZ3mgsW2QjXoJLR3n/tTJ5M59ojf+l3McSzNcpsFEa5CanfnuKyNZaI8Ul9L
         Iusaz84cNrnGyTmFjIHz5o5D1Qd3Yq0+ZWGiUjgVRmjPz7I6mS7mg4FhPRR1CgYucZNC
         iFYITL6XL8FpSYRd+dK5rXp/2kcTQtFPfV+7CYitXi0YSfhwMy+PNA42tFC9GUScksDB
         irmVLdS8Z+55JIqMIzyzsa67kbSPL1XHa9ftrURbekzzBZnUsEfigr8UjrP0Rubp2mYa
         J1Iw==
X-Gm-Message-State: AJIora+8b6lL0PD8XWJG3yNl/PW7ZTKyd2x2ITVXkD5NdM3X47mtzZ4M
        zIAauP+Qap+CjfGozfAaJAA=
X-Google-Smtp-Source: AGRyM1uIUHLmNQV/dKeVyBTjdn57y7Notzyf1JZ/vmYmQG+LWWbwqEFPKV9K1f0sgjaoIze9JFdG9A==
X-Received: by 2002:a17:902:f602:b0:16a:178a:7b0b with SMTP id n2-20020a170902f60200b0016a178a7b0bmr1505706plg.20.1656113669173;
        Fri, 24 Jun 2022 16:34:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902bd8b00b001677fa34a4fsm2356667pls.72.2022.06.24.16.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:34:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:34:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/234] 4.19.249-rc1 review
Message-ID: <20220624233427.GC3341529@roeck-us.net>
References: <20220623164343.042598055@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:41:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.249 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
