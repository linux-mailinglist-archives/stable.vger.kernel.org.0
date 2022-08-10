Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16EFF58E8BF
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 10:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiHJI3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiHJI2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 04:28:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292F585FA4;
        Wed, 10 Aug 2022 01:28:45 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 73so13719539pgb.9;
        Wed, 10 Aug 2022 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=x82j1chcIa6nsAfChVWSl+SlW9WelN5T8r33FLrMLXw=;
        b=ACSgD9wwcd0YaFg72/I6pBU3sUjhE8hBwevHyPMIdwsfgTnr6tmAlpltI1tLZCG5H/
         ZSt68Pnsnfi6muxmov3S+wtD+V84jYaLXJAgGKX01WULSoDTWRrs+HgdaNZF4gIClJpA
         rjHUxvSYCk9/I1KM1LeZpwHbYdF7g6Ah8v4GftmdQdiMI3SnaeKxMiKtPQCMlPysYVUm
         4/qbftuzB/dMhCFl+QwhazMittDaFIiUWkEqTpA1pI4VgynXpN/2y8TwxIamaffCQOKY
         1Ks7vdVgJr/2PfW2atld4dlOywwvEE+fkkzwtTkW89QhsZNAxEw6YYjpVkE+aZwHvE/8
         N7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=x82j1chcIa6nsAfChVWSl+SlW9WelN5T8r33FLrMLXw=;
        b=Hgnf2wwaBKXDdYcDsdgEHd6DNog5YCaoH59PdU04WUpPx0dBTq9q3fiQtICe3OcDzL
         kRr9gEWbWtJMUj1eXUtpxbuP3Z6ylsf+p+muOTph0xNi9ApxfDXsbq8erMh1Cd3tpdvH
         b7WMMGntqT466Uq6RBYverWOzVidxrsY/7omy8YVttM3rNS34U4Mv04C6pzcFyifOzBN
         N3EK5QDxnHZ8IgKHpdwPNrFKjutsTvlasTfdEKf/eQM+/RKVp5WewI5YdMtKjnxyq/CU
         0zBHZVlWOz+PFuh/wsxI74FiOB0mIkiIGdoAkgZ3B1rXJR7LyA3IvAcFbYXRk1Ki2oSw
         8G7g==
X-Gm-Message-State: ACgBeo2Au2aiL+LAmyjVuhvLFcfw1oexOjYeO2TC+2V0Ti0W0/Xybhdm
        rpGV8cEhF6NBMSmvFDqzv3A=
X-Google-Smtp-Source: AA6agR4i+VhbHUVyDzjq10H02RVPmVPlHINXmW22fppslyO9R73WAZpVukBobIpSwvo4X7SqmUvD9A==
X-Received: by 2002:a05:6a00:1709:b0:52e:677b:702b with SMTP id h9-20020a056a00170900b0052e677b702bmr26618042pfc.19.1660120124683;
        Wed, 10 Aug 2022 01:28:44 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-30.three.co.id. [180.214.232.30])
        by smtp.gmail.com with ESMTPSA id u23-20020a1709026e1700b0016dafeda062sm12243685plk.232.2022.08.10.01.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 01:28:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1226B101DAE; Wed, 10 Aug 2022 15:28:40 +0700 (WIB)
Date:   Wed, 10 Aug 2022 15:28:40 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
Message-ID: <YvNsOHIfu3o6NQEm@debian.me>
References: <20220809175513.345597655@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 08:00:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
