Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC4E53F987
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbiFGJWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbiFGJWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:22:01 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69872255B7;
        Tue,  7 Jun 2022 02:22:00 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nyVPQ-0002sg-5u; Tue, 07 Jun 2022 11:21:56 +0200
Message-ID: <cef04dbd-985a-c0d5-4c8b-7e234daa402a@leemhuis.info>
Date:   Tue, 7 Jun 2022 11:21:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Input: bcm5974 - Set missing URB_NO_TRANSFER_DMA_MAP urb
 flag
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>, rydberg@bitmath.org
Cc:     linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        stable@vger.kernel.org
References: <20220606113636.588955-1-mathias.nyman@linux.intel.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220606113636.588955-1-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1654593720;f7f91d6d;
X-HE-SMSGID: 1nyVPQ-0002sg-5u
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.06.22 13:36, Mathias Nyman wrote:
> The bcm5974 driver does the allocation and dma mapping of the usb urb
> data buffer, but driver does not set the URB_NO_TRANSFER_DMA_MAP flag
> to let usb core know the buffer is already mapped.
> 
> usb core tries to map the already mapped buffer, causing a warning:
> "xhci_hcd 0000:00:14.0: rejecting DMA map of vmalloc memory"
> 
> Fix this by setting the URB_NO_TRANSFER_DMA_MAP, letting usb core
> know buffer is already mapped by bcm5974 driver

BTW @reviewers & @maintainers: this is fixing a regression, hence please
prioritize this. For details see "Prioritize work on fixing regressions"
in Documentation/process/handling-regressions.rst or
docs.kernel.org/process/handling-regressions.html .

> Cc: stable@vger.kernel.org
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

If you need to respin this for one reason or another, could you please
add proper 'Link:' tags pointing to all reports about this issue? e.g.
like this:

 Link: https://bugzilla.kernel.org/show_bug.cgi?id=215890

These tags are important, as they allow others to look into the
backstory now and years from now. That is why they should be placed in
cases like this, as Documentation/process/submitting-patches.rst and
Documentation/process/5.Posting.rst explain in more detail.
Additionally, my regression tracking bot ‘regzbot’ relies on these tags
to automatically connect reports with patches that are posted or
committed to fix the reported issue.

> [...]

Ciao, Thorsten
