Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D854A66FE
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 22:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiBAVY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 16:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBAVY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 16:24:26 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB664C061714;
        Tue,  1 Feb 2022 13:24:26 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 4so11517076oil.11;
        Tue, 01 Feb 2022 13:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b0fqg0YjOgI0na/PpFxcGdWEd+ryXtcc0AF9fu6mEbU=;
        b=hkS54+upYVeJgkhqb79102LzaZaJmt8Y5reaLHBQYMteyfpN3DWGg5uUOZN3JMSMuB
         2iR42G+RUSHZLmV94uBn6wQjN0clDhLRIZUKi4Gtx4n5lm7gsui0A8IOhnf59Rn970jg
         6pHMHwI3ToLtDX5VMmwJ5nNMdg/99M4rUs/nF7UfiGoJlO3dHNjIZ9HMAboDs9wpedRl
         PN00DllxI3c9WnHLAEW/LyaAoVouAzmGacTbTIw6vuCnNOr6IfUeq/Pmea4UcQ8DHn8+
         7k3B2EKlFi71siPfFKppnFnFsKUFZKaZkq2mnFTo5fko51Off7deXDkyfLqQAtxZR+9c
         eKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b0fqg0YjOgI0na/PpFxcGdWEd+ryXtcc0AF9fu6mEbU=;
        b=oLo3bScgVFBzA+UNaEJx42z5woKs+fUCG1ohIZIs9egNPwfBDEDLce+juoipOz/xqt
         +SjSYyTgV+dtwfXqT+pfcrtmCXwKBo6FW29UtyWlsePKW0EghlMpC8kWW0Dgjin2EOKf
         5sAbGBqqYHsw4va8CztOfHDSTClAlhdb2c+dXNA/Dfw9HP/KNwqEfGFaI5EI7bPXNKMr
         fWD/uswIVua/XMwg/CRdruuszqZ9quoGvhb8j2a6/Ia3iwZW35CgKl9lOznPFo14uKwF
         o5XHKnwTCxEqaBi4KC63JYiI0u2Rt9Hs8Zggdl6QimKvBDUIpfP/FsiBGJRWQhzDtY1x
         qH2w==
X-Gm-Message-State: AOAM530jHVLrm78CqmrSRvuubNJOVnzgNu7VOm6SjyVdH0QAE51NG1Gb
        YxM91qE1yJoU4ona3Gs5z6w=
X-Google-Smtp-Source: ABdhPJyP6hY+s6pbdqxFUlHg/brntggo8TwY5PKdX8YwoDaDmQdqsaO1Whb/wfn9YzE3aaGEtSUFFQ==
X-Received: by 2002:a05:6808:1287:: with SMTP id a7mr2519209oiw.123.1643750666125;
        Tue, 01 Feb 2022 13:24:26 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g17sm1718122ots.73.2022.02.01.13.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 13:24:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Feb 2022 13:24:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 4.4 00/25] 4.4.302-rc1 review
Message-ID: <20220201212423.GA1830865@roeck-us.net>
References: <20220201180822.148370751@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 07:16:24PM +0100, Greg Kroah-Hartman wrote:
> NOTE!  This is the proposed LAST 4.4.y kernel release to happen under
> the rules of the normal stable kernel releases.  After this one, it will
> be marked End-Of-Life as it has been 6 years and you really should know
> better by now and have moved to a newer kernel tree.  After this one, no
> more security fixes will be backported and you will end up with an
> insecure system over time.
> 
> --------------------------
> 
> This is the start of the stable review cycle for the 4.4.302 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Feb 2022 18:08:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 342 pass: 342 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
