Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F0E6DC374
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 08:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDJGKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 02:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJGKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 02:10:00 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474303ABE;
        Sun,  9 Apr 2023 23:09:59 -0700 (PDT)
Received: from [192.168.1.137] (unknown [213.194.153.37])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: rcn)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 666FF660309E;
        Mon, 10 Apr 2023 07:09:57 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1681106998;
        bh=gQDFXrltfn8fBDBD7wVmDCBTJ72VJgdVNsz7Tyqy0cc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=I8C2BoHT9Bxw1Mf6KC34w6Xr2lhYHI0RwLIoa/jASH03TTf6Q9JSnRCoXiAB88zyV
         VnEneLp6pkaUQtfOvmYY3HzpReXL5wEC6Mk33Rpse67KpGqXb7PlVx+Hsrjh14rFhH
         vUew0JKTmngCtccbURi2E4S5iYxkN3mOnS7AZSX7SE72l7BtOzDBzG6B0DMAySTEnf
         S3yGEbH9zdpTeCJuasQdcBhc0hVR/QCuutDKCtHRrakr3fgRer2F834MYDq4HaXkbZ
         u/trYN/8xycx5fNzsLns3Qe17utSkoxgO+AfVWdVg2N+CU9Sn8QDJ1tuqxG1N9dBKr
         38mXcoe7vZNOQ==
Message-ID: <d7f389ab-914b-c48e-dc8e-290fb72f345e@collabora.com>
Date:   Mon, 10 Apr 2023 08:09:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/3] ARM: dts: meson: Fix the UART compatible strings
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20211227180026.4068352-1-martin.blumenstingl@googlemail.com>
 <20211227180026.4068352-2-martin.blumenstingl@googlemail.com>
 <20230405132900.ci35xji3xbb3igar@rcn-XPS-13-9305>
 <fdffc009-47cf-e88d-5b9e-d6301f7f73f2@leemhuis.info>
 <44556911-e56e-6171-07dd-05cc0e30c732@collabora.com>
 <71816e38-f919-11a4-1ac9-71416b54b243@leemhuis.info>
 <2023040604-washtub-undivided-5763@gregkh>
From:   =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>
In-Reply-To: <2023040604-washtub-undivided-5763@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Thorsten and Greg,

I sent the original report to stable@vger.kernel.org. Sorry for
the confusion, I'm still learning about how report regressions
properly using regzbot, specially for stable branches. Thorsten's
guidelines are being very helpful here.

Cheers,
Ricardo
