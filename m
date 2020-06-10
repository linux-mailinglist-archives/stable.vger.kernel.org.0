Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77CD1F5BCB
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgFJTJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:09:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83798C03E96B;
        Wed, 10 Jun 2020 12:09:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 64so1504537pfv.11;
        Wed, 10 Jun 2020 12:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UZr3EBJ9g5TmeCoDi0CcH5EwecGle5F9xsGSGI28Np8=;
        b=JqChnaBqznYEsOlJ31e0bh9ekny4fMYkzVRgHrPnrOOD/HgwaohCFpt0qfxgVLJ8Z5
         xTNNX/WA88XCG2AkxyVNH37YjQCVR5BcTi4s6VzLjHHSWlxPU2PJxMat8isa5Yani25u
         ecWfW+DSuVsqhcL+0qMmaGAmEP37ZUTRfBTAtB2FBZldWOWU/+b1oCN3VeGtkW1VEPvj
         XTq3CPvLk2GT0BN8YyoySkmfX6qRL3w5G2mke75PKDjfZWj/c6kMT5dQjggIsWl7hWLI
         DVgGblDPKCEHS8PnRXAuuGtMFFOi1kdc6mPCRpTVvrvmRPyLJa/NqouiukBZQV+8aYMC
         km6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UZr3EBJ9g5TmeCoDi0CcH5EwecGle5F9xsGSGI28Np8=;
        b=rzjyLesKcqcTbsMLfknRjYV38xXaMqHjSwk1tDbcnwZfuoP2HrkDIXUmgl2THT/CiE
         N0vDwaR9GL1sxKW9ZxH2ZcIg70jdtH2IOC8SocAZitVNHA1NxD26oHC1e6j3sDVxm7xh
         iQJ40FIJ1sOz8NdolJ2QPRM9CXuPq5o0ahaVEz4+dBDOS91vi0xmcjn0oL5Wmp44xSk1
         0ARtKnfXLse5JXufeQVVjiioPw41r+ChzL9l8/UwM6lOV53eIafNaO6GZVZMiblGe3GE
         u0UAkAR9cpuQIOLbxvapbjYAdOqZspkyu9zYyC6uDhvyrfavGgOb5PNBO6YTfDhFKbdj
         pxPQ==
X-Gm-Message-State: AOAM533xbUciDiHhlYoEpkLTPPO9FkN/CRjDbyelpCU9PYjmrpxVqI8F
        xBb6Q1iELPSTUVG2EoMLSX4=
X-Google-Smtp-Source: ABdhPJwtQxEA/UE+Z0CSfVOeYyRoQIEicbrKsTL0UYJK2eiNQcvD9g2vvN6490i9lmy+wCQNUTwjRA==
X-Received: by 2002:a63:b550:: with SMTP id u16mr3862988pgo.280.1591816195809;
        Wed, 10 Jun 2020 12:09:55 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y7sm624590pfq.43.2020.06.10.12.09.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:09:55 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:09:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/46] 4.14.184-rc2 review
Message-ID: <20200610190954.GD232340@roeck-us.net>
References: <20200609190050.275446645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609190050.275446645@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 09:18:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.184 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:00:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
