Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF15228B7
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbiEKBLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiEKBK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:10:59 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBAF1CB19;
        Tue, 10 May 2022 18:10:48 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id r1so1006133oie.4;
        Tue, 10 May 2022 18:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iC81UxcnDXTbgecnzWChbiH8S1cGXgQWMkXJenSEPfY=;
        b=h65xdHZpyzKazcQCtSTJ4/78ihu4z3RIei0j80BzkmxyN0yj7DdloOc8PLT0otpiWo
         poXwYtMkMzUtrhN9v6zrX5/stmT4bUfzwGEIIyiILevaSfwFCJc5/41fa0yi/Iyko/66
         Pwo6xE29RuW+/uaNH6b0bgi3tF7yc+oiIDyPFsYOai7zj5wDOeBjHwbeAtG/jKZkB1Zw
         DTojDzn2Wq+/p9tjUuez1XZr2SSjErMWWTpn6KaHF0fxjGhdPVmolIgI5ljCRWsMOHo0
         4oJ8bUOMdmPeByXboXd3JDiDpydsqB8aJOSPIO/U8TPLVFEF1S2yUh9AqPe+ge7tkndQ
         9MiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iC81UxcnDXTbgecnzWChbiH8S1cGXgQWMkXJenSEPfY=;
        b=KLC5agGZhZDPr5NcG/CDvBA0Qtq9C3qmCfe19Cc72/97uziZpQ02KtSuRnMxg+8Ihm
         WoBDtDky3BWfsxJf2HJJBJmj1F4ai+uZ9F+vpovh9N1GqrYt1/pyzl23UdFDUgWFxgrd
         vXanzWEM/xc65Hnu47MKl6pg361acnr/YDus1ho0glD/YPDqUNRXrdSOtY5bMRpXDibt
         pJJY+jbCz/CopqBuspRyVhvUFBw5zdOWbnpuHtqf0pYGti5ZIIxs3RW+hUNkOzmyY131
         pwnAmxibvy3UALuPOYP5UcntIt9Ya/8OdVl5cVJPoostr+nfbxyNWVezhVU0i6KqgsJ4
         c/lA==
X-Gm-Message-State: AOAM531F8v4Q54ac12CjrnQLb2AblpzvptysVY1Y8SGjIrIV7SqlIh0c
        JfLJsU5uSMeKmJ5n3v6mOLM=
X-Google-Smtp-Source: ABdhPJxZp/tpSFeFsT1zK/Z5eokIm3ubkDlc9RZd+oxHeFcgQ86wtF8QW25nBzTc12AZsLjmDW8exw==
X-Received: by 2002:a05:6808:1453:b0:328:ad39:c88b with SMTP id x19-20020a056808145300b00328ad39c88bmr728766oiv.103.1652231447143;
        Tue, 10 May 2022 18:10:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a2-20020a9d7242000000b0060603221279sm280100otk.73.2022.05.10.18.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:10:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:10:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/78] 4.14.278-rc1 review
Message-ID: <20220511011045.GB2315160@roeck-us.net>
References: <20220510130732.522479698@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
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

On Tue, May 10, 2022 at 03:06:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.278 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
