Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7525A5896
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 02:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiH3AzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 20:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiH3Ays (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 20:54:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0103E2B0;
        Mon, 29 Aug 2022 17:54:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p8-20020a17090ad30800b001fdfc8c7567so230297pju.1;
        Mon, 29 Aug 2022 17:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=9w5o28hwrDqe0QsW8BZlUdSQHieqN4Nx6LcXamx5x18=;
        b=EiLBeIHqvJoAudqbL4yAlVApZlIWLjdH178CBeKXweaA9SCnRjVaaKyMKqg8I12Ogx
         4h0SrDZQb/1vAXPvnNcW7gQkEcLQ1recjCWNjgoQ2f/R5ROGfigyl7LBWP3MitSNztlS
         02ad3XXbR3l7WLcM1rNrGvT6IckDKYhcHZk/ctqNmEqZ0buL5o3unTA5F8R8cIZTWTdE
         FWsinZza++tUNTZbBzWwI7mQfyFmviVTGfPjy/vzvn83dyUbaj+BG0r4qW39AQtGTsJc
         qZeqbXSLkM/8opd7nofkbmUmQ/WEcIzRKXEqk+a6dsyBnALf6IeLHvlHEcrwDsARgQeW
         NQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=9w5o28hwrDqe0QsW8BZlUdSQHieqN4Nx6LcXamx5x18=;
        b=KiI5WZ1mFNpLCL3hA6ThaC2GRfcJ7kQvgNbXcmktHIFCqKIBZaK4mlIX667rhwoKS1
         x7rp3GhOcs5I/S4r+VCgkuONs3SJst4epfjlVQKg/bH68yiBoU+QDIUxdsCDlcNNVzjv
         nPE7qQqK3Z2xWasTAHQif5R0VD+9OC38rz/Q9gCxFrYDZDxSFjZn9Zvmg2unFE+rz29h
         oJWLmCBozMYx26Y9b+9diCBE5U+vMHe3agt0OqiNn0pEGQC/I13Cw20tSPqGPIzlDKFM
         WzIPfy+WIoXeaIinKx2AuDrI0xOxqMYUSkoclGRvwkMBwBMf1IRznE0SnUFkk3rLoxfv
         H7Mg==
X-Gm-Message-State: ACgBeo0y4izDDJHFR91Ntrzz2t2ydeNVxofDIN5r9E9QB/JXUgiacAMY
        wUnZ52R+ENczJs7IFpZ1oghzd/gd+0R3Eg==
X-Google-Smtp-Source: AA6agR5Y7qOaPyFTw1lPoz2hCtx2SZR/djimo1SZhpJjxRETOzR8Ov1thInZml7PPUhNNmApdnhUKA==
X-Received: by 2002:a17:90b:3c82:b0:1fb:8ef:5ddb with SMTP id pv2-20020a17090b3c8200b001fb08ef5ddbmr20587379pjb.11.1661820884171;
        Mon, 29 Aug 2022 17:54:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v10-20020a170902b7ca00b00172751a2fa4sm3687827plz.80.2022.08.29.17.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 17:54:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Aug 2022 17:54:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Message-ID: <20220830004843.GC3337218@roeck-us.net>
References: <20220829105808.828227973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
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

On Mon, Aug 29, 2022 at 12:57:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
