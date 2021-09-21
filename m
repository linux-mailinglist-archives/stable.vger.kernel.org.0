Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF9413337
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 14:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhIUMMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhIUMMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 08:12:43 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DF4C061574;
        Tue, 21 Sep 2021 05:11:15 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so11528722ota.6;
        Tue, 21 Sep 2021 05:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3kx2FjfhyBudUFzxNjx2QAVhSogt6JzlMNHivnMOs7U=;
        b=bPFXxaVgl3NfEM/HRTDMrIroEcC0tfEp9qnzhorm6MhOELy4hjA5dVvL3BBVCqHPgO
         GvWGFW+0SNwGvGEaEu4NZ+K5Km2Hp05VegeJdS4jAUwgru+uE+eHR6hAcqefa4RQvG14
         h8rVTUTiDcBm7TYgzFnPMqdmInSC5OwZ+VAB3maTSj/vTcyuQlihHNrETTetMVuE7s9i
         +xjTGG6VBtSwGPKJ7ThmEWhDTsFG9cBs8RhbQs/7S3Graiawb9NdK+1d0fOiuLfAN3ay
         ySxGeuAd9UoDZCvjuFxtpCOiFbSUfuXOnP/Ff2PkHhcnw2P0Uvdi6MraA/3VwotyO9Qt
         tZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3kx2FjfhyBudUFzxNjx2QAVhSogt6JzlMNHivnMOs7U=;
        b=DKnc7oRhxzhq4UsZn4ld0fgzuJozTjDe8e7uL1SZ1CSaJbXZHvaSgKLYARYVdZ5bnT
         yx3GWLqNUhiQ7ypK9P7PyVFl8GmVTb6XTuw/7+jktBtf814xOWFwweRs6Xn4AT6V+/dL
         Yf8SJ9z532657mhd0x8KM1TMFyervD2lKFPEjebUEtcImSvGkXDeTh9wCnjgmM+4qxd/
         tNFCl2JOFkV9/gahMXfZLx1U7aLlDaFPpL6CfIqh1/y1Ja0sJsCHMAkPlm1IhaYvFX5l
         Y/IstuUw42745fXwQCqydGxp1J7U0k3DKWPeU8k6eC1TkOMcYDY+pSDWYPNBPLQ9KxH9
         +GDQ==
X-Gm-Message-State: AOAM531ulMwqOCi6ItupcXiYo+Rd9WHIBmIcizy0OqzM5YpFLGMxgA+7
        gFR5Mqf0PyLg8IAgoBALR+Q=
X-Google-Smtp-Source: ABdhPJwcpVA+qIYJV0qNV/YQ7IWLkqDaZ1n6JAMJrwIklPcn1uBIlFBHwhxvb1iIkq9BWJ61TIQ2UQ==
X-Received: by 2002:a05:6830:4124:: with SMTP id w36mr26063490ott.72.1632226274286;
        Tue, 21 Sep 2021 05:11:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u27sm4249864otj.6.2021.09.21.05.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 05:11:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 05:11:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/217] 4.14.247-rc1 review
Message-ID: <20210921121112.GB1043608@roeck-us.net>
References: <20210920163924.591371269@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:40:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.247 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

drivers/net/ethernet/ibm/ibmvnic.c: In function 'ibmvnic_probe':
drivers/net/ethernet/ibm/ibmvnic.c:3968:20: error: 'struct ibmvnic_adapter' has no member named 'failover_pending'

Guenter
