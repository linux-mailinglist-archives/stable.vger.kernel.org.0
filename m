Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DFA1414C8
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 00:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgAQXSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 18:18:21 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53796 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgAQXSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 18:18:21 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so3804947pjc.3
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 15:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VLG8/maPK56SKNLr2yTnp4t8L0TJHtYxqLK8FSBIkjM=;
        b=vy72WAyzSSQasq9HbUjrg3RmYtI0feBoyIRzXbcaqQasdTSoh8bCrZS8wj1qS5OHDb
         ix+JfCHG/FPIkn3ARXwVJ5pihxlwF0EWzuqY8J14IqUpdeFxx7AsAykB2E3xX3mOvNBA
         A5Su205h1jqTioIim81JdQb/+gZXY6nnPxfpDbBB+/MJkk8vCbNpbk31oSxcihMauRs/
         5kUeoF2Pt9b1xQ7bWG9iE12gAjuJhVXC/A1N1wIY93iMdDj6tRVPbPQ/IsUYDqOTklSI
         UgwobEyvB3G2xHgMgOeD8xBSY/lTb79pn1iFqfQpEZdLcZ8P+e2CabEO6lk7YCKaWhAu
         HKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VLG8/maPK56SKNLr2yTnp4t8L0TJHtYxqLK8FSBIkjM=;
        b=Yqrc5/K7oZibvOFX5jjZiQKLcpdfUZS/ITLJyRxZ299NwXCoc4OKySW21YfYhgVczG
         djOtCTQ9gyFDDdu2OpqflKCeODbHYLB+0Fq98Zi1Nf5QXauWu9KsSE2mtRYwaFmXnNyy
         ltteaN42GjTIfak5lJftrXTWDiPQcv1JNl6lVvYmsjR+qVNfEXMC3BUy6nO2ueLwnYjU
         PvWJ182t/dX5lBTR4X5vW+w0r+qrPr9MoQkwgYEvVnZgwrhECeB2fEMrar/Dk1Rdac0x
         L06Br0CuB76lnqVOsS8JunioOfanHgQg8ufY8aBrLABD61XnAGpIgPXNPIMSQZDztrOP
         5Y3A==
X-Gm-Message-State: APjAAAVtsPpNBQWRQg4S8g3nnxoK65/Jcv6J9oCrtjwPfh/6ygF25t7d
        GBVfRLSRDr4+uE2rrTqd6CzXng==
X-Google-Smtp-Source: APXvYqyav0hbbsufO88stfLwuT5j7l9xrp4RSPyN0zoqp/A7wZAkTVx0csOHgCvKj9+MAqieRPBHhQ==
X-Received: by 2002:a17:90a:246d:: with SMTP id h100mr8365827pje.127.1579303100597;
        Fri, 17 Jan 2020 15:18:20 -0800 (PST)
Received: from debian ([122.178.20.229])
        by smtp.gmail.com with ESMTPSA id z64sm31598159pfz.23.2020.01.17.15.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 15:18:19 -0800 (PST)
Date:   Sat, 18 Jan 2020 04:48:13 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/203] 5.4.13-stable review
Message-ID: <20200117231813.GA2799@debian>
References: <20200116231745.218684830@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 12:15:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.13 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 

hello,

compiled and booted 5.4.13-rc1+ . No regressions according to "sudo dmesg -l err"

--
software engineer
rajagiri school of engineering and technology
