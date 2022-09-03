Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B535ABBD8
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiICAgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiICAgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:36:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8253F86C1A;
        Fri,  2 Sep 2022 17:36:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n8-20020a17090a73c800b001fd832b54f6so3625529pjk.0;
        Fri, 02 Sep 2022 17:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=yYy5FbAbvLVuY/cnwKHmyBJHxJ5uUGCqX7rW5LqdAus=;
        b=Q5RJ87JRtY1vvUbWi/tPozv8svnQ7sYIG0GRH5m3aQMa9DgqsHO/SdElFhEa2dwFO8
         xbCcK335vTRC8iussRxsZJigrgsz6rCTcqtvJPchApNPb9T0qsJfnCXvsLYKml7s5RE7
         C4nM2XQyhZBiwZj5tpe9KUG78UAoJenHskyiCHwQlcI7HsZ4tqMXgW54vYxAGGup5SQb
         rY7MB7Th5n4qazT3DgpJupckovc8E+NwLBpCnIsieWDD/6IuTQqBh+jo8Yyw76lU1blI
         A2ghAzC0CGZc0pRRLlpfjRW2W5ewSxssj7JkqE1x77j8yLt2kzqWs3iyEn02uxHbIkpU
         U79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yYy5FbAbvLVuY/cnwKHmyBJHxJ5uUGCqX7rW5LqdAus=;
        b=f0ZoJUa7XAEgIZUomupaY/h76h3VFKfG6kg12gRYOSge31rOjba+4xe0C48JLGPQr2
         TMUMVHBRcM/C6NqUjFIJOD0gvAGVL4e/hnUV5u7chogEFwzq8xFjh7+d+oJD6rMR2weY
         5JX2cHjTN4j0WZqpbWLijrYABk7f5PfCIlmuBVNnE5Bsp0Yvxf0Y3WQN8z3Ay/lIj+VK
         pi87yxRtOyzu26mdI6fEvjNuhzgAxTsk3csW0sAorLqSnzUiyzBlzgkSCYV3sdJg8BlW
         Ks5x1A7RjANpVSnwgJYRo5troJth0g0BbNHx7o5nzU/npFKYDYyyOtxnc82pcQMkn7cG
         zRDA==
X-Gm-Message-State: ACgBeo0TLFCk0etsFnlB7hS+fVqaDYXE7UCpYmZPFenLxfONOVhij8mp
        rRuHrQUFMYdpakbEjS3MRQU=
X-Google-Smtp-Source: AA6agR4IJK5fzpvdzW7wRmou40l2dtW0WY3cwwLxqV47XuETFoLkEdTXR7wnYBq0Zizm26UZcYTn+Q==
X-Received: by 2002:a17:903:230b:b0:16f:2276:1fc4 with SMTP id d11-20020a170903230b00b0016f22761fc4mr36551399plh.172.1662165380091;
        Fri, 02 Sep 2022 17:36:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o185-20020a62cdc2000000b005364e0ec330sm2437953pfg.59.2022.09.02.17.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:36:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:36:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
Message-ID: <20220903003618.GE847372@roeck-us.net>
References: <20220902121359.177846782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:19:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
