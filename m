Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468F45533CA
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349766AbiFUNiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 09:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349954AbiFUNiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 09:38:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AB62AE1D;
        Tue, 21 Jun 2022 06:36:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id go6so8275807pjb.0;
        Tue, 21 Jun 2022 06:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fx8g3r1KTTzJkYG1K4wZ+U1IUr2NvwFpzxpC63oezXE=;
        b=DFs28vjmWHS7TDax1Jz+aoFmtp+R/umVCUnMqh2fsT65fZeEF17may3CO3LTZ5B454
         Vhi/YCitgRRweC0lw+R/X0tr+7BPtdXnx5ni/kWIphUbTWlP6GRUe43yBbreJc9OUdyV
         Z7bsm8YFDMxrgvfwnEnRaaZ6CnIHVr2UKA/4dgkD0jW9Hc+RDVNq1w86cAazXeUUnfbG
         NTixw3LdhXETmF7iM2L6vTg6yblMMmrmWSlvQZnmDQSMIcDFHwYIGVOat8CWBVzF+nrF
         Kbva7efJeIQoYidHsUEdrq8nRRPn6Sbr/dzw1H+e/rR2WNd9P1wZjy5rQSo4Ecr2/gd9
         MuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Fx8g3r1KTTzJkYG1K4wZ+U1IUr2NvwFpzxpC63oezXE=;
        b=0ogUDlnUH/uYc8mg4ETautNea9ElV+rp2J8v3QQqMyVqv+uwfE67QjA3+gOgMZyAOf
         2j0J0QoM0PDVwOndgc2IPbscefJ/8vKeIYxuic3kTjQh/XXDzYYOModHQivBsiJ/7Mon
         vJAdgrss/f4s/sTTrVW0Aa7DpaKzA6dVbFsX03JEuTpaLZ9o5mzZIQg0+g2nR2cqbtUW
         ZlE2SGZulgiu8BqL7bYiVS+cwEbJQqoQY/VeE+RUirw8210BS+WThc8H8mWIP3NaOyt+
         V6N3Bw+OhHPQ6daelNgIamVqNRZ2CXpYVNPMUNc8wIeAMIq4189VMIeBILKTNug14cY/
         d6WA==
X-Gm-Message-State: AJIora+GcNBfPiOWUzg5sGYiGbkH/xo0YGZxhK1hT3sO+KfDPPHnce3v
        vtdLNMwp1b6AH8s5YGjczjw=
X-Google-Smtp-Source: AGRyM1s2DLwO8bGzRB6zAQFF8oYQj8wVkI7mdb6HuZuN3OXPlsIcJTr9e20AXq5oaQMdJ0De7hNU6g==
X-Received: by 2002:a17:902:7e84:b0:166:395c:4b68 with SMTP id z4-20020a1709027e8400b00166395c4b68mr29425645pla.8.1655818590356;
        Tue, 21 Jun 2022 06:36:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y14-20020a637d0e000000b0040cb267ce67sm4498633pgc.53.2022.06.21.06.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 06:36:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Jun 2022 06:36:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
Message-ID: <20220621133627.GA3436363@roeck-us.net>
References: <20220620124737.799371052@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 02:48:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
[ ... ]
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
> 
I am told that this commit breaks builds with clang. Maybe that is no
concern for others, but we'll have to revert it when merging the release
into ChromeOS.

Guenter
