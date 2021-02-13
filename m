Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9F731A9BB
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 04:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhBMDSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 22:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMDSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 22:18:07 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A02C061574;
        Fri, 12 Feb 2021 19:17:26 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u8so1219180ior.13;
        Fri, 12 Feb 2021 19:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0GiEITdkKN0iLUx6HlKsxvLByLgvBtgUPbP6K6GYsLE=;
        b=YmBfJ/4lyWZlmeG3DeQYLEgc0/tJAJVQNIuW0MosSPyu2k45Zg0VNOF0Pue0lfCHMr
         hTLYLS5/UFoyFgy3SYn7CY9xnsej9xQS06TPdZdG62rWOsQsOn19AqE2WZa322FfKYoa
         h6+KbuRqXB5YB1Jdc+3dPgkf+TGAk8YY7Lk/ymjx2UNP//ee4zePv+RlyijlrmbW5Cfp
         RmS6wG1SPJ2Tvf7Cw/Mtu2sw4MlHXEpMOfCqgN8UtapDGcZoTNO3KPWn5tAU0j9ZSbAb
         iKO50qvHKqgEqymSygo/dYSVu6kZexnLn6FqaP8BIbAat/xlLXls+6CXhkN39oOgS/gW
         8myQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0GiEITdkKN0iLUx6HlKsxvLByLgvBtgUPbP6K6GYsLE=;
        b=WkE+vL5V11VzIVosnoPtoKgD20+Z9WmQqfOMWeZbs/4466gIirigmyXhu8fAOKj77h
         kY9GiJN19IsY20VsCst0VLWPqnVX0PsHKhlFRRheKopUWDlqqPZlMnYftvc10S0ppHeQ
         Tfe2DZtcAEjE6887LpCDRpJKs71b706OUqm/oyDp4KmvsWYn6twDQ9vJSs5bmQlqhIjH
         VI81FrftYyX+/Cg9EUeWExzHE8Hd7nNwD9CoM12zGkcGCvTtxqW3kFcpjKrbuNIzzenm
         HnMVAhCdmWehW1ELqye8ICt74JYXyy1bMTUFmES+i0Gd4OMz2PLb6tMuAAYquv8oHRQi
         YZ8A==
X-Gm-Message-State: AOAM532I9Wn0SgN/ISt3S8WhGi6LnwzTqUX1OmYBGzEg0cpoe58EVtwd
        SC2igl2KQdTMkHxPk9jeXPM=
X-Google-Smtp-Source: ABdhPJwy5/+UJwFlQvtYDfd6o1USQv1fY2FEOVpu7E5GTUawz1s69PARtSsFewSXXisDlt0O4E3UEA==
X-Received: by 2002:a5d:9343:: with SMTP id i3mr4639343ioo.138.1613186246386;
        Fri, 12 Feb 2021 19:17:26 -0800 (PST)
Received: from book ([2601:445:8200:6c90::d0e5])
        by smtp.gmail.com with ESMTPSA id f16sm5066213iob.16.2021.02.12.19.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:17:26 -0800 (PST)
Date:   Fri, 12 Feb 2021 21:17:24 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/24] 5.4.98-rc1 review
Message-ID: <20210213031724.GB7927@book>
References: <20210211150148.516371325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 04:02:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.98 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
