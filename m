Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F851F5BCD
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgFJTKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:10:19 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27DDC03E96B;
        Wed, 10 Jun 2020 12:10:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so1313453plv.9;
        Wed, 10 Jun 2020 12:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gavZVcqBHuODCldkSX0yr94bTWekeWExvRrNdmwS3CM=;
        b=CSNYMc5pwj55G0OddO92lMLlQgkPwCJ6mKwfZ3BQkfIWwEeQbNb/dNfsAicpDSO4sk
         p8MZppJVlbUpgsdyOgpTzNHK63h882W/PtzYyBDHgYBP5+u0AxqB3npKJgaGTyWr/i1a
         vgsqVbdQ0hu8Y9bffYCowUmX76LIsnyITadnu9lz2m3VIFGQhwgqKkMD18iYxSJDqqZV
         nd1ZbfLu6n2CB+ozmnb0P3Ge2ylmFXapom/EbUwDQ1eNhvr4coHXYyCbuL21e4M+FAB1
         Qhb6tc5SfHnrRIzeKuPnlkzM/bavEyEKPpjYijKY24GQT4L9hbBXMWJx5PqjCwu7gGBq
         5z/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gavZVcqBHuODCldkSX0yr94bTWekeWExvRrNdmwS3CM=;
        b=M1UZPrjBw0eRjW75CKrWOkvzUowebYO3wrqI6840AdYVm5JgaRJ6kPZptWOioVFH+F
         9LYci8QnfNl8IRU+YKCPnSwdCmKYl1m6HZISGfxm/WRiOGn0X4s6KkrNHyt1g0mEXNZ3
         Tycj6Vfflqccnggt/fgSRPTnaNj/xCqXyJadJzWTb1vd1WLwGnuDZeR34eNQyyVAeQjX
         t/Xz3O+Xb83WYKioM+nSJ3N4J1Smax2Eor+RhgPvXN9KprvpKHt8nodQgpGxp2tNq7bI
         vUXT/RWi9c1KCn/BVOP9XH69/rp9GCmwyxU6fsDISnGr39rhkkCIzUaut3bQuM4Rv25U
         iv7g==
X-Gm-Message-State: AOAM533GxY4ExZgvD2wQomfF14ZC/bePA8NqDPVAWdULYcSPnCFspFln
        yQDPmdURBv5RMGtoeK+JX6U=
X-Google-Smtp-Source: ABdhPJwjzNwuEqs6OpMd14BGGz0INBIHAOLL5kXV4SEOGnJWZ/YGBXeKxYAOAr7AJ7ne2UYTzLPyYg==
X-Received: by 2002:a17:902:7201:: with SMTP id ba1mr4113797plb.223.1591816218536;
        Wed, 10 Jun 2020 12:10:18 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14sm455665pju.7.2020.06.10.12.10.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:10:17 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:10:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/25] 4.19.128-rc2 review
Message-ID: <20200610191017.GE232340@roeck-us.net>
References: <20200609185946.866927360@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609185946.866927360@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 09:18:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.128 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 18:59:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Guenter
