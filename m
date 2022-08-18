Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AABE597E0F
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 07:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiHRFYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 01:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiHRFYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 01:24:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E324824BF1;
        Wed, 17 Aug 2022 22:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2256B8102F;
        Thu, 18 Aug 2022 05:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8963C433D6;
        Thu, 18 Aug 2022 05:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660800246;
        bh=vu3GpUjuyDx7cW/wJlmArNzgzsiHVyxxOsbUeNC8CLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWsYUn6d87d0LqPovgyUHQxPo/Pav3p6BJ5ppLzarezFA0vkU3M/4ljVwQwFxF5c0
         +lhacA7i77ZT8ZI8DZqeDO+NlSBJ5/LoKCG+N7pz3xNksalv7UaMB/cqfGy8cB6X8X
         EJQoy9zOYM7KkusuW/jm0PYAAf9dtAxS0h1VXqTI=
Date:   Thu, 18 Aug 2022 07:24:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     RAJESH DASARI <raajeshdasari@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        jean-philippe@linaro.org, df@google.com
Subject: Re: bpf selftest failed in 5.4.210 kernel
Message-ID: <Yv3M8wqMkLwlaHxa@kroah.com>
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 09:22:00PM +0300, RAJESH DASARI wrote:
> Hi ,
> 
> We are running bpf selftests on 5.4.210 kernel version and we see that
> test case 11 of  test_align failed. Please find the below error.
> 
> selftests: bpf: test_align
> Test  11: pointer variable subtraction ... Failed to find match 16:
> R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2;
> 0xfffffffc)
> # func#0 @0
> # 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
> # 0: (61) r2 = *(u32 *)(r1 +76)
> # 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
> # 1: (61) r3 = *(u32 *)(r1 +80)
> 
> For complete errors please see the attached file. The same test case
> execution was successful in the 5.4.209 version , could you please let
> me know any known issue with the recent changes in 5.4.210 and how to
> fix these errors.

Can you use 'git bisect' to find the offending commit?

thanks,

greg k-h
