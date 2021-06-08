Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129803A0813
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 01:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhFHX6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 19:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhFHX6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 19:58:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939AFC061574;
        Tue,  8 Jun 2021 16:56:53 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h1so3929021plt.1;
        Tue, 08 Jun 2021 16:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1JhxgE7xynYr2Od2lF3VrUTHkJvKEZGSWh7i29yAwd0=;
        b=gsvrMm7SsMGir5ezReyXhGdv5oNhR1sxjkqZ5XHADB3dnvO+D+mZzjlo+l0mv/GcZA
         xxvrlzBhVKnyO1OgzWuCbA7sMElz/zUe8QvEdVoPcs5Zfrty/R6iTvNKAo4OS6b8pw1r
         s4jicLzPgHMtZhPItWNe7GLe+kWZy9tD4erprQ57UQEb0YehTl0RUtG/BI9v2zmNhCI4
         X9YkVOHE5yE5doLOEK6hdXKiPGecDKEZuCsBu/kSmAYJ+a+kJ+0gWPYnDgu6sjURoRwi
         gFhdie9Dzy8hbKUzotPUAEY2fMXFLTWlFOT7eL/rkFDXOMDqNZ9MjJCmPJbAiHb59l/j
         QpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1JhxgE7xynYr2Od2lF3VrUTHkJvKEZGSWh7i29yAwd0=;
        b=Grhk6zldxfnN8XbKi/sluUPpfqP2+Cci27FI2NILTOAsiYtuZNTZpOT8iSzXsDTyEF
         xxyw7xFi8ZB9se3lfFax+oeabEkimCYryThJU5JKz8PbS2D5QgdAzbi2W8XfpSczioAE
         xamsUmoxkuQPeGXc59079KgYgr/TY/APcmrQcOIAlFV2bZ8fFVLZVVyzoKHDagQiF0Xj
         brPGAxBDANAMAvhZNo/lV4rT1VVaDjVtEcqHP6UzS+zenpFRXb1+CPcli0ysEK/pJoQO
         6LhwBPksXzPMxWB7/w+zGRkVHEyAcoXgRiV29I+63KK5wW7RTJw+9MBZJIONX8mVw1YH
         JDFg==
X-Gm-Message-State: AOAM533+dOl8/vFcobPCuPCnHUN5QmDXnhinD0aN+QS0/77TAI0UZNXS
        2sLFgZZ0rU8Kh+TSjVDCxvHnACU1pMJg5Y9bmkU=
X-Google-Smtp-Source: ABdhPJyvz+cK7LyLqp6y0U6sQQXiRsJN9YwdeqtRuRZ4OMfNkuUYnLBzDwF/mGM2KRYJYOE7B70FlQ==
X-Received: by 2002:a17:90b:1e0b:: with SMTP id pg11mr7377577pjb.173.1623196612746;
        Tue, 08 Jun 2021 16:56:52 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 60sm16362516pjz.42.2021.06.08.16.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 16:56:52 -0700 (PDT)
Message-ID: <60c003c4.1c69fb81.625f4.211a@mx.google.com>
Date:   Tue, 08 Jun 2021 16:56:52 -0700 (PDT)
X-Google-Original-Date: Tue, 08 Jun 2021 23:56:50 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/161] 5.12.10-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  8 Jun 2021 20:25:30 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.10 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.10-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

