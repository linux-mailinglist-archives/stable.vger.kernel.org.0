Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7CB6C3AFE
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCUTuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCUTuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:50:51 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6614158B58;
        Tue, 21 Mar 2023 12:50:19 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Ph2JK13rfz9sdT;
        Tue, 21 Mar 2023 20:50:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1679428209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+HzQExFoT+XefCR4rpoUI1sb4aMIJePTtD202bcyR8=;
        b=MEPP0jPLzBZF09c13WDMsEsBIsiTMq/9fo/S+XhRxH7/JKaOuj4/JhHtiUcar3WaF3HMGx
        h/nNaIeDaFW/OxVvCty3bC9j5Lxm2UAIVHssIMiVWm3qPyhaKxjhLQFW028LXUDpXvfO54
        +KZa65Pp1ZRabWeKw88iV9OsA66np52SwJ6NncgSvsSlVBx96DdSvbSun6FUkwMPL+ck1s
        vL1ZgaudhL+1HO2gOzNmgV+TL4gk1uFhWtSQPkdfycpDz6fwyj/fMoBJWVnzdFcjBCOrsa
        BZNurgkZZr2OPVBAE9GPj05UavQJ1X6xGjvGYeDZ4+J1lO573rbZOT7ts4qi9A==
Date:   Tue, 21 Mar 2023 20:50:05 +0100
From:   Erhard Furtner <erhard_f@mailbox.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>,
        Chris Snook <chris.snook@gmail.com>, stable@vger.kernel.org
Subject: Re: When VIA VL805/806 xHCI USB 3.0 Controller is present Atheros
 E2400 (alx) ethernet does not work: NETDEV WATCHDOG: enp5s0 (alx): transmit
 queue 2 timed out
Message-ID: <20230321205005.7b46fe14@yea>
In-Reply-To: <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
References: <20230319013706.016d96b2@yea>
        <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: 1a4q3rhyqws1kqur61t5zfzujbt7ewi4
X-MBO-RS-ID: 0b7dedb5dacdbcc80a0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Mar 2023 11:26:39 +0200
Mathias Nyman <mathias.nyman@linux.intel.com> wrote:

> This could be related to another case with two xHC controllers, but different vendors.
> Bus numbers were interleaved there as well. Removing the asynch probe helped:
> 
> https://lore.kernel.org/linux-usb/d5ff9480-57bd-2c39-8b10-988ad0d14a7e@linux.intel.com/
> 
> Does reverting:
> 4c2604a9a689 usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS
> help for you?

Thanks for the hint Mathias! I'll check that out and report back. Which may take some weeks as this system is located at my parents home.

Regards,
Erhard
