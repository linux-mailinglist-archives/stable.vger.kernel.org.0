Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391A75FF36C
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJNSG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 14:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiJNSG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 14:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF3D28701
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 11:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0381861B87
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 18:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0358EC433C1;
        Fri, 14 Oct 2022 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665770816;
        bh=Uv7FUp4gB1CwVNGKX2mYKebM0QEdASsbdx9Pzv/k3Z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jxFg/itW21/jUfMKxRKBH9fpNxfuK2bMlfp7VS5TnjxmvFS4iVuiI1QwiNSanTpab
         0pQDPmlcbVSji1Cek9vI2U0OoioC93x+DY8zluj/Y4/ELMI2bUNayc47Z94dtQVQVj
         6YSNBSY5g4IJUjdFbOKjhHyNcFprvZvioKhjutZo=
Date:   Fri, 14 Oct 2022 20:07:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     rug@usm.lmu.de
Cc:     stable@vger.kernel.org
Subject: Re: Infiniband problem
Message-ID: <Y0mlbaqnBHzfN1bH@kroah.com>
References: <20221014174921.Horde.Sode83dfrecpOpnn8Z6gguY@www.usm.uni-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014174921.Horde.Sode83dfrecpOpnn8Z6gguY@www.usm.uni-muenchen.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 05:49:21PM +0000, rug@usm.lmu.de wrote:
> Hi to whom it may concern,
> 
> We are getting on a 6.0.0 (and also on 5.10 up) the following Mellanox
> infiniband problem (see below).
> Can you please help (this is on a running ia64 cluster).

Please email the infiniband kernel developers about this.  Their mailing
list info is in the MAINTAINERS file in the kernel source tree.

thanks,

greg k-h
