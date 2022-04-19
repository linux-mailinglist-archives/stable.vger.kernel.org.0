Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5294E506080
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiDSAHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiDSAHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:07:17 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BB92DD4A;
        Mon, 18 Apr 2022 17:04:11 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-e604f712ecso2576487fac.9;
        Mon, 18 Apr 2022 17:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+CUsA4QzDZrJ6q2cw8ru2DVTN+KE98+ptrK+kSG7x0=;
        b=XwWPzPwhONf3YquVlbnuVa/FKCvMguUBVYQWAG+wNowRlnLEmdUISSB4ovoCPdjd5N
         rM7YDIA9/I2ceXDnDfo0iG5K/HDkyehuFJYiIRX2Gu2FbSp/l/dAvIEM3kGZJTcvCpA6
         vbdqPcqE91xwZn9G1f9bhy7qnGJJ6TaIl09dM8FSSIyC2BB2Al/f4RIGol+uItYUFkV9
         mip2qfgpdKBCuzDoJa5elHGscpiRnq/KPdlgdFscm8LwZ/vl/J/XSWdTSjwl4KCgN5+E
         S4F0TlnhRd5iIAi85FPOXy2o3uAlhApF7Kuk+IzfeWn7MFXZGxLplefNh/RYbUX7gcE2
         /UOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4+CUsA4QzDZrJ6q2cw8ru2DVTN+KE98+ptrK+kSG7x0=;
        b=iQK0mE7ExEIFUaBGwXbYO9d+IvOrJI6fd+qjWTdx93+Gy1Rp0mTfLSKw0R3xz3lH9B
         jiEbQVYu3TU84K0DIYrebjhgmxPyMgi6MGan5DEfajE0AwwZ3EcVl7Y1ph4glkYPe2ZU
         SNVCZcsE3ir+E9azEG8XwnHchUyKDn+4dJsnrO5oD8lmdPDatEeaLQQH7u5jhSwFk1uH
         iuHUgI8YqAHjb4CSeK6pwt8E/tlyKLeT2KAXXi/N6KwaJSamADWrJ7NOAnaXKGs3Fcq2
         otfUi5/iPHLrUxt2xil7OS98WUWCmxZ6nuLd7Cmd4GiCWOmmSiJQ7I4cukwsgS7JDTYl
         u7cQ==
X-Gm-Message-State: AOAM530M0JnFIa3+f99Iiy/9wSj6Iiypgj9E7QGjgaRGC0uUUXOn8UTa
        2tKS0gUhsQgGosTofIDq8pI=
X-Google-Smtp-Source: ABdhPJyL8EwskGD/Q1EuPOeVEAhkez1uC3qMhVyzRDcT8zsMhUlb1HN+Jeg1rZ1BU1E3QYN8iX42BA==
X-Received: by 2002:a05:6870:f10a:b0:e2:7b61:41f7 with SMTP id k10-20020a056870f10a00b000e27b6141f7mr5268126oac.196.1650326651093;
        Mon, 18 Apr 2022 17:04:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l10-20020aca3e0a000000b0032258369a5fsm3365660oia.44.2022.04.18.17.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:04:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:04:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/218] 4.9.311-rc1 review
Message-ID: <20220419000408.GA1369577@roeck-us.net>
References: <20220418121158.636999985@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:11:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.311 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
