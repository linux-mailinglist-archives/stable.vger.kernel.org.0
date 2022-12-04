Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306C4641DBD
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLDP4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDP4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:56:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66D013D70;
        Sun,  4 Dec 2022 07:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55AC360EB3;
        Sun,  4 Dec 2022 15:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37705C433C1;
        Sun,  4 Dec 2022 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670169398;
        bh=zlJjNprnbAeSTv45Hp0w5Cp79RLon3z8huRjlMUykDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJoyg/T5EEptuJL5ZqhTJwGhdXz15VLpYNaLSwZeiz9Jm4te5WmmIhh6pmtOwS+Gb
         awSuT3m8+dQ8yrXUqD7em95P3ShgavVREe0uX2IHEuImXbJS3g1ftNLRHbio1FWN/P
         0hisZ40CusfitfJseYadr+M8w0ceJMlKubndAdUQ=
Date:   Sun, 4 Dec 2022 16:56:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 5.19 0/2] tty: n_gsm: revert tx_mutex usage
Message-ID: <Y4zDM6+PqsoDLqvF@kroah.com>
References: <Y4tQjdqL2vbDnTX8@kroah.com>
 <20221203223526.11185-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203223526.11185-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 04, 2022 at 01:35:24AM +0300, Fedor Pchelkin wrote:
> Thanks for notice, n_gsm tx_mutex patches just were added to 5.19, not
> 5.15, so we need to revert them.

5.19 is long end-of-life, there is nothing that we can do about that at
all.

greg k-h
