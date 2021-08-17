Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072BE3EF2A0
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 21:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhHQT2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 15:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhHQT2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 15:28:50 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352DFC061764;
        Tue, 17 Aug 2021 12:28:17 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 108-20020a9d01750000b029050e5cc11ae3so26199675otu.5;
        Tue, 17 Aug 2021 12:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aHm2WT6BVnLaYeBTIrYhaQJuTBXo3Be7mxn/H19IUPQ=;
        b=TvRNnsNZBMCwfrqJij8MVCOGURhvAwAsXhecozG4mV+Fm128oKoDo2Av+JRPF+USWP
         qoKkvWBs8hmTpuuI8RKzVcq/u1XRW3GgGqRMLWGA3ZJhep8dpfMdR/IEIccs//M5iCGn
         e9ivv7Ed3dgsh26HXMQuby6QequZfcWEOaQnGmh+ikjEoazdrUH6G0P27tvlt4Bd0HlA
         B3FTV0Ublssr5ETCQ5dKcguidykrfPPg0Zo02fjufy8lnANz1cFNR+uA6OFlUpxQzAQp
         FVa6H12ixNTHEUhA4evY2IhJViIHmtGBGum3Wgaz5zo6DUI+VIEtSXljscm3d503Zvuj
         oLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=aHm2WT6BVnLaYeBTIrYhaQJuTBXo3Be7mxn/H19IUPQ=;
        b=FN+mQWiSa5F1iE9OUNNnye4CZAxKd1PziSBO1Z45yXJ24XOZzOjUgLB2TxVbQXM0+w
         97nkv1VkrWidY6p+4AyPpzubkAgKinxel0o+7+PCWB4KS7VSuWQCEKTTJX/+PX5HTjF/
         Gw2h1wlaTyGmYsmj8CoMmOequRiDlDmNeQ3OTynscightVTweMxTKhDtDkZiT3c6XFsU
         TlNbjDSINjhi36IQlQEua1AkZgcasAMP6HN6LnhZR+34aZx71vXrWoPiBoXLS+1K4Zyu
         nRfntYXaw763dX5ORxT+MmPJzjfc5LLICjdnwsmkP3xe5JMrjt8FlC2/M55NDDus39eC
         o8tw==
X-Gm-Message-State: AOAM530nyfEEpM+L02aCH1zLTEaCD8Bh2SjoB8m13prcms5FimWkcGz5
        3dhjyofVNfE+8w3R7eSLgEP7MJU7xes=
X-Google-Smtp-Source: ABdhPJxZsoIlMhmY/BUSFAaYfOD5f7ncY6ENZ2VG/SSeGp8+LLCzi2Ux1cgS8kT4F83RVlc7nbxABw==
X-Received: by 2002:a05:6830:85:: with SMTP id a5mr3934168oto.268.1629228496601;
        Tue, 17 Aug 2021 12:28:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b19sm548667oti.34.2021.08.17.12.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Aug 2021 12:28:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/64] 5.4.142-rc2 review
Message-ID: <20210817192813.GA412158@roeck-us.net>
References: <20210816171405.410986560@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816171405.410986560@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:14:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
