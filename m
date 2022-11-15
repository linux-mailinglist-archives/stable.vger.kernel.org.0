Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E60628E09
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 01:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKOAMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 19:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiKOAMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 19:12:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6A112AFE;
        Mon, 14 Nov 2022 16:12:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so15376982pji.1;
        Mon, 14 Nov 2022 16:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yS8quBXtR/yZJG+3YWdsCaXAYDD1DION2BW//xVXiSo=;
        b=UxLB7F3uLDdvPr0y2llH7NpfVYM9uh0kL6whhLpWmbe9eJIEyX2MNCzX1TyEQzbpdn
         UEl9gU5JBcOionZdsJdHM8P2RB5nss0eeXyiiYzqrN/6x7sdDTMeLR6oJnHF0XbsOk/s
         ofznJbUscHulmGue6Uw1kU3y1H/n5yw9icg3bFnbz6r3rBwmw1+F98kuFM8aF/hYOJO0
         vbB9LfY7F3JuErGTUYJt7ez7cBqo1WO4S7J/+DflTZEuogbJTEjVtdMNsxfJawqqhzV5
         /TksXIFsevkXUgB0OgRaff5/ksPhbWCrqu/R+d/klAHH3KvD9auWKS6qa7im6Id6fHu1
         wQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yS8quBXtR/yZJG+3YWdsCaXAYDD1DION2BW//xVXiSo=;
        b=UGxTIwshRRUSSzG9dt9zl7VboFzq0gkK/gntfa5G48Sv0yI1s9hUL72o2hZ1Ud2bTf
         na+jmH5THLz5Wslxci0efcNinpqtekyyg7iSqp5ai6wF3RpwrbxUSoH+TMqYGXS6nSbO
         YohUK7gVh2+Qusr5URJ7IHpqUOVINoPfrR9MyND32Dr+ZUuspR6f7NVTh+JikbpW0FKQ
         5OCrkwp7M8Lu3ps/oFDrfTKmY51Po9Fi0zV2KhfeMnapIAAX/okjqog99eUPwxbqAXnU
         hD2ezPUDJU/Y7cjhD0YJrBFkHnfa8g7c2gZo0TyQC0TrEmdvfBy0ZGyXzRAegS4kZke9
         mlcg==
X-Gm-Message-State: ANoB5pkIpIELFsW9bVEqdGav/SaMx+5bzDnMD7ahtq1oHyA1kbU25Ypa
        SH9PrnMoE21e/axgEHIugwA=
X-Google-Smtp-Source: AA0mqf6uasNwzRqJQkRupqH48YzsspBUNwVsoUbhrMVLMzEVF2NNiY7c5XUI8+AGNleFJ866L3SaFA==
X-Received: by 2002:a17:90a:2b0c:b0:20a:aa74:175f with SMTP id x12-20020a17090a2b0c00b0020aaa74175fmr15755279pjc.194.1668471143465;
        Mon, 14 Nov 2022 16:12:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id iz17-20020a170902ef9100b0016f196209c9sm8174791plb.123.2022.11.14.16.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:12:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Nov 2022 16:12:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Message-ID: <20221115001221.GA2291336@roeck-us.net>
References: <20221114124442.530286937@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
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

On Mon, Nov 14, 2022 at 01:44:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
