Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8CB542DFE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 12:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiFHKjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 06:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiFHKhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 06:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412BC1C0CAB;
        Wed,  8 Jun 2022 03:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F47C60B34;
        Wed,  8 Jun 2022 10:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5058FC34116;
        Wed,  8 Jun 2022 10:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654684353;
        bh=osDczLjj4ZYroNunuCS3ak/VSb8vsNR1fW33YV9phho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S3lW5FGu3iAa/NSQmbsLon1kjR4KgXKD67qUlrMGzcW4cgHwwNmQzzHoP+lkMOiA0
         S/BruE+qR24kXn+bmpTBTOh6zVgTTw+uZDb9W4MZHSy1vFH6/V+Tny9leO+YxGzygF
         6ElCKSPTLJdoW8mycnCEhVlCNh8cColyUXUKlOqE=
Date:   Wed, 8 Jun 2022 12:32:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Caleb Connolly <kc@postmarketos.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.18 579/879] pinctrl/rockchip: support deferring other
 gpio params
Message-ID: <YqB6vmoGsWHAVI29@kroah.com>
References: <20220607165002.659942637@linuxfoundation.org>
 <20220607165019.660801561@linuxfoundation.org>
 <c5c7e071-a645-39a2-c3dc-897173e8c971@postmarketos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5c7e071-a645-39a2-c3dc-897173e8c971@postmarketos.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 11:25:02AM +0100, Caleb Connolly wrote:
> Hi Greg,
> 
> This commit contains a bug which was fixed in commit
> 42d90a1e5caf ("pinctrl/rockchip: support setting input-enable param")

Thanks for letting me know, have now picked that one up too.

greg k-h
