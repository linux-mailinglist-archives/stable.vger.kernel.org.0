Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125216CF589
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 23:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjC2VrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 17:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjC2VrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 17:47:16 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290B95FCD;
        Wed, 29 Mar 2023 14:47:09 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i6so21251190ybu.8;
        Wed, 29 Mar 2023 14:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pB+5qmzYeF4gfMXOeV33fr2Zf6v5XzvIxr1hkkgBRCY=;
        b=TqUeTWMt+zvoZh7VgjNstvdzz3di09QXLIAIDUDqKcsytBx0Con3h/YEyN+tXonV4I
         bA6edFVySz++7jzTi7SgK8Ze5KXw8sT8dw2Zxesp0jPyuztF3xWWfo6atfeZ+7drBnNX
         BEV6DUxbFoMN8eYle3VhB6Qb2GvjIWmQqzTL5dXLhskMfD4xv9YgVS1j8EzzDNenXb6Z
         KYkZu7QAGd716MO1cMHtKgjIbiySwiVCG4pOSc249OHq8LA+ABNXIkgw85ftfyYksat+
         8P6NWxKbdt/1c7sJtqZa1Gf8DPOf7WhjW0wB1bJBNyhii3fcSvhdFKxkDbeXaVz/SWzf
         OxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pB+5qmzYeF4gfMXOeV33fr2Zf6v5XzvIxr1hkkgBRCY=;
        b=zI/rp1fTE/MX9Ar37xRi9m1w0mBjbEEtSvUy5xKHcfJkHyiJcEvgsHhFIrl6hncb2p
         RCEPJx8aP3FOBCdvfRKacsdvWCnaRJLKDAJpH9L6VOKNCj0WoLQ+QhgZgN4hYV/10Poe
         QRVL13VV0lrZqqq1D/Za3o+HE/D1PbadU8mMbgUyh4gwZzF8DA7fQNzQXi9vo8Kx2+wu
         wBRZTjgvJ+nUBtoece4r6ygjeIOn/Amaq9ydWF0kOLtjSuq0GAuFVHv+cZA6LvuYahU+
         IpLbaDwQKzgcdMslI4VnlNallj6mJun+8YmHjRSCwM1e7P7jPGS24OQLGfpW39aHi4bO
         eKPA==
X-Gm-Message-State: AAQBX9f8g+6v79y28D4knoGItqm5KNKt/dP4QAxo1XZr+ZU4vcjKjUn9
        fdkqT8qxUdbmosOscNYx9HU=
X-Google-Smtp-Source: AKy350aC7+F0BTGZwir9fMbQQL4MqV7EQadoU98pfpSMRMcuq4ke9nc1/BtjyZnxtIBExdhqEPrDXQ==
X-Received: by 2002:a25:ac1b:0:b0:b72:df13:fda with SMTP id w27-20020a25ac1b000000b00b72df130fdamr18541814ybi.42.1680126428064;
        Wed, 29 Mar 2023 14:47:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e60-20020a25a3c2000000b00b7767ca74a3sm3670713ybi.64.2023.03.29.14.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:47:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 29 Mar 2023 14:47:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <430f447d-fb8f-408d-b9f0-28db4556a646@roeck-us.net>
References: <20230328142619.643313678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
