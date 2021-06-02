Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D02B397EEE
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFBCYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhFBCYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:24:11 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0FDC061763;
        Tue,  1 Jun 2021 19:22:13 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i14-20020a9d624e0000b029033683c71999so1170680otk.5;
        Tue, 01 Jun 2021 19:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8NrnK+jhhyGoce/qrAL9mpHbdvNlBdp3TQPcFeDTvvA=;
        b=cqscyRVUULAy3oWM49EmKiSCsVZOFOSyV1hfOtIrRkdh/shfrrrtboEM0fo/duHIU2
         rdLfKCtnSPzCPvjChyfSDo8QBSnYfPTSoeFCLw8kEGiVKIhM5sUr604DjDqasj9U62FN
         fWE0KrNOmxmr9I3Dj9VFEfra1QAlXCVg145Nd6sRLpqR1DM4VdnC2tfG6HV1wryeez6K
         QeIVfhB8Nb2NVFP6hw+KbGeAS70wC0LLp3XmKH42IJ2Bij5FsqzRroElR/WIo2O3hVLx
         tfv4OEBRKLWwfi5YRC6JO2/H019pnkVsl5jNQZ4/oWpw15TMd2775yfJyOzrN/C646BI
         QVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8NrnK+jhhyGoce/qrAL9mpHbdvNlBdp3TQPcFeDTvvA=;
        b=nClSWCPgDr6VyjcnCv63/3i8L4WNwMkOReTcdm3olsKrhGSh+8E0vR3lnYT7JcUmp3
         AuyIH3VxrA+51UjFRgjPsvcDrx2VLryVI0zl4eFa+xBju1aR+72YuLDPkST2BaLQQ/Ur
         VVPfQl8x5QRC6KQgPqvC4qMrjzMKL3l9i3AyxbV+yefAOGvWt0UU1z7QNGenpgtU2hoe
         DVuSWdRw0orgt9IPA1Ncwf6DdAmThS/uxwCtJPwjrv0BDE6r6ZbGHfXUUplLzZPBRWHg
         jihK0jXX+eogZl84/CIA0wEiVXDH7M53Lebwikx82imexF4lAKbGitJktWCCjCFZdLJi
         3J7w==
X-Gm-Message-State: AOAM533OzFRR9+mtk1MUtsnNAMb6/BYVDmcxg+shiu6FJ/YUOq41pXrc
        FC0Fewmeks3CHLQrcCSkINo=
X-Google-Smtp-Source: ABdhPJybv2TxXa8UWXR7RLfS0jXBmehNcBpsqiWlHGyk8Ixr+rHmjnOxas4/cknvKOP6oxjQPs61Wg==
X-Received: by 2002:a9d:4008:: with SMTP id m8mr15029676ote.188.1622600531946;
        Tue, 01 Jun 2021 19:22:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p9sm1520008otl.64.2021.06.01.19.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:22:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:22:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/71] 4.9.271-rc2 review
Message-ID: <20210602022210.GB3253484@roeck-us.net>
References: <20210601081514.670960578@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601081514.670960578@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 10:34:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.271 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Jun 2021 08:15:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
