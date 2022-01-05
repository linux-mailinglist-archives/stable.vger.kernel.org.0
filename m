Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EF8485019
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 10:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbiAEJgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 04:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiAEJge (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 04:36:34 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761EEC061761;
        Wed,  5 Jan 2022 01:36:34 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id q8so1105745wra.12;
        Wed, 05 Jan 2022 01:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G5USAhnPcOQaApPKE6/XINe72jhys0o03YHjx6AUo34=;
        b=fsWL5e4hpoRPKa4AwJGr/Tc3cHHvU0gkNXf8PvPGgQES9lshAdQnBHWxGrKVRaSoeD
         QIbtT37gS5vxmVvbiZV3EVvYdM7+jMzPD3E/GOpZ0XROV97JnhekX5g6Ua3coVqLmtW+
         KjQ8vD2Lvsi36leZ/oEhCCqMQoOR95lLSz3imGTZ7HhYRdZPViaJ18wvjktLwD1YJR3R
         EnBWemFmE2bEue4qHYGk6Rju8zUdR6bkgUwZwrsqwyitlMuyhrHfXiWhYQ/QxRx8yw0A
         r0Xa69GrdAw/dVFvyYqfno0H7mJsa3AIp6MNG6EeiEJqVnbZV0LTM9jkQyAsTrQL/CvL
         Hlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G5USAhnPcOQaApPKE6/XINe72jhys0o03YHjx6AUo34=;
        b=jO/XK1NH37LFRPIs912310ujxvLput54GhxLBZPYqc2sNbqY74dtfEh9zGPJN0WaQ4
         1xs1jjvEyu6bCtFzOV9f4eiNKW/wQ65rjE0PHlay7b9n0fo++OzyboBhu5YEc1k6RMrI
         W+i3Mk80Mx+w1UAUeqRbrcRYInDigs4akP63TIh/fqL6mb5Ws7HxzFT8Uksm30aLaHA6
         TLVoQqf2DV/5hnlZzf1l75Phnah90A1A7QO/ZXI3HyECftZH15tEkPSnTP20C/4pj9ws
         28XxLL/CqI2wZcnewrokz98dTczBncQLHfLpfBgd3xlVg9W5XCn5qY8TSVUwc5gj6P9D
         mX8Q==
X-Gm-Message-State: AOAM530N+qEWZuzEr5MtbFXutdSykNVJg83++seCpqNyhNlIr+tpve4U
        9dQlxRZTLtEq0xpN0ZmYbdw=
X-Google-Smtp-Source: ABdhPJwdC9wVwlx0zRMBIx7aPepv3lNNgST90u8OkPcKbWGIOrC8BNXztzqtnZWjsOou0V0ougBZNg==
X-Received: by 2002:a05:6000:156c:: with SMTP id 12mr47004320wrz.502.1641375393109;
        Wed, 05 Jan 2022 01:36:33 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id q3sm4408822wrr.55.2022.01.05.01.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 01:36:32 -0800 (PST)
Date:   Wed, 5 Jan 2022 09:36:30 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/36] 5.4.170-rc2 review
Message-ID: <YdVmnnqBwYzJy138@debian>
References: <20220104073839.317902293@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104073839.317902293@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 04, 2022 at 08:40:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 65 configs -> no new failure
arm (gcc version 11.2.1 20211214): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/587


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

