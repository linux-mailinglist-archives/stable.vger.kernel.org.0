Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48573591918
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 09:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiHMHBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 03:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMHBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 03:01:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D597D27158
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 00:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5F3B81037
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFC6C433C1;
        Sat, 13 Aug 2022 07:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660374074;
        bh=1Vp/ccnFv9lYvN6aLRGFz1YAqLA6vGF7gFvBzzW4GiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lhxgNfzUbv0KtG4dpW96qZaZrBMaO7VO/VCGgn9+3Akl3JnWBx3OAs5O5NkH7dnPV
         kLdsUVBvctJK0v1Mpqzd9N8TBq9A2/4hRSgrOc7BN6WU5r71YbVWcQuAOaLDe72h3Y
         FlpG3GYc1dU4N0juCBVwnzRWVMcL8kaBLe7pQSEY=
Date:   Sat, 13 Aug 2022 09:01:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cmiles69@hushmail.com
Cc:     stable@vger.kernel.org
Subject: Re: AMD RX580 GPU
Message-ID: <YvdMNvkIIaAGkKRW@kroah.com>
References: <20220812224728.C94E18106BC@smtp.hushmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812224728.C94E18106BC@smtp.hushmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 13, 2022 at 10:47:28AM +1200, cmiles69@hushmail.com wrote:
> Linux voidshop 5.15.52_1 #1 SMP Sat Jul 2 15:17:21 UTC 2022 x86_64 GNU/Linux. This kernel runs fine.
> 
> Every other later kernel does not.
> 
> kern.err: [  128.868336] amdgpu 0000:29:00.0: [drm] *ERROR* [CRTC:53:crtc-0] flip_done timed out
> 
> This is the error i get when coming back from playing a wine game ( Sacred gold ).
> 
> Screen freezes, although sometimes i can type sudo reboot and it works.
> 
> Trying different kernel options.

Please try using 'git bisect' and contact the AMD driver developers on
their mailing list with the information you find out.  Not much we can
do here on the stable list, sorry.

good luck,

greg k-h
