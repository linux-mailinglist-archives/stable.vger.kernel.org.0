Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B364638EEA
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 18:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiKYRTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 12:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiKYRTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 12:19:02 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B786350D52;
        Fri, 25 Nov 2022 09:19:01 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id c129so5073345oia.0;
        Fri, 25 Nov 2022 09:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yarLPXmHDeaH9+KUncKUuS9FlG4hBfjikKw28uiKqyk=;
        b=mQLpaCpq4PpsNMORSgcKAE18ILD/icf4FLG635gHxpfXzRf9niA7mhNA7Kx5WARmTF
         i8zwwkdrslu3WTLo8pNfNTo1acuAKDQf7S9HzGmkIJeZT8tpUPASZMNMubX0dp0BP65y
         Dawhwero9Gna8hwnli9tlrydOstXkiRxrzWRE2QEFibspXhwmvPi5iEDaDDnqcG6Dg56
         aIEbAQw5VxvhX+1fesP0323q+JLIb7JA3wXCEEpSkQJuRICAPZn/wccd61dGf1U4SNQX
         eaPF4dF2tGifcfSPeIl0u+A4l8lKgM+foqPUAjgqCeR++Z6AC61j3Li8bGffSikIP0dF
         XpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yarLPXmHDeaH9+KUncKUuS9FlG4hBfjikKw28uiKqyk=;
        b=6h7xOOk7tFjDhPpQYLey8dJvT/gORR8XcQcLRqDqz8pjRgE34oEF09t2PmzvqRpPs7
         /eIyUEer7g88WF0hcJEjiVJrEleubJ/gO3Ipa4oHmoMaqDbSwEct+VUzsdXGjSyPF6dO
         5oMl9RLkISt9FqxizgEYdgM7CxSYeicTQ6G4Eww+UthZISzfQ4OJgkJHlSstQtuuenxC
         MspJ1DYAxYZbrhL7r7MibSavfF8VeblMPU94h7i+GqBuP56JLhhCXR6NbbGDfYiXdpFE
         igri+62TCV0KYQ2HebbRJ/A8IiRGwQJFLZLFaE7bUMsF+kkwpdKXQACbJ2XrcKliJcp3
         c5rw==
X-Gm-Message-State: ANoB5pm3ai+xv/yB54MZINY6sko+/FsK6PHX1LE8nWi8XJ3xdAxpsy3h
        yhQ6nzSvdX3v3DQdS96SBbk=
X-Google-Smtp-Source: AA0mqf4C2GRgs1nz+zpZ+jGoH8K5jBbpfsknDI6yHCRjCwfaBM17eE3OKLhYNSO83CRBLbQyzXW/TA==
X-Received: by 2002:aca:1704:0:b0:359:e535:84a2 with SMTP id j4-20020aca1704000000b00359e53584a2mr19068248oii.59.1669396741069;
        Fri, 25 Nov 2022 09:19:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c21-20020a4ae255000000b0049fd5c02d25sm1747493oot.12.2022.11.25.09.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:19:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 25 Nov 2022 09:18:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <20221125171859.GB1205540@roeck-us.net>
References: <20221125075804.064161337@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>
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

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
