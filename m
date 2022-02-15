Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274004B6038
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbiBOBwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:52:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiBOBwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:52:02 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA5B10610A;
        Mon, 14 Feb 2022 17:51:53 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 13so1228872oiz.12;
        Mon, 14 Feb 2022 17:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6nuupwsWfHGiePrIAP5CpFNtc1wldxbKxphO7wGsa50=;
        b=mfu+eBeVHHNPVNvI+BT/cFVD92E5vs+yrLfgJDwTOJSs7AdRv1nwcptc+r3XL9vPae
         P52m6JxbOTveT25211CYWEYKMhZtdM/J9o7WDP51SiGG1jSHSJDAD75u9oailfYFuXZn
         Bqz4tbb4MBn73WtX3Wk7aqcIkpvKf4d71ze+ooytamZjRjJysUniyG049z+MY0gWxiSL
         sS9uqFM1KytdyJsTEqvdGetX+GWNa9Bu0bLR5AtUo8wEnbUQtZtiL17P0ZVZagsHv8Dy
         Xa8xNkQh6hybQdaJBDBDGGbOrP5FZrISgmIoiovizVATsKBHDe4zVyFjr4aWmU0MUjbz
         FRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6nuupwsWfHGiePrIAP5CpFNtc1wldxbKxphO7wGsa50=;
        b=vFEAGvXEwnXChA0VMPmnsDCFvl0Bog61iwi6qmSuzIHSliAe2ERCRR/7uREsQx7xEe
         bgo73wwyyUaKhBDXfFycpSoFuD3e2sEm6QoH6T4kTsbS7cAGWqb4Q7ioeu2WnkqIkZw/
         XhGslROfZAnKCotY7xSRpKNsp6oYg5Xy2RwJotkTEFwjHHaRPA39jqAcjrvaAUs8hAAO
         ndZLX1qd2TZed3JT1MFTiR1iO/0ue+N635137SiTdBSs2uo5cjRjeqcvhzEJMmcYqTcH
         sB5SG6BNniSQLoUgCKKR5R2MnIIP/0ysCqrgd2soxyb1qROfk2LZTYu2TqePTAbI6kHd
         ogzQ==
X-Gm-Message-State: AOAM530CTjp2mTyEM725jHtW+FQcTAeOPyjboS6EHCNE5hUKQrYp+LRt
        Y5k4lEHC0lDyxVB7XvPc5HM=
X-Google-Smtp-Source: ABdhPJyMx7X2I2WkmwPErA9j50rlsknBWPMhkmZZ/AwIMFCjfvUdS2z5ECRG8qmb+8/9rtPXXz5Kvg==
X-Received: by 2002:aca:3d57:0:b0:2d3:fe9c:9a54 with SMTP id k84-20020aca3d57000000b002d3fe9c9a54mr739862oia.198.1644889912703;
        Mon, 14 Feb 2022 17:51:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y19sm13629686oti.49.2022.02.14.17.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:51:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:51:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
Message-ID: <20220215015150.GD432640@roeck-us.net>
References: <20220214092452.020713240@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:25:28AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
