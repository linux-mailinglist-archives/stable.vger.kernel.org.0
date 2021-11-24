Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2D45C904
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345964AbhKXPpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345617AbhKXPpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 10:45:40 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC66C061756;
        Wed, 24 Nov 2021 07:42:27 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so4890237otl.3;
        Wed, 24 Nov 2021 07:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1sqyelsDqXo4Ss2ml85GtMu6YABUPsG4e01T6KG/eLg=;
        b=UMxPX1wAUlBdry4AzZWw/n6HW9FA65T3nemyKdHficLti1wzZQZ2pYdjB25Rq9eD7w
         0FZe1M5+joElCQAYrR03E56/m4DYsfFYzqNK55Qw7JJVU3I7E8VoBEfqjFS/CQ30SCl9
         i42u4ZVhSoMnYAO4xb1KmhqhKdqJg3N9tMoR/gv9pUPUSWissyTHxtmwQYuC0KcsLpbP
         TzGjQ3vT0pdfs7fMOD2lb36z7qmzj4XZwiS6zcrdnrQA6Ztzsz2OOTMU6PaLYmVEqOFe
         9/y7bKNJsSZEqiEGyWSoplTbYi5XNdjx2Aa+xxnsfjEhZHERrAIneSKMUNOORP0pyDtS
         UG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1sqyelsDqXo4Ss2ml85GtMu6YABUPsG4e01T6KG/eLg=;
        b=4sIy0UEQxPCfBtBAJ/Jkgmt9HRoqCHHJWfF7rlSQRq6dcBld8ky5xvPhIoEbaneKOt
         ilLav9hiZXCxSRdTDk7VjWFrXU1O9Rq6NqF/mo2Pf62iwcxPBaMIDX0oWbtVPW9JCqLG
         HonwJyePm8LoF/PDXPXK61DpwH6ujTyajHf0WWmVbo5Dt1jTgRc5jiDiix66VmshYE4b
         OoSEfdYBL0YI57kitMVv39rAkBXmz4SjQgldtOgrpWz4aGuVDd68+xfuUiQ8S7y0Gn4h
         NjWnOu8VchmxwBapKEd2HOG+/Hl5Gb9YCB67iPNP6qwgyT10ReT/ZXCCWPoZp6WO7ive
         5GRQ==
X-Gm-Message-State: AOAM533owhhmukZhdMQAAaxX/sF3DK/m/vbz/5Fhe2IgZqLaBSspWP6h
        Ci5HPecGoOrNqQfPVhhFaOfQLEaMPJM=
X-Google-Smtp-Source: ABdhPJx1wRj0bDlOUHfhfqZpOYlcbDIcCwSK5dYIlC12mixUN+3kscg1J+irawcAhQMDGH8KwKC7OA==
X-Received: by 2002:a9d:62d9:: with SMTP id z25mr13617764otk.330.1637768546870;
        Wed, 24 Nov 2021 07:42:26 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f20sm41185oiw.48.2021.11.24.07.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 07:42:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 07:42:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/162] 4.4.293-rc1 review
Message-ID: <20211124154225.GB1854532@roeck-us.net>
References: <20211124115658.328640564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:55:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.293 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

sh:dreamcast_defconfig:

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3294:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Guenter
