Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E1D4846B0
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 18:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiADRJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 12:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiADRJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 12:09:03 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C5CC061761;
        Tue,  4 Jan 2022 09:09:02 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id a83-20020a1c9856000000b00344731e044bso1795041wme.1;
        Tue, 04 Jan 2022 09:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U2YI58CWBlzr16v5J8WPidWtDXJijtMt0ufrvo+0HGs=;
        b=NdwPn7xUG+DszJtUCfJ9brWAhyOHgolMch76hx73HAh1UDLAK9BdyRZyh2gjfeeOYu
         6vOuCgQ2j5gl18boCgblcDvNdCUaI1G/ss4gIDAVE7IQeeDn03jJy1jX50NKO0oFkGFa
         xy6AhRtZrNO79HO+BZsK+7ok4JzRIE8skObK6b20tRg2QDh94dmDtMazlhftkZjeQzQZ
         6Cz61K4zl67uv/KzgpnPiT63gu3tRytZSqE3ILY6bnFhtJDWaqoLLBh5V6DAnLdxdIJP
         rThMlakmoUOhttj6uuXA/UsET/SUNv89Fah3rV05MV2ktYM570kN1fTAcPuLztIAl9j3
         puBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U2YI58CWBlzr16v5J8WPidWtDXJijtMt0ufrvo+0HGs=;
        b=hdlAePcCOGErRO1fROYMEVhRdKzywe5HNzoCusSjIi97/A14VUewTHcpdQNfv1by08
         2co+UZzh9r8j74kwSF5PFRi9Z3uXgxCey6IXG3Tk+/39JUPEIHMMEPnsowW4BpCrEqiZ
         UD/CVIiDz9JDYhfEG/cn2a+iSMTWe2jDfUEq/fzhh8Pa+H0xsrY8xWquVXNAY49olOO/
         h9c9cD5R6SfAZcqN5XjA0cPeqSpt8ZVdtNaa09aFTyU0W5XDr950rB5zn0K1GYkBRlaO
         oERmLMjgSrAm7EgQxPrgaoKNafVNE9f9zpp/GLOntBKbfFyFQAclVKa3cL1GimoDoi6W
         y8IQ==
X-Gm-Message-State: AOAM5338t348pSPR31WC3p06kWj94t9Lz4TviRh8ncyl/EIQxOUpLW1l
        8bC7YxIbMAXl+J1BRT3jEgA=
X-Google-Smtp-Source: ABdhPJwYMWCtPR02Cz0ZJfUs8niaqMjO8aRN2BC3tRTOZKdf+I/Mddf0qX874X7DSJJp/o562a3m+g==
X-Received: by 2002:a7b:c30e:: with SMTP id k14mr8154202wmj.74.1641316141293;
        Tue, 04 Jan 2022 09:09:01 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id o15sm33021466wri.106.2022.01.04.09.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:09:00 -0800 (PST)
Date:   Tue, 4 Jan 2022 17:08:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
Message-ID: <YdR/KyQk2GTGAVmK@debian>
References: <20220104073845.629257314@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 04, 2022 at 08:41:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.

Boot test:
x86_64: Booted on my test laptop. No regression.
mips: Booted on ci20 board. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

