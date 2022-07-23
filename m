Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02E57EF64
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbiGWOMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiGWOMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:12:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FB91BEB6;
        Sat, 23 Jul 2022 07:12:05 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y24so6759095plh.7;
        Sat, 23 Jul 2022 07:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ntKU4wWFwQJKqzD2BkOeRs7vVOFVPO09qpFG3mKtC90=;
        b=fgf9a2GpjCcpHkCDjrG+/Qg1ileygK9t5CWGvenQh6wl+Tj0VlnA0xmNBLeGo1wNZh
         aBJ9+XvyzCEzUfzeh+QRb5D7pNNtkH1Rglg1YJGPmmrgvZSxkdJzpXVg6gNkeSaDOI2Z
         NASwu1GZLqyrRKzCN8UagHcbo9ImGLRR7/CMuxLFVWVxBgClQqd83eCe3ryzu+l+CMWt
         UyKh/ALbuEwpPaOIYtIum97qprUd1X1zJfLt9RIbZ9dYtktZVmo24gp77zUUUSdSHjRE
         OYM7RDgh1hhpWuv8Ic/4tC1+MCk9lcJCmxlRoOHAUnEyCOUMgQW3G+exVSCx20Hylcq6
         MpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ntKU4wWFwQJKqzD2BkOeRs7vVOFVPO09qpFG3mKtC90=;
        b=667AtF1vot/K8qqXlw98FI61lDo4/9WlVv9pvi6oYldZEWvjMxKYRhul8FiY38xS8m
         IBb4mQjA4KmwEvLT7kCzBI1HUr4mWbcvYQNX2TerZ9tvqFMc4JAUqF4BEjbKlwyPZ/Fh
         hTiBhekJVWfYpvuNYK7DfZA3TF/CLikfUWjie9CZpvJG7OhiSHwE9k/gmGJJfxxabro3
         MZP2hZA4UJXWSFwVkHxiDjq+sNVgfugGLzD2o8vf/rUdJzKnoEE7qZayMm0XB+Qfppkv
         oYcZIeZKVUvLAXjJNvKDLYsi7t6U9CyVGbo1tmnUMJwQqW2qdVd1p4UZ4CUl0ChoTeV2
         O+Qg==
X-Gm-Message-State: AJIora/oQypLN8aOIDiImhjed6x/G4SUBWaxEOp5tlWDmlnsGzKYZwI7
        BN6CVXjB3nRSRzzWfcOqwcY=
X-Google-Smtp-Source: AGRyM1vaBpBhVimj0NBJM+XKAoNZsH+oETQSnTFbNdbf2ZWXHUsuQtAHHsBoAF1uimepTkUto1DNZw==
X-Received: by 2002:a17:902:cecc:b0:16d:3fec:22fe with SMTP id d12-20020a170902cecc00b0016d3fec22femr4769070plg.96.1658585524702;
        Sat, 23 Jul 2022 07:12:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902d18400b0016d1ab31b05sm5686003plb.42.2022.07.23.07.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:12:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jul 2022 07:12:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/148] 5.10.133-rc1 review
Message-ID: <20220723141202.GA2979894@roeck-us.net>
References: <20220723095224.302504400@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
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

On Sat, Jul 23, 2022 at 11:53:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.133 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 25 Jul 2022 09:50:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
