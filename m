Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC2521212
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 12:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiEJKYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiEJKYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F6E2AC0F9
        for <stable@vger.kernel.org>; Tue, 10 May 2022 03:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6320961722
        for <stable@vger.kernel.org>; Tue, 10 May 2022 10:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D28C385C6;
        Tue, 10 May 2022 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652178015;
        bh=FSoymI0OVvTvbPBaJJsSJuG9Gjsk5c6Ee9ypJLkraNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aWXU1j+uyU4wQxQ0Gr+eO+7dG2EEJTD4CqujJxX8OTfM5tOGoh49egfsGfwlN6dyS
         XgYaSJWHnBrx/6BvtGl2oQp3DGPZUS0XAC/hINez22BRLzgCsiyKL3dfHa56psrHX2
         JlGms6BVt1l1QHf3GgT0DzOFGBJocW9OSl9Qcwb0=
Date:   Tue, 10 May 2022 12:20:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: Please backport to 5.15.x:
 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
Message-ID: <Yno8XLdZ+fWZn0ke@kroah.com>
References: <18d76e36dd24bd03cb470ce6e934533f7ef88b87.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18d76e36dd24bd03cb470ce6e934533f7ef88b87.camel@infinera.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 09:26:31AM +0000, Joakim Tjernlund wrote:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
> 
> I see this error on ThinkPad T14 Gen 2a

But that commit says it fixes commit bf3747ae2e25 ("mt76: mt7921: enable
aspm by default") which is in 5.16, not 5.15.

Have you tested this on 5.15.y to verify it will work properly?

thanks,

greg k-h
