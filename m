Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB4C64AC4B
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiLMAYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiLMAYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:24:11 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE72F39A;
        Mon, 12 Dec 2022 16:24:05 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d69cf000000b006709b5a534aso1994220oto.11;
        Mon, 12 Dec 2022 16:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fx+fqc6mEdzkeigLOHf1Jqj9EmDUP4oupi2FHz5lir0=;
        b=N2Dvt68/0T87uhWYNbo+1/nd2fKnqfFC3J2R6VV7n3BqDM84XxZZ93zBEZAzrrj2rM
         mJn9MEVnasnZUM5ruPjXkmrp3/QIONzpuWikzCd02jYbrHV3oGrQzztjpxma8MjayFLT
         tXb3cloiAw8jE/FppdP/YCFfCczHq6L7o+hQbOhM86gXivhK77Ld8/J7lQ0TlY3dNIzo
         GLEFFrIKxhBpE/MdsGaM23hGAty6jQYixJg6H1c79cKVaXKNm3OeijvUApgDEBLh2uCj
         0Xh/pVWtTSpVrSguVd6YbGOQrCPZJNtCTSfiwKRCXU2aNwqpIyA95i5c0Qao1scgXUcj
         Fieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fx+fqc6mEdzkeigLOHf1Jqj9EmDUP4oupi2FHz5lir0=;
        b=zxKNnD0HAg/xhW62FjzZ+zJGLTfKez9bj/qT3/nCA7FihjNmWb0C1Aa4WAb77TDpQb
         rtcOilg0YENFxgng3/D5MijVo248DFVH3d3VqJgULQlpsmSe+QFZAn4QaryNOs9uGqv+
         pBlP9XR0o6m2LSA4VnuXxIZI+F6Ft/N7GrMJRPHI2dmDlKGD7eoHEvSFgJLVPTXa+fTO
         E2eYjJZGUg0OY+CxSqKDSCqrwE9zgsRqAsO2LnH1mxeUl8Mfd1sJ7lFUfSwLqmiFPOCJ
         i9xbr6LO9Pls9VGkf7+Bk+SLBAox+V7ppLtK4+r5r2DjNt+OzKymEXmmY4Q26xfxh0sQ
         m0SQ==
X-Gm-Message-State: ANoB5pk3ufx7imdSzXfcOA4OjLDroe0wS7w1nTpXzsvC/JN7i/TVLfc8
        x3BnfSCdW85nktU8+13ZoL6Yr0qC4P8=
X-Google-Smtp-Source: AA0mqf4uVYGTHQm/kenENBv01jhyZToS/wmq4P+Mx7sEIrspVFyME5Z0ROIwo37ky3eQ/TCQXh1Dig==
X-Received: by 2002:a9d:6756:0:b0:670:83e9:5b90 with SMTP id w22-20020a9d6756000000b0067083e95b90mr5527703otm.37.1670891045349;
        Mon, 12 Dec 2022 16:24:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g11-20020a056830160b00b0066da36d2c45sm589380otr.22.2022.12.12.16.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:24:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:24:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
Message-ID: <20221213002404.GC2375064@roeck-us.net>
References: <20221212130913.666185567@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 02:18:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
