Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC245AFB65
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 06:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiIGEoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 00:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIGEoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 00:44:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFC78981E;
        Tue,  6 Sep 2022 21:44:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f124so4204061pgc.0;
        Tue, 06 Sep 2022 21:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=CMq79SFYzQoZ1iaAlbGZchIachbkBUPK4cXVqzjhkfA=;
        b=JAjAXF8kguv6kRam9ZaGd10gB3pj4iG6z5gwzpwLyjDokaBXZ27uFo6d41MFfXwsIC
         mErHzFEcjQTJShyenrJeJeFNK1ZESFZ1Orh/spXMAVhunOx6DU5aV7VkNgKg1CJ4cGY/
         jMYYAneSEQ3/w0F8LgMSEuXCwY8MNFWgdJHNZHJXl4FzWPlJhvJBWLMFlRSacb1RoHRR
         /V4acJqdxOMaz6zk3FzB5JNDW1rDy9tChBFYvpRBB7b1bapIiBVzrN30KxcfTDIhcWtb
         QOwNJWSEnvV7+JQNfLfvgtnkQjeo9yWngQeNhnQ87SoFXCjitxVqVX75PoXfXezY8a1K
         biIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=CMq79SFYzQoZ1iaAlbGZchIachbkBUPK4cXVqzjhkfA=;
        b=xuwjwFG13E01ceTeEDHAyQ0JiIRXb9YfwYrd/FV3/O6jSs12zZ8lMfAzoIHWEUXjlE
         wGLQtLAF5C0S3IRha0+TbxHt4Ts8y8UFiID30GM+W5D2bSDo/cnHA0sCGqgWLm6IJGXk
         6IFx6flgBr2osMrgV+hWzKqGfqfeSsxvfF13SfBXWqcY06URstH01VD2niSSOuypjhkR
         gJPMu+cqgEcps6epzWbm/hbUC4/4hVp2lUApKpWN7WBqr0xGt9eHAjJBTW1YgCon5aFu
         QzBZG6Wtsh7Z1HJr4a887IhFJZboZ8f9NlYyOpYUB6Z6qnDPhtYzprLXmAcKCYnU6crR
         /ryw==
X-Gm-Message-State: ACgBeo0oBn4Z1u6AL/sgmLDr+aclcnWCINwsQGHAp3KH3gCacagc31MT
        /oR3Fao4HF0RJvysp7XWSdkErRT2ipQCXQ==
X-Google-Smtp-Source: AA6agR5bpTl9o4e46CiEQ4IKuJkkr8fCpnXllnDD0Nh4mEfZp+8cTzNdLDhTa9xJcQ3le6+OjHLlGg==
X-Received: by 2002:a63:de01:0:b0:42b:31f7:b6ea with SMTP id f1-20020a63de01000000b0042b31f7b6eamr1742897pgg.587.1662525853023;
        Tue, 06 Sep 2022 21:44:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i194-20020a6287cb000000b0053788e9f865sm11268498pfe.21.2022.09.06.21.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 21:44:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 6 Sep 2022 21:44:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Message-ID: <20220907044410.GB854810@roeck-us.net>
References: <20220906132821.713989422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
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

On Tue, Sep 06, 2022 at 03:29:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 486 pass: 486 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
