Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325115185E1
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiECNuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiECNuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:50:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A292BDD;
        Tue,  3 May 2022 06:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92322CE2017;
        Tue,  3 May 2022 13:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7693C385A9;
        Tue,  3 May 2022 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585593;
        bh=X7vTfTUCqnDQdZdNWD+oRGsWY140BFA02CfvcX0Km7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i4J7zS1yGYYtT5+KrV7CF0D51BDA6HaJLNHU4DBWMZiEv4h9W88PO4oPTWxPi1YdY
         HewAqegfkqBAyJqazlfiElA2TBEaQsFj7GV7bY8SC7qmqCsrWfTFM1QkF905oO5nMo
         eVPBzJ/U6PItoIAzvp6Wa8jkIOR7Lnz5z4a1FDJ4=
Date:   Tue, 3 May 2022 15:46:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH] [Rebased for 5.15] eeprom: at25: Use DMA safe buffers
Message-ID: <YnEyOLM+wdiEL/JN@kroah.com>
References: <17730b921128e87ffd05957f39664cd257ff5416.1651577811.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17730b921128e87ffd05957f39664cd257ff5416.1651577811.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 01:37:47PM +0200, Christophe Leroy wrote:
> Upstream commit 5b47b751b760ee1c74a51660fd096aa148a362cd

Now queued up, thanks.

greg k-h
