Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E113C53FE0A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiFGLx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243239AbiFGLxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9408617F
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 04:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32810B80DB1
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 11:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FCBC385A5;
        Tue,  7 Jun 2022 11:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654602813;
        bh=2M2eENT/bbK+vvC+mlii6iocsi6UJNyaXmmTRUEaVjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u/7K3bzCVhn8cuOeztl40PXhrfFZ6FNWu2tKwzWQabW9+B1rGIGVC/lY3JVE+EmeW
         ClC0z8KAHd4fjSAi8hB90j8cFELKEYeJRmRGVG4HcFVgr7c/aox4cW5+SJTNEAPaZq
         89bwt3IES+lZPKjaxlkojxqsa+LxQeiaHQAXjZrk=
Date:   Tue, 7 Jun 2022 13:53:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot loop since 5.17.6
Message-ID: <Yp88N2qL3HXLz0bi@kroah.com>
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
 <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
 <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
 <1f8a4bec-53bd-aaaa-49a7-b5ed4fc5ae34@med.uni-frankfurt.de>
 <a9a68c68-8830-2aa0-acbe-d5d3bb04968f@leemhuis.info>
 <4dc96ed3-169e-37b9-7b8f-85e58dca0bbf@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dc96ed3-169e-37b9-7b8f-85e58dca0bbf@med.uni-frankfurt.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 01:40:03PM +0200, Thomas Sattler wrote:
> Hi Thorsten,
> 
> I just compiled 5.19-rc1 and my issue is solved there.

Any chance you can do 'git bisect' between 5.18 and 5.19-rc1 to find the
commit that fixed the issue?

thanks,

greg k-h
