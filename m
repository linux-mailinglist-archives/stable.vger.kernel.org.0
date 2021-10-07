Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2A424B3E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhJGApG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhJGApG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:45:06 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E331C061746;
        Wed,  6 Oct 2021 17:43:13 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id u20-20020a9d7214000000b0054e170300adso5341913otj.13;
        Wed, 06 Oct 2021 17:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Td0Dtgu17zpQt8hn4faWYt5YgHOCJGVHulmC4DGtAWs=;
        b=fVz7KIfzToLqIu9dD1Lf3017Gi/+o1iJgRvOGkfi4WpSqysEN+wuPCVi6Brl/hyl8q
         vR1ooypLkJfMhZvuDXW4OSXvcba4As2+VS77fW5+wfK+QO5FI4FgJxjF63o+i71K4gx4
         721AmgbuRtYKG5PtsJGP1T8eGd6cAl1rpNvf7QDKHb0QRxU+4RW/xroCXB2xiZRVIJUa
         U/yPVy7xJdF3TpGHLOJOouD2ftfJWpkrt2tC9/0q1JAPwl/kRbwHeYHdzFV5fHRrRfks
         cfanT++BuPQUyB2+yMwbZM7K4VhzbsLG/JBbUgqtxl6A0Z2Nu7hKiNGLXQsX53qGeEJH
         7+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Td0Dtgu17zpQt8hn4faWYt5YgHOCJGVHulmC4DGtAWs=;
        b=qARnEVQAcLH6VpF9mKQ96qD/mcEGknr2ifj01FY0m08zzvAiBgJJnbcdBG6FiD6JWO
         +cY/E6beNkKLkWmDvKRJA23hwUJjM5D3z0hWOIXkAFdOFZDMtVqF6bMfMnixMEsrZMss
         3+FlA5FiBzMha2vSoDpdkEPPVkhVMLs5yI7TXivKSBmjwr/W5F0Gsk4+TJXp4gT1OYJ6
         ce2sBxOqnJiuCkV6Z7114b91NNyoy3t0doISvQu7So1alOWx3D+X1sXYtJEjbhGUVsU7
         qVc2Frf1ZCh/EUt90IMBiDC56TsW+kcdgsFpUoDbKU52OvYrdNDArAVu7iNJSBxKGF6V
         12wQ==
X-Gm-Message-State: AOAM532bd18yh+Bzf+NK2f0ael6G0YvZgaRvzobNGYsvIQc+GHpzV2xL
        YGgQU6yzeL8QEvgnbPQCMj2vNL7CvT8=
X-Google-Smtp-Source: ABdhPJzqGJE+IBCsr8BcjoTWvBOSq8xTaTBwOOIa7daas1foQ9Hkj8XN0Xk7TA4ftlfeF0cGcl90lA==
X-Received: by 2002:a05:6830:2706:: with SMTP id j6mr1184076otu.380.1633567392744;
        Wed, 06 Oct 2021 17:43:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7sm4284313oiw.27.2021.10.06.17.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:43:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:43:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/53] 5.4.151-rc2 review
Message-ID: <20211007004310.GE650309@roeck-us.net>
References: <20211005083256.183739807@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083256.183739807@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:38:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
