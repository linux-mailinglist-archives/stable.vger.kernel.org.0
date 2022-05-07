Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3360051E6A5
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 13:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446272AbiEGLdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 07:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442354AbiEGLdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 07:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C09E49C87
        for <stable@vger.kernel.org>; Sat,  7 May 2022 04:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5EE76117C
        for <stable@vger.kernel.org>; Sat,  7 May 2022 11:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FB7C385A9;
        Sat,  7 May 2022 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651922989;
        bh=o0EiLWdqnzN1NV+owEwH6ILetckO4CFOc/yPOMPUFow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=suYiugPN1RjgiGqF8SNVIMlmf49nmZKLCpuf2l9eP1pW3X1R7M/WAIxgOrAC39Pd7
         9pn6EOUN6UkwA/QFCjjt46kCA0MzDauww3rA1EQZOpVar2KXme0Z6qeSTD+mVcUs1k
         kxTW9XxRGpKzhyBx0YUF7knituEn58GrIPelKxfs=
Date:   Sat, 7 May 2022 13:29:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "llfl(kun.hk)" <llfl@linux.alibaba.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 05/19] iommu/vt-d: Global devTLB flush when present
 context entry changed
Message-ID: <YnZYKgnAGiPC5ecj@kroah.com>
References: <20220506120057.77320-1-llfl@linux.alibaba.com>
 <20220506120057.77320-5-llfl@linux.alibaba.com>
 <YnU2Is7w6u6TZK9V@kroah.com>
 <2fa72980-d94f-3257-1ea4-5ff9c77f8b59@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fa72980-d94f-3257-1ea4-5ff9c77f8b59@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 11:43:25PM +0800, llfl(kun.hk) wrote:
> I am so sorry about that wrong email. I was backporting these patches from a
> mail list, and I added your email to cc list by accident.
> 
> 
> This 'ANBZ' mark is for alibaba inc. code base internal review.
> 
> 
> I am so sorry about those emails confuse you.

Why not submit these for inclusion in the real stable kernel releases,
so that you do not have to backport anything?

They need to go to older kernels, why duplicate the work for everyone?

thanks,

greg k-h
