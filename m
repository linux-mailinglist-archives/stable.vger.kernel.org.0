Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD24F47E7
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347153AbiDEVWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457414AbiDEQDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:03:12 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F401E9BB96
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 08:42:43 -0700 (PDT)
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 778723F811
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649173362;
        bh=7GZo70Jkx4ortmGAZXr0kZLiNDeCCFGRN/cOmY89S9A=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=iyZLaulj+DAwjuF/ZSVN00GfTaDYl4Yu5HWcvMw/oeK2zqI2x2DT3pt8krptlx458
         KNI9ruDe2U8fiAakjYgTJFDBIVjozGMnmMVcZPDDzziDCmFZVPRngdVW3BrIYE7vfM
         Y1+8zbf+0roYCI7QYFrMXVaT7uGnBRjEQBqCA4vZdtSmxeRwBVCnOtN5xvQIp27EjN
         QvI7Sk7SxW/3o1n3cpG9F5XljKlqF+qwYH41ep95Gje78aCmjRfHJ87yIxSC2x0AQ2
         GdEp9Bgu9F6pGuim2ZMXEK/G7B5OpvoHAGTcd83TNCPnfCU1Yj1mMI0fKdhr0KG3B/
         e8C1iOzxvYaKQ==
Received: by mail-il1-f199.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so8364142ilc.17
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 08:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7GZo70Jkx4ortmGAZXr0kZLiNDeCCFGRN/cOmY89S9A=;
        b=a/8M936jeEBI2FBIzX+DDrK9SKK3KZ3qoYnErF8gezye60HxqUF1xV5G6C+hS2i6/g
         jgfIY+DGaHp/McNW2DC1b3gFQPQxwuJro9h1oKiYK2xTXgGppd2s4puHCJIhZfsHjUOX
         9rfNIZTAXYUsm8PrSVATwasLhBsdPFiunBq4E+Px2dInsJYOt9sbWjGzeoKz48IAPvo4
         kOWulQz5czU0RXGSPgML3ArrVvQDIRJv43X816S7u++ieCCiJdRg6/JdLkX6MNsoX1+s
         s5YJnQVM7fd7eY3QAO2VhPPsz0QpnWT5D2cWIlss7wU4EisfbM+UgjUojkpGrb8kwXAA
         rKOQ==
X-Gm-Message-State: AOAM532qa8KjhewmqrX6whBLOtgcUkAlUn0f5WRvVEVu6OWUBupkLEHy
        y/bqRoW/gK38anL8p0EgZ3xr6tySHlN6JOyqb/9t2NHbw5rdw7V26+uCE61vWQW7/WlPlFR/Eed
        CWixp6Io40GtgvRw70d1NQLONd0Ry1DW53g==
X-Received: by 2002:a02:cb4a:0:b0:323:5e9a:255c with SMTP id k10-20020a02cb4a000000b003235e9a255cmr2250781jap.12.1649173360736;
        Tue, 05 Apr 2022 08:42:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG1CiHUIYRegMsFTGUVXr2Te/jPu6rIoOR95h9XYPxdlcZ8BM13OWSDEv0JghT9pe8e2TG/A==
X-Received: by 2002:a02:cb4a:0:b0:323:5e9a:255c with SMTP id k10-20020a02cb4a000000b003235e9a255cmr2250763jap.12.1649173360498;
        Tue, 05 Apr 2022 08:42:40 -0700 (PDT)
Received: from xps13.dannf (c-73-14-97-161.hsd1.co.comcast.net. [73.14.97.161])
        by smtp.gmail.com with ESMTPSA id i12-20020a92c94c000000b002ca56c2cf67sm1508389ilq.28.2022.04.05.08.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 08:42:39 -0700 (PDT)
Date:   Tue, 5 Apr 2022 09:42:37 -0600
From:   dann frazier <dann.frazier@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH 5.16 0199/1017] PCI: xgene: Revert "PCI: xgene: Fix IB
 window setup"
Message-ID: <YkxjbVp3W2LeVIeL@xps13.dannf>
References: <20220405070354.155796697@linuxfoundation.org>
 <20220405070400.156176848@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220405070400.156176848@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 09:18:32AM +0200, Greg Kroah-Hartman wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> commit 825da4e9cec68713fbb02dc6f71fe1bf65fe8050 upstream.
> 
> Commit c7a75d07827a ("PCI: xgene: Fix IB window setup") tried to
> fix the damages that 6dce5aa59e0b ("PCI: xgene: Use inbound resources
> for setup") caused, but actually didn't improve anything for some
> plarforms (at least Mustang and m400 are still broken).
> 
> Given that 6dce5aa59e0b has been reverted, revert this patch as well,
> restoring the PCIe support on XGene to its pre-5.5, working state.
> 
> Link: https://lore.kernel.org/r/YjN8pT5e6/8cRohQ@xps13.dannf
> Link: https://lore.kernel.org/r/20220321104843.949645-3-maz@kernel.org
> Fixes: c7a75d07827a ("PCI: xgene: Fix IB window setup")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: stable@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>
> Cc: Toan Le <toan@os.amperecomputing.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Krzysztof Wilczyński <kw@linux.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Stéphane Graber <stgraber@ubuntu.com>
> Cc: dann frazier <dann.frazier@canonical.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/pci/controller/pci-xgene.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hi Greg,

  I don't think it makes sense to apply this to 5.10.y, 5.15.y &
5.16.y w/o also applying a backport of 1874b6d7ab1, because without
that we will regress support for Stéphane's X-Gene2-based systems. The
backport of 1874b6d7ab1 was rejected for these trees because it doesn't
apply cleanly, but I've just submitted new versions that do.

  -dann
