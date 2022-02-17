Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD804BA58E
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 17:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiBQQR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 11:17:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiBQQR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 11:17:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61EB246349
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 08:17:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6288860B96
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 16:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A87DC340E8;
        Thu, 17 Feb 2022 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645114661;
        bh=QM/kTeaju+uBW/eFA7e9lEV6+dsTG1iertjinVC1tXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lXqZyNODIzRX10jSl7GNjE+kQz+HpdfvUAKdVJj3g0znEXZzgp4kowYP8opQWfy8W
         bvriHUJ99fyS46dS9P08D+jwJ7PUu4Qc8uUG4ueuGO2T4WIlzow+M7onEoXTTbLVFu
         6Ew3wFO7he+ILqpwdgRDgPECrFdSzIFi+zCNrGqE=
Date:   Thu, 17 Feb 2022 17:17:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     daniel@iogearbox.net, andrii@kernel.org, ast@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <Yg51IuzfMnU8Uo6v@kroah.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg5wY5FKj0ikiq+A@google.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 03:57:23PM +0000, Lee Jones wrote:
> Good afternoon Daniel,
> 
> On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> We are in receipt of a bug report which cites this patch as the fix.

Does the bug report really say that this issue is present in the 5.4
kernel tree?  Anything older?

thanks,

greg k-h
