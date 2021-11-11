Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EC344D6F8
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 14:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhKKNEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 08:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbhKKNEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 08:04:45 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A798C061766;
        Thu, 11 Nov 2021 05:01:56 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id u18so9689223wrg.5;
        Thu, 11 Nov 2021 05:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iEdZUZMaNO0bW3dVZanMnJMMs5RMpgqxM6wjLrMPV54=;
        b=KpbWovepdtygIetwEEJJHIxfpdBGkFf8pfRYkg+g0LZYXa4jCE5jKaW8zf9tQb5fKr
         qd54UlDpGu2C9dJqHYHTAJvYxEYU+1TybUnteG7ejdUU9/XBMvX2cyrZC6U1UMMnmQQW
         HXh6MGFO2+8880xatTmJWEk2aEaKz10Umci30AMoNjhgSHW/IcgODj/lve2BJivHXfal
         1ftm8YOFxyekPpUTXBcwu4l49HiqDL6OuPXO07vdssON2RpVCJDZbqovqO7GBVDyv4hP
         2nH8K4779ZUOkdJWM67/aczaxzYCsf2IsEskIVpiIRIoCmyo6wHTzEJm3N/qUmmrfZzb
         PL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iEdZUZMaNO0bW3dVZanMnJMMs5RMpgqxM6wjLrMPV54=;
        b=BXReK2OgLfsi33sZCkEBTzAxBbdpJTLwghEQC0nMgvHQXqnmL8npPlJxkPip1owKN6
         dmSoPqZtbMrXoJU3l+2Cu6T/xdA3CsaXwyspnfsuCpFFIMMuNjfRWnuc9K+1pFaysGBS
         oxb8VfkZ2a0RjZx1Kcj9phab8KRv/Tz63ptmbDlpXUxzFplBJ2WNS+g/MHx8IE46/8hg
         Repca0V/m8cb+p666Qf4/Iy48BYgZb2KCLWpe9Q2AG+hY61AGhlB0LP+THnUeryNiAWf
         Ljw1sUy0TFER/xTrQQlQmffrsLUCzfZ9o3tjpYN9RBMf8X5NHh7syhwL8ZCCkyFQVnVn
         skpg==
X-Gm-Message-State: AOAM5332Eyh3PHZQwcI93Ct5TMCyqxUbit9do9x2ffzTwyzuDf/AtzLe
        UG/7WQiKD75kOpmZTc8Sf0o=
X-Google-Smtp-Source: ABdhPJwj38Ah5arrFaEqRHu44bvv8+maGvAmpwmS6QEiCd/Bakn6hmXRLxOFn/TCiQJ7fdaHBClYwg==
X-Received: by 2002:adf:aac5:: with SMTP id i5mr8870854wrc.67.1636635715084;
        Thu, 11 Nov 2021 05:01:55 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l8sm10416489wmc.40.2021.11.11.05.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 05:01:54 -0800 (PST)
Date:   Thu, 11 Nov 2021 13:01:52 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <YY0UQAQ54Vq4vC3z@debian>
References: <20211110182002.964190708@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.

systemd-journal-flush.service failed due to a timeout resulting in a very very
slow boot on my test laptop. qemu test on openqa failed due to the same problem.

https://openqa.qa.codethink.co.uk/tests/365

A bisect showed the problem to be 8615ff6dd1ac ("mm: filemap: check if THP has
hwpoisoned subpage for PMD page fault"). Reverting it on top of 5.10.79-rc1
fixed the problem.
Incidentally, I was having similar problem with Linus's tree
for last few days and was failing since 20211106 (did not get the time to check).
I will test mainline again with this commit reverted.


--
Regards
Sudip
