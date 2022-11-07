Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D661E855
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 02:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiKGBiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 20:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiKGBiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 20:38:04 -0500
X-Greylist: delayed 719 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Nov 2022 17:38:02 PST
Received: from smtp.tom.com (smtprz25.163.net [106.38.219.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7CBC19
        for <stable@vger.kernel.org>; Sun,  6 Nov 2022 17:38:02 -0800 (PST)
Received: from my-app02.tom.com (my-app02.tom.com [127.0.0.1])
        by freemail02.tom.com (Postfix) with ESMTP id 4E939B00D30
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:25:52 +0800 (CST)
Received: from my-app02.tom.com (HELO smtp.tom.com) ([127.0.0.1])
          by my-app02 (TOM SMTP Server) with SMTP ID -1407226815
          for <stable@vger.kernel.org>;
          Mon, 07 Nov 2022 09:25:52 +0800 (CST)
Received: from antispam1.tom.com (unknown [172.25.16.55])
        by freemail02.tom.com (Postfix) with ESMTP id 38F97B00CC4
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:25:52 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=201807;
        t=1667784352; bh=CZPj/gYTHe0cbu9G9cAtpVDX1hQqwl2Q6jjzkB5MRCc=;
        h=Date:To:Cc:From:Subject:From;
        b=47wVSV6nWbPm08Uve4CGAOehwmYxDbJ5MhtygKl8AkO1oUdMXEufdf4orjw/kuF1T
         kPfKPJvSOApBm55ewmnO4n8ETqWR5qGtA1Tq7i+FgwTI9M6n89Rtq/gDL7n/BNqChe
         FlBXYqUkHXbrRHbaLiRmxhHcilyY/u358Op3I8zE=
Received: from antispam1.tom.com (antispam1.tom.com [127.0.0.1])
        by antispam1.tom.com (Postfix) with ESMTP id 222FED419C3
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:25:52 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at antispam1.tom.com
Received: from antispam1.tom.com ([127.0.0.1])
        by antispam1.tom.com (antispam1.tom.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V5nVKn7Te75p for <stable@vger.kernel.org>;
        Mon,  7 Nov 2022 09:25:50 +0800 (CST)
Received: from [192.168.0.106] (unknown [120.207.227.204])
        by antispam1.tom.com (Postfix) with ESMTPA id CB421D41357;
        Mon,  7 Nov 2022 09:25:49 +0800 (CST)
Message-ID: <39ebab39-fb03-4be4-ec00-c5665f19fbdd@tom.com>
Date:   Mon, 7 Nov 2022 09:25:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
To:     stable@vger.kernel.org
Content-Language: en-US
Cc:     regressions@lists.linux.dev
From:   malaizhichun <malaizhichun@tom.com>
Subject: This is about the acip-bios problem
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please what time  the acpi-bios error reported by the dmesg command will 
be fixed, it's really annoying. I have never been able to eliminate such 
reports, it's only to insert loglevel=3 in grub settings to block. But 
it doesn't solve the problem, and  I use google search , it's tells me 
that fix this problem need a bios upgrade, but actually my hardware has  
stopped upgrade, so I don't know how to do fix this, thanks


[    0.160900] ACPI: Added _OSI(Processor Aggregator Device)
[    0.160900] ACPI: Added _OSI(Linux-Dell-Video)
[    0.160900] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.160900] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.219876] ACPI BIOS Error (bug): Failure creating named object 
[\_SB.PCI0.XHC.RHUB.TPLD], AE_ALREADY_EXISTS (20220331/dswload2-326)
[    0.219885] ACPI Error: AE_ALREADY_EXISTS, During name lookup/catalog 
(20220331/psobject-220)
[    0.219889] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0014)
[    0.219944] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS01], AE_NOT_FOUND (20220331/dswload2-162)
[    0.219950] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.219953] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.219983] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS02], AE_NOT_FOUND (20220331/dswload2-162)
[    0.219987] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.219990] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220019] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS03], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220023] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.220026] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220055] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS04], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220059] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.220062] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220090] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS05], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220095] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.220098] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220126] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS06], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220130] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.220133] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220162] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS07], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220166] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.220169] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220197] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS08], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220202] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)
[    0.220205] ACPI: Skipping parse of AML opcode: OpcodeName 
unavailable (0x0010)
[    0.220233] ACPI BIOS Error (bug): Could not resolve symbol 
[\_SB.PCI0.XHC.RHUB.HS09], AE_NOT_FOUND (20220331/dswload2-162)
[    0.220237] ACPI Error: AE_NOT_FOUND, During name lookup/catalog 
(20220331/psobject-220)

