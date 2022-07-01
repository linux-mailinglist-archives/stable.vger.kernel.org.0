Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA4C5627EC
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiGAA6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiGAA54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:57:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC1C57260;
        Thu, 30 Jun 2022 17:57:55 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d5so865425plo.12;
        Thu, 30 Jun 2022 17:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lt5vhQxdU+0C7nibRNDzRwV90rZ5muzR7h4EE2d6W54=;
        b=HTLXBDqHqHAZ9GDRWRXvXid7LV7TdwIBvKX/P6btZ2vyfGcFQZIfqaxSi6r1vp0xVJ
         VrSon2K8QbmpY3lscTA02W4hXLOds0ZIve3gB02dbW00aJ4xOszjd4EZGd3ZLngODr9m
         5eMjfoK7c2G3faDES5jP3yfPpwxW88Kpnp0dsv1DJOy16rHaRBouGmxUHU9/ZZbFpiHc
         owbeJWdwCsEsG7NGS4ALxLdncsza9Crn24RIjFqCbUFTa0vv12+rvCgLMQvwmOLhMdOo
         OAVAVP+8Le2tL5eTQcWV37PmgAu0qBbTquMxo7j9p48IE4Hinhn9qgeuiFa6u9o4UkUl
         ZKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lt5vhQxdU+0C7nibRNDzRwV90rZ5muzR7h4EE2d6W54=;
        b=b7xb/emDmTt//P8GDkojx6xdeWelq8tCmcVIZ+VOTHB0M54/1y1mlSNpHs4QPJTkwY
         XrDe9OEgLHlkFarqHSHo1o8Np3rSCENru6wu0w+8NGdAviwnoXbAUTQxZnqifLZ+pimA
         iaoHp86ioSVHff80387m16U++LduEhJWAY/GBXUdgcgLf7qWY4AehRCW9tk+k9u6Zyq+
         sd8+lYfQJwr8oh85ykCWNs5iudgGAghl4GDpC+Cz0EJ/S8Ve7kNF+2JED9lHlLn4NdQK
         gPcBrezhZlF37iwnfxykYbNqwCAWjEZ40SDf0ERqjbFUXcK7TpbMYSJjIZ7bcr/TmNas
         SQmA==
X-Gm-Message-State: AJIora9n3FcE1tIA+Un3k58Xrg2UrqsrhS8k2CY9gDIX0ALZFHCHzuNK
        h1Li3KyONqV7i7M68bHdqFs=
X-Google-Smtp-Source: AGRyM1sD08r5B/BPqLFuWkuyU9fGbrXuJNDRUG9w8loA/NpT+DqcNwFJ5AZ8z1iP/avQz1MkePDpAA==
X-Received: by 2002:a17:902:bb8d:b0:168:e48d:86bc with SMTP id m13-20020a170902bb8d00b00168e48d86bcmr18650650pls.93.1656637075318;
        Thu, 30 Jun 2022 17:57:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902e14400b0016a46ee3b49sm13934526pla.236.2022.06.30.17.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:57:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:57:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/12] 5.10.128-rc1 review
Message-ID: <20220701005753.GE3104033@roeck-us.net>
References: <20220630133230.676254336@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:47:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.128 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
