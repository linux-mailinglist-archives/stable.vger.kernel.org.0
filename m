Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8228F421F42
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhJEHLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:11:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50277 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbhJEHLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 03:11:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8EB955C0100;
        Tue,  5 Oct 2021 03:09:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 05 Oct 2021 03:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=fm2; bh=
        Hj37CP3Dw78hSfXRxxNojbV6w54/CCt3HwB3xajnRmc=; b=ZL4PM+i6e5oYR+90
        cS4JXmlhIwbsdFNiXA1ZpVxKPHusnFvjg6r1yyKsSvpaduJzjHgUM/kX+RW9Nyg8
        z0Z/CimhFQ0wTX8UglaW61faH71V0NxRgPlWWkXZmElrOSUiOK0B5KXCiILuVjbu
        Gf0KD1Kt/ptAoQxgmWw8gotnUtaPixqvjiKZJLzefCx4ANlBUb4xe/7Jr90A4Eli
        7kXjQ6CPGMhZacUW5kkTDIZ8OLUebehhVA5kZE04PPR9dEAEjdhhTexTNXXwzqR0
        /dvmjBodoQb1yyDFq2fghdT6rhlbtVzMHxpcSXB+7qTfec9Ea+NyCsspcXI0dpHN
        6EQgKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=Hj37CP3Dw78hSfXRxxNojbV6w54/CCt3HwB3xajnR
        mc=; b=BPx9FwZbm/WOJyK2TJ0H6Y4RbSr3XIFUZ7ulvKV2pKZrIARFrzPWIv4vY
        xLqkyhu2TYWhD27iTovkPtsq0/ElVsjd9eMM7k1WroTs4dnebc5zbUzNwY74TZ5T
        N0kFr/rGT8hYW59KQg9ykEFD4NpOZ4lsauInmuBHUXPoRIlhTxIHVBoT5M9Xb0kU
        o3KC8ek1jM8ReVgdXx3Hyy9Txsx95ywQdM2evUIB7XJv7OrGYnKrZ2VIwDDzbL23
        YqHg/DU+tiqaUuc4AR+a86zb5obsvjGmLHdH0zXHj40Aqjrst2+Z4xVpSmI/M2xm
        04TOFHBT5Ao0se4hHEYyam15VRa5A==
X-ME-Sender: <xms:N_pbYUAec1p-I9nzp1O2Z9uOzXUSMhjqHAxMPlPT6tlmuu3FsBr0Jg>
    <xme:N_pbYWh9J5svjY4BwZKtO2dHgynmKj9KaNM-ONL3Q6NqIAYaMHs4rKKcjKOoArnjL
    XwW4bBXv5728cqUGA>
X-ME-Received: <xmr:N_pbYXktvE1aGYYD67wjsdC0feS6q3rIz61L0HnawQMl8v2SZs53uO3w6F-hGDUGyq_faEj6_CG_oDvuv3azIziW-9pvBrTZbxVzpgJ6mthDdGc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkfgjfhgggfgtsehtuf
    ertddttddvnecuhfhrohhmpefurggthhhiucfmihhnghcuoehnrghkrghtohesnhgrkhgr
    thhordhioheqnecuggftrfgrthhtvghrnhepgeefkefgheevtddthfeihfevfffhhfejud
    elheelgfdvteekuefgkeffudeiudffnecuffhomhgrihhnpehgihhthhhusgdrtghomhen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnrghkrg
    htohesnhgrkhgrthhordhioh
X-ME-Proxy: <xmx:N_pbYax-aUjNqT7qLzNeU6mLoM1PhbhXKQ4o_2M3iEKEEhjRa6o4Dg>
    <xmx:N_pbYZQ7jcelKaXov3EII-wiSylC8DN-IvMHpHS8zB6FsGvH4qcs5g>
    <xmx:N_pbYVby_584YVqdG-W4a70E7TNocCBaa6rul0gdUU6TULfjGO-CTQ>
    <xmx:N_pbYUFmpWfSsdc2pR2RLs5YWtK2qAhcApQ00ckky6eJL7GgQBltsA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 03:09:39 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     hdegoede@redhat.com, mgross@linux.intel.com,
        mario.limonciello@amd.com, rafael@kernel.org, lenb@kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for PMC controller
Date:   Tue, 05 Oct 2021 18:09:36 +1100
Message-ID: <2915349.f8ii16yrt4@youmu>
In-Reply-To: <3ecd9046-ad0c-9c9a-9b09-bbab2f94b9f2@amd.com>
References: <20211002041840.2058647-1-nakato@nakato.io> <3ecd9046-ad0c-9c9a-9b09-bbab2f94b9f2@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, 5 October 2021 16:16:18 AEDT Shyam Sundar S K wrote:
> 
> On 10/2/2021 9:48 AM, Sachi King wrote:
> > The Surface Laptop 4 AMD has used the AMD0005 to identify this
> > controller instead of using the appropriate ACPI ID AMDI0005.  Include
> > AMD0005 in the acpi id list.
> 
> Can you provide an ACPI dump

The ACPI dump for this device is available here:
https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd

> output of 'cat /sys/power/mem_sleep'

[s2idle]

Thanks,
Sachi


