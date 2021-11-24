Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176D445CB50
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbhKXRpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 12:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243013AbhKXRpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 12:45:23 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF75C061574;
        Wed, 24 Nov 2021 09:42:13 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso5429592ots.6;
        Wed, 24 Nov 2021 09:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rBHCmKYn9Au95Mda45DZ+HbQaP/g8yd4RDuwat8Xen8=;
        b=NSXlNH+98KDp/31wzCKWo2c8bjEEhMEiC63TegJABxcA5Q0srywTJtz/qz4rjGIZ5A
         LSsZkXw/YZ3i7k0GPwvw34lcABE3qXEtd1G7S+smUiVITLbYCYIkm3RvhFTs+ZSvYnAw
         4m3lvENV1HODK9gC0f+uT2PtbuWFQYGs192VrLjJFVcF6bpS2J8depiiuUjIqevwsa82
         7+cebzf98wGGK3LxlBgEhwystAUP9eiIzyuVkZTo5Y03CeYwHn9ExpbX39ljNAFrkesS
         SN3xwn908qGOft5eFQxv9gypBaouAOnW+RIhJvHJlYtAye7HLfYp0Wg6IW14P1WRW+ld
         yYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rBHCmKYn9Au95Mda45DZ+HbQaP/g8yd4RDuwat8Xen8=;
        b=txXuVvSL1ULx11tGjE6RG/cnjpw9Gt1LeF/LmHR28FTMATJPX+/iiqhG7JAH7MAjKD
         0JG6m7/Tre60KYPC2Rl08sh0JrQS01PoLdmkEqU0oWMCsXU9Pw7lVafXwEmueUk7EqZu
         9lMCuSpfbslMafMAt6sU5LBnKHLUxnhkRh+X8OBSy856ss9Dji/5WKAO492ietblnRsk
         vbfa5vcWl/VoIi0Ae1Vs6YbUPDg7QifCf0H//dM32i09Z8I7ffhQZEoRFjjkwPkToVex
         NFRe97lBpe1NA2SZn6mDf7dAfPv4Dci7eH9MA9xtXhd6W2rjQWUJE768lf6IZNHe3XGs
         sUPg==
X-Gm-Message-State: AOAM530HwFNK4H7zAVDI35eW467m1gKtlWC0Ecf+jfYxTgQW1XA5NUbS
        tpfLflq1hfUWHm5fq5JFT4M=
X-Google-Smtp-Source: ABdhPJwC8hAjWV0l0BEfyBKmWMpE2YueMhvk31YgPR6hz38W7HtC/IWQs2KpJcvJB04eTSnGlLBARQ==
X-Received: by 2002:a9d:24c3:: with SMTP id z61mr14855787ota.100.1637775733222;
        Wed, 24 Nov 2021 09:42:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e21sm70210ote.72.2021.11.24.09.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 09:42:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 09:42:11 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/251] 4.14.256-rc1 review
Message-ID: <20211124174211.GA539814@roeck-us.net>
References: <20211124115710.214900256@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:54:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.256 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Building s390:defconfig ... failed
--------------
Error log:
mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3411:4: error: implicit declaration of function 'tlb_flush_pmd_range'

The problem also affects 'sh' builds, and possibly others.

Guenter
