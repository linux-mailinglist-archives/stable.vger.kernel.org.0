Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F169630DAC
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 10:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKSJGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 04:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSJGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 04:06:53 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C90A8A13F1;
        Sat, 19 Nov 2022 01:06:52 -0800 (PST)
Received: from 8bytes.org (p200300c27724780086ad4f9d2505dd0d.dip0.t-ipconnect.de [IPv6:2003:c2:7724:7800:86ad:4f9d:2505:dd0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id E05922A00C5;
        Sat, 19 Nov 2022 10:06:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1668848810;
        bh=8Rdt2HShuG8lhLt39g9NwaRNTqvHUGiX0XYjBE5YexU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wnpbnpp9p8e9cBLzOx41TOESAD0w0muFtbORrZFhxOCSLbkxEijkEvZwXFqzEnaeD
         0d9JHqT9cVo1SbxztcFqIOVeuUzc0aR2hZ74I4DIwNXGr+bc84lD0SLRQ6zX7HjaEr
         Mx9vcG5axG3XelhHBzb4Mb/ED6fSmADFRJV9nPszCwIw/uzUmm8Jt2ZCFX4k3lLzF5
         VnMC9jCY6m1pTPfTh2ZQujUmQwsh0fJi4PULh3pzcDlvA165HbnVfJFkD8Mao3Tgqc
         32RO1yCyUDV8d/wXsbRCT0bzCNS2cElrCHUBsrKSju7KS8H91+x4hjubWMb0Fblm9y
         a9YGtO7W7IcHw==
Date:   Sat, 19 Nov 2022 10:06:48 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     iommu@lists.linux.dev, robin.murphy@arm.com,
        suravee.suthikulpanit@amd.com, vasant.hegde@amd.com,
        Mike Day <michael.day@amd.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet
 and ivrs_acpihid options
Message-ID: <Y3icqMJ6Oaut6uBC@8bytes.org>
References: <20220919155638.391481-1-kim.phillips@amd.com>
 <20220919155638.391481-2-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919155638.391481-2-kim.phillips@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 19, 2022 at 10:56:38AM -0500, Kim Phillips wrote:
> Currently, these options cause the following libkmod error:
> 
> libkmod: ERROR ../libkmod/libkmod-config.c:489 kcmdline_parse_result: \
> 	Ignoring bad option on kernel command line while parsing module \
> 	name: 'ivrs_xxxx[XX:XX'
> 
> Fix by introducing a new parameter format for these options and
> throw a warning for the deprecated format.
> 
> Users are still allowed to omit the PCI Segment if zero.
> 
> Adding a Link: to the reason why we're modding the syntax parsing
> in the driver and not in libkmod.
> 
> Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-modules/20200310082308.14318-2-lucas.demarchi@intel.com/
> Reported-by: Kim Phillips <kim.phillips@amd.com>
> Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Applied, thanks.
