Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C4F5AA95A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 10:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiIBIDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 04:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiIBIDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 04:03:18 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC518B7293
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 01:03:16 -0700 (PDT)
Received: from [192.168.1.152] (unknown [222.129.34.149])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id A5CED41591;
        Fri,  2 Sep 2022 08:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1662105795;
        bh=ZOFc641//xjZbzZJp1nLBtreufTaSDvxCbK9eKVutvg=;
        h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
         In-Reply-To:Content-Type;
        b=IeyJwuuuJHlo9ukKPSpZxfUT3MstiFAHjr9O5jNy25I2JlQXjg0WauDlQjconQ8dL
         caT9dB/oqwqM2jK1Yy33s2OcwjP6qSCLhZJBrjXXXkFu275tvOJKvnl5yuze7o9geA
         WG7Zvho27pbbt34BzXBZ/3S7Smp4l62y1bhaSZPAP+W58Kq8pYY3ManjUNJg4KSl6e
         JDGtBC5mX8B9GNfLDLsw7fjgfmOb1Pae8ozGpuVt/N9kok+0Azcr39JNaPyHjYgbw/
         fY5b1yF70mosmnyCYybCpfIXDAFCeYv0mRJR0NFEP+lVDhH4dB8a0GxxWxooLitBuQ
         cd5hAke55ZQlA==
Message-ID: <8d7f7692-b137-fb0c-11e9-c2b69fa465d3@canonical.com>
Date:   Fri, 2 Sep 2022 16:03:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
To:     ville.syrjala@linux.intel.com
Cc:     Jason@zx2c4.com, intel-gfx@lists.freedesktop.org,
        jani.nikula@intel.com, stable@vger.kernel.org
References: <20220902070319.15395-1-ville.syrjala@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Implement
 WaEdpLinkRateDataReload
Content-Language: en-US
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <20220902070319.15395-1-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-by: Aaron Ma <aaron.ma@canonical.com>
