Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0C26CF5B2
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 23:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjC2Vya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 17:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC2Vy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 17:54:29 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9F997;
        Wed, 29 Mar 2023 14:54:28 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5416698e889so319878637b3.2;
        Wed, 29 Mar 2023 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuJnhqOglm39EigVBOorfLFET4EJvRI41CYQanO44wE=;
        b=RR7FRCugnk5U51rg3Y0p5oRleymdIcY3kRaH41wkygg/t7izHSgVSqpiOOlLqo0q3p
         lp+FFjkF2hXhFKtua4KcjqxOGgnkMFiNy6ea5u497E554KmNIyY6xDeu6ceI+U4HPLGE
         iTIeoMgZCdrQ3BYNTi6l2TrELklRlSuEDyrTB3+M+6XZV6zuuCeEQoEKLbf9AqCP9RQN
         aQttkXbUHWfiy4l3lyIru146D49LXUkbCiCk54XMlrRnmmIhyblFBIWk8gBHiiRKHy/R
         NGhk1+TKyEXLECw2JxuFWDsjlK79hfO4ZdB4TOmQL8WsMZ09CkB2WRcQryQaLqYxffFa
         3umg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuJnhqOglm39EigVBOorfLFET4EJvRI41CYQanO44wE=;
        b=POQ+gDcqMkwHVnVyx26QgDS22sWG4kTygGmP7c/0YlsrBzgfvsjdfV/+Gf6DqkaPYe
         1aWQCTu8xkNg1XGlrr6GERE+idXE19hricO4eNWqz46Ohrr87HFATXUElz2VQCowqpWP
         q1GLhS5sKmvEU1c3bCEIonrmDK7DPz4s1ol4atC4LbSLU/doRKHwuneIEp7ZQt9Zi7d1
         cO3EInv/QvM2F+mMgSkPIpVLF1pH5a0iudyyWqzyGZ4wEt5ZEZeOvfl8mVD992mGnMvu
         sOptI7UOlbLHwoUPSmJHCyl9C2tQnr4O45/RLXul0CNNLMw2IbVpgateHwJbG0cF0h5v
         TlPQ==
X-Gm-Message-State: AAQBX9fHPt61MZ93ntNTvG4Hc1ASQjffAT0dcULA6cUFVVlzGf7YKrbW
        sal7IEx1+vyWSLCLkOVxpiXKu3IibOw=
X-Google-Smtp-Source: AKy350bJRteG/ORlYIW4b6bWV9t0iBvfTo+73hIctNo2CSCTcOD0C9HvwPFtn1vOfm5LoswRNSXRxA==
X-Received: by 2002:a81:4ecc:0:b0:544:4d3d:4231 with SMTP id c195-20020a814ecc000000b005444d3d4231mr21168821ywb.47.1680126867682;
        Wed, 29 Mar 2023 14:54:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id by1-20020a05690c082100b00545a08184f5sm3195290ywb.133.2023.03.29.14.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:54:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 29 Mar 2023 14:54:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <232b80c4-e885-43f4-8f77-924cd1b763fe@roeck-us.net>
References: <20230328142617.205414124@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
