Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA654BEC71
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiBUVXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:23:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiBUVXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:23:05 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7803026CC;
        Mon, 21 Feb 2022 13:22:41 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id f19so35307065qvb.6;
        Mon, 21 Feb 2022 13:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VaXx3Qk86JeJv7kleYByO2wq6K+x9v7hB3X60NbPEoI=;
        b=ChatnGVzEZo6jZP+SRT1iFWExgywj/SHGnEJamnWV39Dbrv4Eh79NeilPaSrRpSvl+
         h7TzwHX8VcnlTL76zTWL+W0LtlzSIl2M97UYC41wIB05GkckGbC+MxLhgPzMZC6itS5Z
         UCcRfEEfq/ZE2Q3XwX095PMT2cSXRQ0OEylSwr+T3Y6qXtpmBFpm7AXNpIFJ2Gi8QXBs
         4Emycs7palGXh72pGCzPUizl5Sgq5RU5sIDRxNPRJodRqKu/f3kTmQixGWHxa+7uLe25
         BbuUh3stcn+GSConjareTJ/Su0UBjWZugLDlFa9CThBhhDZN1YFOqKwidH11MuGehtv7
         FaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VaXx3Qk86JeJv7kleYByO2wq6K+x9v7hB3X60NbPEoI=;
        b=hhYoWR9ywB+tjdVFYxz4gogSM8FEhP4ReOj0C4CtQOy9DlfR8d7oZ8inPr1qU94ykQ
         2Thq6e2BuSyy6ku5k/8Hfi2e5VNTRBU91CNWm/N5npWPRj1ZXQQvk72SXm7yQMxhRPSV
         /y7Qy3ucCLQDTgBbxPdaPdSz9s8guiEM03Q+m2orjgbfgoEKXVOA62GMq2gwuYnI1KfL
         VV6qye1/ETnGvooWicvFivwoFK+BxnCxrtledkbtXgFKv3yImO6pTCwim8wJ4mo53kaC
         rystCT5fGfwMguAB8xi04IacV6odCinZCaCkHtHqUqW+qihNYIRH/vZ8lVlH40p49poq
         lt1g==
X-Gm-Message-State: AOAM531j5GJcYoC7Ox6oJk8jlpI/XOJiEUQK2UWCKyFGGUNA1g9sfGlx
        5h/LpU0V3TN4hQqsGCfeR8E=
X-Google-Smtp-Source: ABdhPJy3yb+B9ENWtwRQ1HKQ/nNaf186c+yBUovCZZiyhEWzeFXXKdsLTSl2OvxMXVBiCv+t/PpJPQ==
X-Received: by 2002:a05:6214:5287:b0:42c:acfe:cec1 with SMTP id kj7-20020a056214528700b0042cacfecec1mr16347667qvb.55.1645478560693;
        Mon, 21 Feb 2022 13:22:40 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h4sm10629438qkf.66.2022.02.21.13.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:22:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:22:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Message-ID: <20220221212238.GG42906@roeck-us.net>
References: <20220221084934.836145070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:46:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	mips:malta_defconfig
Qemu test results:
	total: 488 pass: 428 fail: 60
Failed tests:
	<mips boot test, due to build error>

Building mips:malta_defconfig ... failed
--------------
Error log:
net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'

Guenter
