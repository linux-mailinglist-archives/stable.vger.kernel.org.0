Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B285528B1
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 02:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244224AbiFUAra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 20:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241710AbiFUAr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 20:47:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDDC1573B;
        Mon, 20 Jun 2022 17:47:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id a14so2040171pgh.11;
        Mon, 20 Jun 2022 17:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/uSi77cNA2IpkduvE+nLFbNJUaEn97PLXksm9wxHDP4=;
        b=GlhQICgx6+7e4f+YGLGYHEuk/La7n/Dz1KYPLU831em4j5+Re9hsOr0RiNISe0igJg
         n476BjNFpGeNRMnKcCOO35QUmojTjiGI7naI/9Z7RlDwR37+Z1aslol807mSk3Jvot6C
         1zxFKMDQfN70zDHduO0cdQbX9i7aOZ66yHjf3t8s1vJ3fuaSBcZYkl+Zi1a1I8kGIlHq
         7ZOMX2+Ez6nmlkzmgsOf65vTcIDVMg9obYZTvglWYvwua83oLQTfM1LekitBohQ31kHH
         y6q6pXX4SnFVFXSe92ZIyUwjBZY+rpn2XTN9DtXV/N/vKJ7cIyXATpRTlsZ/sUwCXsrp
         JJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/uSi77cNA2IpkduvE+nLFbNJUaEn97PLXksm9wxHDP4=;
        b=huzx6kJ5eEHEd1Ak3oQZW3o5839CQyPQFiXnXekSm74X9K1+jS8M5W6dHGM6LUr0zO
         zhj4X3HgcBdg2ugtZGgR+dgB+B2LVuWGZGjSMKUY365wnsmZkj09d7IfgNknd4dxofDr
         xpfuRVmbON0o2CYjTZrXIcDaCBlyBE71qvSgXjkaH8V4XLt/KJzLOuRq+Qx62LcSjorX
         vKt4xo/1lwM2XaNPnQOuIgSMyqKKaZGSei7Fn8+Uk9nOqhNPCSNaR1E4alCgbH355DiG
         rTwRez1DQfz/368GPVvWx+fMuq4nlHVehZAhPSrcy/w0Cc11ubSsoXhAvFpRKcjFC1zQ
         p5Yg==
X-Gm-Message-State: AJIora9mKWuyge8zfK9bGlUfFglmGJoyBNlYvbrkfNJLXgk7ZvX9OrCv
        t0k7gbvitFL6W1dFfwP2S0o=
X-Google-Smtp-Source: AGRyM1u3NeaSz0PyBRGs/qIeGlvefbQcX03u70c9iVmnUvxzMTOET5iPdXb782hpQaudF7xLaiuxqg==
X-Received: by 2002:a05:6a02:117:b0:3fa:de2:357a with SMTP id bg23-20020a056a02011700b003fa0de2357amr23559418pgb.169.1655772448583;
        Mon, 20 Jun 2022 17:47:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b00168aed83c63sm6998733pls.237.2022.06.20.17.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 17:47:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 20 Jun 2022 17:47:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Message-ID: <20220621004727.GC2242037@roeck-us.net>
References: <20220620124724.380838401@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
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

On Mon, Jun 20, 2022 at 02:50:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
