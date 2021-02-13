Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C311931A9BD
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 04:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBMDUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 22:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhBMDUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 22:20:48 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC74C061574;
        Fri, 12 Feb 2021 19:20:08 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id e133so1253706iof.8;
        Fri, 12 Feb 2021 19:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RAbQOp1eMOlGafWTlI1aXWbSirmwlb3UeG+voOsUkDU=;
        b=AsfUDO5rrYAhkrf5NMUK78l8/Rv01Eteas0Fh0hjh/XgSD2Wv0PhtQauwNQlgrUIEW
         DVPX9flacRvxk5LF/iMZYEcU5Y+/ft/Z4TwQ/kTIiOlWOb2ZpiFnxIu05GCU6JEplYfp
         ESp9nUWq2yhBx6EIZoYn1ftvVJpQlwodMMgw4Ud7A05GIOFjQY6pNVmNQThLBjmXu9Ot
         wOv/51t37q40T1ykl1PvOgCDceL3y39DW/MhzIHh8GMtiVnErl/upyemo7AfFRN7FofG
         5v1FoABJ9UrgEZo1cGTVc4VqRZyenn+MZjPLvPDfj1eSSb6o9vlZ23Ytvb0d7IqyrrFB
         u0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RAbQOp1eMOlGafWTlI1aXWbSirmwlb3UeG+voOsUkDU=;
        b=p3/0RB7xlH9ghQNdhjkEoWjb5kEc8Gf6qdd9KzB67ADZgYG4czBca30cXlFpFEpMF9
         NIYOMgATLdRQBSgyp7uCxnOCRtf0RCO/RFNqJfQk1EEDwt+CdsKC0fGlIjrXpu0Pv/Oa
         toZlnK0EUHCnPTCp8YES1464Hnbj2XCa91HnoULF9pLBieI20zyJIy4yP5uFJ0bSltDH
         qf5meY6973vxgbKRbvcVj45siTnR6qi3Cv0KEtQl1FpkhuoUJTR59usKp/B8uCYJ7nBO
         McRLk2ywEkrPr9KSLUQt7SQs2IffzNkbw2GjtESEftX6ud2pf5B3eUMPQ2yV/b5Bj6Oe
         mc0Q==
X-Gm-Message-State: AOAM532xHUsaNId/zXxNs9QKZSOi72P/9DJZIMjtg192HmWZTBc47y8c
        VOi0+JjBKkUUjhg1Hr5J6dw=
X-Google-Smtp-Source: ABdhPJwvfRtvCd+dhFWj9z1V+guOp7zvHot+MXsaeoUKLE3TVHhjk68OVvR8c9BXOXkn0t9K9+AT/Q==
X-Received: by 2002:a05:6638:38a6:: with SMTP id b38mr5517156jav.49.1613186407574;
        Fri, 12 Feb 2021 19:20:07 -0800 (PST)
Received: from book ([2601:445:8200:6c90::d0e5])
        by smtp.gmail.com with ESMTPSA id e195sm5092130iof.51.2021.02.12.19.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:20:07 -0800 (PST)
Date:   Fri, 12 Feb 2021 21:20:05 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <20210213032005.GC7927@book>
References: <20210211150152.885701259@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 04:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.16 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
