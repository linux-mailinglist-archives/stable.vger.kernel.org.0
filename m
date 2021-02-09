Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19523315603
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhBISai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbhBISYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 13:24:41 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5891C06121C;
        Tue,  9 Feb 2021 10:11:06 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id q4so8683164otm.9;
        Tue, 09 Feb 2021 10:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mghg4abcrODrzjxbyyBe28yhTKPCVNlRigD8jNPstQM=;
        b=OtJI/SHW/Xj1N/DAheU7syLwDZ7zayvWvIp5+rYNRu+VF7vjHq9bWrt38ZObbVG9Ih
         ZYfia14NXlNOKNFvoSwdUIcp+NrQaeYNf7soT8BUkXko4b/LuERU0wb4D0z6bY5ah9Du
         sxM4xQVy6XlLzYZfO6e/sYPb53Bc32E4o6Jl7U39uHvNzd2qHV9gsYTwKikEPeprQDPf
         NRVkdJ3S6iPuRO//AEDNS3Jw2S2ukc06EPY97YgOEjSgAqxD8+9N2LIBv8KdMh5HU4GJ
         BaXPuz1SERC4diDryDHOdij6w0638QOf+/10HNqzuWj7LaZ+Y/uNCZd4FmZxGzT92N8v
         YLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mghg4abcrODrzjxbyyBe28yhTKPCVNlRigD8jNPstQM=;
        b=Vb57cbEhhlrvt5OuwMJgkGy6J7GntdeDmVaLXq0E2PRLYahEA/6BD2JCQDGYsRUg6p
         opLMDCiH7dIxiZ0Ywj09yBJ/4vgYP2ko7FvDeqh5ijmSKotX8IfSwFGIYxwOLiX8Efdo
         6Wf6Xfz3BSDH1Ra8tLqK1IXb1XVJjAYtlZ3X/SogQIkNGdQAxsSfwwsF01MIhu+lJmF4
         ltrmIHgsnLdlW/NQRLMp+szBCp4bB2h80jMRamNmbn5WvBvHb4JE3Gq5PmIK8EsllV4a
         me/xXpoy/KWq/e+OSgWYUw9CofpKdiqN2cpMOODSIALhHPMXQ93ULQzBs9mR7bSHMRZl
         gFnQ==
X-Gm-Message-State: AOAM531oLKd04FFXFoGvdrSDDvuJBUggLxsJDBKjyBFUySe9ozH3BRF2
        YTtAej2yrcUajUK/pG7HBrI=
X-Google-Smtp-Source: ABdhPJzhCa2zWl0LDIfrHI58Ug+YTfS8RkSBdWDKyU8WhJf1IdYHhrf3ryP9eevLKXK+j12PvGwLPw==
X-Received: by 2002:a9d:6d9a:: with SMTP id x26mr2979941otp.178.1612894266383;
        Tue, 09 Feb 2021 10:11:06 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q8sm3830092oth.65.2021.02.09.10.11.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 10:11:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 10:11:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/38] 4.19.175-rc1 review
Message-ID: <20210209181104.GD142661@roeck-us.net>
References: <20210208145806.141056364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.175 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
