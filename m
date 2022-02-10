Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7993E4B1764
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbiBJVCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:02:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344501AbiBJVCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:02:18 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DE01100;
        Thu, 10 Feb 2022 13:02:18 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso7923913ooi.1;
        Thu, 10 Feb 2022 13:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J4x457kQosKgp5+2hecYw4PRDh6A9ZpZEBeZtZlLy0s=;
        b=M/2eYXP5fBXKTGytu+mnlJAFVGenObUSVwi2budaD+lzWVG/BSALY9K/9nNd6pqej0
         IslENoP+f9A7nEMvSr4iFMQu8PgN6DKdZTvOKStOVTV4044eqo/7pZ034mA1+rgO5qFp
         gfQitADaHAOkT6PCPIU1jFxQQx+Cl7h+m9L8t9Tk1GmcXKl8rA/ypG6aW/EGuhJyNF9U
         YSFhNpxn1XD3BPDi98W8Iav3aY6M4tcfzhMTId6Frxrl1PICDyut4SWHAl4iIEokBir6
         WXccqciBNwVPApq7AV50b+YRzQqlXqVtKRMKFAF+PveeorL6dcTA0kp1PP8WeSe+kzA9
         n+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=J4x457kQosKgp5+2hecYw4PRDh6A9ZpZEBeZtZlLy0s=;
        b=t+GJr2GAuwZW2kr1mWwXqfZ/T6SkUcSh9qQf/+htPPrMmZ6s4/l3ekY+FjzxjSSh0v
         bk9nfMUI4cHepURQupJidzSpI4MskGnrmsWvFbkGD87TI9ArwR27bmLVyoP864TXMLoh
         UAQiTMp+43H/pse7MGUeDHeid7kCRNvCQsYJ5ZsLw05JqAL9iqlI6ZAhe6BoU4UERFG5
         ovmljtwf9s43O8ZvwKtLsVd5PQa254DyYwKkM1TgFDUlua3INF+RlAbVOHAluzfIlo8m
         qONUzTutBvQSyWQGwhsSc06u9Ht+yaCQ3ABwfPOADaTSQIjXx+Hc1K5rQn5Xrnn8q1Yh
         h0mQ==
X-Gm-Message-State: AOAM530lT0PPN3nmehkDgJ3cLWN79W6d+zaEpflorpgIMT3VUlX5ToMy
        UdVBVV0BgQ9yBbPalviMCeU=
X-Google-Smtp-Source: ABdhPJx9k+DURPNlqzx+fqvDRIoQSqJ+zZ1bXVBG7Ea3GWHWiLo8AwYPfQQOC5rsZQtxKk8oaqj1jw==
X-Received: by 2002:a05:6871:605:: with SMTP id w5mr1333822oan.277.1644526937633;
        Thu, 10 Feb 2022 13:02:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a4sm8853161oaa.42.2022.02.10.13.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:02:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 13:02:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
Message-ID: <20220210210215.GF2963498@roeck-us.net>
References: <20220209191249.887150036@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
