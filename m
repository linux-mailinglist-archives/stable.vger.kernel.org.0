Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7484EFEE0
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 07:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbiDBFRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 01:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiDBFRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 01:17:23 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6E21AC72A;
        Fri,  1 Apr 2022 22:15:30 -0700 (PDT)
Received: from [192.168.165.80] (unknown [182.2.36.61])
        by gnuweeb.org (Postfix) with ESMTPSA id 0A80C7E356;
        Sat,  2 Apr 2022 05:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648876529;
        bh=Y01PgXHrUoAQRiCbzvaK0s1BZI4Z5mxJMR1GYxrrdVg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QOoNnEQVweFm7+5mdZPgNSNXRlwjrnkQlF3HXxICZaF+d7QVxXjySgkRNpDOHs24B
         3LrIT/ouZF2ofwpm3Zc4Sz66mA6tC1jSBXgY28in5Wysjqr63ie6CPBc1UBAs59c4C
         aO9bcjughMrLMQJCWyy+QJslnTVqGNUQBMyG6Jn/w5Dx9h9Ip2PJo9b3lQr7cQg8eF
         q1ZYz+q+8ttgx90jxD3aWX6kngJyMIPorANmJKJDzMffWBXLWDh0ti4pUgWc63YQVC
         DFFRSOHyBZ09q6JLlnsG+fTva9Rn+b3oLkbn/dC02ipbZY8hTPnxe+ZeMju6KcRn+/
         6/rdXb9khCOxA==
Message-ID: <c768b141-e463-5b4b-daba-794a02da3f1f@gnuweeb.org>
Date:   Sat, 2 Apr 2022 12:15:18 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v6 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
 <20220329104705.65256-2-ammarfaizi2@gnuweeb.org>
 <13463eca-03a2-da0d-c274-fb576a8a051f@intel.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <13463eca-03a2-da0d-c274-fb576a8a051f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/2/22 12:42 AM, Dave Hansen wrote:
> Was this found by inspection or was it causing real-world problems?

It was found by inspection, no real-world problems found so far.

-- 
Ammar Faizi
