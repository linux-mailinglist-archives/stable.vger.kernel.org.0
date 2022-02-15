Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324EC4B6032
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiBOBvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:51:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiBOBve (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:51:34 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D665D4;
        Mon, 14 Feb 2022 17:51:24 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id p190-20020a4a2fc7000000b0031820de484aso21480228oop.9;
        Mon, 14 Feb 2022 17:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DhqG/PLTb6WbbpznoHGV69aSzZA6+2ry1fCIPZUCZOY=;
        b=exCKpPFtD8iwQSK7k2h/QzJ9yQiEWrmrB4aNg5Q0kVsZ4GJ7cOa6iEgL304HZbgzTb
         2ovR4lzs3tjv7U8qBOvmDdalVmvhFp+Zm7xdoQnbAQFmVc75Kq2ZOgPXSR5CU9iFU87S
         MXORx1SP6QpTFwb39GAE1+xR/o/UwNyk6QVUJL5vw4cIFYruSZvfKWbgkOQjvr0/a1xJ
         URorOG/NobzZCVnIPqtarmUDAvK9ZP1tbZ22qkVeFst8rLiqS0t8AkdZ/sILtT8MFVww
         OENrBup2brVCtKQTpflTbdulmcYpa2ObvStxMwbkYq/5l/p9GcmEAo/LGdAThjnPP/9c
         SdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DhqG/PLTb6WbbpznoHGV69aSzZA6+2ry1fCIPZUCZOY=;
        b=Swz6S6RfROs8cEjJ93xxxJDSZO4XxgVXgq5Pwu1cYRaKRHOqoPkSIObuYWZ8YITD2a
         u+bZvjLDBZDLxV7MpLqLWQ4BC6oXCC3akMiXIOAIBwQYuKLczbYMNd4J6Ei3NOzVVTQU
         tSwQzHveqhjvJQpVINJdK/GDIAugbbkXR9Ek4pOJR9omBrzi1Vzq8NdQjOIHbmwtZ20d
         TubyEhcDKf94ch0AWUVxiT29jpocm0rHxF8KVhP4in6P2FLMf9qS3zk4N/abhLzG9zop
         Lak1LduTDFA60w6fHVNp5afwlUsycl2IuWGlHX5BTppwV6Uwt/aQjY1/uKdgnHn/5yFj
         jMKQ==
X-Gm-Message-State: AOAM532jjMq/CutYUGFvR4X6YAyIEMHe78dlkNXaFw85pnahJ9YI4lOE
        xcZ/Vnbotdo5c6V4GXG+5p6/oz/UzE2jiQ==
X-Google-Smtp-Source: ABdhPJzQFtIZygDdtAhV9SHbWHE5yLJrHIAn5sYqtbG5so15egaiIa5BDb61roSoX5ijivd5Gm9PDQ==
X-Received: by 2002:a05:6870:6691:b0:ce:c0c9:5c0 with SMTP id ge17-20020a056870669100b000cec0c905c0mr604805oab.18.1644889884024;
        Mon, 14 Feb 2022 17:51:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q16sm5737558oiv.16.2022.02.14.17.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:51:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:51:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
Message-ID: <20220215015122.GC432640@roeck-us.net>
References: <20220214092448.285381753@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:25:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
