Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C2F53BF54
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiFBUIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiFBUIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:08:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6173B3CB
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 13:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37476617DA
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 20:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E49BC385A5;
        Thu,  2 Jun 2022 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654200530;
        bh=8GzgWaU02MkgYx6vlC1/LAX6muJRS4/DxBOnAunjqzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEHh7NeUB4SYdD+8lksQ+W01tZb4oc2BpECOu1kvSUffnh03rTJsBIetclVoZmUfi
         +55OPuzmPRRneVmefFwMZQkMjJd3ne3Y1nTeDNEm+Q57wcwQfsAmqFF87oW0yRSRWZ
         aaKyCHRS5RscOF1aT1QAtrKG/Ri8aoWnv91sYpig=
Date:   Thu, 2 Jun 2022 22:08:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot loop since 5.17.6
Message-ID: <YpkY0RLWki4PJ49y@kroah.com>
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 02, 2022 at 06:14:43PM +0200, Thomas Sattler wrote:
> After applying "patch-5.17.5-6.part198.patch" compilation is
> broken. Still after applying "patch-5.17.5-6.part199.patch".
> After applying "patch-5.17.5-6.part200.patch", compilation
> works again but the resulting kernel now fails to boot.

I have no idea what those random patches are, please can you say what
the upstream commit is?

thanks,

greg k-h
