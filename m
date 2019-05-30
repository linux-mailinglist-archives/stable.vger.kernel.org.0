Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02444301EC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfE3S2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:28:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34291 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3S2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:28:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id w7so2898813plz.1;
        Thu, 30 May 2019 11:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ckrZR/Q/YzefMb2ZzrgMDkeszmcs4+iDC3SsvgiWOQI=;
        b=rZHOzPr8PdYtdkMCqr/t0mJ5BQvBM/ugfdYvKv1tmr84i3UBYtRrbZ1vKRFqqnKVD8
         s0OYBaAZxIVqmMs1PfG5LkHUrPNSp7rmSHEnTGuU27OIT8vB2vvYq3whKuHEvbFbABgx
         C21deRHvCarAZMZyWohXjrhfmzUcGlpIeHk/pV6zx3RMz7UL7gQP5I6SLco+Tpcdgz05
         plDXG1vubDkdu3IHJjBLGpPAIhg6Oexwek8zVStyGe2MWiC8+YXMle2qOIpTfqYpXc7S
         XYo25Fv4fTSGp2mcaztcInflMiIBuopI40J+WwqTPUDHeA03ZY1JE/Uim9jE4D75pnFj
         tqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ckrZR/Q/YzefMb2ZzrgMDkeszmcs4+iDC3SsvgiWOQI=;
        b=WyonarBTiMyyPcgeIvaqW7+sRuCyw0A8DjhpTi6Xiwf/XhoyKbEk2GvLLP4FJW91Yf
         X8lpSKjmszfUoe96dcZYDR70g9xjGnm9N9B+2frheM49950jWCYJyEj/FksAa0ZBFdS3
         RqllOJMroV5qkLMQkonzRB9ys24tbnacMKvU1lfTxmfszjx3CGMDgXi8kV1yLKgbwUB/
         qDrWc6Mv04YOxgoPMs66zP+DP6YaLvHEZUyvLjwxenQfLIr7tEl/qme0dzU9cWVK7GMM
         ROMyNdQqBTl5Pp0ePBf17JAwfZJ4tYJlIfLyaF+hBGbASVj76UGSO+L8g3llZJ+ALG5q
         LBhw==
X-Gm-Message-State: APjAAAUC9HbMM+bJjIdsX4OJRB0ZgT66F7PzGjCTyg0lnGCpY9OrKLf+
        CyDFhofBGJHAFPgNEDN+Urc=
X-Google-Smtp-Source: APXvYqw0nZRYuXfqpytdhw9pK2wdLd+ze0nwMET4KP9HKk+iyQMcGrDAKyeco0Dxr68Usc7jEZM6zg==
X-Received: by 2002:a17:902:b905:: with SMTP id bf5mr5001237plb.155.1559240889143;
        Thu, 30 May 2019 11:28:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 79sm4110663pfz.144.2019.05.30.11.28.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:28:08 -0700 (PDT)
Date:   Thu, 30 May 2019 11:28:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/193] 4.14.123-stable review
Message-ID: <20190530182807.GB22970@roeck-us.net>
References: <20190530030446.953835040@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 08:04:14PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.123 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:04 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
