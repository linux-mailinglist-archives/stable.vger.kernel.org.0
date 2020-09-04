Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4291425E1F1
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 21:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgIDTXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 15:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIDTXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 15:23:47 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1678BC061244;
        Fri,  4 Sep 2020 12:23:47 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c15so1617744plq.4;
        Fri, 04 Sep 2020 12:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hxw7+emzLGrd/fbHHzNPlcfaWBuPHP704RppLrqURLU=;
        b=GTr7+19dAMgUt8gG2i9fqpoFoOJkaCUkuCkehbDgMXC8ELx1dYT2K5DvMPkueKLGW+
         dzaYZZCBmPsSeLmYHK4fAf8nzq686W60Zv+r3oaGZetZemVpCspmAnLvIl0+Bapa5pDO
         tSqb7DxUhszbrsiZ96EZ4HMRjGjwH8gVCoOpLt7vONXMYoexSjG71AM4H60IvZjuMx5F
         cblkqreDV3OLn88V3BJkyNo8Jz0ajZezHnEGWAEl2RXIQE8AWwibmVpamJZ5p2G0Sfz/
         lXsrk2glNwkVw8Kw5yh9vGLsa6um/wr2ketuFB52BMzvJI+v9uRMy0k8UlmbvhRhSNI7
         Xh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hxw7+emzLGrd/fbHHzNPlcfaWBuPHP704RppLrqURLU=;
        b=Xwa1xUz7QaRzzXRmA2iCYPPHg6SG3TfvZtVhYgj6o44Ebz09Ke5vsIZ5BriYxuNRTR
         WiEybd2u1dceEgFTN8GsR5a315dp+BuVQXgZkZO8rFryq/KyXePE8zF+sT9gyhT8VgkZ
         NI4HSu4m3xrNYpAsE62XaIW1M1h/yeOJYbJvxhAbq+mgb8qB45r2Rly5Ygoq69OtHkeL
         /Q5JSN36IWimGxgGZ+Ysi7BNcJyhCfhTNX8JV/UJQ4idZRkV4FqQ2qIF8D5fSatLWgPy
         eh0jvc8LKv4Vew5PH2gVqD49X40j2OG/lsQUduHtO/fx2k4rr9ay2PJW7Yj1BRHaibfu
         /wLA==
X-Gm-Message-State: AOAM531k+5v1pV5x3QFEr4cOjzpXYegO5TdjPQkFl84fEnGBQITtLjGU
        ffqxcNUy7ZQ9sZgOVL9VCZ0=
X-Google-Smtp-Source: ABdhPJwb0NinZtvp7lf5UsE9m2IIT/9qRIOrcUXD2y7Dytag6euPNx2Zf/jmTYD8DXFMuBwl45+opA==
X-Received: by 2002:a17:902:868b:: with SMTP id g11mr10069757plo.213.1599247426698;
        Fri, 04 Sep 2020 12:23:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g129sm7456410pfb.33.2020.09.04.12.23.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Sep 2020 12:23:46 -0700 (PDT)
Date:   Fri, 4 Sep 2020 12:23:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/17] 5.8.7-rc1 review
Message-ID: <20200904192345.GB211974@roeck-us.net>
References: <20200904120257.983551609@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 03:29:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.7 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
