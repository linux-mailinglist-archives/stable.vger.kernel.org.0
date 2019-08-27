Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4D59F17D
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfH0RYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:24:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44953 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0RYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 13:24:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so13043576pgl.11;
        Tue, 27 Aug 2019 10:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9RJdQrmyKjLb32J8gO0GI+Ezcoe1g1D/7c/GHUyIiJw=;
        b=MsNJ748s9LLSkZzv2KypSTXYeImPDd/unK/uj0s6CAw23GuIc684aj+5yMwTLFKHu3
         yhS206i25sBOKfEJFl/ik52EoEBSBz2OjfhEAN1PhU4HrMO3w3Qjfdmf4KFeK0NXtg+m
         pSlxtOXvsKKi+kb+tkLFr5vYiJXedEh6CWsfRRHRkry4tRh6fO/8cgO7O5TqX+JHeR+z
         H/nIm1sOzhe6r/cI5phqKq3vLJW/Hze3iIcdDKpUCttvOhP1dKYaIzJHZaB9VEFxFTHD
         /u3jlD6iMpZ7VI8mxNc16nKBIY4Qi8py/cAxdWaUs3jhKRo2t/A4FiRmJePfJZcWkb+R
         0WOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9RJdQrmyKjLb32J8gO0GI+Ezcoe1g1D/7c/GHUyIiJw=;
        b=pE/uIyShurxRPW2eDfPRLFgwXEJAjJYBEHLcH8Zlw+yBT1++NKGxAHDOPUFxChxzvr
         Iu1U07GSjHAKWdNKwrKFVgUcYBnAO9tISZLB+jqXDbKqTalvUxeM5xGmvbTL9shqcUHW
         pTD0JPPBN4n1p7r3TptHKdt59vfOTXffDuZSlZbeLko6Rnfkto6NFGBpJwczw8wOJw/8
         Ggi6EVtyVAifw3pEYabbvchedI0Nr13Gjs0Bv+sUDpmH9RRO2D6OoB38FIKYuJpIP4YD
         WyLXaTUXvvauSupq9DWL5UjTLng519jbVrCra8gKr9owC2h8B2bKZqa/POObvcI/PJwt
         4AeQ==
X-Gm-Message-State: APjAAAVZP3r3GTKE1ZDyA0rOvSJO+yWRzlHbBgHATR41qrlc3QBxu2C3
        5y+UVeyr7ZOFaP+6EKFLQ4A=
X-Google-Smtp-Source: APXvYqzaSEGfoqxpwBvATbFDTVlqP/ulSN9kgs28DSxS1q63cVhmX3Qi/N3toDdU8Tyuh5gCGeV5dQ==
X-Received: by 2002:a17:90a:f011:: with SMTP id bt17mr2544pjb.21.1566926693227;
        Tue, 27 Aug 2019 10:24:53 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id q13sm25569148pfl.124.2019.08.27.10.24.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 10:24:52 -0700 (PDT)
Date:   Tue, 27 Aug 2019 10:24:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/62] 4.14.141-stable review
Message-ID: <20190827172451.GB31588@roeck-us.net>
References: <20190827072659.803647352@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 09:50:05AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.141 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
