Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9D52ABF2
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352729AbiEQTaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352749AbiEQTaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:30:05 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AD350B1F;
        Tue, 17 May 2022 12:30:00 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so25444437fac.9;
        Tue, 17 May 2022 12:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vyktrwpdy7dbMr/9IhMsmF12p/lQWfo7ZHq8Bhuap4M=;
        b=j4n24EcYrWVl3SdakxJkllQOL8rWnREcA2C7kBLDwjmlVtpLo6ypy+BBGkDPw34EDA
         KO4J0MDYO2OHsQK+CyDuQiXGpoHk/L/WD1yt4zFD+hUEYYbIVpbOO2W/A8nwdFozFSya
         yGdil2+wq0A6j8Wcu7fqSzZvrwZ0hyUrIZB3VZ7JoW1u9u8DQFR0wkOTB9dc7K2KmZMU
         eRQawYlOqsynGDRVO/EUldDGlRyZxReDqxW4dMMJbpkGAxyE6K6QOQcTAE+mT62JhFkP
         rSp+eCGOku6YBvCI0Oz+OqY3TL4lS+/Lq1RSRpMj2GP/5oN8N9QvfBqnbYL9zE3gteT3
         OCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Vyktrwpdy7dbMr/9IhMsmF12p/lQWfo7ZHq8Bhuap4M=;
        b=Iu2T6YaldB89eY6+TaJ7yS6xw1I5Lie4/IFUsIcjeiTckC/S4HctRfEBsA60hRlrj+
         8I6VS+dCvcGHgSypASjkaV0UG2fCx397VclU/KHQnYUFlVtaVK+eNwlYGodtS8uv+rqr
         haum3yqPOnPBZh6bFKk9YEJDrN+O4O6oz9ZNHKFUt5uS4tl2dXNOUTk8HDUxt/5ctbyl
         PFBOSbamSRulhW7OZ9QoJiE1wxapaOZE6yGtYMdyeQR2GHy7VsvqPt/O2fbVxfMtYaHJ
         yy+w08V50TGidZ+ns6UdQph+E/ZpjW9QBQ9pAapSbwep7VTySYUYAiDs9ToEtkxII1lu
         tE0A==
X-Gm-Message-State: AOAM532lrLL2MHG2H8XERO2jmM7on+kM1QlVdEPdwbrzLNbbPB8xpTfX
        Ho1eXYpYu2aLqf+Gi/njiAs=
X-Google-Smtp-Source: ABdhPJyu43bvqXlEZHsofrqmry+leOhaJf00dfP9F+o5uqv0tqhRAW4wkFI5yg12W0dDHYiDWVEBcQ==
X-Received: by 2002:a05:6870:9a09:b0:e9:20a7:6cf6 with SMTP id fo9-20020a0568709a0900b000e920a76cf6mr19061368oab.122.1652815799974;
        Tue, 17 May 2022 12:29:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b2-20020a05687061c200b000f1949eea6bsm101779oah.53.2022.05.17.12.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:29:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:29:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/25] 4.14.280-rc1 review
Message-ID: <20220517192958.GB1013289@roeck-us.net>
References: <20220516193614.678319286@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193614.678319286@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:36:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.280 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
