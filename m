Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8815279A6B
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 17:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgIZPmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 11:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZPmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 11:42:53 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF08C0613CE;
        Sat, 26 Sep 2020 08:42:53 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id i17so6209249oig.10;
        Sat, 26 Sep 2020 08:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=92Eqn2qMAPQE4mm68EDXihszegVaTB40RjIm0gmqBiQ=;
        b=Ri8Dr1K/SH8oQnVHzVjtaXmQPG5l8mzXqdyysnccw89QSDA2DFO2o8z+G0LyiijaMn
         CUOXp9EPlALrzmygAlt6fV2fweBL0K/v0U+dN/rtOma6BnnP/d1X91CDTT/L8OiWR8N6
         xe/D+Eos0bSJKzbzP8bRXcMuXG7jM+aR0JEewMr6QfxdRCifUA+iNfPh14O270qbrtU2
         9DkMuvDSB9ZO2jyfmfvGvp3VE+BlhIFFgBM5AeYfrGRrWqkQI3s5nR/e43ZfF1MAS1gt
         SXt2g/O8RARjr5IBSxwesKY75tFp/7RE9vtfxkvssqST+z81knOz+OSYrN0+bzZtbeOW
         7w6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=92Eqn2qMAPQE4mm68EDXihszegVaTB40RjIm0gmqBiQ=;
        b=bBRI4PAoY7+gzY/EQx9k+IqxK7L6AlBqWt3o/CSAI6kmPA3ysHlj0NHKDm03+qAA7l
         D/iDtec39hCdTS+Pct6AQW201U6LUsP2PJTtIzey07VtAVFrdnYLGv9taJqpnaxQA9m6
         WGNrYSksBwSH1aw9RcVsgjpIK0ql3tGqf1Mge5ruxRkhuyqueFTnKRNUUgxvLt0QxsP3
         4gx7lPQC1UOSMKsGt2/3fnkO/lfZmKfR1ncILZQFYD5qFFeC8sbtsTSLv09WX0gJD3fD
         iYfmKlHOQOZgot0sjZPyc0EqJNw5BtTcnKw854hzaQo+iq+aVwdP83Jw42iRXiE/BQ8R
         MDQg==
X-Gm-Message-State: AOAM530FKrHCEkEGijVufOqfdJhf40qHNsv5NrTi7crKQsxRccMHHmRc
        7ELGI6bS2Gb0j/eul5gkmBST/zDjY5c=
X-Google-Smtp-Source: ABdhPJxpCpZKqk/Dcyo15qBeC4B2USXBDYpDjna4PVCSHuK3TYsVOpTbc94stmuo771NvP0E0CAfgw==
X-Received: by 2002:aca:cc07:: with SMTP id c7mr1596532oig.82.1601134971158;
        Sat, 26 Sep 2020 08:42:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z10sm652059ooz.14.2020.09.26.08.42.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 08:42:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 26 Sep 2020 08:42:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.148-rc1 review
Message-ID: <20200926154249.GA233060@roeck-us.net>
References: <20200925124720.972208530@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 02:48:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.148 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
