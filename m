Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086E06667F4
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbjALAkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbjALAkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:40:31 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A3A6254;
        Wed, 11 Jan 2023 16:39:55 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id r9so3375040oie.13;
        Wed, 11 Jan 2023 16:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vD6FPw0Foz3KscaH9BJ4SjGehgedvV7XcgtNlp6oYpw=;
        b=jx8uVM+jed9cCTxSuxF3g+qXgo6J7/eQkRCMImwaOjC7zMI7FPJmRKPJdu+ZR7oAxi
         u5nId+iwxA/huPvvDQ6rc2MR+2GaH9a1wjhLuYwTjX3wN6WeIibJBSbim4mhA4pgbnMS
         uDWkkqLdmodToimywp7Xcx2o51prwf9j9eaGgM00CkKltITH0qT4GwjAnoeDvbC9VzrO
         QQdU9MtJ+REO4B1LZQEvYoteF9Fkh8EPNUdEA/hr3/gu3K1vRsMrodwETk/ddsGpoF8E
         Zw9jirI7lwYw7l2gg2ZLipsixtRpaUhtn7OTQpRruE2lWuDShNtGkRPBQ7E9BnlGe/VZ
         d8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vD6FPw0Foz3KscaH9BJ4SjGehgedvV7XcgtNlp6oYpw=;
        b=Ewpf0IRZh4YpC0cLci1nmFxWjw+WgQulzEGQejA6ceGBp8lZeCSkb5duMeu9sx5GLf
         rUdiUHBseZtT6GprMOHgTNf5HfTCw/Vw5TZ6SgFjWKjsWbbycn4wnQsWquV9ds6jyJ5F
         khxHFzKgaFm2nQ4TktKWJub1m2Cc3eZjZf2OP/vVFtnXmG+/Fq7M+5d9BGgvUrolFsis
         onEQ1Lh1iqwV7LE8Kgvq8NLLGVS1rOXMmKsXrs1NMxNBX5ieIIn4MVsmf03Hkvy3lR2V
         Mnia0YMyvONezdjyM8HJEyllF0mmpAA8bAGU9yUOEFgM3ZII2HyNBVQOEPN+cie1F1rQ
         2OJQ==
X-Gm-Message-State: AFqh2kpudlEdADtGS9SAIwjigxjSM7pcVyaOQ3QBqUNcZ+qMGrjEM/yJ
        smLPERWg1LNAPG3pgd10LYk=
X-Google-Smtp-Source: AMrXdXvb3xCEM9deV/155H7juHqnMssSD6E5wampKJojkM34Ez1nWEDc/kCsPahdW37dVIJbjXg5vg==
X-Received: by 2002:a05:6808:1387:b0:35e:bd7e:c89a with SMTP id c7-20020a056808138700b0035ebd7ec89amr40084928oiw.16.1673483994985;
        Wed, 11 Jan 2023 16:39:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bh31-20020a056808181f00b003436fa2c23bsm7296800oib.7.2023.01.11.16.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:39:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Jan 2023 16:39:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <20230112003953.GB1991532@roeck-us.net>
References: <20230110180017.145591678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
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

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
