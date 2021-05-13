Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E368B37F558
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhEMKJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbhEMKJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:09:42 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE9C061574;
        Thu, 13 May 2021 03:08:30 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m37so20882246pgb.8;
        Thu, 13 May 2021 03:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xQb5CvUR9D6dHtw0MyFND36i9V97kRHy15ZIJvGGGUk=;
        b=QiXkD0QBws/AQG/BfSn05N3ZLJHJJkvz8UarLR+8mKyybHu7E//gMl0STXd8W7cbOl
         BOjHWWG84iiqJt/o22sPAYsIuMC8RwOv8eTuQ7rHWM/LLV1OiNpmh8/g+PyE/QLF8PwK
         VzNu4NJPDotT37FzPD71WNzWjuv7cYxGWWdOcvJlpZr1jxsRPee+9QagTjmFPAy7246K
         sJmwdQu70Wjp31kopZOjlSDrSgOJJIgSj0NuHRAwVudKHI4zzBKukAtnAklPX9AlR887
         AuQq3oKvd9/BtSPjuzsxknahQHzHuwQlJtq4Lnr6FgpKna152RVNZxDTphvLMQ/umN2N
         rbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xQb5CvUR9D6dHtw0MyFND36i9V97kRHy15ZIJvGGGUk=;
        b=X+1lxVlXs4RV4rUP9JPKGGUqhDCMCMDMTzV7+EBN+W44/R7DAoGCov+yPRB/uTkDlE
         ehCW+Q4EkXpm5RLZwIncxBAhr0NfUCkevwjD79iNFqDm3XncwrvQa62oKJqcckAyyknT
         Jifu9FH6zk9XsaeWL7bIxIN1JkDjnos2wiX4t2nNwjUq82oqs2CvY4tQKjzG5AUk3FFV
         lQxlKLMw3v2huYXnMgWmJKicnvBaMTUXS2lUkbyWsnr/k8NH+64lnHGxWylcTHA/6Aws
         e65qT9RnSATDQbxFlo64Eiv8r9d0m4y3cOpNpZIYzyOxALp8kwGd8DHP1fCXMi585vf8
         siEg==
X-Gm-Message-State: AOAM530w7ltY65f1wnBPLm49FTdIgnPC4trVXSwcBCWPF96WvAQHo/nE
        aRLVPGYEHPYT/0PAS2UczTxWUYyuHUKakn84BTg=
X-Google-Smtp-Source: ABdhPJwpkiH7b3/dq3zw7Xwf1+TYbstSmXyDpFMjckVzTQORhe7uzYP5cylNWO4Igs0aT6fUBMz1TA==
X-Received: by 2002:a63:5c5e:: with SMTP id n30mr6770320pgm.87.1620900509829;
        Thu, 13 May 2021 03:08:29 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id z7sm1756531pfb.93.2021.05.13.03.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:08:29 -0700 (PDT)
Message-ID: <609cfa9d.1c69fb81.148b5.67df@mx.google.com>
Date:   Thu, 13 May 2021 03:08:29 -0700 (PDT)
X-Google-Original-Date: Thu, 13 May 2021 10:08:23 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/677] 5.12.4-rc1 review
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

On Wed, 12 May 2021 16:40:46 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.4-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

