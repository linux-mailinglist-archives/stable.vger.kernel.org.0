Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3C5E68BA
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiIVQnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiIVQn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:43:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18512606A6;
        Thu, 22 Sep 2022 09:43:25 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c7so9669991pgt.11;
        Thu, 22 Sep 2022 09:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=vf4lFEmt3uwP++C4EsMB7dpgKwPi538z1nHuMHQLHmg=;
        b=Lh44ZV7Ti7vhWqk7FlWNNHvgmNfRZUAiKJKsVHX6GaxluB7dnawEo0rf4fFkOjfC5t
         A3mYPjsGv28qtk7xJIh34CPc6NUHR4t92qdH1pNZiThxxEtL7LHvmelkbgE7hReW2r+U
         YPqAlaqhNzoBmB3pMNFa92KO+ku2AbOd/tkBbPtKnTugbkVtpHryqLhNK3QFwAyIpGWa
         dMnvKjwdqNilclLhH545D3IMAvUhU9NPF6TIlinOUsadQyWga5/9HAGkAaOJasMUHbnI
         FWEHls7LQeylf+OV/8a7f7bQnH8b7y2ftGgcB0CKfy2RJdMxHYeI5mvqR+Bv6XRSR6pu
         hBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vf4lFEmt3uwP++C4EsMB7dpgKwPi538z1nHuMHQLHmg=;
        b=DDjAEVBFS7xeN93IDt+vbP87wz3z/FBrPwdXylAa8y1V7mBl0e6ZivfLBFm/l1QQFI
         PuGuHetA8gHcbWM1BR7O5vr9kQoHLQNvVQmkc5it/J6D7P8l7WZCyDGwnA4kVP2q4aly
         6VMEVTheZRzoqRcFtdoRJW8ZMAwGMrPiKE40QxiuRxNFwzsxz1/8vNPuZt0Wso8scfH3
         hntPLKy24etkWSlIXDTFWqLqiYipzQKalGwiNBppddvs1PTyQBwx7Qq670ZjNI8GYCNt
         m6miL7BJEJtb3amjfN9vMyM109ki22war8xkUsauJeO1QjxYDhT9SZQsiCByhypaM/mw
         NDkA==
X-Gm-Message-State: ACrzQf1OdBdIreHxkoOttYo7YM0+PBgwiiJXuZR2O1Ez2pi/7XhTgwSZ
        /lacKSs8rEUth81tUXsjAH8=
X-Google-Smtp-Source: AMsMyM64utPZZ2FPwmlNoHqD3O/1nqhv+ov5CnL0WUa0Fn7/FuDzEPlpq/pHGGzeun7VV0VpxXz/zg==
X-Received: by 2002:a05:6a00:17a2:b0:540:f501:ab76 with SMTP id s34-20020a056a0017a200b00540f501ab76mr4525065pfg.42.1663865005368;
        Thu, 22 Sep 2022 09:43:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090264cf00b0016dbdf7b97bsm4336126pli.266.2022.09.22.09.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:43:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 22 Sep 2022 09:43:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
Message-ID: <20220922164323.GB1138811@roeck-us.net>
References: <20220921153646.931277075@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 05:45:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 159 pass: 158 fail: 1
Failed builds:
	arm64:allmodconfig
Qemu test results:
	total: 486 pass: 486 fail: 0

Building arm64:allmodconfig ... failed
--------------
Error log:
arch/arm64/kernel/kexec_image.c:136:23: error: 'kexec_kernel_verify_pe_sig' undeclared here

Guenter
