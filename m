Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B545D2E0
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhKYCJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhKYCHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:07:02 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CE9C061A2B;
        Wed, 24 Nov 2021 17:42:56 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso7148426otr.2;
        Wed, 24 Nov 2021 17:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8yycEtvCTwYHY7FMIHuHn+PYSsoxHgTHG9Cu2SQ+7og=;
        b=ZBH0QvZw534DMbYYdA5idoP3CZ09jA9kNZatWg6oEVYt9yd4WAdHzZSKbd6Da0tPSK
         v8vLsh3i2KpdxKkOkvffweGeSLtW2CL2fOwcm3uB+d7LuxBvV/pJDMY8IR6dJpfXddT5
         yIbhipjNXPVOSDJD+egmiadKR5avlIxkWr3TdL97o3z8dshDLPAwd5OzJTpk2YYTZ/og
         GPqAsas+kDsmL7gXpNluyGJEIotYcciajpdCvRwghmI+0SJY1KyREY8Ab6HwqzUruv5O
         GAIfDmZNd6nalBLXdUgw/R8fy3S0jl47h1/dxH6fkB8r1tQ3XV4XZDvKasY0LCxTf7RR
         VC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8yycEtvCTwYHY7FMIHuHn+PYSsoxHgTHG9Cu2SQ+7og=;
        b=JsDYYotDY9NYnYhSLDkq6gQ9jUvx43R7bsXP8har9M6EsKCXjPohcFfE3rjo64GxE0
         dhujggZ0DT/SCLLkBhrYcmK/l3ZxvfhmYc0DN0K36BoDnD85jOyUKrm1fEE7FNZSw6cL
         IyeK2mqotyrPEz+uTf+TBRpKZsDtCVl7X5OBTOL1EtOkSzMmjA9qdGTW1D4JGvbFABTd
         KPE/l/0ehnObpG+XJJKk4OavS6Bi8rii03ovsbIriH549L/tT+dNtLXjo1f5Jwqb23r8
         vX87PaZPXVJqqRqoQDB7DgOfeo4d5ODJUv1vVUoLWXl+y0Pk1pFXrkh4PT8Js4mihOwm
         sDRQ==
X-Gm-Message-State: AOAM533OBBKF8CrbBU58gumL6rir1FN9m5lmc40VZiYgdJ4VRAwXT3dl
        q3eEkDxGF+zG3sbaYOWHhFQ=
X-Google-Smtp-Source: ABdhPJzdmI2SotCTdF/+UB+2q6TTzAd5PTyexbiRFeeVF+wmH8B0VOm6xGKoAFxQC/j/92beJYX3jg==
X-Received: by 2002:a9d:74cd:: with SMTP id a13mr18461951otl.71.1637804575418;
        Wed, 24 Nov 2021 17:42:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg38sm415283oib.40.2021.11.24.17.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:42:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:42:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc1 review
Message-ID: <20211125014253.GD851427@roeck-us.net>
References: <20211124115654.849735859@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:57:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 155 fail: 2
Failed builds:
	arm64:defconfig
	arm64:allmodconfig
Qemu test results:
	total: 446 pass: 402 fail: 44
Failed tests:
	<all arm64>
	<all arm64be>

arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec

Guenter
