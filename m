Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5045353BEBE
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 21:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbiFBTYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 15:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiFBTYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 15:24:21 -0400
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de [141.2.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3FDFDE
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 12:24:21 -0700 (PDT)
Received: from smtpauth2.cluster.uni-frankfurt.de ([10.1.1.238])
        by mailout.rz.uni-frankfurt.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwqQd-00057w-Af; Thu, 02 Jun 2022 21:24:19 +0200
Received: from p57bcf53e.dip0.t-ipconnect.de ([87.188.245.62] helo=[192.168.2.17])
        by smtpauth2.cluster.uni-frankfurt.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwqQd-0000Wl-98; Thu, 02 Jun 2022 21:24:19 +0200
Message-ID: <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
Date:   Thu, 2 Jun 2022 21:24:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: boot loop since 5.17.6
Content-Language: en-US
From:   Thomas Sattler <sattler@med.uni-frankfurt.de>
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
In-Reply-To: <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

with these three diffs reverted, I was able to boot
all affected 5.17.x kernels (x={6,7,8,9,10,11,12})



Am 02.06.22 um 18:42 schrieb Thomas Sattler:
> some more information:
> 
> $ cat /proc/version
> Linux version 5.17.5 (root@dragon) (x86_64-pc-linux-gnu-gcc (Gentoo
> 11.2.1_p20220115 p4) 11.2.1 20220115, GNU ld (Gentoo 2.37_p1 p2) 2.37)
> #130 SMP PREEMPT Thu Apr 28 10:50:24 CEST 2022
> 
> $ uname -mi
> x86_64 GenuineIntel
> 
> 
> I tried to compile 5.17.6 without the three mentioned diffs which
> modify the following files:
> 
>     tools/objtool/check.c   and
>     tools/objtool/elf.c      and
>     tools/objtool/include/objtool/elf.h
> 
> and was then able to successfully boot 5.17.6.
