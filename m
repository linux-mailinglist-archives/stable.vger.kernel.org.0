Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F464A55E3
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 05:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiBAEZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 23:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiBAEY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 23:24:59 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1464C061714;
        Mon, 31 Jan 2022 20:24:59 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id s6-20020a0568301e0600b0059ea5472c98so15026064otr.11;
        Mon, 31 Jan 2022 20:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V2or4QIu1Wi4Eb16oxksjqE+7csYtwTeMgZDLhsCa+I=;
        b=bwJ7exYk20CDWsFMYZuLmLJBLbN7yvo8UVX7zVby43LFiOCXGJZExhkeRpnBALehpp
         4PhiVhYOI/qzW2lp2tDffNTRu5LnBRPwHxI480ecXp6pmDWv37d475DRG+6TZhXbGGLS
         RYnrm62FVN0+48DXTmYMKHnwn7IE5WPovVGaY7rB773h6vRSb/49DElKAbinJNwGCMc2
         eWF9Kt+3xA+Ike6aCrn9863Futtq78YMxz660TL8l6NrosUNqe8GThu2EdETgcKOm3ie
         oB98FLADz4WT2SM3M3FZaLva1WunzKRi2YNLHoiGJ2rR3FIT3XrwWx5QH0/EHy53nPjj
         pmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=V2or4QIu1Wi4Eb16oxksjqE+7csYtwTeMgZDLhsCa+I=;
        b=ctWLybK1F2XmYGMlyMh0IxIpkPkgq3NmDn2AJrJxW9L9Pt75iI0hFfUP3AWHgeKoDe
         mCxdFc5fKmhjOwzRdx3I4xDExDxNF1peB9G+seFEq9ZTeEQqVNgaekwfiqSfQCiOrnVM
         RkhqtcXekUvzVlKY6DTeRHZy+01uuTRQiWDUwKHluiWn1G0BdrxjbcgPfz/egcPqDLhf
         o5COqCWfn6KGR40qSjt17KVbAZ+kmDdOb+vFJgnzDTTlbkEBjnzMwke81i9XGGh10IUA
         9sdJt5QxiVYLL7XHEWo2FKZFQvqiMm88nxlWq9ATDqKLB2/ayQrll/Kkr0WCViERTIUQ
         6E6g==
X-Gm-Message-State: AOAM5319IqB+XYSmAig/16LB5bsPd+dxqFzaReFL6wa6XW1591kWTjcN
        rYQm+4ZGucLY8G12xCmW1Jk=
X-Google-Smtp-Source: ABdhPJxvWtXlXe4yGq42mCr3RF0PEGWIMMpLYIGJNKS6yX26albnKsXoIRU+XgQxHbb/5c/SfMSGtA==
X-Received: by 2002:a05:6830:2b07:: with SMTP id l7mr4858305otv.279.1643689499137;
        Mon, 31 Jan 2022 20:24:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg34sm3018967oob.14.2022.01.31.20.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:24:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 31 Jan 2022 20:24:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
Message-ID: <20220201042457.GB2556037@roeck-us.net>
References: <20220131105220.424085452@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:55:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
