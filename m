Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8195BF1A
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfGAPKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:10:01 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48974 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfGAPKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 11:10:01 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x61F9qNa078059;
        Mon, 1 Jul 2019 10:09:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561993792;
        bh=0+5MZ7ebuY2r8//s/Qw/6N2A3r9Jjoa5Qindm3NxB6k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vKfA+fupl9sy8W8sftHGdoOBJ2FPqgS8muCaScXffaUSx/J+XvSiOJkrSL6kZDU1c
         N1YqHCed2v177amrV169TAOvpno72m30qismqHmZ61CCQlE/YHKukLb71TIAtOMtY9
         KHCOkN6dNCL7/4pZuMuzY0owC7y5myizXjENMENk=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x61F9qHV014790
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Jul 2019 10:09:52 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 1 Jul
 2019 10:09:51 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 1 Jul 2019 10:09:51 -0500
Received: from [172.24.190.172] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x61F9n0H130030;
        Mon, 1 Jul 2019 10:09:50 -0500
Subject: Re: [PATCH 1/2] ARM: davinci: da830-evm: add missing regulator
 constraints for OHCI
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Kevin Hilman <khilman@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        <stable@vger.kernel.org>
References: <20190625164915.30242-1-brgl@bgdev.pl>
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <00cea4e8-c240-8ded-c97c-31ce5186c876@ti.com>
Date:   Mon, 1 Jul 2019 20:39:49 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625164915.30242-1-brgl@bgdev.pl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/19 10:19 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> We need to enable status changes for the fixed power supply for the USB
> controller.
> 
> Fixes: 274e4c336192 ("ARM: davinci: da830-evm: add a fixed regulator for ohci-da8xx")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

For both these patches as well, the offending commit was introduced in
v5.2 so I dropped the stable tag while applying.

Will send pull request tomorrow after some build and boot testing.

Thanks,
Sekhar
