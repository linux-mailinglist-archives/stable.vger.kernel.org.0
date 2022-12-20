Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECC3652740
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 20:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiLTTnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 14:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLTTni (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 14:43:38 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E8BB7D;
        Tue, 20 Dec 2022 11:43:37 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1441d7d40c6so16667947fac.8;
        Tue, 20 Dec 2022 11:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyrJb2r92vPjt/dVeCGTFDyoSsc8LRnKgzMWA7R573U=;
        b=MZyLWeqMC24FsoAelZ7bubOvxkqSorcAZ7ykEckr1dnIHvtmYSbosvBdyDVQ4w7xvd
         LT+OQTIgoH6tEdakOgfbLOqHT00y9+5dmMlgb3hFshl2pSgouqEG2DuM4pSZH4trWvnV
         jJdvisrJI3IPpIz1yoNfmRyYRr1k+TFUMHFMYJxU7gZkAuxkNF2zCOSMaFOFVpIOGfH+
         k46sbhWoiWwxDbThPnkbhrfn3lpELCVHpYFe4Exnq0rTf6UIATkHYBSrJib1ThH1WOQr
         1V6e5KJAlFvhVEDZm0uOUlcMF1b7wYIJIAFRTy7Uc+NosDyu2TjXHJfSNmFT4SDEyd0S
         EmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyrJb2r92vPjt/dVeCGTFDyoSsc8LRnKgzMWA7R573U=;
        b=MF9frQAmeDRohDkbSW9EniuwI7K+ibSCSI/Wj3JKdeToBRSfo4a73aweuOrsFltjpF
         C1zkeTlFkDpr+Q2k5wEfiOLlH55fqIuvqYbcY0sV+SVLzMJDpnlT7LcOX9lBvnpWI96N
         ZosvOkZNW/mHh2RJgTkRQ9ObRU2bzyPhChDFj+BI85+DDW8cvyjuLO2VFgvhRF3Dm/Hl
         pVFAX5Lyk9ROSrzDfaGvLk6g64Tl6m8if5jaGorbXu42d2VqrK/s/omIGqQ2NOlubNTD
         rg/svV5rhC4oObWII3z+qPfH35TTX+r96+4ImNpByMQrZE+7ZodNB+/QcM8uhfPeo8C4
         W8lg==
X-Gm-Message-State: ANoB5plisjSXvPGjtyF4BwKTRFlvTQEsI5k1sGx8wXVHsls0sOYXkHnb
        gpwJzQT1YoApTNPpHmh26H0=
X-Google-Smtp-Source: AA0mqf550M2ZJIY66+vkOvSHC/fpZ6Ejtw+SQ+I3nqG2P5ke8U7d8YQwARxG9Gg4Z+67BUDpUiUIXw==
X-Received: by 2002:a05:6870:517:b0:141:d6f8:f83d with SMTP id j23-20020a056870051700b00141d6f8f83dmr23517463oao.1.1671565416593;
        Tue, 20 Dec 2022 11:43:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cy19-20020a056870b69300b00143065d3e99sm6445549oab.5.2022.12.20.11.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 11:43:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 11:43:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Message-ID: <20221220194334.GA942039@roeck-us.net>
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
 <20221205201527.13525-2-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205201527.13525-2-ftoth@exalondelft.nl>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 09:15:26PM +0100, Ferry Toth wrote:
> Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
> if extcon is present") Dual Role support on Intel Merrifield platform
> broke due to rearranging the call to dwc3_get_extcon().
> 
> It appears to be caused by ulpi_read_id() on the first test write failing
> with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
> DT when the test write fails and returns 0 in that case, even if DT does not
> provide the phy. As a result usb probe completes without phy.
> 
> Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
> fails. The user should then handle it appropriately. A follow up patch
> will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.
> 
> Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>

Hi,

this patch results in some qemu test failures, specifically xilinx-zynq-a9
machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
to boot from USB drive. The log shows

ci_hdrc ci_hdrc.0: failed to register ULPI interface
ci_hdrc: probe of ci_hdrc.0 failed with error -110

and the USB interface does not instantiate. Reverting this patch fixes
the problem. Bisect log is attached.

A detailed log is available at
https://kerneltests.org/builders/qemu-arm-v7-master/builds/484/steps/qemubuildcommand/logs/stdio

Guenter

---
# bad: [35f79d0e2c98ff6ecb9b5fc33113158dc7f7353c] Merge tag 'parisc-for-6.2-1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
# good: [830b3c68c1fb1e9176028d02ef86f3cf76aa2476] Linux 6.1
git bisect start 'HEAD' 'v6.1'
# good: [90b12f423d3c8a89424c7bdde18e1923dfd0941e] Merge tag 'for-linus-6.2-1' of https://github.com/cminyard/linux-ipmi
git bisect good 90b12f423d3c8a89424c7bdde18e1923dfd0941e
# good: [c7020e1b346d5840e93b58cc4f2c67fc645d8df9] Merge tag 'pci-v6.2-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect good c7020e1b346d5840e93b58cc4f2c67fc645d8df9
# bad: [b83a7080d30032cf70832bc2bb04cc342e203b88] Merge tag 'staging-6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect bad b83a7080d30032cf70832bc2bb04cc342e203b88
# good: [057b40f43ce429a02e793adf3cfbf2446a19a38e] Merge tag 'acpi-6.2-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 057b40f43ce429a02e793adf3cfbf2446a19a38e
# good: [851f657a86421dded42b6175c6ea0f4f5e86af97] Merge tag '6.2-rc-smb3-client-fixes-part1' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 851f657a86421dded42b6175c6ea0f4f5e86af97
# good: [fa205589d5e9fc2d1b2f8d31f665152da04160bc] staging: r8188eu: stop beacon processing if kmalloc fails
git bisect good fa205589d5e9fc2d1b2f8d31f665152da04160bc
# good: [4051a1c96e4883f3445cc8f239c214be622f4c6c] Merge tag 'thunderbolt-for-v6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/westeri/thunderbolt into usb-next
git bisect good 4051a1c96e4883f3445cc8f239c214be622f4c6c
# good: [84e57d292203a45c96dbcb2e6be9dd80961d981a] Merge tag 'exfat-for-6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat
git bisect good 84e57d292203a45c96dbcb2e6be9dd80961d981a
# good: [6f1f0ad910f73f5533b65e1748448d334e0ec697] usb: gadget: udc: drop obsolete dependencies on COMPILE_TEST
git bisect good 6f1f0ad910f73f5533b65e1748448d334e0ec697
# good: [c7912f27dedd874d49eadf78b5b6fbfdec52c7c3] staging: rtl8192e: Fix spelling mistake "ContryIE" -> "CountryIE"
git bisect good c7912f27dedd874d49eadf78b5b6fbfdec52c7c3
# bad: [63130462c919ece0ad0d9bb5a1f795ef8d79687e] usb: dwc3: core: defer probe on ulpi_read_id timeout
git bisect bad 63130462c919ece0ad0d9bb5a1f795ef8d79687e
# good: [38cea8e31e9ef143187135d714aed4d7bd18463c] dt-bindings: vendor-prefixes: add Genesys Logic
git bisect good 38cea8e31e9ef143187135d714aed4d7bd18463c
# good: [9bae996ffa28ac03b6d95382a2a082eb219e745a] usb: misc: onboard_usb_hub: add Genesys Logic GL850G hub support
git bisect good 9bae996ffa28ac03b6d95382a2a082eb219e745a
# bad: [8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
git bisect bad 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac
# first bad commit: [8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
