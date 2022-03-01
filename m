Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EF04C93F8
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiCATKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiCATKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:10:44 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D42674F3;
        Tue,  1 Mar 2022 11:10:03 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id j8-20020a056830014800b005ad00ef6d5dso13046918otp.0;
        Tue, 01 Mar 2022 11:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L0NIsjd+sUzSHa4g7zXXHi9oRyhIULXRMYz5XkTBy6E=;
        b=OF6dwu9hzTbsZmVjnwe26RhxJEmVyaY33m7zr12Ees5/mo8NHblC+jBi1qcrYaZJCm
         syp7k8Q3wyvWTrbp6WKwWk7bwQNbKgYhSrVyD+XWXIMgUY+rJdR+KIhqQOeUXmctIqWk
         J+DlMXVNfI/kRTWpgLP+jnM8A5MU0xKurfSCU0VRN0GaHS9ycrj9Mdzne5pG0krHT+6C
         fUr1Mo5kC+5FDPoofl3txzHFKh2/rZTmIXirQajXedWv08Z52LBg/SvC5c8TILDDWpmU
         D9wxaB4fXVMH3I3HSUSIWFD/9ZlP8C5WUgTbo2RzJW2QIzJHvGpdlgPFthNNRfjZMurf
         VtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=L0NIsjd+sUzSHa4g7zXXHi9oRyhIULXRMYz5XkTBy6E=;
        b=Wu40KdFBB8CXpArMwWlSYT566eboHCPGYzaumDzTKgdThLw8dbmh4eumeEQt/yDjxl
         QpAcEjv6mimDlqq04j5CA+ORJoHizZvkz6b0tSLiWwCJvNZe+dbopNwZ1QzLbVFoBq7u
         cRcXi47tmy3ewJiF+U2IAl4ez74az3CV91xubBDgEAyVVJukfdK+xG/ttcFUrT2Ug7Rb
         JqOP0kQ8pXeoxAbhfv/CHI70ndAHGNiaICxadEIT9qHzc98HMJVMttOvGH26iH8aYRk7
         z0NzcZvtoe6MYL2XkaM9mg9F+kvFg272wIeYBGkK+7Lq4dsqAjSDMD90Gsao8+SzGCqY
         e5Xg==
X-Gm-Message-State: AOAM5312q+xgOCugPvqJOa8ccUncmfeyZaMX9g15wD/+ukWPyrCmQ9Il
        5baBhBBuECb33AHyRE4RmTQ=
X-Google-Smtp-Source: ABdhPJwRMFrZuyHU3XZ/7RFYTDINKzfvVUG/zqmqX5N3ctzy33LEA7QcB2v10o8YHE56Lq0p36idvA==
X-Received: by 2002:a05:6830:1f56:b0:5af:a42e:fcb5 with SMTP id u22-20020a0568301f5600b005afa42efcb5mr13372142oth.85.1646161801271;
        Tue, 01 Mar 2022 11:10:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ay6-20020a056808300600b002d45f1a02d7sm8240706oib.6.2022.03.01.11.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:10:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:09:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/31] 4.14.269-rc1 review
Message-ID: <20220301190959.GB563901@roeck-us.net>
References: <20220228172159.515152296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:23:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.269 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
