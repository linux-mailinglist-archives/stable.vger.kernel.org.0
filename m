Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BF053C0EC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 00:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiFBWo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 18:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiFBWo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 18:44:27 -0400
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de [141.2.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7717537A81
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 15:44:25 -0700 (PDT)
Received: from smtpauth1.cluster.uni-frankfurt.de ([10.1.1.45])
        by mailout.rz.uni-frankfurt.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwtYF-0000KT-C4; Fri, 03 Jun 2022 00:44:23 +0200
Received: from p57bcf53e.dip0.t-ipconnect.de ([87.188.245.62] helo=[192.168.2.17])
        by smtpauth1.cluster.uni-frankfurt.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwtYF-0006fs-AO; Fri, 03 Jun 2022 00:44:23 +0200
Message-ID: <1f8a4bec-53bd-aaaa-49a7-b5ed4fc5ae34@med.uni-frankfurt.de>
Date:   Fri, 3 Jun 2022 00:44:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: boot loop since 5.17.6
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
 <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
 <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
From:   Thomas Sattler <sattler@med.uni-frankfurt.de>
In-Reply-To: <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
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

Am 02.06.22 um 23:32 schrieb Nathan Chancellor:
>> Am 02.06.22 um 18:42 schrieb Thomas Sattler:
>>>
>>> I tried to compile 5.17.6 without the three mentioned diffs which
>>> modify the following files:
>>>
>>>      tools/objtool/check.c   and
>>>      tools/objtool/elf.c      and
>>>      tools/objtool/include/objtool/elf.h
>>>
>>> and was then able to successfully boot 5.17.6.
> 
> 5.17.6 has commit 60d2b0b1018a ("objtool: Fix code relocs vs weak
> symbols"), which has a known issue that is fixed with commit
> ead165fa1042 ("objtool: Fix symbol creation"). If you apply ead165fa1042
> on 5.17.6 or newer, does that resolve your issue?

I applied ead165fa1042 ontop of 5.17.12, but that did not make
my system boot that kernel.

Thomas

