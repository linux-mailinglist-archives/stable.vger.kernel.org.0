Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F10D5228B5
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiEKBLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240382AbiEKBLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:11:15 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC2E35A95;
        Tue, 10 May 2022 18:11:14 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id q7-20020a4adc47000000b0035f4d798376so587267oov.6;
        Tue, 10 May 2022 18:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ITj+054+3Ms5/JvFdxUT1qa9X1LPIVvAlt6gUviSmHc=;
        b=MQSSMdlCo0yApXqi4Eh02Gpzg1BzXjFclWBFjs9WK5FJ3DDBiWdRpQVbZkzpLB8tb8
         8S6nKFivZS7nRDZCgPckN0ksMrGqapbYeyB/TNxealZrGfLxZYxOM6S+9xT/3oHzrWXj
         5nshTCjRsb+Jtr/qWMW7mfYsN237mssFdU+gfCIllh8cne4yAR1YxfZJPwxKrngPBSYc
         kbzN6wXdpbDBEj2bmF2mSg9+fZYUaTM5YKjiR5+s7KuVB5/QSpSizSB9OIdC2M55jzr9
         qi8WRW0a9QRwSGndiPTrpqHNaTj/L9lCbRlpTRXxn1/ICOyyOAtDeR8AUE0wZ1jvReDe
         IBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ITj+054+3Ms5/JvFdxUT1qa9X1LPIVvAlt6gUviSmHc=;
        b=JBUAljeiXcctM8giwvUrDWInYgkEMFHHsPxuBCBnJtB3z44JCq4mG8oldeMkwE86SK
         Pn8tqsdjoKt3GSSLynILrydQql89ES0xFTT3r/YtAOleZwTV2JGgwAFjSdMzVnvGePn3
         8xuNFZLhs/Rm31Nj3oJv9o6Ws4pCrb6uSQOKmZgIS93+IQTqEjm9kD+0nKnfJKdwIM9w
         f4yO+PZD67A2xROrn9jjKGksTIrxvW/E+tcYYXNPDipO46KkVfCJ38+atqWnKT/zCkmL
         OxYCM1fzTimriuVzU9DewuJjJQTSWylLQorZM71SjfpGqM6xyLgYV9WMIOyVKPABeGvL
         OWJQ==
X-Gm-Message-State: AOAM530sx8TATcWS/Pw+6m9VXMyFW7Og1f1WLH+lF5C+rmDDZ0iFCzwm
        T0imu0XE8mbGFPqdxaOoZC0=
X-Google-Smtp-Source: ABdhPJxTHQB1VnxdyhOCvKZXfA4G3aup8nKh+hrNnIOBVYlc+cwh9sTPsBgEprnkHXpgu9IF7SMalQ==
X-Received: by 2002:a4a:e784:0:b0:35e:e674:432a with SMTP id x4-20020a4ae784000000b0035ee674432amr8893476oov.78.1652231473624;
        Tue, 10 May 2022 18:11:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t142-20020acaaa94000000b0032647f4e437sm225646oie.45.2022.05.10.18.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:11:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:11:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
Message-ID: <20220511011111.GC2315160@roeck-us.net>
References: <20220510130733.735278074@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
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

On Tue, May 10, 2022 at 03:06:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.242 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
