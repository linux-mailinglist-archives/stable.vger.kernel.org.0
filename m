Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF52540427
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 18:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345250AbiFGQzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 12:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbiFGQzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 12:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A53BC6E3
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1BCF61896
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 16:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053FBC385A5;
        Tue,  7 Jun 2022 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654620916;
        bh=QNEYXqTYrmzrvz2qIW/0ktUexovk58Fij+DKCMOQu7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZnSWtPPTKKdlPL2tfPRZ0BAs0XfAquc4BzgcMkMpu0WSv+NAHoaz+TGXnRzy2ZBz
         3WCG6fU4NOJhB5iQ3RLSFmR+ToRqKc03wfu8nr9skdk2O3Fs3GkTOp0wl7fCwyLLWc
         HaAC66Ffk55UkRyvg/oXQzY6OdBwOTaZARkrS6T8=
Date:   Tue, 7 Jun 2022 18:55:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot loop since 5.17.6
Message-ID: <Yp+C8XVYvK5XszuU@kroah.com>
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
 <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
 <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
 <1f8a4bec-53bd-aaaa-49a7-b5ed4fc5ae34@med.uni-frankfurt.de>
 <a9a68c68-8830-2aa0-acbe-d5d3bb04968f@leemhuis.info>
 <4dc96ed3-169e-37b9-7b8f-85e58dca0bbf@med.uni-frankfurt.de>
 <Yp88N2qL3HXLz0bi@kroah.com>
 <4282db24-0c4e-df01-8b0e-06cf647a3351@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4282db24-0c4e-df01-8b0e-06cf647a3351@med.uni-frankfurt.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 04:17:26PM +0200, Thomas Sattler wrote:
> Hi Greg,
> 
> I did not yet start a bisect but looked at commits that modify
> the same file again. And there was a promising one:
> 
>   22682a07acc3 objtool: Fix objtool regression on x32 systems
> 
> That one applies cleanly to both, 5.17.12 and 5.18.2, and also
> fixes my boot-problem on both.

Oh good, that's already queued up for the next round of stable kernels.

thanks,

greg k-h
