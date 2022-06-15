Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1DF54D41A
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344621AbiFOWBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiFOWBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:01:33 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A7D55490;
        Wed, 15 Jun 2022 15:01:33 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso36746pja.2;
        Wed, 15 Jun 2022 15:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jw0DXKgtV9MyiD0A+UBYYijA5y5Gd/3cuiWJODz/nhc=;
        b=Nvl/qY2zmd7vo0xkTo4tZVDlMbCFFb/K0xrF6Cr6g57ZMpXqDqoL4T0vusq5ygQHNT
         Lmi4L1A2/XifKYHoSqvPrnl1bS5zhetTjyEp7TBjVVuOpq0G2cAtaDalU7ku1kWRoDT9
         7bC6vEpDgeEjcqdcmkhkQIywYRus5u1XRFrmK30rjA4UQCEBWDEX5YQynzBSjS7ho0rp
         78jjCE16pAJZzpXeyoVQAhrjjN37kQrEY40XYucaYjTNb3eAynn5W50lXYPjbDkBcbil
         VDmJPu4tEnurhsOlhpkJlS2LjjX+TO1tNw8G0cOBtym+rVA2ZI2UIAdDcKaXv3/bgL8g
         wUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Jw0DXKgtV9MyiD0A+UBYYijA5y5Gd/3cuiWJODz/nhc=;
        b=jW4A2tJWC+bEN6sr6qipC+t2jOw+vXZLJeItKUn5TKlh91FMt66DQKhdQhfIxSxH1a
         3sLPq+YLuKEku0F8q+w6o1xdVD1ulHloVgg4AsveNQApvSFRsW8EZ77AnCYuDJnMxcEt
         vmpTKzI+m6ac5aL7qNEFFx53qtWDh8vjky9OOQvZWw1gTPToapWK7RToEyas9A6h98FU
         yDbap6TZJ6FhzXGidkhroXwEuulsMg5yjH2uBS8i5xOnpXxcdoK7hvuDMSWWX6ue8QL7
         OkVaPyqSLh21qsrs38FwMXQPZR0KSHzc9rw4b7EGFBBSFdkZK8osGjzZIeJcI55gYUsp
         vtiA==
X-Gm-Message-State: AJIora+/yhsSgLvJEGqmk1NNwHtPg83dgk/hpFs5YOeafNAtNyX3YgsF
        u6O/e3tP807v2vG+ZEKM6eg=
X-Google-Smtp-Source: AGRyM1tMcNpTwEJC6el5Vb99RGU8zajOmd8ZSA2FftyoKPPcoddBy3gehpv08bNIenTp5kRpT1u6uQ==
X-Received: by 2002:a17:903:248:b0:168:cf03:eefe with SMTP id j8-20020a170903024800b00168cf03eefemr1414916plh.124.1655330492461;
        Wed, 15 Jun 2022 15:01:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b001663e1881ecsm80590plk.306.2022.06.15.15.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:01:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:01:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/20] 4.9.319-rc1 review
Message-ID: <20220615220130.GA1229939@roeck-us.net>
References: <20220614183722.061550591@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:39:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.319 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
