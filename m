Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EEF5BF12
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfGAPJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:09:21 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35664 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfGAPJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 11:09:21 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x61F9EGW123659;
        Mon, 1 Jul 2019 10:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561993754;
        bh=JGLmJhDyyf/JrqaEDIPj3Ihu1BizMaUYNCcdOdMtstU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xoiJb4aat2BjGXhvJyJJSIiYCQCXxajVpHSWSz9lS1maIlUIL0e8JGpPqMa6IkGKd
         YXJ1v/421zafck0vGHIYdpZvKckbEQKa8irXa6flKSNUFltql5rqH/NuHDAKY8Uo+s
         ViKD0tIwkdjsMu8+XWqZTkDyqUfRAc6ZiFafUKdU=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x61F9EVl014329
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Jul 2019 10:09:14 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 1 Jul
 2019 10:09:14 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 1 Jul 2019 10:09:14 -0500
Received: from [172.24.190.172] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x61F9CgS061228;
        Mon, 1 Jul 2019 10:09:12 -0500
Subject: Re: [PATCH] ARM: davinci: da830-evm: fix GPIO lookup for OHCI
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Kevin Hilman <khilman@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        <stable@vger.kernel.org>
References: <20190625151612.6204-1-brgl@bgdev.pl>
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <597f203b-3621-df8f-c752-20a5c333c119@ti.com>
Date:   Mon, 1 Jul 2019 20:39:11 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625151612.6204-1-brgl@bgdev.pl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/19 8:46 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The fixed regulator driver doesn't specify any con_id for gpio lookup
> so it must be NULL in the table entry.
> 
> Fixes: 274e4c336192 ("ARM: davinci: da830-evm: add a fixed regulator for ohci-da8xx")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The offending commit was introduced in v5.2 so I dropped the stable tag
while applying.

Will send pull request tomorrow after some build and testing.

Thanks,
Sekhar

