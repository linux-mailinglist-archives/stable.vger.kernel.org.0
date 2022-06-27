Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2282855D6B2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbiF0XmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 19:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242290AbiF0XmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 19:42:08 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AA611477;
        Mon, 27 Jun 2022 16:42:08 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d129so10504866pgc.9;
        Mon, 27 Jun 2022 16:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CsClgpB08hFGeS/5UZi5n58X6+irIaOQJBXsnC0vR5A=;
        b=alaTKMBNWz5w7HFcKo2VyGzja9ciiIxgDyo1PkgNW7DdCs0++c2u5sPDyNBbs8ZdnO
         t1arJkik78SaXKK1Sk9uZcw/x8skqZwX+VL2QFuy/dfoSH47irwjYH2rYsx6yOCbwZjM
         XedeogHEUXPljL2i3wsxetBt6nYlGQfNOiojI4CAEhudlJeyR5zOBrqsNsHMS41Kn7EA
         eHxCg5hDuiOXbK8OV4HOHiuCN/TWV16P+tU7PY3SbQoLvj0OrF14jlu63k2b0I0gW+Px
         PAqg+0e3EcpZno5iSMPzBqMtvBA/VfkmAjENxAkqemUhY2r9xAFkEzCpT9s5gCykNeC8
         xmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CsClgpB08hFGeS/5UZi5n58X6+irIaOQJBXsnC0vR5A=;
        b=7qxti7O6QptbmXNMSJvMA0XwFPLgDExjiJLjN6miHIcYrZ00u/NZpTudu+vAqO2eqp
         bCf8P0BmqjAnTUtSIhSRsGbFTLCDQwKGOFm7zWiRcIqWGmRhfMwPehbQIlD83Ytnolj5
         8hgQ+dTRN8MeXL5VSOVJMo5rO/9a0LSX0NJV+Wjs9vFB0FtpNK2jwPNYQzAuaiYNTw+2
         MEmj54+Tut7pZvN8/lyjTB7xxAgGGrue0xig6Hg/RLC+GjQ4djRzfqvKF0ZlpdSfqTjv
         81wPLFEzjJ4gvlLY0WM+cqA9R6CbOsVMZYdnJGkbZ0TJPRXN1s0nXFd6DMpJj9hYHJKD
         xxBw==
X-Gm-Message-State: AJIora+ZmIV02OA3o4QPb+Lb/oKamJkh2W4Kib/j6GhZnK3L+NBOb0h8
        2C5v9swZ22VBIeWSPAyDOTv4y0/aeMA=
X-Google-Smtp-Source: AGRyM1uoEVpgCejosHvq8sJhc4lwMJ5BPTM6l6BU57sS/tfhvb/gekJsv5FIva2R+eX5MnXdFl2AAw==
X-Received: by 2002:a63:5654:0:b0:408:a75e:c447 with SMTP id g20-20020a635654000000b00408a75ec447mr15126718pgm.296.1656373327583;
        Mon, 27 Jun 2022 16:42:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c8-20020a62e808000000b00525386c17bbsm7882028pfi.79.2022.06.27.16.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 16:42:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 27 Jun 2022 16:42:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Message-ID: <20220627234205.GC2980567@roeck-us.net>
References: <20220627111938.151743692@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
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

On Mon, Jun 27, 2022 at 01:20:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
