Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C825314B7
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiEWPM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237623AbiEWPMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3D24BFEB
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E17B8116E
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E587FC385A9;
        Mon, 23 May 2022 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653318741;
        bh=9cdRpSaL+4gmckmpFRK5mfiiZy3Txgr98PfH6GoWWIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiat0UvZoMu34bGjEi1JQ5npCpb2xvZieFTD62w8Jhgy5v4qGFZvaV4o81JN3wrvz
         TREVGi9XSdNvs6zVUWchiMAVYf/ttmxvpTTH+wKkHNwCGC6aZYFdoOaJVoxAI8Yaso
         SEeGhsSAR7d0/hgAOnoqShi83BnXDtGtEbXcOs9o=
Date:   Mon, 23 May 2022 17:12:18 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Please backport to 5.15.x:
 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
Message-ID: <YoukUuxn86zbYvYT@kroah.com>
References: <18d76e36dd24bd03cb470ce6e934533f7ef88b87.camel@infinera.com>
 <Yno8XLdZ+fWZn0ke@kroah.com>
 <cb4467d882a293eb46b765517b1eccc2757f4e70.camel@infinera.com>
 <c83379db5202a8f0e2ba4e252c3ae153675f4e58.camel@infinera.com>
 <9bd628f13e5ef1f80e3bce8a33d4554627ab4aa4.camel@infinera.com>
 <f521eec2e093279d9f84df35c0cf7ec40d559994.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f521eec2e093279d9f84df35c0cf7ec40d559994.camel@infinera.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 22, 2022 at 06:49:10PM +0000, Joakim Tjernlund wrote:
> Since neither Sean nor Felix has replied I did my own backport to 5.15.x
> Not sure about the proper protocol for this type of work but adding the patch here anyway.
> Unsure if this is correct but I have not seen the error after this patch.

Now queued up, thanks!

greg k-h
