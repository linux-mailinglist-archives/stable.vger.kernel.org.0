Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA0516F72
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377204AbiEBMUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 08:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385032AbiEBMUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 08:20:12 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3FF1A3AC;
        Mon,  2 May 2022 05:16:39 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 89CDE3FA5E;
        Mon,  2 May 2022 12:16:35 +0000 (UTC)
Message-ID: <57711836-be14-6f88-d053-c2919737ca07@marcan.st>
Date:   Mon, 2 May 2022 21:16:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/3] PCI: apple: GPIO handling nitfixes
Content-Language: es-ES
To:     Marc Zyngier <maz@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220502093832.32778-1-marcan@marcan.st>
 <20220502093832.32778-2-marcan@marcan.st> <87h768i6ci.wl-maz@kernel.org>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <87h768i6ci.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/05/2022 19.20, Marc Zyngier wrote:
> On Mon, 02 May 2022 10:38:30 +0100,
> Hector Martin <marcan@marcan.st> wrote:
>>
>> - Use devm managed GPIO getter
>> - GPIO ops can sleep in this context
>>
>> Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
>> Cc: stable@vger.kernel.org
> 
> Why the Cc: stable? I'd guess that at a push, the devm_*() usage help
> with potential memory leaks when the driver fails to probe, but it
> would be good to call that out in the commit message.

Ack, I mentioned what this fixes for v2 and reworded the commit message.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
