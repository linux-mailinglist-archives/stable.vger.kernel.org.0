Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249E3622254
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiKIC6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKIC6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:58:09 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712892A278;
        Tue,  8 Nov 2022 18:58:08 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-13b103a3e5dso18367835fac.2;
        Tue, 08 Nov 2022 18:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QcpbjgzzVFNkTKsqUp5IQX12+DRoA8SqMlXBqDMRDnk=;
        b=BP7x1MHZeTKfjeJ6uTCKliXcC55Kdqt6PZ1gN/qCcd9+vDd1pCZ0jftsNlb6jBCtJL
         nbagCVBi4hbBzAvNgaYcAHQBCGOYdTfm67H4WsOqlW+4hIQQjitddz9KHnLDVZxMdehf
         SNW/v56srf9jcc24wRoXxrNvMXSHDd5E7dXQdvmNTEfA8ZyldxUkD9B2UCeQoVLAwgi+
         /k5XpspYqTkbJ8NezdLqA/M1GAegi1gaGsCAVvVk3ucwI+DIobuYdzIga0QC2HWwy4j/
         nJdfbnu6b7pH7DE7X5cF7XXn+/y/wn8hbdKkBGLRuIdtJlQRCUuhmvYnURSydxIU/O0K
         huaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcpbjgzzVFNkTKsqUp5IQX12+DRoA8SqMlXBqDMRDnk=;
        b=ma4gWZU+CL3DhORFjo15qmhCFX97xauzkiV3XaYGGS2M/yug+WKYfCjYTYFwueQGgZ
         I611A5HAGiwC702wxvWn6deyJR0eZw1pR4/5OARzzuhvGfhIsCfcTamN7CvRiWl5zhJU
         F1R7i1uu4JnntYmwmtmzgKWy4zLojsQebqUdNoBQ+3vXT8WAHeNf6Lu4BKaVAbcO8a+t
         QkslP/v4nCp5mG9kUmQnHkPqCHZaKi2pw4kkzB8byLTlWxeh/7iZeQdaLYkY1uYRSiWs
         D+Pj4WLpWDoRLcty3Q+m0q5vEygG10Z4D4QZEwSxnCaJqf0MSc1qJt0WizU163xWAgma
         DBxQ==
X-Gm-Message-State: ACrzQf1o02zjQdx37fNVUW18sklD/r8MWokohY6nr+wAC3FQdg8oAm/p
        r7bOYNHyJfKAzCGtutXsphI=
X-Google-Smtp-Source: AMsMyM593JzbnldN389gZ80F7EJCTHHek5MdHMuJCdC+H+UlI2/ib4+p8kcWh+T3fLggQnr+VS3j3g==
X-Received: by 2002:a05:6871:b2b:b0:13b:6c86:2f40 with SMTP id fq43-20020a0568710b2b00b0013b6c862f40mr34251887oab.51.1667962687816;
        Tue, 08 Nov 2022 18:58:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12-20020a056830144c00b006393ea22c1csm4784569otp.16.2022.11.08.18.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:58:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:58:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.14 00/40] 4.14.299-rc1 review
Message-ID: <20221109025806.GF2033086@roeck-us.net>
References: <20221108133328.351887714@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 02:38:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.299 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
