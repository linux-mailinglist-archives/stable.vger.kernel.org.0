Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BEBAA2DE
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 14:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389039AbfIEMS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 08:18:59 -0400
Received: from first.geanix.com ([116.203.34.67]:54958 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbfIEMS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 08:18:59 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id B37474F790;
        Thu,  5 Sep 2019 12:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1567685926; bh=8eUSUwjl9XMgEZnPggAi/NndYu7xlTpfRetCfnMbL74=;
        h=From:To:Subject:Cc:Date;
        b=gpduOhAszLalLLyxy+W9HX84FD4JEc4+kIaa4yW1PR1C8UDaSSnAVoIzKxm5ZsWF/
         bu7XfecEzdJCiX7Nfv4adlPsOu8a1rCxWy49g0JbUi0vTlZgA5vTyfXKi5/a6PI+Pq
         E/Ie/lnYVmFAueU5CFK67ofvjLA4NOaLY33tW80qkaipfsoH19wDgNEkpHNv1hdS/0
         26RqbLfazcGA1rOPKmJQ74WHHKpmkc9h6+gZlBS0PAH/yaqylGQheEykBttT9dINqx
         eheUgm+5lRO5sEXFFA+kHbMor9eMNx5dmC9pe6eNBWYM+DQSkJxZ6WBG9LCF+ekybO
         /iE6FxkBBm9MQ==
From:   Sean Nyekjaer <sean@geanix.com>
To:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: bcm2835aux: broken in (4.9), 4.14 and 4.19
Cc:     "Rasmus Pedersen (RD SC)" <rap@serenergy.com>
Message-ID: <5f6bd329-3848-98aa-bae9-e988de0d361a@geanix.com>
Date:   Thu, 5 Sep 2019 14:18:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider picking:

commit 7188a6f0eee3f1fae5d826cfc6d569657ff950ec
Author: Martin Sperl <kernel@martin.sperl.org>
Date:   Sat Mar 30 09:30:58 2019 +0000

     spi: bcm2835aux: unifying code between polling and interrupt driven 
code

commit c7de8500fd8ecbb544846dd5f11dca578c3777e1
Author: Martin Sperl <kernel@martin.sperl.org>
Date:   Sat Mar 30 09:30:59 2019 +0000

     spi: bcm2835aux: remove dangerous uncontrolled read of fifo


commit 73b114ee7db1750c0b535199fae383b109bd61d0
Author: Martin Sperl <kernel@martin.sperl.org>
Date:   Sat Mar 30 09:31:00 2019 +0000

     spi: bcm2835aux: fix corruptions for longer spi transfers

for stable kernel 4.14 and 4.19.

If we want to fix this in 4.9 you should also pick:

commit bc519d9574618e47a0c788000fb78da95e18d953
Author: Rob Herring <robh@kernel.org>
Date:   Thu May 3 13:09:44 2018 -0500

     spi: bcm2835aux: ensure interrupts are enabled for shared handler

Thanks,
/Sean
