Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCAC488140
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 04:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiAHD4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 22:56:20 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:58752 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230292AbiAHD4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jan 2022 22:56:20 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowAD3_i5JC9lhxUlJBQ--.17779S2;
        Sat, 08 Jan 2022 11:55:53 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     damien.lemoal@opensource.wdc.com, David.Laight@ACULAB.COM,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH v3] ide: Check for null pointer after calling devm_ioremap
Date:   Sat,  8 Jan 2022 11:55:52 +0800
Message-Id: <20220108035552.4081511-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAD3_i5JC9lhxUlJBQ--.17779S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw13ArWxtry7tr18ur15Arb_yoWDZwcEgr
        ZYg34DX398JFW5tan3Cr1Svr4I9a47WrykArn0vrW3Wr93Gr4fXF93Kr93Xw1DWas5Cws8
        Gan8A3sxXrWjvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUnQ6pDUUUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 08, 2022 at 10:53:42PM +0800, Damien Le Moal wrote:
>> Cc: stable@vger.kernel.org#5.10
>
> Please keep the space before the #
>
> Cc: stable@vger.kernel.org #5.10

Actually, I added the space before, but the when I use the tool
'scripts/checkpatch.pl' to check my format, it told me a warning
that it should not have space.

The warning is as follow:
WARNING: email address 'stable@vger.kernel.org #5.10' might be
better as 'stable@vger.kernel.org#5.10'

So I have no idea what is correct.
Is the tool outdated?
If so, I will correct my cc and please update the tool.

> As commented before, what exactly was corrected ? That is what needs to be
> mentioned here. In any case, I fail to see what code change you added between v2
> and v3. The code changes are identical in the 2 versions.

Thanks, I will make the changelog more clear.
In fact, in the v2 I was careless to write '!!alt_base'.
So I removed the redundant '!' in v3.

Please tell me the right cc format, and then I will submit a new v3,
without the problems above.

Sincerely thanks,
Jiang

