Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409405B5C52
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 16:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiILOhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 10:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiILOhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 10:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E07A2F679
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 07:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA8C6121B
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A62C433D6;
        Mon, 12 Sep 2022 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662993420;
        bh=mluVG03JMirZvhW6DyQ6tYb92xLqVeqJUP0G5tkAQ1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gGLt900kQNaxO9y6dATZPSHm1AuuKGdZKeh2Oi6wCznbYE4u60+UZpY7nnF7zp/YX
         qtDI71tYy5Aa/3DugkUwDmbDuqNm1YNNRqvtksSYOHqkrnzNzJCPO3QeqPF8sVlj4X
         QYOS4f8IqcXgSaA3dAdq9JWD3y9XwYPE23gGSBKo=
Date:   Mon, 12 Sep 2022 16:37:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eugene Shalygin <eugene.shalygin@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/1] hwmon: (asus-ec-sensors) autoload module via DMI data
Message-ID: <Yx9EJbyjFaLTuAzV@kroah.com>
References: <20220912114842.762355-1-eugene.shalygin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912114842.762355-1-eugene.shalygin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 01:48:41PM +0200, Eugene Shalygin wrote:
> Backport of the 99abb0468cc8 onto the 5.19 branch.

This is not a valid commit id in Linus's tree :(

