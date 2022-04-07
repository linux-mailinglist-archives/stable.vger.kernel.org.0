Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44824F8673
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 19:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346524AbiDGRqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 13:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346533AbiDGRqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 13:46:18 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED46B22C1C1;
        Thu,  7 Apr 2022 10:44:17 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w17-20020a056830111100b005b22c584b93so4376715otq.11;
        Thu, 07 Apr 2022 10:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iOmaGvSY3sNiCGul1zIbS6aLQalKU4+HuWoR1U7SG0M=;
        b=hsDUetQPYoAK5U6TbthwBdVp+Xh9SKjYl1nBV1wTCzjUl+DY5aDvgwD1yvu5ey2aj0
         4Lkl0djKYjy3n0xvpQnhKLKfSFO97Akqe/EKliMA+RihY8rpphxqVrGSDhHKM8Qoi/X9
         SZuOADlbR6xPW4O2bZTbrnNXvRWahzlycyi58hekpJZc1etmdYdBRmr7YoHPaVanO73m
         BwvFuZHDYJVTn33IwKjAhweICLkYhpJ4Wl8xqoOzrDWnCWZU4CnEKVYxuj62C/OLjuLy
         TKuZhtLd7ln2hsRjb+T0kSsJfbO08JD7g4iYPRCcDg71UsHBQlz2wVL0DKi4Cz7DIGW8
         0ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iOmaGvSY3sNiCGul1zIbS6aLQalKU4+HuWoR1U7SG0M=;
        b=HpU65Xfnr9NyeiMAkMwug5tHSN6nW+G2tLdNGHpxwd4lUFzZPIwPeCD2RMHWsQPgtp
         c1pzCdWna9jy5YMt3QfjXLRMjLpW7/nIh4+p0cIb+3KTo9eU4r0gOyFpXRfix01njAGp
         6F7/62lJa7YjrkfeMxMF87KVkzWVL/afcaBt61cw783CdCxXPrDMbdL1pJRVk76I3/uk
         40qTvB4yVb8zfgwCbroupanT/XaNezO1xSIBpC3M+JdBshheNSGPlV+abz6FI4xDexsZ
         z5fPXdMCHkCWb6fGaxgu0miv47hFbgqSyvsln4oig2omxaeCsHhF73O+dBUg9h2KZEvA
         Iygg==
X-Gm-Message-State: AOAM531PvZu+OdHxhmm9eO8EVQj6jEKMAvYa6wRCtv2ogrJD4io5QPAb
        O8npo9d6muabv/1hFzdXMFw=
X-Google-Smtp-Source: ABdhPJwVdHTvCPJEdmoLOVj2BbC0PrkyGlmpkbTU8prjKmhtnb7PXJpSDNqK8RWTD0xUijtU4Xfepg==
X-Received: by 2002:a9d:6447:0:b0:5b2:35ae:7ad6 with SMTP id m7-20020a9d6447000000b005b235ae7ad6mr5138430otl.275.1649353454994;
        Thu, 07 Apr 2022 10:44:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f50-20020a9d03b5000000b005c959dd643csm8244683otf.3.2022.04.07.10.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:44:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 10:44:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 0000/1014] 5.16.19-rc2 review
Message-ID: <20220407174412.GB1827081@roeck-us.net>
References: <20220406133109.570377390@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133109.570377390@linuxfoundation.org>
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

On Wed, Apr 06, 2022 at 03:44:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1014 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
