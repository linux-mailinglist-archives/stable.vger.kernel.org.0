Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1B65A933
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 07:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjAAGxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 01:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAAGxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 01:53:49 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1752AD45
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 22:53:47 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 3016rb1p020555;
        Sun, 1 Jan 2023 07:53:37 +0100
Date:   Sun, 1 Jan 2023 07:53:37 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Lukasz Kalamlacki <lukasz@pm.kalamlacki.eu>
Cc:     stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <20230101065337.GA20539@1wt.eu>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 31, 2022 at 04:58:51PM +0000, Lukasz Kalamlacki wrote:
> Hey,
> 
> 
> Do you have an issue compiling 6.1.2 linux kernel?
> 
> I cannot compile it.

For me it compiles and boots. You'll need to share your config and error
report if you want to get some help.

Willy
