Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6856B3BC6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 11:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCJKOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 05:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjCJKOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 05:14:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14916DCF70
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 02:14:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB674B8224C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 10:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF284C433EF;
        Fri, 10 Mar 2023 10:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678443242;
        bh=rDYdp8NMTsmbjgfL3kPLlqdRRw4llvCemQi12ddAWXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NGI3d9MqfDNqStQXBV8XCVqkbe7jO11I9OVUM6ucILeM2nQKl0IHQzCj2O9xZ62UF
         N3EFr32w+wuIzHcI2ugllQZjgr33Tw/YgQsoXymehEoIMf8pDbtIFh22WcJJKCGg6J
         BNqIWTOvvltVcEtuyX5xwKS9+0XthUK/PbO/H+XM=
Date:   Fri, 10 Mar 2023 11:13:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/10] Backport patches to fix lockdep splat in 6.1
Message-ID: <ZAsC5/+RqEQrCdRK@kroah.com>
References: <20230303092347.4825-1-cheng-jui.wang@mediatek.com>
 <ZAsClzHcFVs+Hztr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAsClzHcFVs+Hztr@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 11:12:39AM +0100, Greg KH wrote:
> On Fri, Mar 03, 2023 at 05:23:22PM +0800, Cheng-Jui Wang wrote:
> > These patches fix the lockdep splat reported in this thread:
> > https://lore.kernel.org/lkml/20220822164404.57952727@gandalf.local.home/
> > 
> > 
> 
> Why not cc: all of the developers involved in this 00/10 email?
> 
> I would need approval from them to be able to take this.
> 
> Also, is the lockdep splat correct?  Or is it a false positive?  And if
> correct, is it something that you can actually trigger somehow?

Also, we can not take these for only 6.1.y for obvious reasons that you
would hit a regression when you move to 6.2.y.  So we need backports for
all newer kernels before we can take them for older ones.  Please
provide all of the backports.

thanks,

greg k-h
