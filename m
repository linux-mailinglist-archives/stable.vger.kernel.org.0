Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF13F2E9C5A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 18:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbhADRto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 12:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbhADRtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 12:49:43 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1507C061795
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 09:48:30 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id v19so19487446pgj.12
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 09:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxace-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=65owITg5bptvn1j++cmPjkA/zjpHPF/EDZomkuXKGqY=;
        b=uY/UlD7z90jZJguSr4Qov6hTFwNsacX2P0geVNecyR5ZH7ZJamw0DXTNljsbMPh9PS
         MFtO+9k1uqqfJPP4oxrzK1VHY59gJeN3JZOQsggZWLYox/RAcbwzjbXHZTbFVt/p2hXc
         5PsPpT843IKgWkVa89xYlfbHBCRM9SdJW1eLo4vZRudTVCbP03yEes6Of/ssVlo1bwwD
         lPisb7pbEW5ixCwrXhMykOxku5XX94zl1lW46mkndO08IyIeRjTZFa0pUxIpRkCFgRPq
         ug5zNvBVQsrv3jFZjiOXLHjS9S5H7+LP8pFgaUWXRdyTsJ7CT9WbL3iRXfIFRSKMSDCy
         Sh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=65owITg5bptvn1j++cmPjkA/zjpHPF/EDZomkuXKGqY=;
        b=dxD69LO2qm5zTECkx2HDd+vbNm/vGvFAtMibgrA3yxuln/BmcnBjADxmnEKACVO7t2
         +3aJWDUSIVBvaKCJC10FUsqVFbTEExZLXRhayCmtnkFKuX19J0+rWKkV7nlmWpVxFu2H
         E7dvxIzAzMSw67Z9hGTA2v2ne0auYzbbVu6YVf3PxGDuB3taG9aUSUcwjVALd3EvZTAz
         WXAZhrzQiUiUsjZKm7ujrkRhfCgCDKSPlslX77jhQiRd4ct95me7cI3EvlUpqXRAUwiS
         d8D/wYEdOyNMh7OMS9pKu5MOxTUAo17Ho8ROVNMeLQnPc1+w12ADt1kUdter2RQeEQLH
         MIsQ==
X-Gm-Message-State: AOAM533t+mJreZCyL4Dk/rNfMA2VpNebuwo8Ybo3s3KG5FoffXdEV9z3
        g4DGNTj8n8za9Ud8qIPfiGbYsg==
X-Google-Smtp-Source: ABdhPJzyl3JwJlJhdPc5Jfiknw7ZF3oAzN30Yms3O1ELx9wLiAGjFS0agKxHvleXTZGJgkZVtJCRqw==
X-Received: by 2002:a63:520e:: with SMTP id g14mr24089127pgb.378.1609782510541;
        Mon, 04 Jan 2021 09:48:30 -0800 (PST)
Received: from home.linuxace.com (cpe-23-243-7-246.socal.res.rr.com. [23.243.7.246])
        by smtp.gmail.com with ESMTPSA id p9sm34954pjb.3.2021.01.04.09.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:29 -0800 (PST)
Date:   Mon, 4 Jan 2021 09:48:26 -0800
From:   Phil Oester <kernel@linuxace.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
Message-ID: <20210104174826.GA76610@home.linuxace.com>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-2-arnd@arndb.de>
 <20201231001553.GB16945@home.linuxace.com>
 <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 03, 2021 at 05:26:29PM +0100, Arnd Bergmann wrote:
> Thank you for the report and bisecting the issue, and sorry this broke
> your system!
> 
> Fortunately, the patch is fairly small, so there are only a limited number
> of things that could go wrong. I haven't tried to analyze that message,
> but I have two ideas:
> 
> a) The added ioc->sense_off check gets triggered and the code relies
>   on the data being written outside of the structure
> 
> b) the address actually needs to always be written as a 64-bit value
>     regardless of the instance->consistent_mask_64bit flag, as the
>    driver did before. This looked like it was done in error.
> 
> Can you try the patch below instead of the revert and see if that
> resolves the regression, and if it triggers the warning message I
> add?

Thanks Arnd, I tried your patch and it resolves the regression.  It does not
trigger the warning message you added.

Phil
