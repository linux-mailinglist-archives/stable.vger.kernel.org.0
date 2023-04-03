Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5D46D4DF7
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjDCQeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDCQd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:33:56 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA4C1987;
        Mon,  3 Apr 2023 09:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1680539630; i=rwarsow@gmx.de;
        bh=FHDXb6Pd4oZ7xxmkmem4l6y9GV1NP+qdWUJdvkda0j4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ehhF/keBHk9O5cnVDhF0MpuGiMJBKbzqXbFKK44l8U1N3oMbqLcWN+KGogLhz5f9U
         0mgjjaCmua60vq+dPetlS/E5TzEk3W+d4f5ppXJb8eXdyBEETgPSrHiiMiFUm+twAV
         wxhE0kNJTkP0cK78s/efAvqYVhFzUQoXgY+hx3wmh3NQ765v/aehkrxAL0PHyeKrET
         StjdPOTpNcw1zLv9Hy4JbVm78uj4x1P+P1q7mapbnpmnv6X5EAWuTjAvaDMTBauFPr
         heQak0NqL7jVGomwE0M7NhO58rQD7g+WicowybGbKDp6oQXs/2rgLtobBuOKPlbKXp
         1tEjOFrVp2uQQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.139]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MiacH-1qNdEH3EhD-00fi89; Mon, 03
 Apr 2023 18:33:50 +0200
Message-ID: <cdf92447-3c2e-a205-0fa7-a55e2e75d0da@gmx.de>
Date:   Mon, 3 Apr 2023 18:33:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:0PQWcxKVA09E7f6N5ILamdrD9vmMHe/gfR5Z6juYGniJNdc3oRK
 t+FriRrKQXNzwicW5YIAwK/dsgkz6XRsM3kKphgQhVHdTaAeDVa3T5lencIBaJ7Rbq2avZB
 5X8XD5mHrSyldzI1XW0JiMXZ394XnkwkXjdKakDY8LkUoJYCEhfjnI/CE8vXwbJ+fNm6ZzD
 5l9gbNXjvjkZkj9ynNFJQ==
UI-OutboundReport: notjunk:1;M01:P0:qsB77XxvXQg=;A5g8uC7kMYcK6Pg4iAH7BBbFEKi
 fig9no5Pvn9gDWmuGNBFvmf/F1hzSUUczfZnhtOMKQq8S/GEgMGmCPv48KyNeeBeHff+GLL87
 3wPULIo7zaLE2lrNgHpaSvDaWGGFJVVDaXEn/8qbRrUYK6Dat4vWpt5IPNmkYgj6kOuWLcrFO
 1MEACv0aQfkxpMeSEzvM+JLGhcEB06vqC/iCj71mRMGxC+hKKzLETFQtLNXVoEb3E7ZBTGyKE
 kYoowimBL8ybKUCZ+vz8GI4wQxtIWNKN/4hRU87Iu92c9j8jxA8TjKPel7ywBFBurii/muYd7
 y+Nh9yh3hIWI+pEKDbjlQKw3IoBCt/4GL57WvS2EJ9bkTnjqpZ06VUC8+9Z/unZwL4nGds5RV
 Y6+MBCi1JSvlNrHNiiCLk9DHbFQI4ajW6aS9yscv0J4bje2qU7j03j31123A9muxpi32Df+7f
 KMuYvi848wCnpCtHep+I5ZwaZFyDIUFtIcOVcWrPYfq8bFT3hHyaA/+TPZyUbZ40ulo+bTopm
 FsEIflqF6dz+DoRXQXL178zqvEhxwiqpSFhsme9xl5qKtWyAGRL/E996Sfne0Nn53YLHWxLda
 TxMDcl11T1THORJ+pK84yHOpgJmqswIe7fQSpCRtnCznMR7jSgi8yxo4mt70tnSui8G7P3pV6
 ZwTu5CoeXzFtwUitnTNnhuyQ0pibM0pzRnIzCrECbllcIixlzGN+e7tLDsNsGTMTZJ8wU3EU9
 1do05NcjYx6h9xuFeiCV+yqmCtmuMaPCi/9Y8oTM3SIdgmsqjjFmc41XrbUKegUJTOBJlaf4H
 w8QKAZRM4hLFmjpIaFJIoSnd+aydMrC09bUvTwvOhLU4t10EnYrus2JUGqRKVYF2QHDmzKy6r
 NckcyxsOlK8xbg4f90HbXMwWStXGxRykpvFfP1tWynOfLCZZ7M5V01OS8y8sznrccQ3pmJ4II
 QY4FkQ==
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.10-rc1

compiles, boots and runs here on Intel x86_64

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

