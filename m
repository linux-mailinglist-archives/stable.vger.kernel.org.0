Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E6A54D42E
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350397AbiFOWDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350381AbiFOWDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:03:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2698562D9;
        Wed, 15 Jun 2022 15:03:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c196so12641989pfb.1;
        Wed, 15 Jun 2022 15:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8dzJtKqjFz+K2perA4DSNiYPjcAFCp1yzvYlBkYKQbk=;
        b=W8o3iZtuIpBN/CMxBr87Bd4n6kkv6cNycL2raxM93IrOKpr1pfICvAMw6fQq2Le363
         NVEognJMaHn6RCDzBg3TLpfoQQq7NZ/f8hrrfREzZZchdrO5+fZGFrZvQEowuHmIYnRw
         FcMNjAUybLdHD+CaEEDDQ72qzWRXBX22xnAlhmHv5mmV0bqPf0nEkyhzzGz5W3anJnk0
         6h+8pCfWKxqtTRwhmt9aYci45Mbcu+4oF4as8Mo8Q1gLhFjf05ZdGc/IL6jkwnE4jRkr
         Z85wncqp/NCUL3lkemfZMUuMD0XcgPN7PXthbMgGVH6pIpUqYbaa9yjaZcQOHkgWEVp6
         0Y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8dzJtKqjFz+K2perA4DSNiYPjcAFCp1yzvYlBkYKQbk=;
        b=gTcurTJlKG2TAaFgM4p1tp6QtWZrTKWFot8vsktCrx0uUuj+7PIWxX9u4N1DeN3emP
         a60KRXSkUEWaX/M+WGllL0sQyDgj29n955L6MwUZnqpds/gpbOIYtGazvRFhmZcHqLfe
         KvlyUWx7ah79bta9kZe/5x5joMgAak+twoSSDcA5KHscPS6FJDWulmDxElb3avwkDbkb
         LkdTQbmCrN8ZgieOngzkwdnn7JCFTUpXYg+3RFT/IB96jPF7eUcX4W2LZzTyYVDjEc0O
         2NGB+A4od4VcA+HgBKlN7BZFV+ocXNHCOUViQRL64wFVDFK/i5IarqIS7wmHetS+47vm
         eR/g==
X-Gm-Message-State: AJIora9EXr9kLqY723isLCfE2fkvNC/91JGhNdXW/74IY/rMMESdH6H/
        vRRTIoTTFbhN2mbb++OUcng=
X-Google-Smtp-Source: AGRyM1u0LM43xQpYzY0YFqqWsQ/Z80c8lKlITrVhToQeNrhKbPJLdazD3BPAGZ275bxXLWhdm+waUw==
X-Received: by 2002:a05:6a00:a03:b0:522:990c:c795 with SMTP id p3-20020a056a000a0300b00522990cc795mr1666063pfh.15.1655330625353;
        Wed, 15 Jun 2022 15:03:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w9-20020a639349000000b003fc5fd21752sm74135pgm.50.2022.06.15.15.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:03:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:03:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
Message-ID: <20220615220343.GF1229939@roeck-us.net>
References: <20220614183720.512073672@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
