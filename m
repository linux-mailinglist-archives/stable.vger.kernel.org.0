Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531AA501FFE
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbiDOBNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240327AbiDOBNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:13:40 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F08506F5;
        Thu, 14 Apr 2022 18:11:13 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c24-20020a9d6c98000000b005e6b7c0a8a8so4554363otr.2;
        Thu, 14 Apr 2022 18:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7d7LDFC+hAF6nPFR7L3PcxLrotkue7hFcEYskmEsUiM=;
        b=NuxMc4FQYcSfO0TCUzaJmy2KpH/A0K+vMlNqKE68AIsUndX6aWvsEVF0iolqqURwTG
         J6cY+eVxOFdZwK7yT2G9cn89fuIISCIKlRFGvWHLSmMby6ilATQElNirgn8InQ0zUmqO
         ejcCq6xZ0Lv0mL6sqpenZ7fdtbvKY6mhtBwhRkUK01Wk/3EMJBTxHlSCPYhdtqPj/8JT
         H9BluvsMDwEJhPVRUgibPeaFpT0CGrwTp8bsk0Gc8srIvCSXjbFG0d6UB8fEFPryjp/m
         YnsQ8nVWKf3pVHVIjANLwGHekR2+0EYP2FRwSgsHT1CTHejOKmbKKTARuP1Dx88deneJ
         gLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7d7LDFC+hAF6nPFR7L3PcxLrotkue7hFcEYskmEsUiM=;
        b=Icv7lx9DJqj1w2AmaL3FtXI0vi6lxJtShXn5t8W289uLaoQHwxyLE7qmqgX0/8HBDq
         xKg+ocacHv8HRo31g8ISuDXYQnvyztcjaLVTINvpbfBf9FMtbJlOIp4GR585M6rcGahf
         zoqbjIZ47nFomVS9PXazxIaS1m39AC9Y1tZ9IQi3Fp7baJaMHVuNJI4ICL3cMqcbcZbc
         En7yAXIIqT1kWct7EsOx3rZePzTk9s1UFDks6EooH6hbQlMOCh1aGS5y2UbxsRiciSo9
         cF+vXqabZHEGOCD3UmfzEahCNeYjkxuWrQL4n0Qd7uwWBvFyMr+UDG8OYfp44t419yLt
         /UDg==
X-Gm-Message-State: AOAM533RwXTqmlHpTIYAI4KIRwxOYLZhZxmE4ZmwWwQTOEgG/lE+K+Dw
        ZWrKt0PEsU99G1T+eSc7TTE=
X-Google-Smtp-Source: ABdhPJySNoUX3evdp0jBakGK4JPzHPZ4aHQ6z4EXTbSGYuiIRDaVdrBeMksr+illW3UmHO3HYSwyPw==
X-Received: by 2002:a9d:7d86:0:b0:601:4479:17bf with SMTP id j6-20020a9d7d86000000b00601447917bfmr1673018otn.299.1649985073114;
        Thu, 14 Apr 2022 18:11:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a19-20020a0568301dd300b0060131a30a1dsm616702otj.67.2022.04.14.18.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 18:11:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 14 Apr 2022 18:11:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/475] 5.4.189-rc1 review
Message-ID: <20220415011111.GB2791443@roeck-us.net>
References: <20220414110855.141582785@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
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

On Thu, Apr 14, 2022 at 03:06:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.189 release.
> There are 475 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
