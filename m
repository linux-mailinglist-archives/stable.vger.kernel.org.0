Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEEF5A0E08
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbiHYKje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiHYKjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:39:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A32EA4045
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 03:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1647B82733
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 10:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164C6C433D6;
        Thu, 25 Aug 2022 10:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661423967;
        bh=5mx0pT9V+NMCmfyu1zDiYJ8Jecx0vSYzq6VjX9SM9XE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2tImBeuyaZBwPDcf05Uvq+J6HNAMvzWTrH9xmPgTu+t4sM3q+g3sKMliFXcB7p5nY
         vYOn6bONCkVAMixvMWgNvtk+AHwq+MadCiDjJ7j5c2y2VnMf73xVuMG+Pq8F1roi67
         Q+zickfisqFvgIFA0f8rF7HJbXjko81XAB5YkyKw=
Date:   Thu, 25 Aug 2022 12:39:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: patch request for 5.15-stable to fix gcc-12 build
Message-ID: <YwdRV/+0jReYpeAx@kroah.com>
References: <YwaZX/nl4lsadXpF@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwaZX/nl4lsadXpF@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 10:34:23PM +0100, Sudip Mukherjee (Codethink) wrote:
> Hi Greg,
> 
> v5.15.y riscv builds fails with gcc-12. Can I please request to add the
> following to the queue:
> 
> ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
> 32329216ca1d ("eth: sun: cassini: remove dead code")

All now queued up, thanks.

greg k-h
