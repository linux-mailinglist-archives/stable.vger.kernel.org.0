Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3DF678E84
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 03:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjAXCs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 21:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjAXCs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 21:48:59 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743E432E4E;
        Mon, 23 Jan 2023 18:48:58 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id f5-20020a9d5f05000000b00684c0c2eb3fso8463744oti.10;
        Mon, 23 Jan 2023 18:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRQo6lUgqggMAmuBjwphVAeDFQgoop+xnd6gX5YgB0g=;
        b=KsMHOxWFmIXg19fJUaR0Wpaf4MPv4gCrKseGsMaercTpuYYWSVQ7QN8cKEjsqstShB
         DvIRiDriD/M1GfRkoepJLRg3Zl05daG3Mu06cR2yosa7q1x93svy0rLrjk+vq/E8H+j5
         dpkPU8R+S/1Pc//TiJtEs5iVFOtlahS//xdfhZYJuMds6ODd2yKBla3RaW/3lr404CBT
         sqs+/IgIB9pSl0k3m6iL4afdPJcZDSEn7KR/NHZHawsFRSdTyhULstJKHmPz2Bn0nNIQ
         4q8poFyO91ZaS10bGHovs7NtkORdFVvw9XvR5CrJjgE2/NdR/SDzNSGJvUMC3mgvH7hL
         XnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eRQo6lUgqggMAmuBjwphVAeDFQgoop+xnd6gX5YgB0g=;
        b=eudbHLJwqlZMVJO3MdqCy7zXx+t4KzDh2cWKAQHcMpIiL833G9xxGYlG8WS0UrUvd5
         MDfgZOwa5hMqGJ81G79AgOj1Ay2myXebDU1l0X/4DJ1ckFKARh9g7IN9UFK2BBXjAzxd
         EbB6WRGOAvrkED30AdrrOpxi16+s15bdFOl485tfbNWiDg10qh0Gi8Mrx0yf8mX2xGgo
         kBfu5ACa9yKYnSrnDAGlCeqd+s5Mds7mckjHOhR2e368iYqyUvCX1IFbECNf6Jr99Hh+
         lVFR1TXeID7nN0pR08EtEC5nTMju5hPA9kF/o64qsLXGz2OlUGsmwJLEGDLaW4nlbaZ9
         02/Q==
X-Gm-Message-State: AFqh2krr++r/kgTD/dq82vws+Y4VD7xgje0clZ84gqJiA35lVnR0QbnG
        LFNVOpd7pMULFAFXBNzGYwc=
X-Google-Smtp-Source: AMrXdXuquNpVCNlEsf9HCeKHPrxp1wH0mLBCrLb5zhVQPP5H/dzmr8NPCXaYKSS1BAefXeyAVyQpDQ==
X-Received: by 2002:a05:6830:142:b0:686:41a0:479 with SMTP id j2-20020a056830014200b0068641a00479mr13511000otp.3.1674528537641;
        Mon, 23 Jan 2023 18:48:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a2-20020a056830100200b0066ca61230casm436139otp.8.2023.01.23.18.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:48:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 23 Jan 2023 18:48:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc2 review
Message-ID: <20230124024856.GD1495310@roeck-us.net>
References: <20230123094914.748265495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094914.748265495@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 10:52:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
